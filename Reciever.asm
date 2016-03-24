;--------------------------------------------------------
; File Created by C51
; Version 1.0.0 #1069 (Apr 23 2015) (MSVC)
; This file was generated Thu Mar 24 10:58:12 2016
;--------------------------------------------------------
$name Reciever
$optc51 --model-small
	R_DSEG    segment data
	R_CSEG    segment code
	R_BSEG    segment bit
	R_XSEG    segment xdata
	R_PSEG    segment xdata
	R_ISEG    segment idata
	R_OSEG    segment data overlay
	BIT_BANK  segment data overlay
	R_HOME    segment code
	R_GSINIT  segment code
	R_IXSEG   segment xdata
	R_CONST   segment code
	R_XINIT   segment code
	R_DINIT   segment code

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	public _direction_PARM_2
	public _pow_PARM_2
	public _main
	public _right_motor_power
	public _left_motor_power
	public _direction
	public _binary2int
	public _pow
	public _Timer2_ISR
	public _Timer5_ISR
	public __c51_external_startup
	public _c
	public _z
	public _back_left_motor
	public _left_motor
	public _back_right_motor
	public _right_motor
	public _mode
	public _binary2int_PARM_2
	public _b
	public _RB
	public _RF
	public _LB
	public _LF
	public _pwm_count
	public _signal
	public _buffer
