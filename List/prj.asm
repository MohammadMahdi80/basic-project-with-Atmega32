
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 1.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _n_entered=R5
	.DEF _x1=R4
	.DEF _x2=R7
	.DEF _x3=R6
	.DEF _x4=R9
	.DEF _a=R8
	.DEF _b=R11
	.DEF _c=R10
	.DEF _d=R13
	.DEF _pas_entered=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x61,0x35,0x23,0x32
_0x4:
	.DB  0x31,0x32,0x33,0x61,0x34,0x35,0x36,0x62
	.DB  0x37,0x38,0x39,0x63,0x2A,0x30,0x23,0x64
_0x9F:
	.DB  0x0
_0x0:
	.DB  0x31,0x2E,0x4C,0x45,0x44,0x20,0x20,0x20
	.DB  0x20,0x20,0x3C,0x3D,0x0,0x32,0x2E,0x42
	.DB  0x75,0x7A,0x7A,0x65,0x72,0x0,0x31,0x2E
	.DB  0x4C,0x45,0x44,0x0,0x32,0x2E,0x42,0x75
	.DB  0x7A,0x7A,0x65,0x72,0x20,0x20,0x3C,0x3D
	.DB  0x0,0x33,0x2E,0x52,0x65,0x6C,0x61,0x79
	.DB  0x20,0x20,0x20,0x3C,0x3D,0x0,0x70,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x20,0x57
	.DB  0x72,0x6F,0x6E,0x67,0x20,0x21,0x0,0x65
	.DB  0x6E,0x74,0x65,0x72,0x20,0x70,0x61,0x73
	.DB  0x73,0x77,0x6F,0x72,0x64,0x20,0x3A,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x4C,0x45
	.DB  0x44,0x0,0x20,0x20,0x20,0x20,0x20,0x42
	.DB  0x75,0x7A,0x7A,0x65,0x72,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x52,0x65,0x6C,0x61,0x79
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _pass_list
	.DW  _0x3*2

	.DW  0x10
	.DW  _character
	.DW  _0x4*2

	.DW  0x01
	.DW  0x05
	.DW  _0x9F*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/24/2022
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;#include <delay.h>
;
;
;
;unsigned char n_entered=0, x1, x2, x3, x4, a, b, c, d, pas_entered, menu_flg=0, pas_flg=0, led_flg=0, buzzer_flg=0, relay_flg=0;
;char pass_list[5] = {'a', '5', '#', '2'};

	.DSEG
;char character[17] = {'1', '2', '3', 'a', '4', '5', '6', 'b', '7', '8', '9', 'c', '*', '0', '#', 'd'};
;unsigned char flag1=0, flag2=0, flag3=0, rising_edg_flg=0, falling_edg_flg=0, buzzer_sound=0;
;
;void show_entered_pas(void)
; 0000 0026 {

	.CSEG
_show_entered_pas:
; 0000 0027        lcd_gotoxy(0,1);
	CALL SUBOPT_0x0
; 0000 0028        if(n_entered==1)
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x5
; 0000 0029        {
; 0000 002A             lcd_putchar(x1);
	ST   -Y,R4
	RJMP _0x98
; 0000 002B        }
; 0000 002C        else if(n_entered==2)
_0x5:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x7
; 0000 002D        {
; 0000 002E             lcd_putchar(x1);
	CALL SUBOPT_0x1
; 0000 002F             lcd_putchar(x2);
	RJMP _0x98
; 0000 0030        }
; 0000 0031        else if(n_entered==3)
_0x7:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x9
; 0000 0032        {
; 0000 0033             lcd_putchar(x1);
	CALL SUBOPT_0x1
; 0000 0034             lcd_putchar(x2);
	CALL _lcd_putchar
; 0000 0035             lcd_putchar(x3);
	ST   -Y,R6
	RJMP _0x98
; 0000 0036        }
; 0000 0037        else if(n_entered==4)
_0x9:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0xB
; 0000 0038        {
; 0000 0039             lcd_putchar(x1);
	CALL SUBOPT_0x1
; 0000 003A             lcd_putchar(x2);
	CALL _lcd_putchar
; 0000 003B             lcd_putchar(x3);
	ST   -Y,R6
	CALL _lcd_putchar
; 0000 003C             lcd_putchar(x4);
	ST   -Y,R9
_0x98:
	CALL _lcd_putchar
; 0000 003D        }
; 0000 003E 
; 0000 003F }
_0xB:
	RET
