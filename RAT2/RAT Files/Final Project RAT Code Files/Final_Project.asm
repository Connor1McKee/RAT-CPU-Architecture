
;---------------------------------------------------------------------
;Bubble Blast

;By Marty Lange and Connor McKee

;-----------CODE NEEDDED:---------------------------------------------
;---1. Draw background
;---2. Draw borders
;---3. Draw preloaded bubbles (the level)
;---4. Draw random bubble to be fired (possible direction arrow)
;---5. Trajectory of the bubble and bouncing effect
;---6. Bubbles popping when 3 or more, check for adjacent colors
;---7. OPTIONAL: add extral levels, or random level generator and/or move down feature?
;---------------------------------------------------------------------

.CSEG
.ORG 0x10

.EQU VGA_HADD = 0x90
.EQU VGA_LADD = 0x91
.EQU VGA_COLOR = 0x92
.EQU COLOR_READ = 0x93
.EQU RANDOM_COLOR = 0x21

.EQU SSEG_ID1 = 0x81
.EQU SSEG_ID2 = 0x82

.EQU KEYBOARD = 0x44

.EQU BG_COLOR       = 0x00             ; Background:  black

;r0 is used for comparing the cursor's position
;r1 is set to hold 0 no matter what
;r3 is used for holding a random number
;r2 is currently being used for debugging
;r4 is used for storing the shifted Y value
;r5 is used for storing the shifted X value
;r6 is used for color
;r7 is used for Y
;r8 is used for X
;r9 is used for ending coordinates
;r10 is used for storing Y
;r11 is used for storing X
;r12 is used for storing ending value
;r13 is used for storing Y (checking for deletion)
;r14 is used for storing Y (checking for deletion)
;r17 is used to store the random color
;r25 is used for entire check counter 
;r26 is used for loading 
;r27 is used for delete pointer
;r28 is used for loop count
;r29 is used for color count
;r30 is used for storing the keyboard input
;r31 used for reading/storing color



;---------------------------------------------------------------------
init:	 SEI
         CALL   draw_background         ; draw using default color

         MOV    r7, 0x04                ; starting Y coordinate
         MOV    r8, 0x05                ; starting X coordinate
		 MOV    r9, 0x36                ; ending Y coordinate
		 MOV    r6, 0xFF                ; color white
         CALL   draw_vertical_line    	; draw left border  

         MOV    r7, 0x04                ; starting Y coordinate
         MOV    r8, 0x2D                ; starting X coordinate
		 MOV    r9, 0x36                ; ending Y coordinate
		 MOV    r6, 0xFF                ; color white
         CALL   draw_vertical_line    	; draw right border  
		 
         MOV    r7, 0x04                ; starting Y coordinate
         MOV    r8, 0x05                ; starting X coordinate
		 MOV    r9, 0x2D                ; ending X coordinate
		 MOV    r6, 0xFF                ; color white
         CALL   draw_horizontal_line    ; draw top border 
	 
		 MOV    r7, 0x36                ; starting Y coordinate
         MOV    r8, 0x05                ; starting X coordinate
		 MOV    r9, 0x2D                ; ending X coordinate
		 MOV    r6, 0xFF                ; color white
         CALL   draw_horizontal_line    ; draw bot border
		 
		 CALL DRAW_CURSOR_90			; draw cursor initial position

