#include <C8051F38x.h>
#include <stdio.h>

#define  SYSCLK         48000000L // System clock frequency in Hz
#define  BAUDRATE       115200L
#define  DATABAUD		111111L 		//MUST CHANGE

//ASSIGN PROPER PINS
#define  LEFT_FORWARD    P2_1
#define  RIGHT_FORWARD   P2_1
#define  LEFT_BACKWARD   P2_1
#define  RIGHT_BACKWARD  P2_1

#define SIGNAL_IN P2_1 ///where ever the signal comes in from receiver

//all of there need to be confirmed
#define joystick  0
#define tether    1
#define MODE_BIT  12
#define DIRECTION 15
#define POWER1    22
#define POWER2    29

#define PUSH_SFRPAGE _asm push _SFRPAGE _endasm
#define POP_SFRPAGE _asm pop _SFRPAGE _endasm

volatile unsigned char buffer[33];
volatile unsigned char signal[33];
volatile unsigned char pwm_count;
volatile bit           mode;
volatile unsigned char LF, LB, RF, RB, b;
volatile bit right_motor, back_right_motor, left_motor, back_left_motor; 
volatile bit z, c;


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
	P2MDOUT|=0b_0000_0011;
	P0MDOUT |= 0x10; // Enable UTX as push-pull output
	XBR0     = 0x01; // Enable UART on P0.4(TX) and P0.5(RX)                     
	XBR1     = 0x40; // Enable crossbar and weak pull-ups

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
	TMR5RL=(-(SYSCLK/(2*48))/(100L)); // Initialize reload value
	///////
	
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
	if(b<32){
		signal[32-b] = SIGNAL_IN;
		b++;
		//restore spf page
		SFRPAGE=0xf;
		POP_SFRPAGE;
		return;
	}
	//restore spf page
	b = 0;
	SFRPAGE=0xf;
	POP_SFRPAGE;
}

//this timer will control the power to both motors through pulse width modulation
void Timer2_ISR (void) interrupt 5
{
	SFRPAGE = 0x0;
	TF2H = 0; // Clear Timer2 interrupt flag
	
	pwm_count++;
	if(pwm_count>100) pwm_count=0;
	
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
	int result = 0;
	
	while(1 != exp)
		result += base;
	
	return result;
}

int binary2int(int start, int stop){

	int counter = 0;
	int num = 0;
	
	for(counter = start; counter <= stop; counter++)
		num += signal[counter]*pow(2, counter - start);

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
    else if (left == 1 && right == 0) // left forward high, right backward high
    {
        right_motor = 0; 
        left_motor = 1; 
        back_right_motor = 1; 
        back_left_motor = 0; 
    }
    else if (left == 0 && right == 1) // left backward high, right forward high  
    {
        right_motor = 1; 
        left_motor = 0; 
        back_right_motor = 1; 
        back_left_motor = 0; 
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
    else if (left_motor == 0) 
        LF = 0; 
    else if (back_left_motor == 1)
        LB = power; 
    else if (back_left_motor == 0)
        LB = 0; 
}

void right_motor_power(int power)
{
    if (right_motor == 1)
        RF = power; 
    else if (right_motor == 0) 
        RF = 0; 
    else if (back_right_motor == 1)
        RB = power; 
    else if (back_right_motor == 0)
        RB = 0; 
}

void main(void){
	
	unsigned char temp_1;
	unsigned char temp_2;
    
	//initialization
	_c51_external_startup();
	b = 0;
	mode = 0;
	LF = 0;
	LB = 0;
	RF = 0;
	RB = 0;
	
	
	//wait when we start until the first start sequence
	while(!SIGNAL_IN);
	EA = 1;
	
	
	
	while(1)
	{
		SFRPAGE = 0xF;
		EIE2 |= ET5;
		SFRPAGE = 0;
		//wait for the first bit to come in
		while(b == MODE_BIT);
		//double check this logic
		mode = signal[32] ? 0:1;      //need to know size of start 
	
		//decode the signal if you are in this mode
		if(mode == joystick)
		{
			
			//enable timer 5
			
			while(b != DIRECTION); 
			//call a function to interpret that bit of the signal
            direction(signal[DIRECTION], signal[DIRECTION+1]); 
			
			while(b != POWER1);
			//call function to convert power
			temp_1 = binary2int(POWER1, POWER2);
            left_motor_power(temp_1); 
            
			
			while(b != POWER2);
			//call a function to convert power
			temp_2 = binary2int(POWER2, 0);
            right_motor_power(temp_2);
            
		
		}
		
		//maintain a constant, programeable distance from the controller
		else if (mode == tether)
		{
			
			//disable timer 5
			
		}
	}
}