;
;void check_flag(void)
; 0000 0042 {
_check_flag:
; 0000 0043     if(flag1 != 0){if(TCNT0 == 255 & flag1 == 2) flag1=0; else if(TCNT0 == 255) flag1 ++;}
	LDS  R30,_flag1
	CPI  R30,0
	BREQ _0xC
	CALL SUBOPT_0x2
	LDS  R26,_flag1
	CALL SUBOPT_0x3
	BREQ _0xD
	LDI  R30,LOW(0)
	RJMP _0x99
_0xD:
	IN   R30,0x32
	CPI  R30,LOW(0xFF)
	BRNE _0xF
	LDS  R30,_flag1
	SUBI R30,-LOW(1)
_0x99:
	STS  _flag1,R30
_0xF:
; 0000 0044     if(flag2 != 0){if(TCNT0 == 255 & flag2 == 2) flag2=0; else if(TCNT0 == 255) flag2 ++;}
_0xC:
	LDS  R30,_flag2
	CPI  R30,0
	BREQ _0x10
	CALL SUBOPT_0x2
	LDS  R26,_flag2
	CALL SUBOPT_0x3
	BREQ _0x11
	LDI  R30,LOW(0)
	RJMP _0x9A
_0x11:
	IN   R30,0x32
	CPI  R30,LOW(0xFF)
	BRNE _0x13
	LDS  R30,_flag2
	SUBI R30,-LOW(1)
_0x9A:
	STS  _flag2,R30
_0x13:
; 0000 0045     if(flag3 != 0){if(TCNT0 == 255 & flag3 == 2) flag3=0; else if(TCNT0 == 255) flag3 ++;}
_0x10:
	LDS  R30,_flag3
	CPI  R30,0
	BREQ _0x14
	CALL SUBOPT_0x2
	LDS  R26,_flag3
	CALL SUBOPT_0x3
	BREQ _0x15
	LDI  R30,LOW(0)
	RJMP _0x9B
_0x15:
	IN   R30,0x32
	CPI  R30,LOW(0xFF)
	BRNE _0x17
	LDS  R30,_flag3
	SUBI R30,-LOW(1)
_0x9B:
	STS  _flag3,R30
_0x17:
; 0000 0046     if(buzzer_sound != 0){if(TCNT0 == 255 & buzzer_sound == 4) buzzer_sound=0; else if(TCNT0 == 255) buzzer_sound ++;}
_0x14:
	LDS  R30,_buzzer_sound
	CPI  R30,0
	BREQ _0x18
	CALL SUBOPT_0x2
	LDS  R26,_buzzer_sound
	LDI  R30,LOW(4)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x19
	LDI  R30,LOW(0)
	RJMP _0x9C
_0x19:
	IN   R30,0x32
	CPI  R30,LOW(0xFF)
	BRNE _0x1B
	LDS  R30,_buzzer_sound
	SUBI R30,-LOW(1)
_0x9C:
	STS  _buzzer_sound,R30
_0x1B:
; 0000 0047 }
_0x18:
	RET
