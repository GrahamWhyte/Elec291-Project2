#include <C8051F38x.h>
#include <stdio.h>

#define  SYSCLK         48000000L // System clock frequency in Hz
#define  BAUDRATE       115200L
#define  DATABAUD		111111L 		//MUST CHANGE

//ASSIGN PROPER PINS
#define  LEFT_FORWARD    P2_5
#define  RIGHT_FORWARD   P2_3
#define  LEFT_BACKWARD   P2_4
#define  RIGHT_BACKWARD  P2_2

#define SIGNAL_IN P1_7 ///where ever the signal comes in from receiver
#define LEFT_DISTANCE P2_0 
#define RIGHT_DISTANCE P2_1 

//all of there need to be confirmed
#define joystick  0
#define tether    1
#define MODE_BIT  12
#define DIRECTION 14
#define POWER1    17
#define POWER2    25

#define START_SIZE 5
#define SIGNAL_SIZE 10

#define PUSH_SFRPAGE _asm push _SFRPAGE _endasm
#define POP_SFRPAGE _asm pop _SFRPAGE _endasm

#define VDD 3.325 //Will need to be measured 

volatile unsigned char signal[SIGNAL_SIZE];
volatile unsigned char pwm_count;
volatile bit           mode;
volatile unsigned char LF, LB, RF, RB, signal_counter, start_counter, interrupt_counter;
volatile bit right_motor, back_right_motor, left_motor, back_left_motor; 
volatile bit  c, buffer_full, flag;
volatile int sum;



char _c51_external_startup (void)
{
	PCA0MD&=(~0x40) ;    // DISABLE WDT: clear Watchdog Enable bit
	VDM0CN=0x80; // enable VDD monitor
	RSTSRC=0x02|0x04; // Enable reset on missing clock detector and VDD

	// CLKSEL&=0b_1111_1000; // Not needed because CLKSEL==0 after reset
	#if (SYSCLK == 12000000L)
	
		//CLKSEL|=0b_0000_0000;  // SYSCLK derived from the Internal High-Frequency Oscillator / 4 
	#elif (SYSCLK == 24000000L)
		CLKSEL|=0b_0000_0010; // SYSCLK derived from the Internal High-Frequency Oscillator / 2.
	#elif (SYSCLK == 48000000L)
		CLKSEL|=0b_0000_0011; // SYSCLK derived from the Internal High-Frequency Oscillator / 1.
	#else
		#error SYSCLK must be either 12000000L, 24000000L, or 48000000L
	#endif
	OSCICN |= 0x03; // Configure internal oscillator for its maximum frequency

	// Configure UART0
	SCON0 = 0x10; 
#if (SYSCLK/BAUDRATE/2L/256L < 1)
	TH1 = 0x10000-((SYSCLK/BAUDRATE)/2L);
	CKCON &= ~0x0B;                  // T1M = 1; SCA1:0 = xx
	CKCON |=  0x08;
#elif (SYSCLK/BAUDRATE/2L/256L < 4)
	TH1 = 0x10000-(SYSCLK/BAUDRATE/2L/4L);
	CKCON &= ~0x0B; // T1M = 0; SCA1:0 = 01                  
	CKCON |=  0x01;
#elif (SYSCLK/BAUDRATE/2L/256L < 12)
	TH1 = 0x10000-(SYSCLK/BAUDRATE/2L/12L);
	CKCON &= ~0x0B; // T1M = 0; SCA1:0 = 00
#else
	TH1 = 0x10000-(SYSCLK/BAUDRATE/2/48);
	CKCON &= ~0x0B; // T1M = 0; SCA1:0 = 10
	CKCON |=  0x02;
#endif
	TL1 = TH1;      // Init Timer1
	TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit autoreload
	TMOD |=  0x20;                       
	TR1 = 1; // START Timer1
	TI = 1;  // Indicate TX0 ready
	
	// Configure the pins used for square output
	P1MDOUT=0b_0000_0000;
	P1 = 0b_1000_0000;
	P2MDOUT|=0b_0011_1100;
	P0MDOUT |= 0b_0001_0100; // Enable UTX as push-pull output
	XBR0     = 0b_0000_0001; // Enable UART on P0.4(TX) and P0.5(RX)                     
	XBR1     = 0b_0100_0000; // Enable crossbar and weak pull-ups
	
	P1MDIN &= 0b1000_0000; //Pin 1_7 
	
	
	//Peak Detector 
	P2MDIN &= 0b1111_1100; //Pins 2_0, 2_1
	P2SKIP |= 0b0000_0011; //Skip crossbar decoding 
	AMX0P = LQFP32_MUX_P2_0; // Select positive input from P2.0, will need to be changed when readng from 2_1
	AMX0N = LQFP32_MUX_GND;  // GND is negative input (Single-ended Mode)
	
	ADC0CF = 0xF8; // SAR clock = 31, Right-justified result
	ADC0CN = 0b_1000_0000; // AD0EN=1, AD0TM=0
  	REF0CN=0b_0000_1000; //Select VDD as the voltage reference for the converter
	
	
	// Initialize timer 2 for periodic interrupts
	TMR2CN=0x00;   // Stop Timer2; Clear TF2;
	CKCON|=0b_0001_0000;
	TMR2RL=(-(SYSCLK/(2*48))/(100L)); // Initialize reload value
	TMR2=0xffff;   // Set to reload immediately
	ET2=1;         // Enable Timer2 interrupts
	TR2=1;         // Start Timer2
	
	// Initialize timer 5 for periodic interrupts
	SFRPAGE = 0xF;
	TMR5CN=0x00;   // Stop Timer5; Clear TF5;
	CKCON1|=0b_0000_0100;
	
	///////NEED THE RATE
//	TMR5RL=(-(SYSCLK/(2*48))/(200L)); // Initialize reload value
	///////
	
	TMR5RL = (0x10000L - (SYSCLK / 996));
	
	TMR5=0xffff;   // Set to reload immediately
	EIE2 |= ET5;        // Enable Timer5 interrupts
	TR5=1;         // Start Timer5

	return 0;
}

