;---------------------
; Title: Seven Segment Count Up or Down
;---------------------
; Program Details:
; The purpose of this program is to increment or decrement the seven 
; segment counter using switches.
; Dependencies: NONE
; Compiler: xc8, 3.10
; Author: Derek Kan
; OUTPUTS: PORTD
; INPUTS: 
; Versions:
; V0.1: 3/25/26 - work in progress, only increment triggered with button
;-----------------------------

;---------------------
; Initialization
;---------------------
#include <xc.inc>
;---------------------
; Program Inputs
;---------------------
Inner_loop  equ 255 // in decimal
Outer_loop  equ 255

;---------------------
; Definitions
;---------------------

;---------------------
; Program Constants
;---------------------
    
;---------------------
; Program Organization
;---------------------
    PSECT absdata,abs,ovrld        ; Do not change

    ORG          0                ;Reset vector
    GOTO        _setup

    ORG          0020H           ; Begin assembly at 0020H
    
;---------------------
; Setup & Main Program
;---------------------   
_setup:
    clrf WREG
    CALL _setupPortD
    CALL _setupPortB
    clrf PORTB
    clrf PORTD
    
    
_main:
    BTFSC PORTB, 2
    CALL increment
    GOTO _main
    
    
;-------------------------------------
; Call Functions
;-------------------------------------
_setupPortD:
    BANKSEL	PORTD ;
    CLRF	PORTD ;Init PORTA
    BANKSEL	LATD ;Data Latch
    CLRF	LATD ;
    BANKSEL	ANSELD ;
    CLRF	ANSELD ;digital I/O
    BANKSEL	TRISD ;
    MOVLW	0b00000000 ;Set RD[7:0] as outputs
    MOVWF	TRISD 
    RETURN

_setupPortB:
    BANKSEL	PORTB ;
    CLRF	PORTB ;Init PORTB
    BANKSEL	LATB ;Data Latch
    CLRF	LATB ;
    BANKSEL	ANSELB ;
    CLRF	ANSELB ;digital I/O
    BANKSEL	TRISB ;
    MOVLW	0b00000110 ;
    MOVWF	TRISB ;
    RETURN
    
    
;-----The Delay Subroutine    
loopDelay: 
    MOVLW       Inner_loop
    MOVWF       0x10
    MOVLW       Outer_loop
    MOVWF       0x11
_loop1:
    DECF        0x10,1
    BNZ         _loop1
    MOVLW       Inner_loop ; Re-initialize the inner loop for when the outer loop decrements.
    MOVWF       0x10
    DECF        0x11,1 // outer loop
    BNZ        _loop1
    RETURN
    
_3loops:
    CALL loopDelay
    CALL loopDelay
    CALL loopDelay
    CLRWDT
    RETURN
    
    
;Increment Subroutine
increment:
    MOVLW 0xBF ;display 0 by lighting up correct segments
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x06 ;display 1
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01011011 ;display 2
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01001111 ;display 3
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01100110 ;display 4
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01101101 ;display 5
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01111101 ;display 6
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b00000111 ;display 7
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01111111 ;display 8
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01101111 ;display 9
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01110111 ;display A
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01111100 ;display B
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b00111001 ;display C
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01011110 ;display D
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01111001 ;display E
    MOVWF PORTD
    CALL _3loops
    MOVLW 0b01110001 ;display F
    MOVWF PORTD
    CALL _3loops
    RETURN
    