;
;void menu(void)
; 0000 004A {
_menu:
; 0000 004B 
; 0000 004C         if(menu_flg == 0 )
	LDS  R30,_menu_flg
	CPI  R30,0
	BRNE _0x1C
; 0000 004D         {
; 0000 004E             lcd_clear();
	CALL _lcd_clear
; 0000 004F             lcd_putsf("1.LED     <=");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x4
; 0000 0050             lcd_gotoxy(0,1);
; 0000 0051             lcd_putsf("2.Buzzer");
	__POINTW1FN _0x0,13
	RJMP _0x9D
; 0000 0052         }
; 0000 0053         else if(menu_flg == 1)
_0x1C:
	LDS  R26,_menu_flg
	CPI  R26,LOW(0x1)
	BRNE _0x1E
; 0000 0054         {
; 0000 0055                 lcd_clear();
	CALL _lcd_clear
; 0000 0056             lcd_putsf("1.LED");
	__POINTW1FN _0x0,22
	CALL SUBOPT_0x4
; 0000 0057             lcd_gotoxy(0,1);
; 0000 0058             lcd_putsf("2.Buzzer  <=");
	__POINTW1FN _0x0,28
	RJMP _0x9D
; 0000 0059         }
; 0000 005A         else if(menu_flg == 2)
_0x1E:
	LDS  R26,_menu_flg
	CPI  R26,LOW(0x2)
	BRNE _0x20
; 0000 005B         {
; 0000 005C             lcd_clear();
	CALL SUBOPT_0x5
; 0000 005D             lcd_gotoxy(0,0);
; 0000 005E             lcd_putsf("3.Relay   <=");
	__POINTW1FN _0x0,41
_0x9D:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 005F         }
; 0000 0060 
; 0000 0061 }
_0x20:
	RET
