//  freq_gen.c: Uses timer 2 interrupt to generate a square wave at pins
//  P2.0 and P2.1.  The program allows the user to enter a frequency.
//  Copyright (c) 2010-2015 Jesus Calvino-Fraga
//  ~C51~

#include <C8051F38x.h>
#include <stdlib.h>
#include <stdio.h>

#define SYSCLK    48000000L // SYSCLK frequency in Hz
#define BAUDRATE  115200L   // Baud rate of UART in bps
#define DEFAULT_F 15500L
#define  SMB_FREQUENCY  100000L   // I2C SCL clock rate (10kHz to 100kHz)
#define  START_SIGNAL 0b_11111 
#define  RESON_FREQUENCY  0x10000L-(SYSCLK/(2L*15000))



#define TRANSMIT_RATE  10

#define  LED        P2_2
#define  LED_ON     0
#define  LED_OFF    1
#define OUT0 P2_0
#define OUT1 P2_1

#define XMIN 127.0
#define XMAX 127.0
#define YMIN 127.0
#define YMAX 127.0
#define GOTO_YX "\x1B[%d;%dH"

volatile float LF;
volatile float LB;
volatile float RF;
volatile float RB;
int convert[12];


void Decode_Signal(int joy_x, int joy_y)
{
		if(joy_x<=10 && joy_x >=-10)
			joy_x = 0;
		if(joy_y<=10 && joy_y >=-10)
			joy_y = 0;
			
		if(joy_x!=0 && joy_y==0){
		
			if(joy_x>0){
			
				LF = joy_x/127.0*100.0;
				RB = LF;
			
			}
			
			if(joy_x<0)
			{
			
				RF = -joy_x/127.0*100.0;
				LB = RF;
			}
		
		}
		
		else if(joy_y!=0 && joy_x==0){
		
			if(joy_y>0){
			
				LF = joy_y/127.0*100.0;
				RF = LF;
			
			}
			
			if(joy_y<0){
			
				RB = -joy_y/127.0*100.0;
				LB = RB;
			
			}
		
		}
		
		else{
		
			if(joy_x>0 && joy_y>0){
				
				RF = (joy_y/127.0*100.0)/2.0;
				LF = RF + (joy_x/127.0*100.0)/2.0; //value may need to change
			
			}
			
			else if(joy_x<0 && joy_y<0){
				
				RB = -(joy_y/127.0*100.0)/2.0;
				LB = RB -(joy_x/127.0*100.0)/2.0; //value may need to change
			
			}
			
			else if(joy_x>0 && joy_y<0){
				
				RB = -(joy_y/127.0*100.0)/2.0;
				LF = RF - (joy_x/88*100.0)/2.0; //value may need to change
			
			}
			
			else if(joy_x<0 && joy_y>0){
				
				LF = (joy_y/127.0*100.0)/2.0;
				RF = LF - (joy_x/127.0*100.0)/2.0; //value may need to change
			
			}	
			
		}
	return;
}


volatile unsigned char pwm_count=0;

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
	P2MDOUT |= 0b0000_0111;   // Make the LED (P2.2) a push-pull output
	XBR0 = 0b0000_0101;       // Enable SMBus pins and UART pins P0.4(TX) and P0.5(RX)                    
	XBR1     = 0x40; // Enable crossbar and weak pull-ups
	
	// Configure Timer 0 as the I2C clock source
	CKCON |= 0x04; // Timer0 clock source = SYSCLK
	TMOD &= 0xf0;  // Mask out timer 1 bits
	TMOD |= 0x02;  // Timer0 in 8-bit auto-reload mode
	// Timer 0 configured to overflow at 1/3 the rate defined by SMB_FREQUENCY
	TL0 = TH0 = 256-(SYSCLK/SMB_FREQUENCY/3);
	TR0 = 1; // Enable timer 0
	
	// Configure and enable SMBus
	SMB0CF = INH | EXTHOLD | SMBTOE | SMBFTE ;
	SMB0CF |= ENSMB;  // Enable SMBus

	// Initialize timer 2 for periodic interrupts
	TMR2CN=0x00;   // Stop Timer2; Clear TF2;
	CKCON|=0b_0001_0000;
	TMR2RL= RESON_FREQUENCY; // Initialize reload value
	TMR2=0xffff;   // Set to reload immediately
	ET2=1;         // Enable Timer2 interrupts
	TR2=0;         //Don't Start Timer2

	EA=1; // Enable interrupts
	

	LED = LED_OFF;

	EA=1; // Enable interrupts
	
	return 0;
}
void Timer4ms(unsigned char ms)
{
	unsigned char i;// usec counter
	unsigned char k;
	
	k=SFRPAGE;
	SFRPAGE=0xf;
	// The input for Timer 4 is selected as SYSCLK by setting bit 0 of CKCON1:
	CKCON1|=0b_0000_0001;
	
	TMR4RL = 65536-(SYSCLK/1000L); // Set Timer4 to overflow in 1 ms.
	TMR4 = TMR4RL;                 // Initialize Timer4 for first overflow
	
	TMR4CN = 0x04;                 // Start Timer4 and clear overflow flag
	for (i = 0; i < ms; i++)       // Count <ms> overflows
	{
		while (!(TMR4CN & 0x80));  // Wait for overflow
		TMR4CN &= ~(0x80);         // Clear overflow indicator
	}
	TMR4CN = 0 ;                   // Stop Timer4 and clear overflow flag
	SFRPAGE=k;	
}