;----------------------------------------------------------------
;-------Game title-----------------------------------------------
;----------------------------------------------------------------		 
		 ;draw 1st B 
		 MOV 	r7, 0x04				; starting Y coordinate
		 MOV	r8, 0x2F				; starting X coordinate
		 MOV	r6, 0xFF				; color : white (FOR NOW)
		 CALL   draw_character_B
		 
		 ;draw U
		 MOV 	r7, 0x04				; starting Y coordinate
		 MOV	r8, 0x34				; starting X coordinate
		 MOV	r9, 0x09				; ending Y coordinate
		 CALL	draw_vertical_line		; draw left U edge
		 MOV	r7, 0x0A				; starting Y coordinate
		 MOV	r8, 0x35				; starting X coordinate
		 MOV 	r9, 0x36				; ending X coordinate
		 CALL 	draw_horizontal_line	; draw bot edge
		 MOV	r7, 0x04				; starting Y coordinate
		 MOV 	r8, 0x37				; starting X coordinate
		 MOV	r9, 0x09				; ending Y coordinate
		 CALL	draw_vertical_line		; draw right U edge
		  
		 ;draw 2nd B
		 MOV 	r7, 0x04				; staring Y coordinate
		 MOV 	r8, 0x39				; starting X coordinate
		 CALL 	draw_character_B
		 
		 ;draw 3rd B
		 MOV 	r7, 0x04				; staring Y coordinate
		 MOV 	r8, 0x3E				; starting X coordinate
		 CALL 	draw_character_B
		 
		 ;draw L
		 MOV	r7, 0x04				; staring Y coordinate
		 MOV	r8, 0x43				; starting X coordinate
		 CALL	draw_character_L		
		 
		 ;draw E
		 MOV	r7, 0x05				; starting Y coordinate
		 MOV	r8, 0x48				; starting X coordinate
		 MOV 	r9, 0x09				; ending Y value
		 CALL 	draw_vertical_line		; draw E left edge
		 MOV	r7, 0x04				; starting Y coordinate
		 MOV 	r8, 0x49				; starting X coordinate
		 MOV	r9, 0x4B				; ending X value
		 CALL 	draw_horizontal_line	; draw top E edge
		 MOV	r7, 0x07				; starting Y coordinate
		 MOV 	r8, 0x49				; starting X coordinate
		 CALL 	draw_dot				; draw middle E dot
		 MOV	r7, 0x0A				; starting Y coordinate
		 MOV	r8, 0x49				; starting X coordinate
		 MOV 	r9, 0x4B				; ending X value
		 CALL 	draw_horizontal_line	; draw bottom E edge
					
		 ;draw last B
		 MOV 	r7, 0x0D				; starting Y coordinate
		 MOV 	r8, 0x2F				; starting X coordinate
		 CALL 	draw_character_B
		 
		 ;draw 2nd L
		 MOV 	r7, 0x0D				; starting Y coordinate
		 MOV	r8, 0x34				; starting X coordinate
		 CALL 	draw_character_L
		 
		 ;draw A
		 MOV 	r7, 0x0D				; starting Y coordinate
		 MOV 	r8, 0x3A				; starting X coordinate
		 MOV	r9, 0x3B
		 CALL	draw_horizontal_line	; draw A top edge
		 MOV	r7, 0x0E				; starting Y coordinate
		 MOV	r8, 0x39				; starting X coordinate
		 MOV 	r9, 0x13
		 CALL 	draw_vertical_line		; draw A left edge
		 MOV	r7, 0x0E				; starting Y coordinate
		 MOV	r8, 0x3C				; starting X coordinate
		 MOV 	r9, 0x13
		 CALL 	draw_vertical_line		; draw A right edge
		 MOV	r7, 0x10				; starting Y coordinate
		 MOV	r8, 0x3A				; starting X coordinate
		 MOV 	r9, 0x3B
		 CALL 	draw_horizontal_line	; draw A 
		 
		 ;draw S
		 MOV	r7, 0x0D
		 MOV	r8, 0x3F
		 MOV 	r9, 0x41
		 CALL 	draw_horizontal_line	; draw S top edge	 
		 MOV	r7, 0x0E
		 MOV 	r8, 0x3E
		 MOV	r9, 0x0F
		 CALL 	draw_vertical_line		; draw S left edge 1
		 MOV	r7, 0x10
		 MOV	r8, 0x3F
		 MOV	r9, 0x40
		 CALL 	draw_horizontal_line	; draw S mid edge
		 MOV	r7, 0x11
		 MOV	r8, 0x41
		 MOV 	r9, 0x12
		 CALL 	draw_vertical_line		; draw S right edge
		 MOV 	r7, 0x13
		 MOV	r8, 0x3E
		 MOV	r9, 0x40
		 CALL 	draw_horizontal_line	; draw S bot edge
		 
		 ;draw T
		 MOV	r7, 0x0E
		 MOV 	r8, 0x43
		 CALL 	draw_dot				; draw T left edge
		 MOV	r7, 0x0D
		 MOV	r8, 0x44
		 MOV 	r9, 0x46
		 CALL 	draw_horizontal_line	; draw T top edge
		 MOV 	r7, 0x0E
		 MOV	r8, 0x47
		 CALL 	draw_dot				; draw T right edge
		 MOV	r7, 0x0D
		 MOV	r8, 0x45
		 MOV 	r9, 0x13
		 CALL 	draw_vertical_line		; draw T middle
		 
		 ;draw bottom line
		 MOV 	r7, 0x15
		 MOV	r8, 0x2F
		 MOV 	r9, 0x33
		 MOV 	r6, 0xE0				; draw Red line
		 CALL 	draw_horizontal_line
		 MOV	r8, 0x34
		 MOV 	r9, 0x38
		 MOV 	r6, 0xD0				; draw Orange line
		 CALL 	draw_horizontal_line
		 MOV 	r8, 0x39
		 MOV 	r9, 0x3D
		 MOV 	r6, 0xD8				
		 CALL 	draw_horizontal_line	; draw Yellow line
		 MOV 	r8, 0x3E
		 MOV 	r9, 0x42
		 MOV	r6, 0x1C
		 CALL 	draw_horizontal_line	; draw Green line
		 MOV 	r8, 0x43
		 MOV 	r9, 0x47
		 MOV 	r6, 0x03
		 CALL 	draw_horizontal_line	; draw Blue line
		 MOV 	r8, 0x48
		 MOV 	r9, 0x4C
		 MOV 	r6, 0x87
		 CALL 	draw_horizontal_line	; draw Purple line