;
;void read_key_input(void)
; 0000 0064 {
_read_key_input:
; 0000 0065 
; 0000 0066     if(PIND.3 == 1)
	SBIS 0x10,3
	RJMP _0x21
; 0000 0067     {
; 0000 0068         a = PIND.4;
	LDI  R30,0
	SBIC 0x10,4
	LDI  R30,1
	MOV  R8,R30
; 0000 0069         b = PIND.5;
	LDI  R30,0
	SBIC 0x10,5
	LDI  R30,1
	MOV  R11,R30
; 0000 006A         c = PIND.6;
	LDI  R30,0
	SBIC 0x10,6
	LDI  R30,1
	MOV  R10,R30
; 0000 006B         d = PIND.7;
	LDI  R30,0
	SBIC 0x10,7
	LDI  R30,1
	MOV  R13,R30
; 0000 006C 
; 0000 006D         pas_entered = ((a<<3) | (b<<2) | (c<<1) | d) ;
	MOV  R30,R8
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R26,R30
	MOV  R30,R11
	LSL  R30
	LSL  R30
	OR   R30,R26
	MOV  R26,R30
	MOV  R30,R10
	LSL  R30
	OR   R30,R26
	OR   R30,R13
	MOV  R12,R30
; 0000 006E 
; 0000 006F         check_flag();
	RCALL _check_flag
; 0000 0070 
; 0000 0071         if(n_entered == 0)
	TST  R5
	BRNE _0x22
; 0000 0072         {
; 0000 0073             flag1 = 1;
	LDI  R30,LOW(1)
	STS  _flag1,R30
; 0000 0074             TCNT0 = 0;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0075             x1 = character[pas_entered];
	CALL SUBOPT_0x6
	LD   R4,Z
; 0000 0076             n_entered = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0077             show_entered_pas();
	RCALL _show_entered_pas
; 0000 0078         }
; 0000 0079         else if(n_entered == 1)
	RJMP _0x23
_0x22:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x24
; 0000 007A         {
; 0000 007B             flag2 = 1;
	STS  _flag2,R30
; 0000 007C             x2 = character[pas_entered];
	CALL SUBOPT_0x6
	LD   R7,Z
; 0000 007D             n_entered = 2;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 007E             if((x1 == x2 & flag1 == 0) | (x1 != x2)) {show_entered_pas(); TCNT0 = 0;}
	MOV  R30,R7
	MOV  R26,R4
	CALL __EQB12
	MOV  R0,R30
	LDS  R26,_flag1
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R0,R30
	MOV  R30,R7
	MOV  R26,R4
	CALL __NEB12
	OR   R30,R0
	BREQ _0x25
	RCALL _show_entered_pas
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 007F             else n_entered = 1;
	RJMP _0x26
_0x25:
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0080         }
_0x26:
; 0000 0081         else if(n_entered == 2)
	RJMP _0x27
_0x24:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x28
; 0000 0082         {
; 0000 0083             flag3 = 1;
	LDI  R30,LOW(1)
	STS  _flag3,R30
; 0000 0084             x3 = character[pas_entered];
	CALL SUBOPT_0x6
	LD   R6,Z
; 0000 0085             n_entered = 3;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 0086             if((x2 == x3 & flag2 == 0) | (x3 != x2)) {show_entered_pas(), TCNT0 = 0;}
	MOV  R30,R6
	MOV  R26,R7
	CALL __EQB12
	MOV  R0,R30
	LDS  R26,_flag2
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R0,R30
	MOV  R30,R7
	MOV  R26,R6
	CALL __NEB12
	OR   R30,R0
	BREQ _0x29
	RCALL _show_entered_pas
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0087             else  n_entered = 2;
	RJMP _0x2A
_0x29:
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 0088         }
_0x2A:
; 0000 0089         else if(n_entered == 3)
	RJMP _0x2B
_0x28:
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ PC+3
	JMP _0x2C
; 0000 008A         {
; 0000 008B             x4 = character[pas_entered];
	CALL SUBOPT_0x6
	LD   R9,Z
; 0000 008C             n_entered = 4;
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 008D             if((x3 == x4 & flag3 == 0) | (x3 != x4))
	MOV  R30,R9
	MOV  R26,R6
	CALL __EQB12
	MOV  R0,R30
	LDS  R26,_flag3
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R0,R30
	MOV  R30,R9
	MOV  R26,R6
	CALL __NEB12
	OR   R30,R0
	BREQ _0x2D
; 0000 008E             {
; 0000 008F                 lcd_clear();
	RCALL _lcd_clear
; 0000 0090                 if(x1==pass_list[0] & x2==pass_list[1] & x3==pass_list[2] & x4==pass_list[3])
	LDS  R30,_pass_list
	MOV  R26,R4
	CALL __EQB12
	MOV  R0,R30
	__GETB1MN _pass_list,1
	MOV  R26,R7
	CALL __EQB12
	AND  R0,R30
	__GETB1MN _pass_list,2
	MOV  R26,R6
	CALL __EQB12
	AND  R0,R30
	__GETB1MN _pass_list,3
	MOV  R26,R9
	CALL __EQB12
	AND  R30,R0
	BREQ _0x2E
; 0000 0091                 {
; 0000 0092                     pas_flg = 1;
	LDI  R30,LOW(1)
	STS  _pas_flg,R30
; 0000 0093                     menu();
	RCALL _menu
; 0000 0094                 }
; 0000 0095                 else
	RJMP _0x2F
_0x2E:
; 0000 0096                 {
; 0000 0097 
; 0000 0098                     lcd_putsf("password Wrong !");
	__POINTW1FN _0x0,54
	CALL SUBOPT_0x7
; 0000 0099                     delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x8
; 0000 009A                     lcd_clear();
	CALL SUBOPT_0x5
; 0000 009B                     lcd_gotoxy(0,0);
; 0000 009C                     lcd_putsf("enter password :");
	__POINTW1FN _0x0,71
	CALL SUBOPT_0x7
; 0000 009D                     n_entered = 0;
	CLR  R5
; 0000 009E                 }
_0x2F:
; 0000 009F 
; 0000 00A0 
; 0000 00A1 
; 0000 00A2             }
; 0000 00A3             else n_entered = 3;
	RJMP _0x30
_0x2D:
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 00A4         }
_0x30:
; 0000 00A5     }
_0x2C:
_0x2B:
_0x27:
_0x23:
; 0000 00A6 
; 0000 00A7 
; 0000 00A8 
; 0000 00A9 
; 0000 00AA }
_0x21:
	RET
;
;void menu_in(void)
; 0000 00AD {
_menu_in:
; 0000 00AE     lcd_clear();
	RCALL _lcd_clear
; 0000 00AF     if (led_flg == 1) lcd_putsf("      LED");
	LDS  R26,_led_flg
	CPI  R26,LOW(0x1)
	BRNE _0x31
	__POINTW1FN _0x0,88
	RJMP _0x9E
; 0000 00B0     else if(buzzer_flg == 1) lcd_putsf("     Buzzer");
_0x31:
	LDS  R26,_buzzer_flg
	CPI  R26,LOW(0x1)
	BRNE _0x33
	__POINTW1FN _0x0,98
	RJMP _0x9E
; 0000 00B1     else if(relay_flg == 1) lcd_putsf("     Relay");
_0x33:
	LDS  R26,_relay_flg
	CPI  R26,LOW(0x1)
	BRNE _0x35
	__POINTW1FN _0x0,110
_0x9E:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_putsf
; 0000 00B2 
; 0000 00B3 }
_0x35:
	RET
