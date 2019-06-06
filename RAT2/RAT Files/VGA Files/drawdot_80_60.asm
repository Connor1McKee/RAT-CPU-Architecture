;---------------------------------------------------------------------
; An expanded "draw_dot" program that includes subrountines to draw
; vertical lines, horizontal lines, and a full background. 
; 
; As written, this programs does the following: 
;   1) draws a the background green (draws all the tiles)
;   2) draws a red dot
;   3) draws a red horizontal lines
;   4) draws a red vertical line
;
; Author: SHANE KENT
; Modifications: Brett Glidden, Paul Hummel
;---------------------------------------------------------------------

.CSEG
.ORG 0x10

.EQU VGA_HADD = 0x90
.EQU VGA_LADD = 0x91
.EQU VGA_COLOR = 0x92

.EQU BG_COLOR       = 0x03             ; Background:  green

;r6 is used for color
;r7 is used for Y
;r8 is used for X

;---------------------------------------------------------------------
init:	 SEI
         CALL   draw_background         ; draw using default color

         MOV    r7, 0x1E                ; generic Y coordinate
         MOV    r8, 0x28                ; generic X coordinate
         MOV    r6, 0xE0                ; color red
         CALL   draw_dot                ; draw red square 

         MOV    r8,0x01                 ; starting x coordinate
         MOV    r7,0x32                 ; start y coordinate
         MOV    r9,0x46                 ; ending x coordinate
         CALL   draw_horizontal_line

         MOV    r8,0x08                 ; starting x coordinate
         MOV    r7,0x04                 ; start y coordinate
         MOV    r9,0x37                 ; ending y coordinate
         CALL   draw_vertical_line
      

main:	AND R0, R0
	
		BRN    main                    ; continuous loop 
;--------------------------------------------------------------------



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
           MOV   r4,r7         ; copy Y coordinate
           MOV   r5,r8         ; copy X coordinate

           AND   r5,0x7F       ; make sure top 1 bits cleared
           AND   r4,0x3F       ; make sure top 2 bits cleared
           LSR   r4             ; need to get the bottom bit of r4 into sA
           BRCS  dd_add80

dd_out:    OUT   r5,VGA_LADD   ; write bot 8 address bits to register
           OUT   r4,VGA_HADD   ; write top 5 address bits to register
           OUT   r6,VGA_COLOR  ; write color data to frame buffer
           RET           

dd_add80:  OR    r5,0x80       ; set bit if needed
           BRN   dd_out
; --------------------------------------------------------------------