void I2C_write (unsigned char output_data)
{
	SMB0DAT = output_data; // Put data into buffer
	SI0 = 0;
	while (!SI0); // Wait until done with send
}

unsigned char I2C_read (void)
{
	unsigned char input_data;

	SI0 = 0;
	while (!SI0); // Wait until we have data to read
	input_data = SMB0DAT; // Read the data

	return input_data;
}

void I2C_start (void)
{
	ACK0 = 1;
	STA0 = 1;     // Send I2C start
	STO0 = 0;
	SI0 = 0;
	while (!SI0); // Wait until start sent
	STA0 = 0;     // Reset I2C start
}

void I2C_stop(void)
{
	STO0 = 1;  	// Perform I2C stop
	SI0 = 0;	// Clear SI
	//while (!SI0);	   // Wait until stop complete (Doesn't work???)
}

void nunchuck_init(bit print_extension_type)
{
	unsigned char i, buf[6];
	
	// Older initialization format that works only for older nunchucks
	//I2C_start();
	//I2C_write(0xA4);
	//I2C_write(0x40);
	//I2C_write(0x00);
	//I2C_stop();
	
	// Newer initialization format that works for all nunchucks
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xF0);
	I2C_write(0x55);
	I2C_stop();
	Timer4ms(1);
	 
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xFB);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);

	// Read the extension type from the register block.  For the original Nunchuk it should be
	// 00 00 a4 20 00 00.
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xFA); // extension type register
	I2C_stop();
	Timer4ms(3); // 3 ms required to complete acquisition

	I2C_start();
	I2C_write(0xA5);
	
	// Receive values
	for(i=0; i<6; i++)
	{
		buf[i]=I2C_read();
	}
	ACK0=0;
	I2C_stop();
	Timer4ms(3);
	
	if(print_extension_type)
	{
		printf("Extension type: %02x  %02x  %02x  %02x  %02x  %02x\n", 
			buf[0],  buf[1], buf[2], buf[3], buf[4], buf[5]);
	}

	// Send the crypto key (zeros), in 3 blocks of 6, 6 & 4.

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xF0);
	I2C_write(0xAA);
	I2C_stop();
	Timer4ms(1);

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x40);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x40);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x40);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);
	
}

int round_to_ten( int num)
{
	return num/14; 
}

void nunchuck_getdata(unsigned char * s)
{
	unsigned char i;

	// Start measurement
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(3); 	// 3 ms required to complete acquisition

	// Request values
	I2C_start();
	I2C_write(0xA5);
	
	// Receive values
	for(i=0; i<6; i++)
	{
		s[i]=(I2C_read()^0x17)+0x17; // Read and decrypt
	}
	ACK0=0;
	I2C_stop();
}

void send_bit(int b)
{
	if(b == 1)
	{
		OUT1 = 0;
		OUT0 = 1;
		TR2 = 1;
		Timer4ms(TRANSMIT_RATE-2);
		TR2 = 0;
		Timer4ms(2);
	}
	else
	{
		OUT1 = 0;
		OUT0 = 0;
		Timer4ms(TRANSMIT_RATE);
	}
 	TR2 = 0;
 	OUT1 = 0;
	OUT0 = 0;
}

void send_int(int num, int size)
{
	int i;
	for(i = size; i>0; i--)
	{
		convert[i-1] = num%2;
		num = num / 2;
	}
	for(i = 0;i<size;i++)
	{
		send_bit(convert[i]);
	}
}


void Timer2_ISR (void) interrupt 5
{
	unsigned char page_save;
    page_save=SFRPAGE;
    SFRPAGE=0;
	TF2H = 0; // Clear Timer2 interrupt flag
	OUT0=!OUT0;
	OUT1=!OUT1;
	SFRPAGE=page_save;
}

void main (void)
{
	unsigned char rbuf[6];
 	int joy_x, joy_y, off_x, off_y, acc_x, acc_y, acc_z;
 	bit but1, but2;
	bit l_dir, r_dir;
	int left_power, right_power;
	int power=0;
	
	
	
	
	
	EA = 1;

	printf("\x1b[2J\x1b[1;1H"); // Clear screen using ANSI escape sequence.
	printf("\n\nWII Nunchuck I2C Reader\n");

	Timer4ms(200);
	nunchuck_init(1);
	Timer4ms(100);

	nunchuck_getdata(rbuf);

	off_x=(int)rbuf[0]-128;
	off_y=(int)rbuf[1]-128;
	printf("Offset_X:%4d Offset_Y:%4d\n\n", off_x, off_y);

	while(1)
	{
	
		nunchuck_getdata(rbuf);
		joy_x=(int)rbuf[0]-128-off_x;
		joy_y=(int)rbuf[1]-128-off_y;
		acc_x=rbuf[2]*4; 
		acc_y=rbuf[3]*4;
		acc_z=rbuf[4]*4;
		but1=!((rbuf[5] & 0x01)?1:0);
		but2=!((rbuf[5] & 0x02)?1:0);
		if (rbuf[5] & 0x04) acc_x+=2;
		if (rbuf[5] & 0x08) acc_x+=1;
		if (rbuf[5] & 0x10) acc_y+=2;
		if (rbuf[5] & 0x20) acc_y+=1;
		if (rbuf[5] & 0x40) acc_z+=2;
		if (rbuf[5] & 0x80) acc_z+=1;
		
		LF = 0;
		RF = 0;
		LB = 0;
		RB = 0;

	  if(but1)
	  	{
	  
		  	printf("\nTracking Mode!\n");
		  	Timer4ms(50);
			while(but1)
			{
				nunchuck_getdata(rbuf);
		 		but1 = !((rbuf[5] & 0x01)?1:0);
		 		Timer4ms(50);
			}
			OUT1 = 0;
			OUT0 = 1;
			TR2 = 1;
			printf("\nTracking Mode!\n");
			Timer4ms(50);
	    	while(!but1)
			{
			nunchuck_getdata(rbuf);
		 	but1 = !((rbuf[5] & 0x01)?1:0);
		 	Timer4ms(50);
			}
			printf("\nTracking Mode!\n");
			Timer4ms(50);
			while(but1)
			{
				nunchuck_getdata(rbuf);
		 		but1 = !((rbuf[5] & 0x01)?1:0);
		 		Timer4ms(50);
			}
			OUT1 =0;
			OUT0 = 0;
			TR2 = 0;
			printf("\nControl!\n");
		}
	else
	{
			
		l_dir = 1;
		r_dir = 1;
		power = 0;
		
		if(joy_x > 5)
		{
			l_dir = 1;
			r_dir = 0;
			power = (int) 1*((float)joy_x/127)*100/14;
		}
		else if(joy_x < -5)
		{
			l_dir = 0;
			r_dir = 1;
			power = (int) -1*((float)joy_x/127)*100/14;
		}
		
		if(joy_y > 5)
		{
			l_dir = 1;
			r_dir = 1;
			power = (int) 1*((float)joy_y/127)*100/14;
		}
		else if(joy_y < -5)
		{
			l_dir = 0;
			r_dir = 0;
			power = (int) -1*((float)joy_y/127)*100/14;
		}
			
		send_int(START_SIGNAL, 5);
		send_bit(0); 
		send_bit(but1);
		send_bit(but2);
		send_bit(l_dir);
		send_bit(r_dir);
		send_bit(0);
		send_bit(0);
		send_int(power,3);
		send_int(0, 4);
	}

  }
}