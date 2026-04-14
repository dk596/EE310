/* 
 * File:   functionfile.h
 * Author: derek
 *
 * Created on April 14, 2026, 1:49 PM
 */

#ifndef FUNCTIONFILE_H
#define	FUNCTIONFILE_H
#include <xc.h>
void InitializeSystem(void) //sets up all the ports, interrupts
{
    TRISB = 0x00;
    TRISC = 0xFF; 
    TRISD = 0x00; 
    ANSELB = 0x00;
    ANSELC = 0x00;
    ANSELD = 0x00;
    LATB = 0x00;
    PORTC = 0xFF;
    LATD = 0x00;
    IOCCNbits.IOCCN4 = 1;    // trigger on falling edge
    IOCCPbits.IOCCP4 = 0;    //disable rising edge
    PIE0bits.IOCIE = 1;      // Enable IOC interrupts
    INTCON0bits.GIE = 1;     //enable global interrupt
    WPUCbits.WPUC4 = 1;     //pull up for interrupt
}

void count1(int digit, int number)
{
    while(1)
    {
        while(PORTCbits.RC2 == 0) //scan for photoresistor input
        {
            LATD=digit; //display digit on 7-segment
            escape_check = 1; //escape loop
        }
        if(escape_check == 1) 
        {
            escape_check = 0;
            break;
        }
    }
    int i = 0;
    __delay_ms(500); 
    while (i < 15) //delay for around 3 seconds
    {
        i++; // Just counting to waste time
        __delay_ms(200);
        if(PORTCbits.RC2 == 0) //if another input detected, stop the delay,
            ///move to next number
        {
            break;
        }
    }
    if(i==15) //Check if waited long enough
    {
        escape_check = 1; //escape from this input
        zeroth_digit = number; //set the digit
        return;
    }     
}


void count2(int digit, int number) //same logic as count 1, but for 2nd digit
{
    while(1)
    {
        while(PORTCbits.RC3 == 0)
        {
            LATD=digit;
            escape_check = 1;
        }
        if(escape_check == 1)
        {
            escape_check = 0;
            break;
        }
    }
    int i = 0;
    __delay_ms(500); 
    while (i < 15) 
    {
        i++; // Just counting to waste time
        __delay_ms(200);
        if(PORTCbits.RC3 == 0)
        {
            break;
        }
    }
    if(i==15) //Check if waited long enough
    {
        escape_check = 1; //escape from this input
        first_digit = 16 * number; //set the digit
        return;
    }     
}

void input1(void)
{
    while(1)
    {
        count1(0x3F, 0); //count and display 0 on 7-segment
        if(escape_check == 1) //if waited for 0, register input
        {
            escape_check = 0;
            return;
        }
        count1(0x06, 1); //count and display 1 on 7-segment
        if(escape_check == 1) //register 1 as input
        {
            escape_check = 0;
            return;
        }    
        count1(0x5B, 2); //count and display 2 on 7-segment
        if(escape_check == 1) //register 2
        {
            escape_check = 0;
            return;
        }  
        count1(0x4F, 3); //count and display 3 on 7-segment
        if(escape_check == 1) //register 3
        {
            escape_check = 0;
            return;
        } 
        count1(0x66, 4); //count and display 4 on 7-segment
        if(escape_check == 1) //register 4
        {
            escape_check = 0;
            return;
        }
    }
}





void input2(void) //same logic as input1, but for 2nd digit
{
    while(1)
    {
        count2(0x3F, 0);
        if(escape_check == 1)
        {
            escape_check = 0;
            return;
        }
        count2(0x06, 1);
        if(escape_check == 1)
        {
            escape_check = 0;
            return;
        }    
        count2(0x5B, 2);
        if(escape_check == 1)
        {
            escape_check = 0;
            return;
        }  
        count2(0x4F, 3);
        if(escape_check == 1)
        {
            escape_check = 0;
            return;
        } 
        count2(0x66, 4);
        if(escape_check == 1)
        {
            escape_check = 0;
            return;
        }
    }
}

void reset(void)
{
    int zeroth_digit = 0x00;
    int first_digit = 0x00;
    int final_code = 0x00;
    LATD=0x00;
}




void __interrupt(irq(IOC), high_priority) IOC_ISR(void) {
    // 1. Check if RC4 caused the interrupt
    if (IOCCFbits.IOCCF4 == 1) { 
        // 2. Clear the specific pin flag first
        IOCCFbits.IOCCF4 = 0; 
        if (PORTCbits.RC4 == 0)
        {
        // 3. Perform action (e.g., toggle LED)
        LATD= 0xF7;
        LATB=0x00;
        LATBbits.LB3=1;
        __delay_ms(500);
        LATBbits.LB3=0;
        __delay_ms(500);
        LATBbits.LB3=1;
        __delay_ms(500);
        LATBbits.LB3=0;  
        LATD=0x00;

        while(1)
        {
            ;
        }
        }

    }
}
#endif	/* FUNCTIONFILE_H */