;---------------------------------------------------------	
;-------------- Draw Level--------------------------------
;--------------------------------------------------------
		MOV  r6, 0xD8		; draw yellow bubbles
		 
		 MOV  r8, 0x13
		 MOV  r7, 0x08
		 CALL draw_dot
		 
		 MOV  r8, 0x14
		 MOV  r7, 0x09
		 CALL draw_dot
		 
		 MOV  r8, 0x15
		 MOV  r7, 0x0A
		 CALL draw_dot
		 
		 MOV  r8, 0x13
		 MOV  r7, 0x0A
		 CALL draw_dot
		 
		 MOV r6, 0xD0		; draw orange bubbbles
		 
		 MOV  r8, 0x16
		 MOV  r7, 0x05
		 CALL draw_dot
		 
		 MOV  r8, 0x15
		 MOV  r7, 0x06
		 CALL draw_dot
		 
		 MOV  r8, 0x14
		 MOV  r7, 0x06
		 CALL draw_dot
		 
		 MOV  r8, 0x14
		 MOV  r7, 0x07
		 CALL draw_dot
		 
		 MOV  r8, 0x1B
		 MOV  r7, 0x06
		 CALL draw_dot
		 
		 MOV  r8, 0x1B
		 MOV  r7, 0x05
		 CALL draw_dot
		 
		 MOV  r8, 0x1E
		 MOV  r7, 0x05
		 CALL draw_dot
		 
		 MOV  r8, 0x1F
		 MOV  r7, 0x06
		 CALL draw_dot
		 
		 MOV r6, 0x87		; draw purple bubbles
		 
		 MOV  r8, 0x12
		 MOV  r7, 0x05
		 CALL draw_dot
		 
		 MOV  r8, 0x12
		 MOV  r7, 0x06
		 CALL draw_dot
		 
		 MOV  r8, 0x11
		 MOV  r7, 0x07
		 CALL draw_dot
		 
		 MOV  r8, 0x18
		 MOV  r7, 0x05
		 CALL draw_dot
		 
		 MOV  r8, 0x19
		 MOV  r7, 0x06
		 CALL draw_dot
		 
		 MOV  r8, 0x1A
		 MOV  r7, 0x07
		 CALL draw_dot
		 
		 MOV r6, 0x03		; draw blue bubbles
		 
		 MOV  r8, 0x1E
		 MOV  r7, 0x07
		 CALL draw_dot
		 
		 MOV  r8, 0x1F
		 MOV  r7, 0x08
		 CALL draw_dot
		 
		 MOV  r8, 0x1E
		 MOV  r7, 0x09
		 CALL draw_dot
		 
		 MOV  r8, 0x1D
		 MOV  r7, 0x0A
		 CALL draw_dot
		 
		 MOV r6, 0x1C		; draw green bubbles
		 
		 MOV  r8, 0x18
		 MOV  r7, 0x07
		 CALL draw_dot
		 
		 MOV  r8, 0x17
		 MOV  r7, 0x08
		 CALL draw_dot
		 
		 MOV  r8, 0x16
		 MOV  r7, 0x09
		 CALL draw_dot
		 
		 MOV r6, 0xE0		; draw red bubbles
		 
		 MOV  r8, 0x19
		 MOV  r7, 0x08
		 CALL draw_dot
		 
		 MOV  r8, 0x1A
		 MOV  r7, 0x09
		 CALL draw_dot
		 
		 MOV  r8, 0x1B
		 MOV  r7, 0x0A
		 CALL draw_dot
;------------------------------------------------------
	
		;initialize registers to 0 to start game
		MOV r4, 0x00
		MOV r5, 0x00
		MOV r7, 0x00
		MOV r8, 0x00
		MOV r9, 0x00
		MOV r10, 0x00
		MOV r11, 0x00
		MOV r12, 0x00
		MOV r30, 0x00
		MOV r31, 0x00
		MOV r0, 0x00
		MOV r1, 0x00
		 
		 
		
		
	return_to_main:
		CALL choose_color				; takes a random number and determines a random color to be shot

	main:
		SEI
		BRN    main                    ; continuous loop 

;--------------------------------------------------------------------		
;---choose_color-----------------------------------------------------
;--------------------------------------------------------------------
choose_color:
		;IN r3, RANDOM_COLOR
		CMP r3, 0x2A					; divide the random number by increments of 256/6
		BRCS SET_GREEN
		CMP r3, 0x54
		BRCS SET_PURPLE
		CMP r3, 0x7E
		BRCS SET_BLUE
		CMP r3, 0xA8
		BRCS SET_RED
		CMP r3, 0xD2
		BRCS SET_ORANGE
		CMP r3, 0xFF
		BRCS SET_YELLOW
	
	SET_GREEN:
		MOV r17, 0x1C
		MOV r6, 0x1C
		MOV r8, 0x19
		MOV r7, 0x39
		CALL draw_dot
		RET
	
	SET_PURPLE:
		MOV r17, 0x87
		MOV r6, 0x87
		MOV r8, 0x19
		MOV r7, 0x39
		CALL draw_dot
		RET
	
	SET_BLUE:
		MOV r17, 0x03
		MOV r6, 0x03
		MOV r8, 0x19
		MOV r7, 0x39
		CALL draw_dot
		RET
	
	SET_RED:
		MOV r17, 0xE0
		MOV r6, 0xE0
		MOV r8, 0x19
		MOV r7, 0x39
		CALL draw_dot
		RET
		
	SET_ORANGE:
		MOV r17, 0xD0
		MOV r6, 0xD0
		MOV r8, 0x19
		MOV r7, 0x39
		CALL draw_dot
		RET
		
	SET_YELLOW:
		MOV r17, 0xD8
		MOV r6, 0xD8
		MOV r8, 0x19
		MOV r7, 0x39
		CALL draw_dot
		RET
;---------------------------------------------------------------------
;-  Subroutine: draw_character_L
;-
;-  Draws the character L using (r8,r7) as the top left corner
;-
;-  Parameters:
;-   r8  = x-coordinate
;-   r7  = y-coordinate
;-   r9  = ending coordinate
;-   r6  = color used for line
;-	 r11 = used for storing Y - value
;- 
;- Tweaked registers: r7, r8, r9, r11
;--------------------------------------------------------------------
draw_character_L:
			MOV 	r9, r7					; set ending Y coordinate
			ADD		r9, 0x05				; modify ending Y coordinate
			MOV		r11, r7					; store Y value
			CALL 	draw_vertical_line		; draw left L edge
			
			MOV		r7, r11					; load previous Y value
			ADD 	r8, 0x01				; modify starting X coordinate
			ADD 	r7, 0x06				; modify starting Y coordinate
			MOV 	r9, r8					; set ending X value
			ADD 	r9, 0x02				; modify ending X value
			CALL	draw_horizontal_line	; draw bottom L edge
			
			RET
		
