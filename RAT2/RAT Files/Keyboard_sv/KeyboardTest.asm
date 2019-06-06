; --------------------------------------------------------------------
; Program to test keyboard input with interrupts. Each interrupt is 
; counted and the current total is displayed to the LEDs (0 - 255)
; The keycode is displayed on the Seven Segment
;
; Author: Paul Hummel
; --------------------------------------------------------------------

.CSEG
.ORG 0x20

.EQU SSEG = 0x81
.EQU LEDS = 0x40
.EQU PS2_KEY_CODE = 0x44
.EQU loop_count = 0xAA

init:
   SEI
   MOV  R0, 0x00    ;r0 used for counting interrupts
   MOV  R1, 0x00    ;r1 used for reading keyboard code
   OUT R0, LEDS
   OUT R1, SSEG
   
main:    	MOV R11, loop_count

out_for1:   SUB  R11, 0x01
            MOV  R12, loop_count   ;set middle for loop count

mid_for1:   SUB  R12, 0x01
            MOV  R13, loop_count   ;set inside for loop count

in_for1:    MOV  R31, 0xFF
            MOV  R31, 0xFF
            MOV  R31, 0xFF
            SUB  R13, 0x01
            BRNE in_for1

            OR   R12, 0x00         ;load flags for middle for counter
            BRNE mid_for1

            OR   R11, 0x00         ;load flags for outsde for counter value
            BRNE out_for1
  
			BRN  main   ; continuous loop waiting for interrupts


; --------------------------------------------------------------------
; Interrupts service routine
; --------------------------------------------------------------------
My_ISR:		IN  R1, PS2_KEY_CODE
			ADD R0, 0x01
			OUT R0, LEDS
			OUT R1, SSEG
			RETIE

; --------------------------------------------------------------------
; interrupt vector
; --------------------------------------------------------------------
.CSEG
.ORG 0x3FF
BRN My_ISR