;
;void led(void)
; 0000 00B6 {
_led:
; 0000 00B7     if(led_flg ==0)
	LDS  R30,_led_flg
	CPI  R30,0
	BRNE _0x36
; 0000 00B8     {
; 0000 00B9         PORTC.0 = 1;
	SBI  0x15,0
; 0000 00BA         PORTA.1 = 1;
	SBI  0x1B,1
; 0000 00BB         PORTA.2 = 1;
	SBI  0x1B,2
; 0000 00BC         led_flg = 1;
	LDI  R30,LOW(1)
	STS  _led_flg,R30
; 0000 00BD         menu_in();
	RCALL _menu_in
; 0000 00BE     }
; 0000 00BF     else
	RJMP _0x3D
_0x36:
; 0000 00C0     {
; 0000 00C1         menu();
	RCALL _menu
; 0000 00C2         PORTC.0 = 0;
	RCALL SUBOPT_0x9
; 0000 00C3         PORTA.1 = 0;
; 0000 00C4         PORTA.2 = 0;
; 0000 00C5         led_flg = 0;
; 0000 00C6     }
_0x3D:
; 0000 00C7 
; 0000 00C8 }
	RET
;
;void buzzer(void)
; 0000 00CB {
_buzzer:
; 0000 00CC     if(buzzer_flg ==0)
	LDS  R30,_buzzer_flg
	CPI  R30,0
	BRNE _0x44
; 0000 00CD     {
; 0000 00CE         PORTC.1 = 1;
	SBI  0x15,1
; 0000 00CF         PORTA.1 = 1;
	SBI  0x1B,1
; 0000 00D0         PORTA.2 = 1;
	SBI  0x1B,2
; 0000 00D1         buzzer_flg = 1;
	LDI  R30,LOW(1)
	STS  _buzzer_flg,R30
; 0000 00D2         buzzer_sound = 1;
	STS  _buzzer_sound,R30
; 0000 00D3         TCNT0 = 0;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00D4         menu_in();
	RCALL _menu_in
; 0000 00D5     }
; 0000 00D6     else
	RJMP _0x4B
_0x44:
; 0000 00D7     {
; 0000 00D8         menu();
	RCALL _menu
; 0000 00D9         PORTC.1 = 0;
	RCALL SUBOPT_0xA
; 0000 00DA         PORTA.1 = 0;
; 0000 00DB         PORTA.2 = 0;
; 0000 00DC         buzzer_flg = 0;
; 0000 00DD     }
_0x4B:
; 0000 00DE }
	RET
;
;void relay(void)
; 0000 00E1 {
_relay:
; 0000 00E2     if(relay_flg ==0)
	LDS  R30,_relay_flg
	CPI  R30,0
	BRNE _0x52
; 0000 00E3     {
; 0000 00E4         menu_in();
	RCALL _menu_in
; 0000 00E5         PORTA.5 = 1;
	SBI  0x1B,5
; 0000 00E6         PORTA.1 = 1;
	SBI  0x1B,1
; 0000 00E7         PORTA.0 = 1;
	SBI  0x1B,0
; 0000 00E8         PORTA.3 = 1;
	SBI  0x1B,3
; 0000 00E9         PORTA.4 = 1;
	SBI  0x1B,4
; 0000 00EA         PORTA.6 = 1;
	SBI  0x1B,6
; 0000 00EB         relay_flg = 1;
	LDI  R30,LOW(1)
	STS  _relay_flg,R30
; 0000 00EC         menu_in();
	RCALL _menu_in
; 0000 00ED     }
; 0000 00EE     else
	RJMP _0x5F
_0x52:
; 0000 00EF     {
; 0000 00F0         menu();
	RCALL _menu
; 0000 00F1         PORTA.5 = 0;
	RCALL SUBOPT_0xB
; 0000 00F2         PORTA.1 = 0;
; 0000 00F3         PORTA.0 = 0;
; 0000 00F4         PORTA.3 = 0;
; 0000 00F5         PORTA.4 = 0;
; 0000 00F6         PORTA.6 = 0;
; 0000 00F7         relay_flg = 0;
; 0000 00F8     }
_0x5F:
; 0000 00F9 }
	RET