//this timer is used as a baud rate thingy for receiving data
void Timer5_ISR (void) interrupt INTERRUPT_TIMER5
{
	 
	//change spf page
	PUSH_SFRPAGE;
	SFRPAGE=0xf; 
	
	TF5H = 0; // Clear Timer5 interrupt flag
	
	if(interrupt_counter < 10)
	{
		interrupt_counter++;
		sum += SIGNAL_IN;
		//P0_2 = !P0_2;
	}
	else
	{
		P0_2 = !P0_2;
	
		interrupt_counter = 0;
		
		//printf("%u", SIGNAL_IN);
		
		if(!buffer_full)
		{
			if(!flag)
			{
				if (SIGNAL_IN) 
					start_counter++; 
				else 
					start_counter=0; 
					
				if (start_counter>START_SIZE-1)	//sorta worked at >= 11, so Iunno.
				{
					flag = 1;
					start_counter = 0;
				}
			}
			else
			{		
				if(signal_counter < SIGNAL_SIZE)
				{	
					//signal[signal_counter] = SIGNAL_IN;
					
					if(sum < 6)
						signal[signal_counter] = 0;
					else
						signal[signal_counter] = 1;
						
					
					sum=0;
					
					signal_counter++; 
				}
				else
				{
					signal_counter = 0;
					flag = 0;
					buffer_full = 1;
				}
			}
		}
		
	}
	
	/*if(b<32){
		signal[32-b] = SIGNAL_IN;
		b++;
	*/
		//restore spf page
	SFRPAGE=0xf;
	POP_SFRPAGE;
	return;
}

//this timer will control the power to both motors through pulse width modulation
void Timer2_ISR (void) interrupt 5
{
	SFRPAGE = 0x0;
	TF2H = 0; // Clear Timer2 interrupt flag
	
	pwm_count++;
	if(pwm_count>100) 
		pwm_count=0;
	
	if(LB == 0){
		LEFT_FORWARD=pwm_count>LF?0:1;
	}
	if(LF == 0){
		LEFT_BACKWARD=pwm_count>LB?0:1;
	}
	if(RB == 0){
		RIGHT_FORWARD=pwm_count>RF?0:1;
	}
	if(RF == 0){
		RIGHT_BACKWARD=pwm_count>RB?0:1;
	}
}

int pow( int base, int exp){

	int i = 0;
	int result = 1;
	
	for(i=0; i< exp; i++)
		result *= base;
	
	return result;
}

int binary2int(int start, int stop){

	int counter = 0;
	int num = 0;
	
	for(counter = start; counter <= stop; counter++)
		num += signal[counter]*pow(2, stop - counter);

	return num;
}

void direction(unsigned char left, unsigned char right)
{
    if (left == 1 && right == 1) //both forward moters high  
    {
        right_motor = 1; 
        left_motor = 1;
        back_right_motor = 0; 
        back_left_motor = 0;   
    }
    else if (left == 0 && right == 1) // left forward high, right backward high
    {
        right_motor = 0; 
        left_motor = 1; 
        back_right_motor = 1; 
        back_left_motor = 0; 
    }
    else if (left == 1 && right == 0) // left backward high, right forward high  
    {
        right_motor = 1; 
        left_motor = 0; 
        back_right_motor = 0; 
        back_left_motor = 1; 
    }
    else if (left == 0 && right == 0) //both backward moters high
    {
        right_motor = 0; 
        left_motor = 0; 
        back_right_motor = 1; 
        back_left_motor = 1; 
    }
    
}

void left_motor_power(int power)
{
    if (left_motor == 1)
        LF = power; 
    if (left_motor == 0) 
        LF = 0; 
    if (back_left_motor == 1)
        LB = power; 
    if (back_left_motor == 0)
        LB = 0; 
    
}

