/*
 * ---------------------
 * Title: IO Ports Relay
 * ---------------------
 * Program Details:
 *  The purpose of this program is to simulate opening a box using a code.
 * Inputs: RC2, RC3
 * Outputs: PORTD, RB0, RB3
 * Date: 4/12/26
 * File Dependencies / Libraries: It is required to include the 
 * Configuration Header File 
 * Compiler: xc8, 3.10
 * Device: PIC18F47K42
 * Author: Derek Kan
 * Versions:
 *      V1.0: Basic implementation 
 */

#define _XTAL_FREQ 4000000
#include <xc.h>
#include "configfile.h"

//-------------------------------------
// Function Prototypes
//-------------------------------------
void InitializeSystem(void);

void input1(void);
void input2(void);
void count1(int digit, int number);
void count2(int digit, int number);
void reset(void);
int zeroth_digit = 0x00;
int first_digit = 0x00;
int final_code = 0x00;
int secret_code = 0x23;
int escape_check = 0x00;

void main(void) {
    while(1)
    {
        InitializeSystem();
        input1();
        LATDbits.LD7=1;
        input2();
        final_code = first_digit + zeroth_digit;
        if(final_code == secret_code)
        {
            LATD=0x1E;
            LATBbits.LB0=1;
            __delay_ms(3000);
            break;
        }
        else
        {
            LATD=0x76;
            LATBbits.LB3=1;
            __delay_ms(3000);
            LATBbits.LB3=0;
        }
        reset();
    }

    return;
}



//-------------------------------------
// Initialize Port Directions
//-------------------------------------
void InitializeSystem(void)
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
}



void input1(void)
{
    while(1)
    {
        count1(0x3F, 0);
        if(escape_check == 1)
        {
            escape_check = 0;
            return;
        }
        count1(0x06, 1);
        if(escape_check == 1)
        {
            escape_check = 0;
            return;
        }    
        count1(0x5B, 2);
        if(escape_check == 1)
        {
            escape_check = 0;
            return;
        }  
        count1(0x4F, 3);
        if(escape_check == 1)
        {
            escape_check = 0;
            return;
        } 
        count1(0x66, 4);
        if(escape_check == 1)
        {
            escape_check = 0;
            return;
        }
    }
}


void count1(int digit, int number)
{
    while(1)
    {
        while(PORTCbits.RC2 == 0)
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
        if(PORTCbits.RC2 == 0)
        {
            break;
        }
    }
    if(i==15) //Check if 
    {
        escape_check = 1;
        zeroth_digit = number;
        return;
    }     
}


void count2(int digit, int number)
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
    if(i==15) //Check if 
    {
        escape_check = 1;
        first_digit = 16 * number;
        return;
    }     
}


void input2(void)
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
}