;
;void devices(void)
; 0000 00FC {
_devices:
; 0000 00FD         if(menu_flg == 0) led();
	LDS  R30,_menu_flg
	CPI  R30,0
	BRNE _0x6C
	RCALL _led
; 0000 00FE         else if(menu_flg == 1) buzzer();
	RJMP _0x6D
_0x6C:
	LDS  R26,_menu_flg
	CPI  R26,LOW(0x1)
	BRNE _0x6E
	RCALL _buzzer
; 0000 00FF         else if(menu_flg == 2) relay();
	RJMP _0x6F
_0x6E:
	LDS  R26,_menu_flg
	CPI  R26,LOW(0x2)
	BRNE _0x70
	RCALL _relay
; 0000 0100 }
_0x70:
_0x6F:
_0x6D:
	RET
;
;void init(void)
; 0000 0103 {
_init:
; 0000 0104         PORTC.0 = 0;
	RCALL SUBOPT_0x9
; 0000 0105         PORTA.1 = 0;
; 0000 0106         PORTA.2 = 0;
; 0000 0107         led_flg = 0;
; 0000 0108 
; 0000 0109         PORTC.1 = 0;
	RCALL SUBOPT_0xA
; 0000 010A         PORTA.1 = 0;
; 0000 010B         PORTA.2 = 0;
; 0000 010C         buzzer_flg = 0;
; 0000 010D 
; 0000 010E         PORTA.5 = 0;
	RCALL SUBOPT_0xB
; 0000 010F         PORTA.1 = 0;
; 0000 0110         PORTA.0 = 0;
; 0000 0111         PORTA.3 = 0;
; 0000 0112         PORTA.4 = 0;
; 0000 0113         PORTA.6 = 0;
; 0000 0114         relay_flg = 0;
; 0000 0115 }
	RET
;
;void btn_handler(void)
; 0000 0118 {
_btn_handler:
; 0000 0119     check_flag();
	RCALL _check_flag
; 0000 011A     if(buzzer_sound==0 & buzzer_flg==1) PORTC.1 = 0;
	LDS  R26,_buzzer_sound
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	LDS  R26,_buzzer_flg
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x89
	CBI  0x15,1
; 0000 011B 
; 0000 011C     if(PIND.0 ==0) rising_edg_flg=1;
_0x89:
	SBIC 0x10,0
	RJMP _0x8C
	LDI  R30,LOW(1)
	STS  _rising_edg_flg,R30
; 0000 011D     if(PIND.0 ==1 & rising_edg_flg == 1)
_0x8C:
	LDI  R26,0
	SBIC 0x10,0
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	LDS  R26,_rising_edg_flg
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x8D
; 0000 011E     {
; 0000 011F      menu_flg ++;
	LDS  R30,_menu_flg
	SUBI R30,-LOW(1)
	STS  _menu_flg,R30
; 0000 0120      rising_edg_flg = 0;
	LDI  R30,LOW(0)
	STS  _rising_edg_flg,R30
; 0000 0121      if(menu_flg == 3) menu_flg = 0;
	LDS  R26,_menu_flg
	CPI  R26,LOW(0x3)
	BRNE _0x8E
	STS  _menu_flg,R30
; 0000 0122      init();
_0x8E:
	RCALL _init
; 0000 0123      menu();
	RCALL _menu
; 0000 0124     }
; 0000 0125     else if(PIND.1 == 1)
	RJMP _0x8F
_0x8D:
	SBIS 0x10,1
	RJMP _0x90
; 0000 0126     {
; 0000 0127         falling_edg_flg = 1;;
	LDI  R30,LOW(1)
	STS  _falling_edg_flg,R30
; 0000 0128     }
; 0000 0129 
; 0000 012A     if(falling_edg_flg == 1 & PIND.1 ==0)
_0x90:
_0x8F:
	LDS  R26,_falling_edg_flg
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x10,1
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x91
; 0000 012B     {
; 0000 012C         falling_edg_flg = 0;
	LDI  R30,LOW(0)
	STS  _falling_edg_flg,R30
; 0000 012D         devices();
	RCALL _devices
; 0000 012E     }
; 0000 012F 
; 0000 0130 }
_0x91:
	RET
