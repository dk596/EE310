;---------------------
; Title: Seven Segment Count Up or Down
;---------------------
; Program Details:
; The purpose of this program is to increment or decrement the seven 
; segment counter using switches.
; Dependencies: NONE
; Compiler: xc8, 3.10
; Operating System: Windows 11 
; Author: Derek Kan
; Credit to Dr. Farahmand for original code of _setupPortD/B, loopDelay
; OUTPUTS: PORTD
; INPUTS: PORTB [2:1]
; Versions:
; V0.1: 3/25/26 - work in progress, only increment triggered with button
; V0.2: 3/25/26 - increment, decrement, reset, hold number added
; V1.0: 3/31/26 - comments added
;-----------------------------

;---------------------
; Initialization
;---------------------
#include <xc.inc>
#include "./AssemblyConfig.inc"
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
_setup: ;setup the ports as inputs/outputs
    clrf WREG
    CALL _setupPortD
    CALL _setupPortB
    clrf PORTB
    clrf PORTD
        
_main: ;this displays nothing until a button is pressed
    CLRF 0x55 ;exit "restart mode"
    MOVLW 0x00
    MOVWF PORTD
    CALL _3loops
display0: ;each display function places the appropriate number into PORTD,
	  ;calls a delay function, then checks whether only switch B is pressed
	  ;(which then jumps to the previous number) or not (which then moves
	  ;forward to the next number)
    MOVLW 0xBF ;display 0 by lighting up correct segments
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  displayF
display1:
    MOVLW 0x06 ;display 1
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  display0
display2:
    MOVLW 0b01011011 ;display 2
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  display1
display3:
    MOVLW 0b01001111 ;display 3
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  display2
display4:
    MOVLW 0b01100110 ;display 4
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  display3
display5:
    MOVLW 0b01101101 ;display 5
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  display4
display6:
    MOVLW 0b01111101 ;display 6
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  display5
display7:
    MOVLW 0b00000111 ;display 7
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  display6
display8:
    MOVLW 0b01111111 ;display 8
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  display7
display9:
    MOVLW 0b01101111 ;display 9
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  display8
displayA:
    MOVLW 0b01110111 ;display A
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  display9
displayB:
    MOVLW 0b01111100 ;display B
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  displayA
displayC:
    MOVLW 0b00111001 ;display C
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  displayB
displayD:
    MOVLW 0b01011110 ;display D
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  displayC
displayE:
    MOVLW 0b01111001 ;display E
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  displayD
displayF:
    MOVLW 0b01110001 ;display F
    MOVWF PORTD
    CALL _3loops
    MOVLW 0x02
    SUBWF PORTB, 0
    BZ	  displayE
    GOTO display0 ;loops back to display 0
    
    
;-------------------------------------
; Call Functions
;-------------------------------------
_setupPortD:   ;sets up PORTD as outputs
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

_setupPortB:   ;sets up PORTB 2, 1 as inputs
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
loopDelay: ;this initalizes the loop delay
    MOVLW       Inner_loop
    MOVWF       0x10
    MOVLW       Outer_loop
    MOVWF       0x11
_loop1:   ;this is the actual loop
    DECF        0x10,1
    BNZ         _loop1
    MOVLW       Inner_loop ; Re-initialize the inner loop for when the outer loop decrements.
    MOVWF       0x10
    DECF        0x11,1 // outer loop
    BTFSC	0x55, 0  ;if in "restart mode", ignore pressed buttons
    GOTO	restartjump
    MOVLW	0x06 ;if both buttons pressed, go to restart
    CPFSLT	PORTB
    GOTO	restart
    MOVLW	0x00 ;if neither button pressed, extend delay
    CPFSGT	PORTB
    GOTO	loopDelay
restartjump:    
    BNZ        _loop1

    RETURN

    
restart:
    MOVLW 0xBF ;display 0 by lighting up correct segments
    MOVWF PORTD
    MOVWF 0x55
    CALL  _3loops  ;delay so that the user sees the 0, "restart mode" on
    GOTO    _main
    
_3loops: ;needed to extend delay time
    CALL loopDelay
    CALL loopDelay
    CALL loopDelay
    RETURN
    
    


    