void right_motor_power(int power)
{
    if (right_motor == 1)
        RF = power; 
    if (right_motor == 0) 
        RF = 0; 
    if (back_right_motor == 1)
        RB = power; 
    if (back_right_motor == 0)
        RB = 0; 
}

void parse_power(int *power)
{
	*power = *power * 14;
}

void main(void){
	
    //unsigned long int testNumber; 
    int i; 
    int left_power = 0, right_power = 0;
    bit left_dir = 1, right_dir = 1, other_button = 0;
    int power;
    
    //int testArray[32];
  	
  	SIGNAL_IN = 0;
    
	//initialization
	_c51_external_startup();
	//b = 0;
	mode = 0;
	LF = 0;
	LB = 0;
	RF = 0;
	RB = 0;
	signal_counter = 0; 
	start_counter = 0; 
	buffer_full = 0;
	flag = 0;
	interrupt_counter = 0;
	
	sum = 0;
	power = 0;
	
	/*
	//Specifically for testing, remove later 
	printf("Enter integer\n");
	//scanf("%lu", &testNumber); 
	testNumber = 0b_00_11_0_111_0_111; 
	printf("\n%lu\n", testNumber); 
	for (i=0; i<SIGNAL_SIZE; i++)
	{
		signal[SIGNAL_SIZE -1 - i] = (((unsigned long int)1 << i) & testNumber) >> i; 
		//printf("%u", signal[SIGNAL_SIZE -1 -i]); 
	}
	
	buffer_full = 1; //ggggggggggggggggggggggg
	
	
	for (i=0; i<SIGNAL_SIZE; i++)
	{
		printf("%u", signal[i]); 
	}
	
	SIGNAL_IN = 1; 
	*/
	
	
	//wait when we start until the first start sequence
	while(!SIGNAL_IN)
		printf("%u", SIGNAL_IN);
	
	printf("hi");
	//interrupt_counter = 5;	
	
	EA = 1;
	
	
	
	while(1)
	{
		SFRPAGE = 0xF;
		EIE2 |= ET5;
		SFRPAGE = 0;
		
		//wait for the first bit to come in
		//Temporarily changed for testing purposes 
		//while(b == MODE_BIT);
		//double check this logic
		//mode = signal[12] ? 0:1;      //need to know size of start 
		//mode = joystick; 
		//printf("\nYEEEEE"); 
		//decode the signal if you are in this mode
		//if(mode == joystick)
		//{
		
			if(buffer_full)
			{
				printf("\nBuffer full\n");
				printf("Received Signal: ");
				for (i=0; i<SIGNAL_SIZE; i++) 
					printf("%u", signal[i]); 
				
				EIE2 &= 0b_1101_1111;
				
				buffer_full = 0;
				
				printf("\npad: %u", signal[0]);
				mode = signal[1];
				printf("\nmode:%u", mode);
				
				other_button = signal[2];
				printf("\nbutton:%u", other_button);
				
				left_dir = signal[3];
				printf("\nleftdir:%u", left_dir);
				
				right_dir = signal[4];
				printf("\nrightdir:%u", right_dir);
				
				power = binary2int(7, 9);
				parse_power(&power);
				printf("\npower:%d", power);
				/*
				left_power = binary2int(6, 8);
				parse_power(&left_power);
				printf("\nleftpow:%i", left_power);
				
				right_power = binary2int(11, 13);
				parse_power(&right_power);
				printf("\nrightpow:%i\n", right_power);
				*/
						
				EIE2 |= 0b_0010_0000;
			}
			
			
			/*
			//printf("\nYEEEEE"); 
			//enable timer 5
			printf("\n%u", b); 
			while(b != DIRECTION);
			printf("\n%u", b); 
			//call a function to interpret that bit of the signal
            direction(signal[DIRECTION], signal[DIRECTION+1]); 
			printf("\n%u", b);
			while(b != POWER1);
			//call function to convert power
			temp_1 = binary2int(POWER1, POWER2-1);
            left_motor_power(temp_1); 
            printf("%u\n, %u\n, %u\n, %u\n, ", LF, RF, LB, RB); 
            
			
			while(b != POWER2);
			//call a function to convert power
			temp_2 = binary2int(POWER2, 31);
            right_motor_power(temp_2);
            */
		
		
		//if(mode == joystick)
		if(1)
		
		{
			/*
			direction(left_dir, right_dir); 
					
	        left_motor_power(left_power); 
					
	        right_motor_power(right_power);
			*/
			
			direction(left_dir, right_dir); 
					
	        left_motor_power(power); 
					
	        right_motor_power(power);
		
		}
		
		//maintain a constant, programeable distance from the controller
		else if (mode == tether)
		{
			
			//disable timer 5
			
		}
	}
}