;
;
;
;
;
;void main(void)
; 0000 0137 {
_main:
; 0000 0138 // Declare your local variables here
; 0000 0139 
; 0000 013A // Input/Output Ports initialization
; 0000 013B // Port A initialization
; 0000 013C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 013D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 013E PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 013F DDRA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0140 
; 0000 0141 // Port B initialization
; 0000 0142 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0143 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0144 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0145 DDRB=0x00;
	OUT  0x17,R30
; 0000 0146 
; 0000 0147 // Port C initialization
; 0000 0148 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0149 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 014A PORTC=0x00;
	OUT  0x15,R30
; 0000 014B DDRC=0xff;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 014C 
; 0000 014D // Port D initialization
; 0000 014E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 014F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0150 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0151 DDRD=0x00;
	OUT  0x11,R30
; 0000 0152 
; 0000 0153 // Timer/Counter 0 initialization
; 0000 0154 // Clock source: System Clock
; 0000 0155 // Clock value: 0.977 kHz
; 0000 0156 // Mode: Normal top=0xFF
; 0000 0157 // OC0 output: Disconnected
; 0000 0158 TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0159 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 015A OCR0=0x00;
	OUT  0x3C,R30
; 0000 015B 
; 0000 015C // Timer/Counter 1 initialization
; 0000 015D // Clock source: System Clock
; 0000 015E // Clock value: Timer1 Stopped
; 0000 015F // Mode: Normal top=0xFFFF
; 0000 0160 // OC1A output: Discon.
; 0000 0161 // OC1B output: Discon.
; 0000 0162 // Noise Canceler: Off
; 0000 0163 // Input Capture on Falling Edge
; 0000 0164 // Timer1 Overflow Interrupt: Off
; 0000 0165 // Input Capture Interrupt: Off
; 0000 0166 // Compare A Match Interrupt: Off
; 0000 0167 // Compare B Match Interrupt: Off
; 0000 0168 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0169 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 016A TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 016B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 016C ICR1H=0x00;
	OUT  0x27,R30
; 0000 016D ICR1L=0x00;
	OUT  0x26,R30
; 0000 016E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 016F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0170 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0171 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0172 
; 0000 0173 // Timer/Counter 2 initialization
; 0000 0174 // Clock source: System Clock
; 0000 0175 // Clock value: Timer2 Stopped
; 0000 0176 // Mode: Normal top=0xFF
; 0000 0177 // OC2 output: Disconnected
; 0000 0178 ASSR=0x00;
	OUT  0x22,R30
; 0000 0179 TCCR2=0x00;
	OUT  0x25,R30
; 0000 017A TCNT2=0x00;
	OUT  0x24,R30
; 0000 017B OCR2=0x00;
	OUT  0x23,R30
; 0000 017C 
; 0000 017D // External Interrupt(s) initialization
; 0000 017E // INT0: Off
; 0000 017F // INT1: Off
; 0000 0180 // INT2: Off
; 0000 0181 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0182 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0183 
; 0000 0184 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0185 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0186 
; 0000 0187 // USART initialization
; 0000 0188 // USART disabled
; 0000 0189 UCSRB=0x00;
	OUT  0xA,R30
; 0000 018A 
; 0000 018B // Analog Comparator initialization
; 0000 018C // Analog Comparator: Off
; 0000 018D // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 018E ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 018F SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0190 
; 0000 0191 // ADC initialization
; 0000 0192 // ADC disabled
; 0000 0193 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0194 
; 0000 0195 // SPI initialization
; 0000 0196 // SPI disabled
; 0000 0197 SPCR=0x00;
	OUT  0xD,R30
; 0000 0198 
; 0000 0199 // TWI initialization
; 0000 019A // TWI disabled
; 0000 019B TWCR=0x00;
	OUT  0x36,R30
; 0000 019C 
; 0000 019D // Alphanumeric LCD initialization
; 0000 019E // Connections specified in the
; 0000 019F // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 01A0 // RS - PORTB Bit 0
; 0000 01A1 // RD - PORTB Bit 1
; 0000 01A2 // EN - PORTB Bit 2
; 0000 01A3 // D4 - PORTB Bit 4
; 0000 01A4 // D5 - PORTB Bit 5
; 0000 01A5 // D6 - PORTB Bit 6
; 0000 01A6 // D7 - PORTB Bit 7
; 0000 01A7 // Characters/line: 8
; 0000 01A8 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 01A9 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 01AA lcd_putsf("enter password :");
	__POINTW1FN _0x0,71
	RCALL SUBOPT_0x7
; 0000 01AB 
; 0000 01AC while (1)
_0x92:
; 0000 01AD       {
; 0000 01AE       // Place your code here
; 0000 01AF       if(pas_flg == 0)read_key_input();
	LDS  R30,_pas_flg
	CPI  R30,0
	BRNE _0x95
	RCALL _read_key_input
; 0000 01B0       else btn_handler();
	RJMP _0x96
_0x95:
	RCALL _btn_handler
; 0000 01B1 
; 0000 01B2       }
_0x96:
	RJMP _0x92
; 0000 01B3 }
_0x97:
	RJMP _0x97
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x18,4
	RJMP _0x2000005