;--------------------------------------------------------------------

;---------------------------------------------------------------------
;-  Subroutine: draw_character_B
;-
;-  Draws the character B using (r8,r7) as the top-left corner
;-
;-  Parameters:
;-   r8  = x-coordinate
;-   r7  = y-coordinate
;-   r9  = ending y-coordinate
;-   r6  = color used for line
;-	 r11 = used for storing the Y - value
;-	 r12 = used for storing the ending value
;- 
;- Tweaked registers: r7,r9, r8, r10, r11, r12
;--------------------------------------------------------------------
draw_character_B:
		MOV		r9, r7					; set ending Y coordinate
		ADD 	r9, 0x06				; modify ending Y coordinate
		MOV		r11, r7					; store Y value
		MOV 	r12, r9					; store ending value
		CALL 	draw_vertical_line		; draw left B edge
		
		MOV 	r7, r11					; load previous Y value
		MOV		r9, r12					; load previous ending value
		ADD		r8, 0x01				; modify starting X coordinate
		MOV		r9, r8					; set ending X coordinate
		ADD 	r9, 0x01				; modify ending X coordinate
		MOV 	r12, r9					; store previous ending value
		MOV		r10, r8					; store previous X coordinate
		CALL	draw_horizontal_line	; draw top B edge
		
		MOV 	r9, r12					; load previous ending value
		MOV		r8, r10					; load previous X coordinate
		ADD		r7, 0x03				; modify Y coordinate
		CALL	draw_horizontal_line	; draw mid B edge
		
		MOV 	r9, r12					; load previous ending value
		MOV		r8, r10					; load previous X coordinate
		ADD 	r7, 0x03				; modify Y coordinate
		CALL	draw_horizontal_line	; draw bot B edge
		
		MOV 	r9, r12					; load previous ending value
		MOV		r8, r10					; load previous X coordinate
		SUB		r7, 0x05				; modify Y coordinate
		ADD 	r8, 0x02				; modify X coordinate
		MOV 	r9, r7					; set init ending Y coordinate
		ADD		r9, 0x01				; modify ending Y coordinate
		MOV		r11, r7					; store Y value
		MOV 	r12, r9					; store ending value
		CALL	draw_vertical_line		; draw top-right B edge
		
		MOV 	r7, r11					; load previous Y value
		MOV		r9, r12					; load previous ending value
		ADD		r7, 0x03				; modify starting Y coordinate
		ADD		r9, 0x03				; modify ending Y coordinate
		CALL	draw_vertical_line		; draw bot-right B edge
		
		RET								; END SUBROUTINE
	
				
;--------------------------------------------------------------------
;-  Subroutine: draw_horizontal_line
;-
;-  Draws a horizontal line from (r8,r7) to (r9,r7) using color in r6
;-
;-  Parameters:
;-   r8  = starting x-coordinate
;-   r7  = y-coordinate
;-   r9  = ending x-coordinate
;-   r6  = color used for line
;- 
;- Tweaked registers: r8,r9
;--------------------------------------------------------------------
draw_horizontal_line:
        ADD    r9,0x01          ; go from r8 to r15 inclusive

draw_horiz1:
        CALL   draw_dot         ; 
        ADD    r8,0x01
        CMP    r8,r9
        BRNE   draw_horiz1
        RET
;--------------------------------------------------------------------


;---------------------------------------------------------------------
;-  Subroutine: draw_vertical_line
;-
;-  Draws a horizontal line from (r8,r7) to (r8,r9) using color in r6
;-
;-  Parameters:
;-   r8  = x-coordinate
;-   r7  = starting y-coordinate
;-   r9  = ending y-coordinate
;-   r6  = color used for line
;- 
;- Tweaked registers: r7,r9
;--------------------------------------------------------------------
draw_vertical_line:
         ADD    r9,0x01

draw_vert1:          
         CALL   draw_dot
         ADD    r7,0x01
         CMP    r7,R9
         BRNE   draw_vert1
         RET
;--------------------------------------------------------------------

;---------------------------------------------------------------------
;-  Subroutine: draw_background
;-
;-  Fills the 80x60 grid with one color using successive calls to 
;-  draw_horizontal_line subroutine. 
;- 
;-  Tweaked registers: r10,r7,r8,r9
;----------------------------------------------------------------------
draw_background: 
         MOV   r6,BG_COLOR              ; use default color
         MOV   r10,0x00                 ; r10 keeps track of rows
start:   MOV   r7,r10                   ; load current row count 
         MOV   r8,0x00                  ; restart x coordinates
         MOV   r9,0x4F 					; set to total number of columns
 
         CALL  draw_horizontal_line
         ADD   r10,0x01                 ; increment row count
         CMP   r10,0x3C                 ; see if more rows to draw
         BRNE  start                    ; branch to draw more rows
         RET
;---------------------------------------------------------------------
    
;---------------------------------------------------------------------
;- Subrountine: draw_dot
;- 
;- This subroutine draws a dot on the display the given coordinates: 
;- 
;- (X,Y) = (r8,r7)  with a color stored in r6  
;- 
;- Tweaked registers: r4,r5
;---------------------------------------------------------------------
draw_dot: 
           MOV   r4,r7        			; copy Y coordinate
           MOV   r5,r8         			; copy X coordinate

           AND   r5,0x7F       			; make sure top 1 bits cleared
           AND   r4,0x3F       			; make sure top 2 bits cleared
           LSR   r4             		; need to get the bottom bit of r4 into sA
           BRCS  dd_add80

