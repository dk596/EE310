//-----------------------------
// Title: Heating and Cooling Control System
//-----------------------------
// Purpose: The purpose of this program is to design a heating and cooling
// system.
// Dependencies: NONE
// Compiler: xc8, 3.10
// Author: Derek Kan
// OUTPUTS: PORTD
// INPUTS: refTempInput, measuredTempInput
// Versions:
// V1.0: 3/7/26 - First version
// V1.1: 3/7/26 - added comments, negative functionality
//-----------------------------

;---------------------
; Initialization
;---------------------
#include <xc.inc>
    
;----------------
; PROGRAM INPUTS
;----------------
#define  measuredTempInput 	-5  ;temperature values (store in 0x21)
				    ;range (-10C - 60C)
#define  refTempInput 		15  ;(store in 0x20)
				    ;range (10C - 50C)
;---------------------
; Definitions
;---------------------
#define SWITCH    LATD,2    
#define LED0      PORTD,0
#define LED1	     PORTD,1
    
;---------------------
; Program Constants
;---------------------
REG10   equ     10h   ;required constants
REG11   equ     11h
REG01   equ     1h
refTemp	    equ	    20h	;reg to store reference temperature
measuredTemp	equ	21h  ;reg to store measured temperature
contReg	    equ	    22h  ;reg to store state of system
NUME	equ	80h	;reg to store numerator
QU	equ	81h	;reg to store quotient
;---------------------
; Main Program
;---------------------
    PSECT absdata,abs,ovrld
    ORG          0020H           ; Begin assembly at 0020H
    BANKSEL ANSELD		;enable PORTD as output
    CLRF    ANSELD
    MOVLW   0x00
    MOVWF   TRISD
    MOVLW   measuredTempInput	;move measured temperature value to reg
    MOVWF   measuredTemp
    MOVLW   refTempInput	;move reference temperature value to reg
    MOVWF   refTemp
    CALL    hexToDec		;record temperature values in decimal
    MOVLW   measuredTempInput	;move measured temperature value to WREG
    SUBWF   refTemp, 0		;refTemp - measuredTemp
    BZ	LED_OFF			;branch if refTemp = measuredTemp
    BN	LED_HOT			;branch if refTemp < measuredTemp
    GOTO    LED_COLD		;only case left refTemp > measuredTemp

hexToDec:  ;This code is based on Mazidi, p. 164, repeated subtraction method
	   ;we divide the number by 10, the remainder becomes the decimal digit
	   ;and the quotient becomes the new dividend
    MOVLW   measuredTempInput	;Converting measured value from hex to dex
    ADDWF   TRISD, 0	    ;check if value is negative
    BN	    INVERT	;gets rid of potential negative sign
BACK:    BANKSEL NUME    
    MOVWF   NUME    ;moving to NUME to prepare division
    MOVLW   10	    ;we will divide by 10 repeatedly
    CLRF    QU	    ;make sure quotient is cleared
D_1:
    INCF    QU, F   ;increment quotient for every sub
    SUBWF   NUME    ;subtract WREG from NUME value
    BC	D_1	    ;if positive go back (C=1 for positive)
    ADDWF   NUME    ;one too many sub, this is our first digit
    DECF    QU, F   ;one too many for quotient
    MOVFF   NUME, 0x70	;save the first digit in 0x70
    MOVFF   QU, NUME	;the previous quotient is now the dividend
    CLRF    QU		;clear quotient
D_2:
    INCF    QU, F   ;Same steps as in D1
    SUBWF   NUME
    BC	D_2
    ADDWF   NUME
    DECF    QU, F
    MOVFF   NUME, 0x71	;save the second digit in 0x71
    MOVFF   QU, 0x72	;a 2-digit hex has 3-digit decimal, so we can directly
			;store the remaining quotient as the third digit

    

    MOVLW   refTempInput	;Converting ref value from hex to dec
    MOVWF   NUME		;same process as for the measured value
    MOVLW   10
    CLRF    QU
D_3:
    INCF    QU, F
    SUBWF   NUME
    BC	D_3
    ADDWF   NUME
    DECF    QU, F
    MOVFF   NUME, 0x60
    MOVFF   QU, NUME
    CLRF    QU
D_4:
    INCF    QU, F
    SUBWF   NUME
    BC	D_4
    ADDWF   NUME
    DECF    QU, F
    MOVFF   NUME, 0x61
    MOVFF   QU, 0x62
    RETURN

LED_HOT:    ;if measuredTemp>refTemp (activate cooling system)
    MOVLW   0x02    ;set contReg
    MOVWF   contReg
    MOVLW   0x04    ;turn on PORTD.2
    MOVWF   PORTD
    GOTO    FIN
LED_COLD:   ;if measuredTemp<refTemp (activate heating system)
    MOVLW   0x01    ;set contReg
    MOVWF   contReg
    MOVLW   0x02    ;turn on PORTD.1
    MOVWF   PORTD
    GOTO    FIN
LED_OFF:    ;if measuredTemp=refTemp (turn off system)
    MOVLW   0x00    ;set contReg
    MOVWF   contReg 
    MOVLW   0x00    ;set PORTD = 0
    MOVWF   PORTD
    GOTO    FIN

INVERT:	    ;inverts measured temperature value if negative for storing in dec
    NEGF    WREG
    GOTO    BACK
FIN:
    END