_0x2000004:
	CBI  0x18,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x18,5
	RJMP _0x2000007
_0x2000006:
	CBI  0x18,5
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x18,6
	RJMP _0x2000009
_0x2000008:
	CBI  0x18,6
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x18,7
	RJMP _0x200000B
_0x200000A:
	CBI  0x18,7
_0x200000B:
	__DELAY_USB 1
	SBI  0x18,2
	__DELAY_USB 2
	CBI  0x18,2
	__DELAY_USB 2
	RJMP _0x2020001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 17
	RJMP _0x2020001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xC
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xC
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2020001
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2020001
_lcd_putsf:
	ST   -Y,R17
_0x2000017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000017
_0x2000019:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,6
	SBI  0x17,7
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xD
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET

	.DSEG
_menu_flg:
	.BYTE 0x1
_pas_flg:
	.BYTE 0x1
_led_flg:
	.BYTE 0x1
_buzzer_flg:
	.BYTE 0x1
_relay_flg:
	.BYTE 0x1
_pass_list:
	.BYTE 0x5
_character:
	.BYTE 0x11
_flag1:
	.BYTE 0x1
_flag2:
	.BYTE 0x1
_flag3:
	.BYTE 0x1
_rising_edg_flg:
	.BYTE 0x1
_falling_edg_flg:
	.BYTE 0x1
_buzzer_sound:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R4
	RCALL _lcd_putchar
	ST   -Y,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	IN   R30,0x32
	LDI  R26,LOW(255)
	CALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(2)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_putsf
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	RCALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	MOV  R30,R12
	LDI  R31,0
	SUBI R30,LOW(-_character)
	SBCI R31,HIGH(-_character)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CBI  0x15,0
	CBI  0x1B,1
	CBI  0x1B,2
	LDI  R30,LOW(0)
	STS  _led_flg,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	CBI  0x15,1
	CBI  0x1B,1
	CBI  0x1B,2
	LDI  R30,LOW(0)
	STS  _buzzer_flg,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	CBI  0x1B,5
	CBI  0x1B,1
	CBI  0x1B,0
	CBI  0x1B,3
	CBI  0x1B,4
	CBI  0x1B,6
	LDI  R30,LOW(0)
	STS  _relay_flg,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

;END OF CODE MARKER
__END_OF_CODE:
