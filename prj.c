/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 6/24/2022
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>

// Alphanumeric LCD Module functions
#include <alcd.h>
#include <delay.h>



unsigned char n_entered=0, x1, x2, x3, x4, a, b, c, d, pas_entered, menu_flg=0, pas_flg=0, led_flg=0, buzzer_flg=0, relay_flg=0;
char pass_list[5] = {'a', '5', '#', '2'};
char character[17] = {'1', '2', '3', 'a', '4', '5', '6', 'b', '7', '8', '9', 'c', '*', '0', '#', 'd'};
unsigned char flag1=0, flag2=0, flag3=0, rising_edg_flg=0, falling_edg_flg=0, buzzer_sound=0;

void show_entered_pas(void)
{ 
       lcd_gotoxy(0,1);
       if(n_entered==1)
       {
            lcd_putchar(x1);
       }
       else if(n_entered==2)
       {
            lcd_putchar(x1);
            lcd_putchar(x2); 
       }   
       else if(n_entered==3)
       {
            lcd_putchar(x1);
            lcd_putchar(x2);
            lcd_putchar(x3); 
       }  
       else if(n_entered==4)
       {
            lcd_putchar(x1);
            lcd_putchar(x2); 
            lcd_putchar(x3);  
            lcd_putchar(x4);
       }    
       
}

void check_flag(void)
{
    if(flag1 != 0){if(TCNT0 == 255 & flag1 == 2) flag1=0; else if(TCNT0 == 255) flag1 ++;} 
    if(flag2 != 0){if(TCNT0 == 255 & flag2 == 2) flag2=0; else if(TCNT0 == 255) flag2 ++;} 
    if(flag3 != 0){if(TCNT0 == 255 & flag3 == 2) flag3=0; else if(TCNT0 == 255) flag3 ++;} 
    if(buzzer_sound != 0){if(TCNT0 == 255 & buzzer_sound == 4) buzzer_sound=0; else if(TCNT0 == 255) buzzer_sound ++;} 
}

void menu(void)
{

        if(menu_flg == 0 )
        {
            lcd_clear();
            lcd_putsf("1.LED     <=");
            lcd_gotoxy(0,1);
            lcd_putsf("2.Buzzer");
        } 
        else if(menu_flg == 1)
        {
                lcd_clear();
            lcd_putsf("1.LED");
            lcd_gotoxy(0,1);
            lcd_putsf("2.Buzzer  <=");
        }
        else if(menu_flg == 2)
        {
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("3.Relay   <=");
        } 

}

void read_key_input(void)
{

    if(PIND.3 == 1)
    {
        a = PIND.4;
        b = PIND.5;
        c = PIND.6;
        d = PIND.7;  

        pas_entered = ((a<<3) | (b<<2) | (c<<1) | d) ;  
        
        check_flag();
        
        if(n_entered == 0)
        {            
            flag1 = 1; 
            TCNT0 = 0;
            x1 = character[pas_entered];   
            n_entered = 1;
            show_entered_pas();
        }    
        else if(n_entered == 1)
        {                 
            flag2 = 1; 
            x2 = character[pas_entered];
            n_entered = 2;  
            if((x1 == x2 & flag1 == 0) | (x1 != x2)) {show_entered_pas(); TCNT0 = 0;}  
            else n_entered = 1; 
        }
        else if(n_entered == 2)
        {          
            flag3 = 1; 
            x3 = character[pas_entered]; 
            n_entered = 3;
            if((x2 == x3 & flag2 == 0) | (x3 != x2)) {show_entered_pas(), TCNT0 = 0;} 
            else  n_entered = 2; 
        }
        else if(n_entered == 3)
        {              
            x4 = character[pas_entered];
            n_entered = 4; 
            if((x3 == x4 & flag3 == 0) | (x3 != x4)) 
            {
                lcd_clear();
                if(x1==pass_list[0] & x2==pass_list[1] & x3==pass_list[2] & x4==pass_list[3])
                {        
                    pas_flg = 1;
                    menu();            
                }
                else 
                {  
                
                    lcd_putsf("password Wrong !");
                    delay_ms(1000); 
                    lcd_clear();
                    lcd_gotoxy(0,0);
                    lcd_putsf("enter password :"); 
                    n_entered = 0;
                }
            
                    
                
            }
            else n_entered = 3; 
        }
    }
    

    
    
}

