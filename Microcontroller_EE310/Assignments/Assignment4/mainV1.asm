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
//-----------------------------

;---------------------
; Initialization
;---------------------
#include <xc.inc>
    
;----------------
; PROGRAM INPUTS
;----------------
#define  measuredTempInput 	45
#define  refTempInput 		25

;---------------------
; Definitions
;---------------------
#define SWITCH    LATD,2  
#define LED0      PORTD,0
#define LED1	     PORTD,1
    
;---------------------
; Program Constants
;---------------------
REG10   equ     10h   // in HEX
REG11   equ     11h
REG01   equ     1h
refTemp	    equ	    20h
measuredTemp	equ	21h  
contReg	    equ	    22h  
NUME	equ	80h
QU	equ	81h
;---------------------
; Main Program
;---------------------
    PSECT absdata,abs,ovrld
    ORG          0020H           ; Begin assembly at 0020H
    BANKSEL ANSELD
    CLRF    ANSELD
    MOVLW   0x00
    MOVWF   TRISD
    MOVLW   measuredTempInput
    MOVWF   measuredTemp
    MOVLW   refTempInput
    MOVWF   refTemp
    CALL    hexToDec
    MOVLW   measuredTempInput
    SUBWF   refTemp
    BZ	LED_OFF
    BN	LED_HOT
    GOTO    LED_COLD

hexToDec:   ; This code is taken from Mazidi, p. 164
    MOVLW   measuredTempInput
    BANKSEL NUME
    MOVWF   NUME
    MOVLW   10
    CLRF    QU
D_1:
    INCF    QU, F
    SUBWF   NUME
    BC	D_1
    ADDWF   NUME
    DECF    QU, F
    MOVFF   NUME, 0x70
    MOVFF   QU, NUME
    CLRF    QU
D_2:
    INCF    QU, F
    SUBWF   NUME
    BC	D_2
    ADDWF   NUME
    DECF    QU, F
    MOVFF   NUME, 0x71
    MOVFF   QU, 0x72

    
    MOVLW   refTempInput	;Converting ref value from hex to dec

    MOVWF   NUME
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

LED_HOT:    ;if measuredTemp>refTemp
    MOVLW   0x02
    MOVWF   contReg
    MOVLW   0x04
    MOVWF   PORTD
    GOTO    FIN
LED_COLD:   ;if measuredTemp<refTemp
    MOVLW   0x01
    MOVWF   contReg
    MOVLW   0x02
    MOVWF   PORTD
    GOTO    FIN
LED_OFF:    ;if measuredTemp=refTemp
    MOVLW   0x00
    MOVWF   contReg
    MOVLW   0x00
    MOVWF   PORTD
    GOTO    FIN

FIN:
    END
