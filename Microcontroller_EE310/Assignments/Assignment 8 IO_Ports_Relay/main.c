/*
 * ---------------------
 * Title: IO Ports Relay
 * ---------------------
 * Program Details:
 *  The purpose of this program is to simulate opening a box using a code.
 * Inputs: RC2, RC3, RC4
 * Outputs: PORTD, RB0, RB3
 * Date: 4/12/26
 * File Dependencies / Libraries: It is required to include the 
 * Configuration Header File 
 * Compiler: xc8, 3.10
 * Device: PIC18F47K42
 * Author: Derek Kan
 * Versions:
 *      V1.0: Basic implementation 
 *      V1.1: Added interrupt, comments
 *      V1.2: Created header files
 */

#define _XTAL_FREQ 4000000
#include <xc.h>
#include "configfile.h"
#include "initializationfile.h"
#include "functionfile.h"




void main(void) {
    while(1)
    {
        InitializeSystem();
        input1(); //detect first input
        LATDbits.LD7=1;  //LED shows first input inputted
        input2(); //detect second input
        final_code = first_digit + zeroth_digit; //determine final code
        if(final_code == secret_code) //check if entered code is correct
        {
            LATD=0x1E; //motor if correct
            LATBbits.LB0=1;
            __delay_ms(3000);
            break;
        }
        else
        {
            LATD=0x76; //buzzer if incorrect
            LATBbits.LB3=1;
            __delay_ms(3000);
            LATBbits.LB3=0;
        }
        reset();
    }

    return;
}