void menu_in(void)
{
    lcd_clear();
    if (led_flg == 1) lcd_putsf("      LED");
    else if(buzzer_flg == 1) lcd_putsf("     Buzzer");
    else if(relay_flg == 1) lcd_putsf("     Relay");
 
}

void led(void)
{
    if(led_flg ==0)
    {      
        PORTC.0 = 1;
        PORTA.1 = 1;
        PORTA.2 = 1;
        led_flg = 1;
        menu_in(); 
    }
    else
    {     
        menu();
        PORTC.0 = 0;
        PORTA.1 = 0;
        PORTA.2 = 0;
        led_flg = 0;
    }  

}

void buzzer(void)
{
    if(buzzer_flg ==0)
    {
        PORTC.1 = 1;
        PORTA.1 = 1;
        PORTA.2 = 1;
        buzzer_flg = 1;  
        buzzer_sound = 1;
        TCNT0 = 0;
        menu_in(); 
    }
    else
    {     
        menu();
        PORTC.1 = 0;
        PORTA.1 = 0;
        PORTA.2 = 0;
        buzzer_flg = 0;
    }
}

void relay(void)
{
    if(relay_flg ==0)
    {               
        menu_in();
        PORTA.5 = 1;
        PORTA.1 = 1;
        PORTA.0 = 1;   
        PORTA.3 = 1;
        PORTA.4 = 1;
        PORTA.6 = 1;
        relay_flg = 1;  
        menu_in();
    }
    else
    {        
        menu();
        PORTA.5 = 0;
        PORTA.1 = 0;
        PORTA.0 = 0;   
        PORTA.3 = 0;
        PORTA.4 = 0;
        PORTA.6 = 0;
        relay_flg = 0;
    }
}

void devices(void)
{   
        if(menu_flg == 0) led();
        else if(menu_flg == 1) buzzer();
        else if(menu_flg == 2) relay(); 
}

void init(void)
{
        PORTC.0 = 0;
        PORTA.1 = 0;
        PORTA.2 = 0;
        led_flg = 0; 
        
        PORTC.1 = 0;
        PORTA.1 = 0;
        PORTA.2 = 0;
        buzzer_flg = 0; 
        
        PORTA.5 = 0;
        PORTA.1 = 0;
        PORTA.0 = 0;   
        PORTA.3 = 0;
        PORTA.4 = 0;
        PORTA.6 = 0;
        relay_flg = 0;      
}

void btn_handler(void)
{
    check_flag();
    if(buzzer_sound==0 & buzzer_flg==1) PORTC.1 = 0;
    
    if(PIND.0 ==0) rising_edg_flg=1; 
    if(PIND.0 ==1 & rising_edg_flg == 1)
    {
     menu_flg ++; 
     rising_edg_flg = 0;
     if(menu_flg == 3) menu_flg = 0; 
     init();
     menu(); 
    }  
    else if(PIND.1 == 1)
    {            
        falling_edg_flg = 1;;     
    }  
    
    if(falling_edg_flg == 1 & PIND.1 ==0)
    {       
        falling_edg_flg = 0;
        devices();
    }
  
}





void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0xff;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0xff;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 0.977 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x05;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 0
// RD - PORTB Bit 1
// EN - PORTB Bit 2
// D4 - PORTB Bit 4
// D5 - PORTB Bit 5
// D6 - PORTB Bit 6
// D7 - PORTB Bit 7
// Characters/line: 8
lcd_init(16);
lcd_gotoxy(0,0);
lcd_putsf("enter password :");

while (1)
      {
      // Place your code here 
      if(pas_flg == 0)read_key_input(); 
      else btn_handler();

      }
}