;--------------------------------------------------------
; Special Function Registers
;--------------------------------------------------------
_P0             DATA 0x80
_SP             DATA 0x81
_DPL            DATA 0x82
_DPH            DATA 0x83
_EMI0TC         DATA 0x84
_EMI0CF         DATA 0x85
_OSCLCN         DATA 0x86
_PCON           DATA 0x87
_TCON           DATA 0x88
_TMOD           DATA 0x89
_TL0            DATA 0x8a
_TL1            DATA 0x8b
_TH0            DATA 0x8c
_TH1            DATA 0x8d
_CKCON          DATA 0x8e
_PSCTL          DATA 0x8f
_P1             DATA 0x90
_TMR3CN         DATA 0x91
_TMR4CN         DATA 0x91
_TMR3RLL        DATA 0x92
_TMR4RLL        DATA 0x92
_TMR3RLH        DATA 0x93
_TMR4RLH        DATA 0x93
_TMR3L          DATA 0x94
_TMR4L          DATA 0x94
_TMR3H          DATA 0x95
_TMR4H          DATA 0x95
_USB0ADR        DATA 0x96
_USB0DAT        DATA 0x97
_SCON           DATA 0x98
_SCON0          DATA 0x98
_SBUF           DATA 0x99
_SBUF0          DATA 0x99
_CPT1CN         DATA 0x9a
_CPT0CN         DATA 0x9b
_CPT1MD         DATA 0x9c
_CPT0MD         DATA 0x9d
_CPT1MX         DATA 0x9e
_CPT0MX         DATA 0x9f
_P2             DATA 0xa0
_SPI0CFG        DATA 0xa1
_SPI0CKR        DATA 0xa2
_SPI0DAT        DATA 0xa3
_P0MDOUT        DATA 0xa4
_P1MDOUT        DATA 0xa5
_P2MDOUT        DATA 0xa6
_P3MDOUT        DATA 0xa7
_IE             DATA 0xa8
_CLKSEL         DATA 0xa9
_EMI0CN         DATA 0xaa
__XPAGE         DATA 0xaa
_SBCON1         DATA 0xac
_P4MDOUT        DATA 0xae
_PFE0CN         DATA 0xaf
_P3             DATA 0xb0
_OSCXCN         DATA 0xb1
_OSCICN         DATA 0xb2
_OSCICL         DATA 0xb3
_SBRLL1         DATA 0xb4
_SBRLH1         DATA 0xb5
_FLSCL          DATA 0xb6
_FLKEY          DATA 0xb7
_IP             DATA 0xb8
_CLKMUL         DATA 0xb9
_SMBTC          DATA 0xb9
_AMX0N          DATA 0xba
_AMX0P          DATA 0xbb
_ADC0CF         DATA 0xbc
_ADC0L          DATA 0xbd
_ADC0H          DATA 0xbe
_SFRPAGE        DATA 0xbf
_SMB0CN         DATA 0xc0
_SMB1CN         DATA 0xc0
_SMB0CF         DATA 0xc1
_SMB1CF         DATA 0xc1
_SMB0DAT        DATA 0xc2
_SMB1DAT        DATA 0xc2
_ADC0GTL        DATA 0xc3
_ADC0GTH        DATA 0xc4
_ADC0LTL        DATA 0xc5
_ADC0LTH        DATA 0xc6
_P4             DATA 0xc7
_TMR2CN         DATA 0xc8
_TMR5CN         DATA 0xc8
_REG01CN        DATA 0xc9
_TMR2RLL        DATA 0xca
_TMR5RLL        DATA 0xca
_TMR2RLH        DATA 0xcb
_TMR5RLH        DATA 0xcb
_TMR2L          DATA 0xcc
_TMR5L          DATA 0xcc
_TMR2H          DATA 0xcd
_TMR5H          DATA 0xcd
_SMB0ADM        DATA 0xce
_SMB1ADM        DATA 0xce
_SMB0ADR        DATA 0xcf
_SMB1ADR        DATA 0xcf
_PSW            DATA 0xd0
_REF0CN         DATA 0xd1
_SCON1          DATA 0xd2
_SBUF1          DATA 0xd3
_P0SKIP         DATA 0xd4
_P1SKIP         DATA 0xd5
_P2SKIP         DATA 0xd6
_USB0XCN        DATA 0xd7
_PCA0CN         DATA 0xd8
_PCA0MD         DATA 0xd9
_PCA0CPM0       DATA 0xda
_PCA0CPM1       DATA 0xdb
_PCA0CPM2       DATA 0xdc
_PCA0CPM3       DATA 0xdd
_PCA0CPM4       DATA 0xde
_P3SKIP         DATA 0xdf
_ACC            DATA 0xe0
_XBR0           DATA 0xe1
_XBR1           DATA 0xe2
_XBR2           DATA 0xe3
_IT01CF         DATA 0xe4
_CKCON1         DATA 0xe4
_SMOD1          DATA 0xe5
_EIE1           DATA 0xe6
_EIE2           DATA 0xe7
_ADC0CN         DATA 0xe8
_PCA0CPL1       DATA 0xe9
_PCA0CPH1       DATA 0xea
_PCA0CPL2       DATA 0xeb
_PCA0CPH2       DATA 0xec
_PCA0CPL3       DATA 0xed
_PCA0CPH3       DATA 0xee
_RSTSRC         DATA 0xef
_B              DATA 0xf0
_P0MDIN         DATA 0xf1
_P1MDIN         DATA 0xf2
_P2MDIN         DATA 0xf3
_P3MDIN         DATA 0xf4
_P4MDIN         DATA 0xf5
_EIP1           DATA 0xf6
_EIP2           DATA 0xf7
_SPI0CN         DATA 0xf8
_PCA0L          DATA 0xf9
_PCA0H          DATA 0xfa
_PCA0CPL0       DATA 0xfb
_PCA0CPH0       DATA 0xfc
_PCA0CPL4       DATA 0xfd
_PCA0CPH4       DATA 0xfe
_VDM0CN         DATA 0xff
_DPTR           DATA 0x8382
_TMR2RL         DATA 0xcbca
_TMR3RL         DATA 0x9392
_TMR4RL         DATA 0x9392
_TMR5RL         DATA 0xcbca
_TMR2           DATA 0xcdcc
_TMR3           DATA 0x9594
_TMR4           DATA 0x9594
_TMR5           DATA 0xcdcc
_SBRL1          DATA 0xb5b4
_ADC0           DATA 0xbebd
_ADC0GT         DATA 0xc4c3
_ADC0LT         DATA 0xc6c5
_PCA0           DATA 0xfaf9
_PCA0CP1        DATA 0xeae9
_PCA0CP2        DATA 0xeceb
_PCA0CP3        DATA 0xeeed
_PCA0CP0        DATA 0xfcfb
_PCA0CP4        DATA 0xfefd
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
_P0_0           BIT 0x80
_P0_1           BIT 0x81
_P0_2           BIT 0x82
_P0_3           BIT 0x83
_P0_4           BIT 0x84
_P0_5           BIT 0x85
_P0_6           BIT 0x86
_P0_7           BIT 0x87
_TF1            BIT 0x8f
_TR1            BIT 0x8e
_TF0            BIT 0x8d
_TR0            BIT 0x8c
_IE1            BIT 0x8b
_IT1            BIT 0x8a
_IE0            BIT 0x89
_IT0            BIT 0x88
_P1_0           BIT 0x90
_P1_1           BIT 0x91
_P1_2           BIT 0x92
_P1_3           BIT 0x93
_P1_4           BIT 0x94
_P1_5           BIT 0x95
_P1_6           BIT 0x96
_P1_7           BIT 0x97
_S0MODE         BIT 0x9f
_SCON0_6        BIT 0x9e
_MCE0           BIT 0x9d
_REN0           BIT 0x9c
_TB80           BIT 0x9b
_RB80           BIT 0x9a
_TI0            BIT 0x99
_RI0            BIT 0x98
_SCON_6         BIT 0x9e
_MCE            BIT 0x9d
_REN            BIT 0x9c
_TB8            BIT 0x9b
_RB8            BIT 0x9a
_TI             BIT 0x99
_RI             BIT 0x98
_P2_0           BIT 0xa0
_P2_1           BIT 0xa1
_P2_2           BIT 0xa2
_P2_3           BIT 0xa3
_P2_4           BIT 0xa4
_P2_5           BIT 0xa5
_P2_6           BIT 0xa6
_P2_7           BIT 0xa7
_EA             BIT 0xaf
_ESPI0          BIT 0xae
_ET2            BIT 0xad
_ES0            BIT 0xac
_ET1            BIT 0xab
_EX1            BIT 0xaa
_ET0            BIT 0xa9
_EX0            BIT 0xa8
_P3_0           BIT 0xb0
_P3_1           BIT 0xb1
_P3_2           BIT 0xb2
_P3_3           BIT 0xb3
_P3_4           BIT 0xb4
_P3_5           BIT 0xb5
_P3_6           BIT 0xb6
_P3_7           BIT 0xb7
_IP_7           BIT 0xbf
_PSPI0          BIT 0xbe
_PT2            BIT 0xbd
_PS0            BIT 0xbc
_PT1            BIT 0xbb
_PX1            BIT 0xba
_PT0            BIT 0xb9
_PX0            BIT 0xb8
_MASTER0        BIT 0xc7
_TXMODE0        BIT 0xc6
_STA0           BIT 0xc5
_STO0           BIT 0xc4
_ACKRQ0         BIT 0xc3
_ARBLOST0       BIT 0xc2
_ACK0           BIT 0xc1
_SI0            BIT 0xc0
_MASTER1        BIT 0xc7
_TXMODE1        BIT 0xc6
_STA1           BIT 0xc5
_STO1           BIT 0xc4
_ACKRQ1         BIT 0xc3
_ARBLOST1       BIT 0xc2
_ACK1           BIT 0xc1
_SI1            BIT 0xc0
_TF2            BIT 0xcf
_TF2H           BIT 0xcf
_TF2L           BIT 0xce
_TF2LEN         BIT 0xcd
_TF2CEN         BIT 0xcc
_T2SPLIT        BIT 0xcb
_TR2            BIT 0xca
_T2CSS          BIT 0xc9
_T2XCLK         BIT 0xc8
_TF5H           BIT 0xcf
_TF5L           BIT 0xce
_TF5LEN         BIT 0xcd
_TMR5CN_4       BIT 0xcc
_T5SPLIT        BIT 0xcb
_TR5            BIT 0xca
_TMR5CN_1       BIT 0xc9
_T5XCLK         BIT 0xc8
_CY             BIT 0xd7
_AC             BIT 0xd6
_F0             BIT 0xd5
_RS1            BIT 0xd4
_RS0            BIT 0xd3
_OV             BIT 0xd2
_F1             BIT 0xd1
_PARITY         BIT 0xd0
_CF             BIT 0xdf
_CR             BIT 0xde
_PCA0CN_5       BIT 0xde
_CCF4           BIT 0xdc
_CCF3           BIT 0xdb
_CCF2           BIT 0xda
_CCF1           BIT 0xd9
_CCF0           BIT 0xd8
_ACC_7          BIT 0xe7
_ACC_6          BIT 0xe6
_ACC_5          BIT 0xe5
_ACC_4          BIT 0xe4
_ACC_3          BIT 0xe3
_ACC_2          BIT 0xe2
_ACC_1          BIT 0xe1
_ACC_0          BIT 0xe0
_AD0EN          BIT 0xef
_AD0TM          BIT 0xee
_AD0INT         BIT 0xed
_AD0BUSY        BIT 0xec
_AD0WINT        BIT 0xeb
_AD0CM2         BIT 0xea
_AD0CM1         BIT 0xe9
_AD0CM0         BIT 0xe8
_B_7            BIT 0xf7
_B_6            BIT 0xf6
_B_5            BIT 0xf5
_B_4            BIT 0xf4
_B_3            BIT 0xf3
_B_2            BIT 0xf2
_B_1            BIT 0xf1
_B_0            BIT 0xf0
_SPIF           BIT 0xff
_WCOL           BIT 0xfe
_MODF           BIT 0xfd
_RXOVRN         BIT 0xfc
_NSSMD1         BIT 0xfb
_NSSMD0         BIT 0xfa
_TXBMT          BIT 0xf9
_SPIEN          BIT 0xf8
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	rbank0 segment data overlay
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	rseg R_DSEG
_buffer:
	ds 33