dd_out:    OUT   r5,VGA_LADD   			; write bot 8 address bits to register
           OUT   r4,VGA_HADD   			; write top 5 address bits to register
           OUT   r6,VGA_COLOR  			; write color data to frame buffer
           RET           

dd_add80:  OR    r5,0x80       			; set bit if needed
           BRN   dd_out
; --------------------------------------------------------------------


;---------------------------------------------------------------------
;- Subrountine: check_color
;- 
;- This subroutine draws a dot on the display the given coordinates: 
;- 
;- (X,Y) = (r8,r7)  with a color stored in r6  
;- 
;- Tweaked registers: r4,r5
;---------------------------------------------------------------------
check_color: 
           MOV   r4,r7         			; copy Y coordinate
           MOV   r5,r8         			; copy X coordinate

           AND   r5,0x7F       			; make sure top 1 bits cleared
           AND   r4,0x3F       			; make sure top 2 bits cleared
           LSR   r4             		; need to get the bottom bit of r4 into sA
           BRCS  cc_add80

cc_out:    OUT   r5,VGA_LADD   			; write bot 8 address bits to register
           OUT   r4,VGA_HADD   			; write top 5 address bits to register
           IN    r31,COLOR_READ  		; store color of certain pixel
           RET           

cc_add80:  OR    r5,0x80       			; set bit if needed
           BRN   cc_out
; --------------------------------------------------------------------

;---------------------------------------------------------------------
;- Subrountine: check_color2
;- 
;- This subroutine draws a dot on the display the given coordinates: 
;- 
;- (X,Y) = (r11,r10)  with a color stored in r6  
;- 
;- Tweaked registers: r4,r5
;---------------------------------------------------------------------
check_color2: 
           MOV   r4,r10         		; copy Y coordinate
           MOV   r5,r11         		; copy X coordinate

           AND   r5,0x7F       			; make sure top 1 bits cleared
           AND   r4,0x3F       			; make sure top 2 bits cleared
           LSR   r4             		; need to get the bottom bit of r4 into sA
           BRCS  cc_add802

cc_out2:    OUT   r5,VGA_LADD   		; write bot 8 address bits to register
           OUT   r4,VGA_HADD   			; write top 5 address bits to register
           IN    r31,COLOR_READ  		; store color of certain pixel
           RET           

cc_add802:  OR    r5,0x80       		; set bit if needed
           BRN   cc_out2



;---------------------------------------------------------------------
;- DRAW_CURSOR_90 - draws the shooting cursor in its vertical position
;---------------------------------------------------------------------

DRAW_CURSOR_90:	 
		 MOV r7, 0x30
		 MOV R8, 0x19
		 MOV r9, 0x35
		 CALL draw_vertical_line
		 MOV r7, 0x31
		 MOV r8, 0x18
		 MOV r9, 0x1A
		 CALL draw_horizontal_line
		 MOV r7, 0x32
		 MOV r8, 0x17
		 CALL draw_dot
		 MOV r7, 0x32
		 MOV r8, 0x1B
		 CALL draw_dot
		 RET	

		 
;---------------------------------------------------------------------
;- DRAW_CURSOR_RIGHT - draws a shifted cursor 45 degrees to the right
;---------------------------------------------------------------------
DRAW_CURSOR_RIGHT:
		MOV r7, 0x35
		MOV r8, 0x19
		CALL draw_dot
		MOV r7, 0x34
		MOV r8, 0x1A
		CALL draw_dot
		MOV r7, 0x33
		MOV r8, 0x1B
		CALL draw_dot
		MOV r7, 0x32
		MOV r8, 0x1C
		CALL draw_dot
		MOV r7, 0x31
		MOV r8, 0x1D
		CALL draw_dot
		MOV r7, 0x31
		MOV r8, 0x1A
		MOV r9, 0x1B
		CALL draw_horizontal_line
		MOV r7, 0x33
		MOV r8, 0x1D
		MOV r9, 0x34
		CALL draw_vertical_line
		RET
		
;---------------------------------------------------------------------
;- DRAW_CURSOR_LEFT - draws a shifted cursor 45 degrees to the left
;---------------------------------------------------------------------		
DRAW_CURSOR_LEFT:
		MOV r7, 0x35
		MOV r8, 0x19
		CALL draw_dot
		MOV r7, 0x34
		MOV r8, 0x18
		CALL draw_dot
		MOV r7, 0x33
		MOV r8, 0x17
		CALL draw_dot
		MOV r7, 0x32
		MOV r8, 0x16
		CALL draw_dot
		MOV r7, 0x31
		MOV r8, 0x15
		CALL draw_dot
		MOV r7, 0x31
		MOV r8, 0x17
		MOV r9, 0x18
		CALL draw_horizontal_line
		MOV r7, 0x33
		MOV r8, 0x15
		MOV r9, 0x34
		CALL draw_vertical_line
		RET
		 

;---------------------------------------------------------------------
;- LEFT - checks to see if the cursor is in the left position
;---------------------------------------------------------------------		 
LEFT:
		CMP 	r0, 0x01				; check to see if in right position
		BREQ 	ER_RIGHT_DR_CENTER
		
		CMP 	r0, 0x00				; check to see if in center position
		BREQ 	ER_CENTER_DR_LEFT
		BRN 	return_to_main			; if already in left position, do nothing
		 
;---------------------------------------------------------------------
;- RIGHT - checks to see if the cursor is in the left position
;---------------------------------------------------------------------
RIGHT:
		CMP 	r0, 0xFF			; check to see if in left position
		BREQ 	ER_LEFT_DR_CENTER

		CMP 	r0, 0x00			; check to see if in center position
		BREQ 	ER_CENTER_DR_RIGHT
		BRN 	return_to_main		; if already in right position, do nothing

;-----------------------------------------------------------------------
;- ER_CENTER_DR_LEFT - Erases the center cursor and draws the left cursor
;-----------------------------------------------------------------------		
ER_CENTER_DR_LEFT:
		MOV r0, 0xFF				; reset position counter to be in right position
		MOV r6, 0x00				; color over previous centered cursor
		CALL DRAW_CURSOR_90
		
		MOV r6, 0xFF				; draw right cursor
		CALL DRAW_CURSOR_LEFT
		BRN	return_to_main			; always loop back to interrupt state
					
;-----------------------------------------------------------------------
;- ER_RIGHT_DR_CNETER - Erases the right cursor and draws the center cursor
;-----------------------------------------------------------------------
ER_RIGHT_DR_CENTER:
		MOV r0, 0x00				; reset position counter to be centered
		MOV r6, 0x00				; color over right cursor
		CALL DRAW_CURSOR_RIGHT		
		
		MOV r6, 0xFF
		CALL DRAW_CURSOR_90			; draw center cursor
		BRN	return_to_main			; always loop back to interrupt state
				
										
;-----------------------------------------------------------------------
;- ER_LEFT_DR_CENTER - Erases the left cursor and draws the center cursor
;-----------------------------------------------------------------------
ER_LEFT_DR_CENTER:
		MOV r0, 0x00				; reset position counter to be centered
		MOV r6, 0x00				; color over left cursor
		CALL DRAW_CURSOR_LEFT		
		
		MOV r6, 0xFF
		CALL DRAW_CURSOR_90			; draw center cursor
		BRN return_to_main			; always loop back to interrupt state
		
		
;-----------------------------------------------------------------------
;- ER_CENTER_DR_RIGHT - Erases the center cursor and draws the right cursor
;-----------------------------------------------------------------------

ER_CENTER_DR_RIGHT:
		 MOV r0, 0x01				; reset position counter to be in right position
		 MOV r6, 0x00				; color over previous cursor
		 CALL DRAW_CURSOR_90
		
		MOV r6, 0xFF				; draw right cursor
		CALL DRAW_CURSOR_RIGHT
		BRN	return_to_main			; always loop back to main

		
;---------------------------------------------------------------------
;- SHOOT - selects which angle to shoot at and gets the next random color to be shot
;---------------------------------------------------------------------
SHOOT:
		IN r3, RANDOM_COLOR			; generate new random number to be assigned for next shot
	    CMP r0, 0x00				; branch to different shooting loops based on cursor position
		BREQ SHOOT_CENTER
		CMP r0, 0xFF
		BREQ SHOOT_LEFT
		CMP r0, 0x01
		BREQ SHOOT_RIGHT
		BRN return_to_main			; failsafe, return back to main and halt movement

;---------------------------------------------------------------------
;- SHOOT_CENTER - shoots from the center position
;---------------------------------------------------------------------
SHOOT_CENTER:
		MOV r7, 0x2F
		MOV r8, 0x19				; sets inital bubble position
		MOV r6, r17					; with the randomly generated color			
		CALL draw_dot

	loop:
		MOV r10, r7					; store previous Y
		MOV r11, r8					; store previous x
		MOV r13, r7					; store previous Y again
		MOV r14, r8					; store previous  X again
		SUB r7, 0x01				; move up one y position
		SUB r10, 0x01				; move stored position up one for deletion checking
		CALL check_for_hit			; check to see if the bubble has hit a similar or a nonsimilar color
		CALL check_top_border		; checking if the top y position is the top border
		
		CALL FRAME_DELAY			; delay for moving dot
		MOV r6, 0x00				; set color to black
		MOV r7, r13					; restore previous Y
		CALL draw_dot				; color over previous bubble
		SUB r7, 0x01				; get new Y position
		MOV r6, r17					; set color to randomly generated color
		CALL draw_dot				; draw new bubble position
		brn loop					; loop until a border, non-similar color, or color w/ < 3 adjacents found
	
;---------------------------------------------------------------------
;- SHOOT_CENTER: check_top_border - checks if the bubble has reached border
;---------------------------------------------------------------------	
check_top_border:
		CALL check_color			; check next positions color
		CMP r31, 0xFF				; compare to white border
		BREQ draw_stopped_dot
		RET							; no border found, return 

draw_stopped_dot:
		POP r27						; maintain stack integrity
		MOV r10, 0x00				; clear previous positions
		MOV r11, 0x00
		brn return_to_main			; stop bubble movement
		
;---------------------------------------------------------------------
;- SHOOT_LEFT - fires a shot from the left cursor
;---------------------------------------------------------------------
SHOOT_LEFT:
		MOV r7, 0x30
		MOV r8, 0x14
		MOV r6, r17					; set color to randomly generated color
		CALL draw_dot				; draw initial bubble position
		
	left_loop:
		MOV r10, r7					; store previous Y
		MOV r11, r8			    	;store previous X
		MOV r13, r7					; store previous Y again
		MOV r14, r8					; store previous  X again
		SUB r7, 0x01				; move up one y position
		CALL check_top_border
		SUB r8, 0x01				; move up one x position
		CALL check_for_left_border	; checking if the left position is the border
		SUB r10, 0x01
		CALL check_for_hit			; checking if the next translated position is similar or non-similar color
		
		CALL FRAME_DELAY			; delay for moving dot
		MOV r6, 0x00				; set color to black
		MOV r7, r13					; restore previous Y
		MOV r8, r14					; restore previous X
		CALL draw_dot				; color over previous bubble
		SUB r7, 0x01				; get new Y position
		SUB r8, 0x01				; get new X position
		MOV r6, r17					; set color to randomly generated color
		CALL draw_dot				; draw new bubble position
		brn left_loop				; loop until a border, non-similar color, or color w/ < 3 adjacents found
	
;---------------------------------------------------------------------
;- SHOOT_LEFT: check_for_border - checks if the bubble has reached border
;---------------------------------------------------------------------	
check_for_left_border:
		CALL check_color			; check next positions color
		CMP r31, 0xFF				; compare to white border
		BREQ draw_translated_dot
		RET							; no border found, return 

draw_translated_dot:
		POP r27						; maintain stack integrity
		MOV r7, r10					; restore previous positions
		MOV r8, r11					
		MOV r10, 0x00				; clear previous positions
		MOV r11, 0x00
		brn right_loop            	; tranlsate to right

;---------------------------------------------------------------------
;- SHOOT_RIGHT - fires a shot from the right cursor
;---------------------------------------------------------------------
SHOOT_RIGHT:
		MOV r7, 0x30
		MOV r8, 0x1E
		MOV r6, r17					; set color to randomly generated color
		CALL draw_dot				; draw initial bubble position
		
	right_loop:
		MOV r10, r7					; store previous Y
		MOV r11, r8			    	; store previous X
		MOV r13, r7					; store previous Y again
		MOV r14, r8					; store previous  X again
		SUB r7, 0x01				; move up one y position
		CALL check_top_border		
		ADD r8, 0x01				; move up one x position
		CALL check_for_right_border	; checking for the top y position
		SUB	r10, 0x01
		CALL check_for_hit			; checking if the next translated position is similar or non-similar color
		
		CALL FRAME_DELAY			; delay for moving dot
		MOV r6, 0x00				; set color to black
		MOV r7, r13					; restore previous Y
		MOV r8, r14					; restore previous X
		CALL draw_dot				; color over previous bubble
		SUB r7, 0x01				; get new Y position
		ADD r8, 0x01				; get new X position
		MOV r6, r17					; set color to randomly generated color
		CALL draw_dot				; draw new bubble position
		brn right_loop				; loop until a border, non-similar color, or color w/ < 3 adjacents found
	
;---------------------------------------------------------------------
;- SHOOT_RIGHT: check_for_border
;---------------------------------------------------------------------	
check_for_right_border:
		CALL check_color			; check next positions color
		OUT r31, 0x81
		OUT r4, 0x82
		CMP r31, 0xFF				; compare to white border
		BREQ draw_translated_right_dot
		RET							; no border found, return 

draw_translated_right_dot:
		POP r27						; maintain stack integrity
		MOV r7, r10					; restore previous positions
		MOV r8, r11			
		MOV r10, 0x00				; reset the cursors previous position
		MOV r11, 0x00
		brn left_loop       		; tranlsate left


;---------------------------------------------------------------------
;- check_for_hit
;---------------------------------------------------------------------	
check_for_hit:
		
		MOV r27, 0x20				; set pseudo stack pointer to store similar bubble positions

  subsequent_hit:
		MOV r28, 0x00				; initalize counter for tracking adjacent positions
		
	one:	
		CALL check_color2			; check above color 
		ADD r28, 0x01				; increment the position counter
		CMP  r10, r13				; avoid checking previous bubble by comparing
		BREQ two					; current to previous X position
		CMP r31, r17				; check if the adjacent bubble is the same color
		BREQ store_position			; store similar colored bubble's position to stack

	two:
		ADD r11, 0x01 				; check diagonal right above
		CALL check_color2			; check diagonal color 
		ADD r28, 0x01				; increment the position counter
		CMP r31, r17				; check if the adjacent bubble is the same color
		BREQ store_position			; store similar colored bubble's position to stack
	
		
	three:	
		ADD r10, 0x01			
		CALL check_color2			; check right color
		ADD r28, 0x01				; increment the position counter
		CMP r31, r17				; check if the adjacent bubble is the same color
		BREQ store_position			; store similar colored bubble's position to stack

		
	four:
		ADD r10, 0x01				
		CALL check_color2			; check below right diag color 
		ADD r28, 0x01				; increment the position counter
		CMP r31, r17				; check if the adjacent bubble is the same color
		BREQ store_position			; store similar colored bubble's position to stack

	five:	
		SUB r11, 0x01				
		CALL check_color2			; check below color 
		ADD r28, 0x01				; increment the position counter
		CMP  r10, r13				; avoid checking previous bubble by comparing
		BREQ six					; current to previous X position
		CMP r31, r17				; check if the adjacent bubble is the same color
		BREQ store_position			; store similar colored bubble's position to stack
	
	six:
		SUB r11, 0x01				
		CALL check_color2			; check left down diagonal color 
		ADD r28, 0x01				; increment the position counter
		CMP r31, r17				; check if the adjacent bubble is the same color
		BREQ store_position

	seven:	
		SUB r10, 0x01				
		CALL check_color2			; check left color 
		ADD r28, 0x01				; increment the position counter
		CMP r31, r17				; check if the adjacent bubble is the same color
		BREQ store_position			; store similar colored bubble's position to stack

	eight:	
		SUB r10, 0x01				
		CALL check_color2			; check left up diagonal color 
		ADD r28, 0x01				; increment the position counter
		CMP r31, r17				; check if the adjacent bubble is the same color
		BREQ store_position			; store similar colored bubble's position to stack

	finish:
		CMP r25, 0x03				; check to see if at max number of bubbles to delete
		BREQ delete_bubbles			; if 3 bubbles found to delete, delete those bubbles
		CLC
		SUB r26, 0x01				; decrement secondary stack pointer 
		LD r10, (r26)				; load temporary values stored at SP
		ST r1, (r26)				; write over value with 0
		SUB r26, 0x01				; decrement secondary stack pointer 
		LD r11, (r26)				; load temporary values stored at SP
		ST r1, (r26)				; write over value with 0
		ADD r25, 0x01				; increment number of bubbles to delete
		BRN subsequent_hit			; loop to check the subsequent bubble's neighbor for more to delete

return_to_shoot:
		;reset color here
		RET							; return to where check hit was called

store_position:
		ADD r29, 0x01				; add to number of bubbles found

		ST r11, (r26)				; store position of found bubble to temp
		ADD r26,0x01				; stack pointer address for subsequent checking
		ST r10, (r26)
		ADD r26, 0x01
		
		ST r11, (r27)				; store position of found bubble to the list
		ADD r27, 0x01				; in the stack to be checked over when deleting
		ST r10, (r27)
		ADD r27, 0x01
		
		;ADD r25, 0x01
		
		CMP r28, 0x01				; check position counter to return back to
		BREQ two					; the next position to be checked to 
		CMP r28, 0x02				; ensure that all positions are checked
		BREQ three
		CMP r28, 0x03
		BREQ four
		CMP r28, 0x04
		BREQ five
		CMP r28, 0x05
		BREQ six
		CMP r28, 0x06
		BREQ seven
		CMP r28, 0x07
		BREQ eight
		CMP r28, 0x08
		BREQ finish
		
;---------------------------------------------------------------------
;- Delete bubbles 
;---------------------------------------------------------------------		
		
	delete_bubbles:
		CMP r29, 0x02				; check to make sure at least three bubbles found
		BRCS done					; branch if three not found
		
		MOV r6, 0x00				; set color to black
		MOV r7, r13					; restore previous positions (secondary)
		MOV r8, r14					
		CALL draw_dot				; color over bubble's current position

	loop_through_stack:
		SUB r27, 0x01				; decrement pointer
		LD r7, (r27)				; load Y pos. from stack
		ST r1, (r27)				; store zero to overwrite data
		SUB r27, 0x01				; decrement pointer
		LD r8, (r27)				; load X pos. from stack
		ST r1, (r27)				; store zero to overwrite data
		CALL draw_dot				; color over similar color bubble
		
		MOV r29, 0x00				; reset total found bubble counters
		MOV r25, 0x00
		CMP r27, 0x20 				; check for end of stack list bubbles to delete
		BREQ return_to_main			; finish and exit back to main
		
		BRN loop_through_stack		; otherwise, continue to move through stack
		
						
	  done:
		CMP r0, 0x00					; check position of shot to then check if the bubble
		BREQ check_center_for_nonblack	; has hit a bubble that is not its same color
		CMP r0, 0xFF					; *enables bubble stacking*
		BREQ check_left_for_nonblack
		CMP r0, 0x01
		BREQ check_right_for_nonblack
		brn return_to_shoot				; finish and exit back to shooting call
		
		
check_center_for_nonblack:
		CALL check_color			; call to see if black
		CMP	r31, 0x00				; check if black
		BREQ return_to_shoot		; return to continue checks and moving shot
		CMP r31, r17				; compare current shot color to next position's color
		BREQ subsequent_hit			; if same color, check for subsequent similar color bubbles
		BRNE return_to_main			; if just black, halt movement to stack
		
check_left_for_nonblack:
		CALL check_color			; call to see if black
		CMP	r31, 0x00				; check if black
		BREQ return_to_shoot		; return to continue checks and moving shot
		CMP r31, r17				; compare current shot color to next position's color
		BREQ subsequent_hit			; if same color, check for subsequent similar color bubbles
		BRNE return_to_main			; check this for position
		
check_right_for_nonblack:
		CALL check_color			; call to see if black
		CMP	r31, 0x00				; check if black
		BREQ return_to_shoot		; return to continue checks and moving shot
		CMP r31, r17				; compare current shot color to next position's color
		BREQ subsequent_hit			; if same color, check for subsequent similar color bubbles
		BRNE return_to_main			; if just black, halt movement to stack

		
;---------------------------------------------------------------------
;- SHOOT: FRAME_DELAY - delays the movement of the bubble
;---------------------------------------------------------------------	
FRAME_DELAY:
		MOV     R20, 0x0A    		; Start delay
OUTSIDE_FOR0: 	SUB     R20, 0x01

		MOV     R21, 0xAA
MIDDLE_FOR0:  	SUB     R21, 0x01
             
		MOV     R22, 0xAA
INSIDE_FOR0:  	SUB     R22, 0x01
		BRNE    INSIDE_FOR0
		OR      R21, 0x00
		BRNE    MIDDLE_FOR0
		OR      R20, 0x00
		BRNE    OUTSIDE_FOR0
		RET	
				
;---------------------------------------------------------------------
;- KEY_INT - ISR for the keyboard
;---------------------------------------------------------------------
KEY_INT:
		CLI
		IN r30, KEYBOARD			; read in keycode value
		CMP r30, 0x74        		; check if right cursor movement key pressed
		BREQ RIGHT
		CMP r30, 0x6B        		; check if left cursor movement key pressed 
		BREQ LEFT
		CMP	r30, 0x29				; check if shoot key pressed
		BREQ SHOOT
		RETIE
		
; --------------------------------------------------------------------


.ORG 0x3FF
BRN KEY_INT