_signal:
	ds 33
_pwm_count:
	ds 1
_LF:
	ds 1
_LB:
	ds 1
_RF:
	ds 1
_RB:
	ds 1
_b:
	ds 1
_binary2int_PARM_2:
	ds 2
_binary2int_num_1_37:
	ds 2
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	rseg	R_OSEG
_pow_PARM_2:
	ds 2
	rseg	R_OSEG
_direction_PARM_2:
	ds 1
	rseg	R_OSEG
	rseg	R_OSEG
;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	rseg R_ISEG
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	DSEG
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	rseg R_BSEG
_mode:
	DBIT	1
_right_motor:
	DBIT	1
_back_right_motor:
	DBIT	1
_left_motor:
	DBIT	1
_back_left_motor:
	DBIT	1
_z:
	DBIT	1
_c:
	DBIT	1
_Timer2_ISR_sloc0_1_0:
	DBIT	1
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	rseg R_PSEG
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	rseg R_XSEG
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	XSEG
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	rseg R_IXSEG
	rseg R_HOME
	rseg R_GSINIT
	rseg R_CSEG
;--------------------------------------------------------
; Reset entry point and interrupt vectors
;--------------------------------------------------------
	CSEG at 0x0000
	ljmp	_crt0
	CSEG at 0x002b
	ljmp	_Timer2_ISR
	CSEG at 0x00a3
	ljmp	_Timer5_ISR
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	rseg R_HOME
	rseg R_GSINIT
	rseg R_GSINIT
;--------------------------------------------------------
; data variables initialization
;--------------------------------------------------------
	rseg R_DINIT
	; The linker places a 'ret' at the end of segment R_DINIT.
;--------------------------------------------------------
; code
;--------------------------------------------------------
	rseg R_CSEG
;------------------------------------------------------------
;Allocation info for local variables in function '_c51_external_startup'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:36: char _c51_external_startup (void)
;	-----------------------------------------
;	 function _c51_external_startup
;	-----------------------------------------
__c51_external_startup:
	using	0
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:38: PCA0MD&=(~0x40) ;    // DISABLE WDT: clear Watchdog Enable bit
	anl	_PCA0MD,#0xBF
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:39: VDM0CN=0x80; // enable VDD monitor
	mov	_VDM0CN,#0x80
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:40: RSTSRC=0x02|0x04; // Enable reset on missing clock detector and VDD
	mov	_RSTSRC,#0x06
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:49: CLKSEL|=0b_0000_0011; // SYSCLK derived from the Internal High-Frequency Oscillator / 1.
	orl	_CLKSEL,#0x03
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:53: OSCICN |= 0x03; // Configure internal oscillator for its maximum frequency
	orl	_OSCICN,#0x03
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:56: SCON0 = 0x10; 
	mov	_SCON0,#0x10
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:58: TH1 = 0x10000-((SYSCLK/BAUDRATE)/2L);
	mov	_TH1,#0x30
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:59: CKCON &= ~0x0B;                  // T1M = 1; SCA1:0 = xx
	anl	_CKCON,#0xF4
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:60: CKCON |=  0x08;
	orl	_CKCON,#0x08
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:73: TL1 = TH1;      // Init Timer1
	mov	_TL1,_TH1
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:74: TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit autoreload
	anl	_TMOD,#0x0F
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:75: TMOD |=  0x20;                       
	orl	_TMOD,#0x20
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:76: TR1 = 1; // START Timer1
	setb	_TR1
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:77: TI = 1;  // Indicate TX0 ready
	setb	_TI
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:80: P2MDOUT|=0b_0000_0011;
	orl	_P2MDOUT,#0x03
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:81: P0MDOUT |= 0x10; // Enable UTX as push-pull output
	orl	_P0MDOUT,#0x10
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:82: XBR0     = 0x01; // Enable UART on P0.4(TX) and P0.5(RX)                     
	mov	_XBR0,#0x01
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:83: XBR1     = 0x40; // Enable crossbar and weak pull-ups
	mov	_XBR1,#0x40
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:86: TMR2CN=0x00;   // Stop Timer2; Clear TF2;
	mov	_TMR2CN,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:87: CKCON|=0b_0001_0000;
	orl	_CKCON,#0x10
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:88: TMR2RL=(-(SYSCLK/(2*48))/(100L)); // Initialize reload value
	mov	_TMR2RL,#0x78
	mov	(_TMR2RL >> 8),#0xEC
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:89: TMR2=0xffff;   // Set to reload immediately
	mov	_TMR2,#0xFF
	mov	(_TMR2 >> 8),#0xFF
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:90: ET2=1;         // Enable Timer2 interrupts
	setb	_ET2
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:91: TR2=1;         // Start Timer2
	setb	_TR2
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:94: SFRPAGE = 0xF;
	mov	_SFRPAGE,#0x0F
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:95: TMR5CN=0x00;   // Stop Timer5; Clear TF5;
	mov	_TMR5CN,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:96: CKCON1|=0b_0000_0100;
	orl	_CKCON1,#0x04
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:99: TMR5RL=(-(SYSCLK/(2*48))/(100L)); // Initialize reload value
	mov	_TMR5RL,#0x78
	mov	(_TMR5RL >> 8),#0xEC
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:102: TMR5=0xffff;   // Set to reload immediately
	mov	_TMR5,#0xFF
	mov	(_TMR5 >> 8),#0xFF
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:103: EIE2 |= ET5;        // Enable Timer5 interrupts
	orl	_EIE2,#0x20
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:104: TR5=1;         // Start Timer5
	setb	_TR5
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:106: return 0;
	mov	dpl,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer5_ISR'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:110: void Timer5_ISR (void) interrupt INTERRUPT_TIMER5
;	-----------------------------------------
;	 function Timer5_ISR
;	-----------------------------------------
_Timer5_ISR:
	push	acc
	push	ar2
	push	ar0
	push	psw
	mov	psw,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:113: PUSH_SFRPAGE;
	 push _SFRPAGE 
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:114: SFRPAGE=0xf;
	mov	_SFRPAGE,#0x0F
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:116: TF5H = 0; // Clear Timer5 interrupt flag
	clr	_TF5H
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:117: if(b<33){
	mov	a,#0x100 - 0x21
	add	a,_b
	jc	L003002?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:118: signal[32-b] = SIGNAL_IN;
	mov	a,#0x20
	clr	c
	subb	a,_b
	add	a,#_signal
	mov	r0,a
	mov	c,_P2_1
	clr	a
	rlc	a
	mov	r2,a
	mov	@r0,a
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:119: b++;
	inc	_b
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:121: SFRPAGE=0xf;
	mov	_SFRPAGE,#0x0F
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:122: POP_SFRPAGE;
	 pop _SFRPAGE 
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:123: return;
	sjmp	L003003?
L003002?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:126: b = 0;
	mov	_b,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:127: SFRPAGE=0xf;
	mov	_SFRPAGE,#0x0F
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:128: POP_SFRPAGE;
	 pop _SFRPAGE 
L003003?:
	pop	psw
	pop	ar0
	pop	ar2
	pop	acc
	reti
;	eliminated unneeded push/pop ar1
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer2_ISR'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:132: void Timer2_ISR (void) interrupt 5
;	-----------------------------------------
;	 function Timer2_ISR
;	-----------------------------------------
_Timer2_ISR:
	push	acc
	push	psw
	mov	psw,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:134: SFRPAGE = 0x0;
	mov	_SFRPAGE,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:135: TF2H = 0; // Clear Timer2 interrupt flag
	clr	_TF2H
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:137: pwm_count++;
	inc	_pwm_count
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:138: if(pwm_count>100) pwm_count=0;
	mov	a,_pwm_count
	add	a,#0xff - 0x64
	jnc	L004002?
	mov	_pwm_count,#0x00
L004002?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:140: if(LB == 0){
	mov	a,_LB
	jnz	L004004?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:141: LEFT_FORWARD=pwm_count>LF?0:1;
	clr	c
	mov	a,_LF
	subb	a,_pwm_count
	mov  _Timer2_ISR_sloc0_1_0,c
	cpl	c
	mov	_P2_1,c
L004004?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:143: if(LF == 0){
	mov	a,_LF
	jnz	L004006?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:144: LEFT_BACKWARD=pwm_count>LB?0:1;
	clr	c
	mov	a,_LB
	subb	a,_pwm_count
	mov  _Timer2_ISR_sloc0_1_0,c
	cpl	c
	mov	_P2_1,c
L004006?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:146: if(RB == 0){
	mov	a,_RB
	jnz	L004008?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:147: RIGHT_FORWARD=pwm_count>RF?0:1;
	clr	c
	mov	a,_RF
	subb	a,_pwm_count
	mov  _Timer2_ISR_sloc0_1_0,c
	cpl	c
	mov	_P2_1,c
L004008?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:149: if(RF == 0){
	mov	a,_RF
	jnz	L004011?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:150: RIGHT_BACKWARD=pwm_count>RB?0:1;
	clr	c
	mov	a,_RB
	subb	a,_pwm_count
	mov  _Timer2_ISR_sloc0_1_0,c
	cpl	c
	mov	_P2_1,c
L004011?:
	pop	psw
	pop	acc
	reti
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;------------------------------------------------------------
;Allocation info for local variables in function 'pow'
;------------------------------------------------------------
;exp                       Allocated with name '_pow_PARM_2'
;base                      Allocated to registers r2 r3 
;i                         Allocated to registers 
;result                    Allocated to registers r4 r5 
;------------------------------------------------------------
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:154: int pow( int base, int exp){
;	-----------------------------------------
;	 function pow
;	-----------------------------------------
_pow:
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:157: int result = 0;
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:159: while(1 != exp)
	clr	a
	mov	r4,a
	mov	r5,a
	mov	a,_pow_PARM_2
	cjne	a,#0x01,L005008?
	mov	a,(_pow_PARM_2 + 1)
	jnz	L005008?
	mov	a,#0x01
	sjmp	L005009?
L005008?:
	clr	a
L005009?:
	mov	r6,a
L005001?:
	mov	a,r6
	jnz	L005003?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:160: result += base;
	mov	a,r2
	add	a,r4
	mov	r4,a
	mov	a,r3
	addc	a,r5
	mov	r5,a
	sjmp	L005001?
L005003?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:162: return result;
	mov	dpl,r4
	mov	dph,r5
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'binary2int'
;------------------------------------------------------------
;stop                      Allocated with name '_binary2int_PARM_2'
;start                     Allocated to registers r2 r3 
;counter                   Allocated to registers r6 r7 
;num                       Allocated with name '_binary2int_num_1_37'
;------------------------------------------------------------
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:165: int binary2int(int start, int stop){
;	-----------------------------------------
;	 function binary2int
;	-----------------------------------------
_binary2int:
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:168: int num = 0;
	clr	a
	mov	_binary2int_num_1_37,a
	mov	(_binary2int_num_1_37 + 1),a
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:170: for(counter = start; counter <= stop; counter++)
	mov	ar6,r2
	mov	ar7,r3
L006001?:
	clr	c
	mov	a,_binary2int_PARM_2
	subb	a,r6
	mov	a,(_binary2int_PARM_2 + 1)
	xrl	a,#0x80
	mov	b,r7
	xrl	b,#0x80
	subb	a,b
	jc	L006004?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:171: num += signal[counter]*pow(2, counter - start);
	mov	a,r6
	add	a,#_signal
	mov	r0,a
	mov	ar4,@r0
	mov	a,r6
	clr	c
	subb	a,r2
	mov	_pow_PARM_2,a
	mov	a,r7
	subb	a,r3
	mov	(_pow_PARM_2 + 1),a
	mov	dptr,#0x0002
	push	ar2
	push	ar3
	push	ar4
	push	ar6
	push	ar7
	lcall	_pow
	mov	__mulint_PARM_2,dpl
	mov	(__mulint_PARM_2 + 1),dph
	pop	ar7
	pop	ar6
	pop	ar4
	mov	r5,#0x00
	mov	dpl,r4
	mov	dph,r5
	push	ar6
	push	ar7
	lcall	__mulint
	mov	r4,dpl
	mov	r5,dph
	pop	ar7
	pop	ar6
	pop	ar3
	pop	ar2
	mov	a,r4
	add	a,_binary2int_num_1_37
	mov	_binary2int_num_1_37,a
	mov	a,r5
	addc	a,(_binary2int_num_1_37 + 1)
	mov	(_binary2int_num_1_37 + 1),a
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:170: for(counter = start; counter <= stop; counter++)
	inc	r6
	cjne	r6,#0x00,L006001?
	inc	r7
	sjmp	L006001?
L006004?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:173: return num;
	mov	dpl,_binary2int_num_1_37
	mov	dph,(_binary2int_num_1_37 + 1)
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'direction'
;------------------------------------------------------------
;right                     Allocated with name '_direction_PARM_2'
;left                      Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:176: void direction(unsigned char left, unsigned char right)
;	-----------------------------------------
;	 function direction
;	-----------------------------------------
_direction:
	mov	r2,dpl
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:178: if (left == 1 && right == 1) //both forward moters high  
	clr	a
	cjne	r2,#0x01,L007026?
	inc	a
L007026?:
	mov	r3,a
	jz	L007013?
	mov	a,#0x01
	cjne	a,_direction_PARM_2,L007013?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:180: right_motor = 1; 
	setb	_right_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:181: left_motor = 1;
	setb	_left_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:182: back_right_motor = 0; 
	clr	_back_right_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:183: back_left_motor = 0;   
	clr	_back_left_motor
	ret
L007013?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:185: else if (left == 1 && right == 0) // left forward high, right backward high
	mov	a,r3
	jz	L007009?
	mov	a,_direction_PARM_2
	jnz	L007009?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:187: right_motor = 0; 
	clr	_right_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:188: left_motor = 1; 
	setb	_left_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:189: back_right_motor = 1; 
	setb	_back_right_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:190: back_left_motor = 0; 
	clr	_back_left_motor
	ret
L007009?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:192: else if (left == 0 && right == 1) // left backward high, right forward high  
	mov	a,r2
	jnz	L007005?
	mov	a,#0x01
	cjne	a,_direction_PARM_2,L007005?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:194: right_motor = 1; 
	setb	_right_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:195: left_motor = 0; 
	clr	_left_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:196: back_right_motor = 1; 
	setb	_back_right_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:197: back_left_motor = 0; 
	clr	_back_left_motor
	ret
L007005?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:199: else if (left == 0 && right == 0) //both backward moters high
	mov	a,r2
	jnz	L007016?
	mov	a,_direction_PARM_2
	jnz	L007016?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:201: right_motor = 0; 
	clr	_right_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:202: left_motor = 0; 
	clr	_left_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:203: back_right_motor = 1; 
	setb	_back_right_motor
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:204: back_left_motor = 1; 
	setb	_back_left_motor
L007016?:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'left_motor_power'
;------------------------------------------------------------
;power                     Allocated to registers r2 r3 
;------------------------------------------------------------
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:208: void left_motor_power(int power)
;	-----------------------------------------
;	 function left_motor_power
;	-----------------------------------------
_left_motor_power:
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:210: if (left_motor == 1)
	jnb	_left_motor,L008010?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:211: LF = power; 
	mov	_LF,r2
	ret
L008010?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:212: else if (left_motor == 0) 
	jb	_left_motor,L008007?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:213: LF = 0; 
	mov	_LF,#0x00
	ret
L008007?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:214: else if (back_left_motor == 1)
	jnb	_back_left_motor,L008004?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:215: LB = power; 
	mov	_LB,r2
	ret
L008004?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:216: else if (back_left_motor == 0)
	jb	_back_left_motor,L008012?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:217: LB = 0; 
	mov	_LB,#0x00
L008012?:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'right_motor_power'
;------------------------------------------------------------
;power                     Allocated to registers r2 r3 
;------------------------------------------------------------
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:220: void right_motor_power(int power)
;	-----------------------------------------
;	 function right_motor_power
;	-----------------------------------------
_right_motor_power:
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:222: if (right_motor == 1)
	jnb	_right_motor,L009010?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:223: RF = power; 
	mov	_RF,r2
	ret
L009010?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:224: else if (right_motor == 0) 
	jb	_right_motor,L009007?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:225: RF = 0; 
	mov	_RF,#0x00
	ret
L009007?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:226: else if (back_right_motor == 1)
	jnb	_back_right_motor,L009004?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:227: RB = power; 
	mov	_RB,r2
	ret
L009004?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:228: else if (back_right_motor == 0)
	jb	_back_right_motor,L009012?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:229: RB = 0; 
	mov	_RB,#0x00
L009012?:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;temp_1                    Allocated to registers r2 
;temp_2                    Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:232: void main(void){
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:238: _c51_external_startup();
	lcall	__c51_external_startup
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:239: b = 0;
	mov	_b,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:240: mode = 0;
	clr	_mode
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:241: LF = 0;
	mov	_LF,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:242: LB = 0;
	mov	_LB,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:243: RF = 0;
	mov	_RF,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:244: RB = 0;
	mov	_RB,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:248: while(!SIGNAL_IN);
L010001?:
	jnb	_P2_1,L010001?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:249: EA = 1;
	setb	_EA
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:256: while(b == MODE_BIT);
L010004?:
	mov	a,#0x0C
	cjne	a,_b,L010039?
	sjmp	L010004?
L010039?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:258: mode = signal[32] ? 0:1;      //need to know size of start 
	mov	a,(_signal + 0x0020)
	cjne	a,#0x01,L010040?
L010040?:
	mov	_mode,c
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:261: if(mode == joystick)
	jb	_mode,L010019?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:265: SFRPAGE = 0xF;
	mov	_SFRPAGE,#0x0F
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:266: EIE2 |= ET5;
	orl	_EIE2,#0x20
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:267: SFRPAGE = 0;
	mov	_SFRPAGE,#0x00
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:268: while(b != DIRECTION); 
L010007?:
	mov	a,#0x0F
	cjne	a,_b,L010007?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:270: direction(signal[DIRECTION], signal[DIRECTION+1]); 
	mov	dpl,(_signal + 0x000f)
	mov	_direction_PARM_2,(_signal + 0x0010)
	lcall	_direction
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:272: while(b != POWER1);
L010010?:
	mov	a,#0x16
	cjne	a,_b,L010010?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:274: temp_1 = binary2int(POWER1, POWER2);
	mov	_binary2int_PARM_2,#0x1D
	clr	a
	mov	(_binary2int_PARM_2 + 1),a
	mov	dptr,#0x0016
	lcall	_binary2int
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:275: left_motor_power(temp_1); 
	mov	r3,#0x00
	mov	dph,r3
	lcall	_left_motor_power
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:278: while(b != POWER2);
L010013?:
	mov	a,#0x1D
	cjne	a,_b,L010013?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:280: temp_2 = binary2int(POWER2, 0);
	clr	a
	mov	_binary2int_PARM_2,a
	mov	(_binary2int_PARM_2 + 1),a
	mov	dptr,#0x001D
	lcall	_binary2int
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:281: right_motor_power(temp_2);
	mov	r3,#0x00
	mov	dph,r3
	lcall	_right_motor_power
	sjmp	L010004?
L010019?:
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:287: else if (mode == tether)
	jnb	_mode,L010004?
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:291: SFRPAGE = 0xF;
	mov	_SFRPAGE,#0x0F
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:292: EIE2 &= 0b1101_1111;
	anl	_EIE2,#0xDF
;	C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c:293: SFRPAGE = 0;
	mov	_SFRPAGE,#0x00
	ljmp	L010004?
	rseg R_CSEG

	rseg R_XINIT

	rseg R_CONST

	CSEG

end
