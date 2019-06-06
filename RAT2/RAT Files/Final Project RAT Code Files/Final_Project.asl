

List FileKey 
----------------------------------------------------------------------
C1      C2      C3      C4    || C5
--------------------------------------------------------------
C1:  Address (decimal) of instruction in source file. 
C2:  Segment (code or data) and address (in code or data segment) 
       of inforation associated with current linte. Note that not all
       source lines will contain information in this field.  
C3:  Opcode bits (this field only appears for valid instructions.
C4:  Data field; lists data for labels and assorted directives. 
C5:  Raw line from source code.
----------------------------------------------------------------------


(0001)                            || 
(0002)                            || ;---------------------------------------------------------------------
(0003)                            || ;Bubble Blast
(0004)                            || 
(0005)                            || ;By Marty Lange and Connor McKee
(0006)                            || 
(0007)                            || ;-----------CODE NEEDDED:---------------------------------------------
(0008)                            || ;---1. Draw background
(0009)                            || ;---2. Draw borders
(0010)                            || ;---3. Draw preloaded bubbles (the level)
(0011)                            || ;---4. Draw random bubble to be fired (possible direction arrow)
(0012)                            || ;---5. Trajectory of the bubble and bouncing effect
(0013)                            || ;---6. Bubbles popping when 3 or more, check for adjacent colors
(0014)                            || ;---7. OPTIONAL: add extral levels, or random level generator and/or move down feature?
(0015)                            || ;---------------------------------------------------------------------
(0016)                            || 
(0017)                            || .CSEG
(0018)                       016  || .ORG 0x10
(0019)                            || 
(0020)                       144  || .EQU VGA_HADD = 0x90
(0021)                       145  || .EQU VGA_LADD = 0x91
(0022)                       146  || .EQU VGA_COLOR = 0x92
(0023)                       147  || .EQU COLOR_READ = 0x93
(0024)                       033  || .EQU RANDOM_COLOR = 0x21
(0025)                            || 
(0026)                       129  || .EQU SSEG_ID1 = 0x81
(0027)                       130  || .EQU SSEG_ID2 = 0x82
(0028)                            || 
(0029)                       068  || .EQU KEYBOARD = 0x44
(0030)                            || 
(0031)                       000  || .EQU BG_COLOR       = 0x00             ; Background:  black
(0032)                            || 
(0033)                            || ;r0 is used for comparing the cursor's position
(0034)                            || ;r1 is set to hold 0 no matter what
(0035)                            || ;r3 is used for holding a random number
(0036)                            || ;r2 can be used for something else it is currently being used for debugging
(0037)                            || ;r4 is used for storing the shifted Y value
(0038)                            || ;r5 is used for storing the shifted X value
(0039)                            || ;r6 is used for color
(0040)                            || ;r7 is used for Y
(0041)                            || ;r8 is used for X
(0042)                            || ;r9 is used for ending coordinates
(0043)                            || ;r10 is used for storing Y
(0044)                            || ;r11 is used for storing X
(0045)                            || ;r12 is used for storing ending value
(0046)                            || ;r13 is used for storing Y (checking for deletion)
(0047)                            || ;r14 is used for storing Y (checking for deletion)
(0048)                            || ;r17 is used to store the random color
(0049)                            || ;r25 is used for entire check counter 
(0050)                            || ;r26 is used for loading 
(0051)                            || ;r27 is used for delete pointer
(0052)                            || ;r28 is used for loop count
(0053)                            || ;r29 is used for color count
(0054)                            || ;r30 is used for storing the keyboard input
(0055)                            || ;r31 used for reading/storing color
(0056)                            || 
(0057)                            || 
(0058)                            || 
(0059)                            || ;---------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x08080  0x100  ||              BRN     0x10        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0060)  CS-0x010  0x1A000  0x010  || init:	 SEI
(0061)  CS-0x011  0x08BA9         ||          CALL   draw_background         ; draw using default color
(0062)                            || 
(0063)  CS-0x012  0x36704         ||          MOV    r7, 0x04                ; starting Y coordinate
(0064)  CS-0x013  0x36805         ||          MOV    r8, 0x05                ; starting X coordinate
(0065)  CS-0x014  0x36936         || 		 MOV    r9, 0x36                ; ending Y coordinate
(0066)  CS-0x015  0x366FF         || 		 MOV    r6, 0xFF                ; color white
(0067)  CS-0x016  0x08B79         ||          CALL   draw_vertical_line    	; draw left border  
(0068)                            || 
(0069)  CS-0x017  0x36704         ||          MOV    r7, 0x04                ; starting Y coordinate
(0070)  CS-0x018  0x3682D         ||          MOV    r8, 0x2D                ; starting X coordinate
(0071)  CS-0x019  0x36936         || 		 MOV    r9, 0x36                ; ending Y coordinate
(0072)  CS-0x01A  0x366FF         || 		 MOV    r6, 0xFF                ; color white
(0073)  CS-0x01B  0x08B79         ||          CALL   draw_vertical_line    	; draw right border  
(0074)                            || 		 
(0075)  CS-0x01C  0x36704         ||          MOV    r7, 0x04                ; starting Y coordinate
(0076)  CS-0x01D  0x36805         ||          MOV    r8, 0x05                ; starting X coordinate
(0077)  CS-0x01E  0x3692D         || 		 MOV    r9, 0x2D                ; ending X coordinate
(0078)  CS-0x01F  0x366FF         || 		 MOV    r6, 0xFF                ; color white
(0079)  CS-0x020  0x08B49         ||          CALL   draw_horizontal_line    ; draw top border 
(0080)                            || 	 
(0081)  CS-0x021  0x36736         || 		 MOV    r7, 0x36                ; starting Y coordinate
(0082)  CS-0x022  0x36805         ||          MOV    r8, 0x05                ; starting X coordinate
(0083)  CS-0x023  0x3692D         || 		 MOV    r9, 0x2D                ; ending X coordinate
(0084)  CS-0x024  0x366FF         || 		 MOV    r6, 0xFF                ; color white
(0085)  CS-0x025  0x08B49         ||          CALL   draw_horizontal_line    ; draw bot border
(0086)                            || 		 
(0087)  CS-0x026  0x08D19         || 		 CALL DRAW_CURSOR_90			; draw cursor initial position
(0088)                            || 
(0089)                            || ;----------------------------------------------------------------
(0090)                            || ;-------Game title-----------------------------------------------
(0091)                            || ;----------------------------------------------------------------		 
(0092)                            || 		 ;draw 1st B 
(0093)  CS-0x027  0x36704         || 		 MOV 	r7, 0x04				; starting Y coordinate
(0094)  CS-0x028  0x3682F         || 		 MOV	r8, 0x2F				; starting X coordinate
(0095)  CS-0x029  0x366FF         || 		 MOV	r6, 0xFF				; color : white (FOR NOW)
(0096)  CS-0x02A  0x08A29         || 		 CALL   draw_character_B
(0097)                            || 		 
(0098)                            || 		 ;draw U
(0099)  CS-0x02B  0x36704         || 		 MOV 	r7, 0x04				; starting Y coordinate
(0100)  CS-0x02C  0x36834         || 		 MOV	r8, 0x34				; starting X coordinate
(0101)  CS-0x02D  0x36909         || 		 MOV	r9, 0x09				; ending Y coordinate
(0102)  CS-0x02E  0x08B79         || 		 CALL	draw_vertical_line		; draw left U edge
(0103)  CS-0x02F  0x3670A         || 		 MOV	r7, 0x0A				; starting Y coordinate
(0104)  CS-0x030  0x36835         || 		 MOV	r8, 0x35				; starting X coordinate
(0105)  CS-0x031  0x36936         || 		 MOV 	r9, 0x36				; ending X coordinate
(0106)  CS-0x032  0x08B49         || 		 CALL 	draw_horizontal_line	; draw bot edge
(0107)  CS-0x033  0x36704         || 		 MOV	r7, 0x04				; starting Y coordinate
(0108)  CS-0x034  0x36837         || 		 MOV 	r8, 0x37				; starting X coordinate
(0109)  CS-0x035  0x36909         || 		 MOV	r9, 0x09				; ending Y coordinate
(0110)  CS-0x036  0x08B79         || 		 CALL	draw_vertical_line		; draw right U edge
(0111)                            || 		  
(0112)                            || 		 ;draw 2nd B
(0113)  CS-0x037  0x36704         || 		 MOV 	r7, 0x04				; staring Y coordinate
(0114)  CS-0x038  0x36839         || 		 MOV 	r8, 0x39				; starting X coordinate
(0115)  CS-0x039  0x08A29         || 		 CALL 	draw_character_B
(0116)                            || 		 
(0117)                            || 		 ;draw 3rd B
(0118)  CS-0x03A  0x36704         || 		 MOV 	r7, 0x04				; staring Y coordinate
(0119)  CS-0x03B  0x3683E         || 		 MOV 	r8, 0x3E				; starting X coordinate
(0120)  CS-0x03C  0x08A29         || 		 CALL 	draw_character_B
(0121)                            || 		 
(0122)                            || 		 ;draw L
(0123)  CS-0x03D  0x36704         || 		 MOV	r7, 0x04				; staring Y coordinate
(0124)  CS-0x03E  0x36843         || 		 MOV	r8, 0x43				; starting X coordinate
(0125)  CS-0x03F  0x089D1         || 		 CALL	draw_character_L		
(0126)                            || 		 
(0127)                            || 		 ;draw E
(0128)  CS-0x040  0x36705         || 		 MOV	r7, 0x05				; starting Y coordinate
(0129)  CS-0x041  0x36848         || 		 MOV	r8, 0x48				; starting X coordinate
(0130)  CS-0x042  0x36909         || 		 MOV 	r9, 0x09				; ending Y value
(0131)  CS-0x043  0x08B79         || 		 CALL 	draw_vertical_line		; draw E left edge
(0132)  CS-0x044  0x36704         || 		 MOV	r7, 0x04				; starting Y coordinate
(0133)  CS-0x045  0x36849         || 		 MOV 	r8, 0x49				; starting X coordinate
(0134)  CS-0x046  0x3694B         || 		 MOV	r9, 0x4B				; ending X value
(0135)  CS-0x047  0x08B49         || 		 CALL 	draw_horizontal_line	; draw top E edge
(0136)  CS-0x048  0x36707         || 		 MOV	r7, 0x07				; starting Y coordinate
(0137)  CS-0x049  0x36849         || 		 MOV 	r8, 0x49				; starting X coordinate
(0138)  CS-0x04A  0x08BF9         || 		 CALL 	draw_dot				; draw middle E dot
(0139)  CS-0x04B  0x3670A         || 		 MOV	r7, 0x0A				; starting Y coordinate
(0140)  CS-0x04C  0x36849         || 		 MOV	r8, 0x49				; starting X coordinate
(0141)  CS-0x04D  0x3694B         || 		 MOV 	r9, 0x4B				; ending X value
(0142)  CS-0x04E  0x08B49         || 		 CALL 	draw_horizontal_line	; draw bottom E edge
(0143)                            || 					
(0144)                            || 		 ;draw last B
(0145)  CS-0x04F  0x3670D         || 		 MOV 	r7, 0x0D				; starting Y coordinate
(0146)  CS-0x050  0x3682F         || 		 MOV 	r8, 0x2F				; starting X coordinate
(0147)  CS-0x051  0x08A29         || 		 CALL 	draw_character_B
(0148)                            || 		 
(0149)                            || 		 ;draw 2nd L
(0150)  CS-0x052  0x3670D         || 		 MOV 	r7, 0x0D				; starting Y coordinate
(0151)  CS-0x053  0x36834         || 		 MOV	r8, 0x34				; starting X coordinate
(0152)  CS-0x054  0x089D1         || 		 CALL 	draw_character_L
(0153)                            || 		 
(0154)                            || 		 ;draw A
(0155)  CS-0x055  0x3670D         || 		 MOV 	r7, 0x0D				; starting Y coordinate
(0156)  CS-0x056  0x3683A         || 		 MOV 	r8, 0x3A				; starting X coordinate
(0157)  CS-0x057  0x3693B         || 		 MOV	r9, 0x3B
(0158)  CS-0x058  0x08B49         || 		 CALL	draw_horizontal_line	; draw A top edge
(0159)  CS-0x059  0x3670E         || 		 MOV	r7, 0x0E				; starting Y coordinate
(0160)  CS-0x05A  0x36839         || 		 MOV	r8, 0x39				; starting X coordinate
(0161)  CS-0x05B  0x36913         || 		 MOV 	r9, 0x13
(0162)  CS-0x05C  0x08B79         || 		 CALL 	draw_vertical_line		; draw A left edge
(0163)  CS-0x05D  0x3670E         || 		 MOV	r7, 0x0E				; starting Y coordinate
(0164)  CS-0x05E  0x3683C         || 		 MOV	r8, 0x3C				; starting X coordinate
(0165)  CS-0x05F  0x36913         || 		 MOV 	r9, 0x13
(0166)  CS-0x060  0x08B79         || 		 CALL 	draw_vertical_line		; draw A right edge
(0167)  CS-0x061  0x36710         || 		 MOV	r7, 0x10				; starting Y coordinate
(0168)  CS-0x062  0x3683A         || 		 MOV	r8, 0x3A				; starting X coordinate
(0169)  CS-0x063  0x3693B         || 		 MOV 	r9, 0x3B
(0170)  CS-0x064  0x08B49         || 		 CALL 	draw_horizontal_line	; draw A 
(0171)                            || 		 
(0172)                            || 		 ;draw S
(0173)  CS-0x065  0x3670D         || 		 MOV	r7, 0x0D
(0174)  CS-0x066  0x3683F         || 		 MOV	r8, 0x3F
(0175)  CS-0x067  0x36941         || 		 MOV 	r9, 0x41
(0176)  CS-0x068  0x08B49         || 		 CALL 	draw_horizontal_line	; draw S top edge	 
(0177)  CS-0x069  0x3670E         || 		 MOV	r7, 0x0E
(0178)  CS-0x06A  0x3683E         || 		 MOV 	r8, 0x3E
(0179)  CS-0x06B  0x3690F         || 		 MOV	r9, 0x0F
(0180)  CS-0x06C  0x08B79         || 		 CALL 	draw_vertical_line		; draw S left edge 1
(0181)  CS-0x06D  0x36710         || 		 MOV	r7, 0x10
(0182)  CS-0x06E  0x3683F         || 		 MOV	r8, 0x3F
(0183)  CS-0x06F  0x36940         || 		 MOV	r9, 0x40
(0184)  CS-0x070  0x08B49         || 		 CALL 	draw_horizontal_line	; draw S mid edge
(0185)  CS-0x071  0x36711         || 		 MOV	r7, 0x11
(0186)  CS-0x072  0x36841         || 		 MOV	r8, 0x41
(0187)  CS-0x073  0x36912         || 		 MOV 	r9, 0x12
(0188)  CS-0x074  0x08B79         || 		 CALL 	draw_vertical_line		; draw S right edge
(0189)  CS-0x075  0x36713         || 		 MOV 	r7, 0x13
(0190)  CS-0x076  0x3683E         || 		 MOV	r8, 0x3E
(0191)  CS-0x077  0x36940         || 		 MOV	r9, 0x40
(0192)  CS-0x078  0x08B49         || 		 CALL 	draw_horizontal_line	; draw S bot edge
(0193)                            || 		 
(0194)                            || 		 ;draw T
(0195)  CS-0x079  0x3670E         || 		 MOV	r7, 0x0E
(0196)  CS-0x07A  0x36843         || 		 MOV 	r8, 0x43
(0197)  CS-0x07B  0x08BF9         || 		 CALL 	draw_dot				; draw T left edge
(0198)  CS-0x07C  0x3670D         || 		 MOV	r7, 0x0D
(0199)  CS-0x07D  0x36844         || 		 MOV	r8, 0x44
(0200)  CS-0x07E  0x36946         || 		 MOV 	r9, 0x46
(0201)  CS-0x07F  0x08B49         || 		 CALL 	draw_horizontal_line	; draw T top edge
(0202)  CS-0x080  0x3670E         || 		 MOV 	r7, 0x0E
(0203)  CS-0x081  0x36847         || 		 MOV	r8, 0x47
(0204)  CS-0x082  0x08BF9         || 		 CALL 	draw_dot				; draw T right edge
(0205)  CS-0x083  0x3670D         || 		 MOV	r7, 0x0D
(0206)  CS-0x084  0x36845         || 		 MOV	r8, 0x45
(0207)  CS-0x085  0x36913         || 		 MOV 	r9, 0x13
(0208)  CS-0x086  0x08B79         || 		 CALL 	draw_vertical_line		; draw T middle
(0209)                            || 		 
(0210)                            || 		 ;draw bottom line
(0211)  CS-0x087  0x36715         || 		 MOV 	r7, 0x15
(0212)  CS-0x088  0x3682F         || 		 MOV	r8, 0x2F
(0213)  CS-0x089  0x36933         || 		 MOV 	r9, 0x33
(0214)  CS-0x08A  0x366E0         || 		 MOV 	r6, 0xE0			; draw Red line
(0215)  CS-0x08B  0x08B49         || 		 CALL 	draw_horizontal_line
(0216)  CS-0x08C  0x36834         || 		 MOV	r8, 0x34
(0217)  CS-0x08D  0x36938         || 		 MOV 	r9, 0x38
(0218)  CS-0x08E  0x366D0         || 		 MOV 	r6, 0xD0				; draw Orange line
(0219)  CS-0x08F  0x08B49         || 		 CALL 	draw_horizontal_line
(0220)  CS-0x090  0x36839         || 		 MOV 	r8, 0x39
(0221)  CS-0x091  0x3693D         || 		 MOV 	r9, 0x3D
(0222)  CS-0x092  0x366D8         || 		 MOV 	r6, 0xD8				
(0223)  CS-0x093  0x08B49         || 		 CALL 	draw_horizontal_line	; draw Yellow line
(0224)  CS-0x094  0x3683E         || 		 MOV 	r8, 0x3E
(0225)  CS-0x095  0x36942         || 		 MOV 	r9, 0x42
(0226)  CS-0x096  0x3661C         || 		 MOV	r6, 0x1C
(0227)  CS-0x097  0x08B49         || 		 CALL 	draw_horizontal_line	; draw Green line
(0228)  CS-0x098  0x36843         || 		 MOV 	r8, 0x43
(0229)  CS-0x099  0x36947         || 		 MOV 	r9, 0x47
(0230)  CS-0x09A  0x36603         || 		 MOV 	r6, 0x03
(0231)  CS-0x09B  0x08B49         || 		 CALL 	draw_horizontal_line	; draw Blue line
(0232)  CS-0x09C  0x36848         || 		 MOV 	r8, 0x48
(0233)  CS-0x09D  0x3694C         || 		 MOV 	r9, 0x4C
(0234)  CS-0x09E  0x36687         || 		 MOV 	r6, 0x87
(0235)  CS-0x09F  0x08B49         || 		 CALL 	draw_horizontal_line	; draw Purple line
(0236)                            || ;---------------------------------------------------------	
(0237)                            || ;-------------- Draw Level--------------------------------
(0238)                            || ;--------------------------------------------------------
(0239)  CS-0x0A0  0x366D8         || 		MOV  r6, 0xD8		; draw yellows
(0240)                            || 		 
(0241)  CS-0x0A1  0x36813         || 		 MOV  r8, 0x13
(0242)  CS-0x0A2  0x36708         || 		 MOV  r7, 0x08
(0243)  CS-0x0A3  0x08BF9         || 		 CALL draw_dot
(0244)                            || 		 
(0245)  CS-0x0A4  0x36814         || 		 MOV  r8, 0x14
(0246)  CS-0x0A5  0x36709         || 		 MOV  r7, 0x09
(0247)  CS-0x0A6  0x08BF9         || 		 CALL draw_dot
(0248)                            || 		 
(0249)  CS-0x0A7  0x36815         || 		 MOV  r8, 0x15
(0250)  CS-0x0A8  0x3670A         || 		 MOV  r7, 0x0A
(0251)  CS-0x0A9  0x08BF9         || 		 CALL draw_dot
(0252)                            || 		 
(0253)  CS-0x0AA  0x36813         || 		 MOV  r8, 0x13
(0254)  CS-0x0AB  0x3670A         || 		 MOV  r7, 0x0A
(0255)  CS-0x0AC  0x08BF9         || 		 CALL draw_dot
(0256)                            || 		 
(0257)  CS-0x0AD  0x366D0         || 		 MOV r6, 0xD0		; draw oranges
(0258)                            || 		 
(0259)  CS-0x0AE  0x36816         || 		 MOV  r8, 0x16
(0260)  CS-0x0AF  0x36705         || 		 MOV  r7, 0x05
(0261)  CS-0x0B0  0x08BF9         || 		 CALL draw_dot
(0262)                            || 		 
(0263)  CS-0x0B1  0x36815         || 		 MOV  r8, 0x15
(0264)  CS-0x0B2  0x36706         || 		 MOV  r7, 0x06
(0265)  CS-0x0B3  0x08BF9         || 		 CALL draw_dot
(0266)                            || 		 
(0267)  CS-0x0B4  0x36814         || 		 MOV  r8, 0x14
(0268)  CS-0x0B5  0x36706         || 		 MOV  r7, 0x06
(0269)  CS-0x0B6  0x08BF9         || 		 CALL draw_dot
(0270)                            || 		 
(0271)  CS-0x0B7  0x36814         || 		 MOV  r8, 0x14
(0272)  CS-0x0B8  0x36707         || 		 MOV  r7, 0x07
(0273)  CS-0x0B9  0x08BF9         || 		 CALL draw_dot
(0274)                            || 		 
(0275)  CS-0x0BA  0x3681B         || 		 MOV  r8, 0x1B
(0276)  CS-0x0BB  0x36706         || 		 MOV  r7, 0x06
(0277)  CS-0x0BC  0x08BF9         || 		 CALL draw_dot
(0278)                            || 		 
(0279)  CS-0x0BD  0x3681B         || 		 MOV  r8, 0x1B
(0280)  CS-0x0BE  0x36705         || 		 MOV  r7, 0x05
(0281)  CS-0x0BF  0x08BF9         || 		 CALL draw_dot
(0282)                            || 		 
(0283)  CS-0x0C0  0x3681E         || 		 MOV  r8, 0x1E
(0284)  CS-0x0C1  0x36705         || 		 MOV  r7, 0x05
(0285)  CS-0x0C2  0x08BF9         || 		 CALL draw_dot
(0286)                            || 		 
(0287)  CS-0x0C3  0x3681F         || 		 MOV  r8, 0x1F
(0288)  CS-0x0C4  0x36706         || 		 MOV  r7, 0x06
(0289)  CS-0x0C5  0x08BF9         || 		 CALL draw_dot
(0290)                            || 		 
(0291)  CS-0x0C6  0x36687         || 		 MOV r6, 0x87		; draw purples
(0292)                            || 		 
(0293)  CS-0x0C7  0x36812         || 		 MOV  r8, 0x12
(0294)  CS-0x0C8  0x36705         || 		 MOV  r7, 0x05
(0295)  CS-0x0C9  0x08BF9         || 		 CALL draw_dot
(0296)                            || 		 
(0297)  CS-0x0CA  0x36812         || 		 MOV  r8, 0x12
(0298)  CS-0x0CB  0x36706         || 		 MOV  r7, 0x06
(0299)  CS-0x0CC  0x08BF9         || 		 CALL draw_dot
(0300)                            || 		 
(0301)  CS-0x0CD  0x36811         || 		 MOV  r8, 0x11
(0302)  CS-0x0CE  0x36707         || 		 MOV  r7, 0x07
(0303)  CS-0x0CF  0x08BF9         || 		 CALL draw_dot
(0304)                            || 		 
(0305)  CS-0x0D0  0x36818         || 		 MOV  r8, 0x18
(0306)  CS-0x0D1  0x36705         || 		 MOV  r7, 0x05
(0307)  CS-0x0D2  0x08BF9         || 		 CALL draw_dot
(0308)                            || 		 
(0309)  CS-0x0D3  0x36819         || 		 MOV  r8, 0x19
(0310)  CS-0x0D4  0x36706         || 		 MOV  r7, 0x06
(0311)  CS-0x0D5  0x08BF9         || 		 CALL draw_dot
(0312)                            || 		 
(0313)  CS-0x0D6  0x3681A         || 		 MOV  r8, 0x1A
(0314)  CS-0x0D7  0x36707         || 		 MOV  r7, 0x07
(0315)  CS-0x0D8  0x08BF9         || 		 CALL draw_dot
(0316)                            || 		 
(0317)  CS-0x0D9  0x36603         || 		 MOV r6, 0x03		; draw blues
(0318)                            || 		 
(0319)  CS-0x0DA  0x3681E         || 		 MOV  r8, 0x1E
(0320)  CS-0x0DB  0x36707         || 		 MOV  r7, 0x07
(0321)  CS-0x0DC  0x08BF9         || 		 CALL draw_dot
(0322)                            || 		 
(0323)  CS-0x0DD  0x3681F         || 		 MOV  r8, 0x1F
(0324)  CS-0x0DE  0x36708         || 		 MOV  r7, 0x08
(0325)  CS-0x0DF  0x08BF9         || 		 CALL draw_dot
(0326)                            || 		 
(0327)  CS-0x0E0  0x3681E         || 		 MOV  r8, 0x1E
(0328)  CS-0x0E1  0x36709         || 		 MOV  r7, 0x09
(0329)  CS-0x0E2  0x08BF9         || 		 CALL draw_dot
(0330)                            || 		 
(0331)  CS-0x0E3  0x3681D         || 		 MOV  r8, 0x1D
(0332)  CS-0x0E4  0x3670A         || 		 MOV  r7, 0x0A
(0333)  CS-0x0E5  0x08BF9         || 		 CALL draw_dot
(0334)                            || 		 
(0335)  CS-0x0E6  0x3661C         || 		 MOV r6, 0x1C		; draw greens
(0336)                            || 		 
(0337)  CS-0x0E7  0x36818         || 		 MOV  r8, 0x18
(0338)  CS-0x0E8  0x36707         || 		 MOV  r7, 0x07
(0339)  CS-0x0E9  0x08BF9         || 		 CALL draw_dot
(0340)                            || 		 
(0341)  CS-0x0EA  0x36817         || 		 MOV  r8, 0x17
(0342)  CS-0x0EB  0x36708         || 		 MOV  r7, 0x08
(0343)  CS-0x0EC  0x08BF9         || 		 CALL draw_dot
(0344)                            || 		 
(0345)  CS-0x0ED  0x36816         || 		 MOV  r8, 0x16
(0346)  CS-0x0EE  0x36709         || 		 MOV  r7, 0x09
(0347)  CS-0x0EF  0x08BF9         || 		 CALL draw_dot
(0348)                            || 		 
(0349)  CS-0x0F0  0x366E0         || 		 MOV r6, 0xE0		; draw reds
(0350)                            || 		 
(0351)  CS-0x0F1  0x36819         || 		 MOV  r8, 0x19
(0352)  CS-0x0F2  0x36708         || 		 MOV  r7, 0x08
(0353)  CS-0x0F3  0x08BF9         || 		 CALL draw_dot
(0354)                            || 		 
(0355)  CS-0x0F4  0x3681A         || 		 MOV  r8, 0x1A
(0356)  CS-0x0F5  0x36709         || 		 MOV  r7, 0x09
(0357)  CS-0x0F6  0x08BF9         || 		 CALL draw_dot
(0358)                            || 		 
(0359)  CS-0x0F7  0x3681B         || 		 MOV  r8, 0x1B
(0360)  CS-0x0F8  0x3670A         || 		 MOV  r7, 0x0A
(0361)  CS-0x0F9  0x08BF9         || 		 CALL draw_dot
(0362)                            || ;------------------------------------------------------
(0363)                            || 	
(0364)                            || 		;initialize all registers to 0 to start game
(0365)  CS-0x0FA  0x36400         || 		MOV r4, 0x00
(0366)  CS-0x0FB  0x36500         || 		MOV r5, 0x00
(0367)  CS-0x0FC  0x36700         || 		MOV r7, 0x00
(0368)  CS-0x0FD  0x36800         || 		MOV r8, 0x00
(0369)  CS-0x0FE  0x36900         || 		MOV r9, 0x00
(0370)  CS-0x0FF  0x36A00         || 		MOV r10, 0x00
(0371)  CS-0x100  0x36B00         || 		MOV r11, 0x00
(0372)  CS-0x101  0x36C00         || 		MOV r12, 0x00
(0373)  CS-0x102  0x37E00         || 		MOV r30, 0x00
(0374)  CS-0x103  0x37F00         || 		MOV r31, 0x00
(0375)  CS-0x104  0x36000         || 		MOV r0, 0x00
(0376)  CS-0x105  0x36100         || 		MOV r1, 0x00
(0377)                            || 		 
(0378)                            || 		 
(0379)                            || 			  	  
(0380)                            || 
(0381)                            || 
(0382)                            || 		;CMP r4, 0x74        	;check if right cursor movement key pressed
(0383)                            || 		;BREQ RIGHT
(0384)                            || 		;CMP r4, 0x6B        	;check if left cursor movement key pressed 
(0385)                            || 		;BREQ LEFT
(0386)                            || 		;CMP	r4, 0x29			;check if shoot key pressed
(0387)                            || 		;BREQ SHOOT
(0388)                            || 		;cmp to check for shoot from r30
(0389)                            || 		;if shot from r30
(0390)                            || 		;CALL choose color
(0391)                            || 		;update the register and draw in position
(0392)  CS-0x106  0x00000         || 		AND r0, r0
(0393)                            || 		
(0394)                            || 		
(0395)                     0x107  || 	return_to_main:
(0396)                            || 		;CMP r30, 0x29
(0397)                            || 		;BREQ choose_color
(0398)  CS-0x107  0x08851         || 		CALL choose_color
(0399)                            || 		;MOV r7, 0x2F
(0400)                            || 		;MOV r8, 0x19
(0401)                            || 		;MOV r6, r17					; set color to randomly generated color
(0402)                            || 		;CALL draw_dot
(0403)                     0x108  || 	main:
(0404)  CS-0x108  0x1A000         || 		SEI
(0405)  CS-0x109  0x08840         || 		BRN    main                    ; continuous loop 
(0406)                            || 
(0407)                            || ;--------------------------------------------------------------------		
(0408)                            || ;---choose_color-----------------------------------------------------
(0409)                            || ;--------------------------------------------------------------------
(0410)                     0x10A  || choose_color:
(0411)                            || 		;IN r3, RANDOM_COLOR
(0412)  CS-0x10A  0x3032A         || 		CMP r3, 0x2A
(0413)  CS-0x10B  0x0A8B0         || 		BRCS SET_GREEN
(0414)  CS-0x10C  0x30354         || 		CMP r3, 0x54
(0415)  CS-0x10D  0x0A8E0         || 		BRCS SET_PURPLE
(0416)  CS-0x10E  0x3037E         || 		CMP r3, 0x7E
(0417)  CS-0x10F  0x0A910         || 		BRCS SET_BLUE
(0418)  CS-0x110  0x303A8         || 		CMP r3, 0xA8
(0419)  CS-0x111  0x0A940         || 		BRCS SET_RED
(0420)  CS-0x112  0x303D2         || 		CMP r3, 0xD2
(0421)  CS-0x113  0x0A970         || 		BRCS SET_ORANGE
(0422)  CS-0x114  0x303FF         || 		CMP r3, 0xFF
(0423)  CS-0x115  0x0A9A0         || 		BRCS SET_YELLOW
(0424)                            || 	
(0425)                     0x116  || 	SET_GREEN:
(0426)  CS-0x116  0x3711C         || 		MOV r17, 0x1C
(0427)  CS-0x117  0x3661C         || 		MOV r6, 0x1C
(0428)  CS-0x118  0x36819         || 		MOV r8, 0x19
(0429)  CS-0x119  0x36739         || 		MOV r7, 0x39
(0430)  CS-0x11A  0x08BF9         || 		CALL draw_dot
(0431)  CS-0x11B  0x18002         || 		RET
(0432)                            || 	
(0433)                     0x11C  || 	SET_PURPLE:
(0434)  CS-0x11C  0x37187         || 		MOV r17, 0x87
(0435)  CS-0x11D  0x36687         || 		MOV r6, 0x87
(0436)  CS-0x11E  0x36819         || 		MOV r8, 0x19
(0437)  CS-0x11F  0x36739         || 		MOV r7, 0x39
(0438)  CS-0x120  0x08BF9         || 		CALL draw_dot
(0439)  CS-0x121  0x18002         || 		RET
(0440)                            || 	
(0441)                     0x122  || 	SET_BLUE:
(0442)  CS-0x122  0x37103         || 		MOV r17, 0x03
(0443)  CS-0x123  0x36603         || 		MOV r6, 0x03
(0444)  CS-0x124  0x36819         || 		MOV r8, 0x19
(0445)  CS-0x125  0x36739         || 		MOV r7, 0x39
(0446)  CS-0x126  0x08BF9         || 		CALL draw_dot
(0447)  CS-0x127  0x18002         || 		RET
(0448)                            || 	
(0449)                     0x128  || 	SET_RED:
(0450)  CS-0x128  0x371E0         || 		MOV r17, 0xE0
(0451)  CS-0x129  0x366E0         || 		MOV r6, 0xE0
(0452)  CS-0x12A  0x36819         || 		MOV r8, 0x19
(0453)  CS-0x12B  0x36739         || 		MOV r7, 0x39
(0454)  CS-0x12C  0x08BF9         || 		CALL draw_dot
(0455)  CS-0x12D  0x18002         || 		RET
(0456)                            || 		
(0457)                     0x12E  || 	SET_ORANGE:
(0458)  CS-0x12E  0x371D0         || 		MOV r17, 0xD0
(0459)  CS-0x12F  0x366D0         || 		MOV r6, 0xD0
(0460)  CS-0x130  0x36819         || 		MOV r8, 0x19
(0461)  CS-0x131  0x36739         || 		MOV r7, 0x39
(0462)  CS-0x132  0x08BF9         || 		CALL draw_dot
(0463)  CS-0x133  0x18002         || 		RET
(0464)                            || 		
(0465)                     0x134  || 	SET_YELLOW:
(0466)  CS-0x134  0x371D8         || 		MOV r17, 0xD8
(0467)  CS-0x135  0x366D8         || 		MOV r6, 0xD8
(0468)  CS-0x136  0x36819         || 		MOV r8, 0x19
(0469)  CS-0x137  0x36739         || 		MOV r7, 0x39
(0470)  CS-0x138  0x08BF9         || 		CALL draw_dot
(0471)  CS-0x139  0x18002         || 		RET
(0472)                            || ;---------------------------------------------------------------------
(0473)                            || ;-  Subroutine: draw_character_L
(0474)                            || ;-
(0475)                            || ;-  Draws the character L using (r8,r7) as the top left corner
(0476)                            || ;-
(0477)                            || ;-  Parameters:
(0478)                            || ;-   r8  = x-coordinate
(0479)                            || ;-   r7  = starting y-coordinate
(0480)                            || ;-   r9  = ending coordinate
(0481)                            || ;-   r6  = color used for line
(0482)                            || ;- 
(0483)                            || ;- Tweaked registers: r7, r8, r9, r11
(0484)                            || ;--------------------------------------------------------------------
(0485)                     0x13A  || draw_character_L:
(0486)  CS-0x13A  0x04939         || 			MOV 	r9, r7					; set ending Y coordinate
(0487)  CS-0x13B  0x28905         || 			ADD		r9, 0x05				; modify ending Y coordinate
(0488)  CS-0x13C  0x04B39         || 			MOV		r11, r7					; store Y value
(0489)  CS-0x13D  0x08B79         || 			CALL 	draw_vertical_line		; draw left L edge
(0490)                            || 			
(0491)  CS-0x13E  0x04759         || 			MOV		r7, r11					; load previous Y value
(0492)  CS-0x13F  0x28801         || 			ADD 	r8, 0x01				; modify starting X coordinate
(0493)  CS-0x140  0x28706         || 			ADD 	r7, 0x06				; modify starting Y coordinate
(0494)  CS-0x141  0x04941         || 			MOV 	r9, r8					; set ending X value
(0495)  CS-0x142  0x28902         || 			ADD 	r9, 0x02				; modify ending X value
(0496)  CS-0x143  0x08B49         || 			CALL	draw_horizontal_line	; draw bottom L edge
(0497)                            || 			
(0498)  CS-0x144  0x18002         || 			RET
(0499)                            || 		
(0500)                            || ;--------------------------------------------------------------------
(0501)                            || 
(0502)                            || ;---------------------------------------------------------------------
(0503)                            || ;-  Subroutine: draw_character_B
(0504)                            || ;-
(0505)                            || ;-  Draws the character B from (r8,r7) to (r8,r9) using color in r6
(0506)                            || ;-
(0507)                            || ;-  Parameters:
(0508)                            || ;-   r8  = x-coordinate
(0509)                            || ;-   r7  = starting y-coordinate
(0510)                            || ;-   r9  = ending y-coordinate
(0511)                            || ;-   r6  = color used for line
(0512)                            || ;- 
(0513)                            || ;- Tweaked registers: r7,r9, r8, r10, r12
(0514)                            || ;--------------------------------------------------------------------
(0515)                     0x145  || draw_character_B:
(0516)  CS-0x145  0x04939         || 		MOV		r9, r7					; set ending Y coordinate
(0517)  CS-0x146  0x28906         || 		ADD 	r9, 0x06				; modify ending Y coordinate
(0518)  CS-0x147  0x04B39         || 		MOV		r11, r7					; store Y value
(0519)  CS-0x148  0x04C49         || 		MOV 	r12, r9					; store ending value
(0520)  CS-0x149  0x08B79         || 		CALL 	draw_vertical_line		; draw left B edge
(0521)                            || 		
(0522)  CS-0x14A  0x04759         || 		MOV 	r7, r11					; load previous Y value
(0523)  CS-0x14B  0x04961         || 		MOV		r9, r12					; load previous ending value
(0524)  CS-0x14C  0x28801         || 		ADD		r8, 0x01				; modify starting X coordinate
(0525)  CS-0x14D  0x04941         || 		MOV		r9, r8					; set ending X coordinate
(0526)  CS-0x14E  0x28901         || 		ADD 	r9, 0x01				; modify ending X coordinate
(0527)  CS-0x14F  0x04C49         || 		MOV 	r12, r9					; store previous ending value
(0528)  CS-0x150  0x04A41         || 		MOV		r10, r8					; store previous X coordinate
(0529)  CS-0x151  0x08B49         || 		CALL	draw_horizontal_line	; draw top B edge
(0530)                            || 		
(0531)  CS-0x152  0x04961         || 		MOV 	r9, r12					; load previous ending value
(0532)  CS-0x153  0x04851         || 		MOV		r8, r10					; load previous X coordinate
(0533)  CS-0x154  0x28703         || 		ADD		r7, 0x03				; modify Y coordinate
(0534)  CS-0x155  0x08B49         || 		CALL	draw_horizontal_line	; draw mid B edge
(0535)                            || 		
(0536)  CS-0x156  0x04961         || 		MOV 	r9, r12					; load previous ending value
(0537)  CS-0x157  0x04851         || 		MOV		r8, r10					; load previous X coordinate
(0538)  CS-0x158  0x28703         || 		ADD 	r7, 0x03				; modify Y coordinate
(0539)  CS-0x159  0x08B49         || 		CALL	draw_horizontal_line	; draw bot B edge
(0540)                            || 		
(0541)  CS-0x15A  0x04961         || 		MOV 	r9, r12					; load previous ending value
(0542)  CS-0x15B  0x04851         || 		MOV		r8, r10					; load previous X coordinate
(0543)  CS-0x15C  0x2C705         || 		SUB		r7, 0x05				; modify Y coordinate
(0544)  CS-0x15D  0x28802         || 		ADD 	r8, 0x02				; modify X coordinate
(0545)  CS-0x15E  0x04939         || 		MOV 	r9, r7					; set init ending Y coordinate
(0546)  CS-0x15F  0x28901         || 		ADD		r9, 0x01				; modify ending Y coordinate
(0547)  CS-0x160  0x04B39         || 		MOV		r11, r7					; store Y value
(0548)  CS-0x161  0x04C49         || 		MOV 	r12, r9					; store ending value
(0549)  CS-0x162  0x08B79         || 		CALL	draw_vertical_line		; draw top-right B edge
(0550)                            || 		
(0551)  CS-0x163  0x04759         || 		MOV 	r7, r11					; load previous Y value
(0552)  CS-0x164  0x04961         || 		MOV		r9, r12					; load previous ending value
(0553)  CS-0x165  0x28703         || 		ADD		r7, 0x03				; modify starting Y coordinate
(0554)  CS-0x166  0x28903         || 		ADD		r9, 0x03				; modify ending Y coordinate
(0555)  CS-0x167  0x08B79         || 		CALL	draw_vertical_line		; draw bot-right B edge
(0556)                            || 		
(0557)  CS-0x168  0x18002         || 		RET								; END SUBROUTINE
(0558)                            || 	
(0559)                            || 				
(0560)                            || ;--------------------------------------------------------------------
(0561)                            || ;-  Subroutine: draw_horizontal_line
(0562)                            || ;-
(0563)                            || ;-  Draws a horizontal line from (r8,r7) to (r9,r7) using color in r6
(0564)                            || ;-
(0565)                            || ;-  Parameters:
(0566)                            || ;-   r8  = starting x-coordinate
(0567)                            || ;-   r7  = y-coordinate
(0568)                            || ;-   r9  = ending x-coordinate
(0569)                            || ;-   r6  = color used for line
(0570)                            || ;- 
(0571)                            || ;- Tweaked registers: r8,r9
(0572)                            || ;--------------------------------------------------------------------
(0573)                     0x169  || draw_horizontal_line:
(0574)  CS-0x169  0x28901         ||         ADD    r9,0x01          ; go from r8 to r15 inclusive
(0575)                            || 
(0576)                     0x16A  || draw_horiz1:
(0577)  CS-0x16A  0x08BF9         ||         CALL   draw_dot         ; 
(0578)  CS-0x16B  0x28801         ||         ADD    r8,0x01
(0579)  CS-0x16C  0x04848         ||         CMP    r8,r9
(0580)  CS-0x16D  0x08B53         ||         BRNE   draw_horiz1
(0581)  CS-0x16E  0x18002         ||         RET
(0582)                            || ;--------------------------------------------------------------------
(0583)                            || 
(0584)                            || 
(0585)                            || ;---------------------------------------------------------------------
(0586)                            || ;-  Subroutine: draw_vertical_line
(0587)                            || ;-
(0588)                            || ;-  Draws a horizontal line from (r8,r7) to (r8,r9) using color in r6
(0589)                            || ;-
(0590)                            || ;-  Parameters:
(0591)                            || ;-   r8  = x-coordinate
(0592)                            || ;-   r7  = starting y-coordinate
(0593)                            || ;-   r9  = ending y-coordinate
(0594)                            || ;-   r6  = color used for line
(0595)                            || ;- 
(0596)                            || ;- Tweaked registers: r7,r9
(0597)                            || ;--------------------------------------------------------------------
(0598)                     0x16F  || draw_vertical_line:
(0599)  CS-0x16F  0x28901         ||          ADD    r9,0x01
(0600)                            || 
(0601)                     0x170  || draw_vert1:          
(0602)  CS-0x170  0x08BF9         ||          CALL   draw_dot
(0603)  CS-0x171  0x28701         ||          ADD    r7,0x01
(0604)  CS-0x172  0x04748         ||          CMP    r7,R9
(0605)  CS-0x173  0x08B83         ||          BRNE   draw_vert1
(0606)  CS-0x174  0x18002         ||          RET
(0607)                            || ;--------------------------------------------------------------------
(0608)                            || 
(0609)                            || ;---------------------------------------------------------------------
(0610)                            || ;-  Subroutine: draw_background
(0611)                            || ;-
(0612)                            || ;-  Fills the 80x60 grid with one color using successive calls to 
(0613)                            || ;-  draw_horizontal_line subroutine. 
(0614)                            || ;- 
(0615)                            || ;-  Tweaked registers: r10,r7,r8,r9
(0616)                            || ;----------------------------------------------------------------------
(0617)                     0x175  || draw_background: 
(0618)  CS-0x175  0x36600         ||          MOV   r6,BG_COLOR              ; use default color
(0619)  CS-0x176  0x36A00         ||          MOV   r10,0x00                 ; r10 keeps track of rows
(0620)  CS-0x177  0x04751  0x177  || start:   MOV   r7,r10                   ; load current row count 
(0621)  CS-0x178  0x36800         ||          MOV   r8,0x00                  ; restart x coordinates
(0622)  CS-0x179  0x3694F         ||          MOV   r9,0x4F 					; set to total number of columns
(0623)                            ||  
(0624)  CS-0x17A  0x08B49         ||          CALL  draw_horizontal_line
(0625)  CS-0x17B  0x28A01         ||          ADD   r10,0x01                 ; increment row count
(0626)  CS-0x17C  0x30A3C         ||          CMP   r10,0x3C                 ; see if more rows to draw
(0627)  CS-0x17D  0x08BBB         ||          BRNE  start                    ; branch to draw more rows
(0628)  CS-0x17E  0x18002         ||          RET
(0629)                            || ;---------------------------------------------------------------------
(0630)                            ||     
(0631)                            || ;---------------------------------------------------------------------
(0632)                            || ;- Subrountine: draw_dot
(0633)                            || ;- 
(0634)                            || ;- This subroutine draws a dot on the display the given coordinates: 
(0635)                            || ;- 
(0636)                            || ;- (X,Y) = (r8,r7)  with a color stored in r6  
(0637)                            || ;- 
(0638)                            || ;- Tweaked registers: r4,r5
(0639)                            || ;---------------------------------------------------------------------
(0640)                     0x17F  || draw_dot: 
(0641)  CS-0x17F  0x04439         ||            MOV   r4,r7        			; copy Y coordinate
(0642)  CS-0x180  0x04541         ||            MOV   r5,r8         			; copy X coordinate
(0643)                            || 
(0644)  CS-0x181  0x2057F         ||            AND   r5,0x7F       			; make sure top 1 bits cleared
(0645)  CS-0x182  0x2043F         ||            AND   r4,0x3F       			; make sure top 2 bits cleared
(0646)  CS-0x183  0x10401         ||            LSR   r4             		; need to get the bottom bit of r4 into sA
(0647)  CS-0x184  0x0AC48         ||            BRCS  dd_add80
(0648)                            || 
(0649)  CS-0x185  0x34591  0x185  || dd_out:    OUT   r5,VGA_LADD   			; write bot 8 address bits to register
(0650)  CS-0x186  0x34490         ||            OUT   r4,VGA_HADD   			; write top 5 address bits to register
(0651)  CS-0x187  0x34692         ||            OUT   r6,VGA_COLOR  			; write color data to frame buffer
(0652)  CS-0x188  0x18002         ||            RET           
(0653)                            || 
(0654)  CS-0x189  0x22580  0x189  || dd_add80:  OR    r5,0x80       			; set bit if needed
(0655)  CS-0x18A  0x08C28         ||            BRN   dd_out
(0656)                            || ; --------------------------------------------------------------------
(0657)                            || 
(0658)                            || 
(0659)                            || ;---------------------------------------------------------------------
(0660)                            || ;- Subrountine: check_color
(0661)                            || ;- 
(0662)                            || ;- This subroutine draws a dot on the display the given coordinates: 
(0663)                            || ;- 
(0664)                            || ;- (X,Y) = (r8,r7)  with a color stored in r6  
(0665)                            || ;- 
(0666)                            || ;- Tweaked registers: r4,r5
(0667)                            || ;---------------------------------------------------------------------
(0668)                     0x18B  || check_color: 
(0669)  CS-0x18B  0x04439         ||            MOV   r4,r7         			; copy Y coordinate
(0670)  CS-0x18C  0x04541         ||            MOV   r5,r8         			; copy X coordinate
(0671)                            || 
(0672)  CS-0x18D  0x2057F         ||            AND   r5,0x7F       			; make sure top 1 bits cleared
(0673)  CS-0x18E  0x2043F         ||            AND   r4,0x3F       			; make sure top 2 bits cleared
(0674)  CS-0x18F  0x10401         ||            LSR   r4             		; need to get the bottom bit of r4 into sA
(0675)  CS-0x190  0x0ACA8         ||            BRCS  cc_add80
(0676)                            || 
(0677)  CS-0x191  0x34591  0x191  || cc_out:    OUT   r5,VGA_LADD   			; write bot 8 address bits to register
(0678)  CS-0x192  0x34490         ||            OUT   r4,VGA_HADD   			; write top 5 address bits to register
(0679)  CS-0x193  0x33F93         ||            IN    r31,COLOR_READ  		; store color of certain pixel
(0680)  CS-0x194  0x18002         ||            RET           
(0681)                            || 
(0682)  CS-0x195  0x22580  0x195  || cc_add80:  OR    r5,0x80       			; set bit if needed
(0683)  CS-0x196  0x08C88         ||            BRN   cc_out
(0684)                            || ; --------------------------------------------------------------------
(0685)                            || 
(0686)                            || ;---------------------------------------------------------------------
(0687)                            || ;- Subrountine: check_color2
(0688)                            || ;- 
(0689)                            || ;- This subroutine draws a dot on the display the given coordinates: 
(0690)                            || ;- 
(0691)                            || ;- (X,Y) = (r11,r10)  with a color stored in r6  
(0692)                            || ;- 
(0693)                            || ;- Tweaked registers: r4,r5
(0694)                            || ;---------------------------------------------------------------------
(0695)                     0x197  || check_color2: 
(0696)  CS-0x197  0x04451         ||            MOV   r4,r10         			; copy Y coordinate
(0697)  CS-0x198  0x04559         ||            MOV   r5,r11         			; copy X coordinate
(0698)                            || 
(0699)  CS-0x199  0x2057F         ||            AND   r5,0x7F       			; make sure top 1 bits cleared
(0700)  CS-0x19A  0x2043F         ||            AND   r4,0x3F       			; make sure top 2 bits cleared
(0701)  CS-0x19B  0x10401         ||            LSR   r4             		; need to get the bottom bit of r4 into sA
(0702)  CS-0x19C  0x0AD08         ||            BRCS  cc_add802
(0703)                            || 
(0704)  CS-0x19D  0x34591  0x19D  || cc_out2:    OUT   r5,VGA_LADD   			; write bot 8 address bits to register
(0705)  CS-0x19E  0x34490         ||            OUT   r4,VGA_HADD   			; write top 5 address bits to register
(0706)  CS-0x19F  0x33F93         ||            IN    r31,COLOR_READ  		; store color of certain pixel
(0707)  CS-0x1A0  0x18002         ||            RET           
(0708)                            || 
(0709)  CS-0x1A1  0x22580  0x1A1  || cc_add802:  OR    r5,0x80       			; set bit if needed
(0710)  CS-0x1A2  0x08CE8         ||            BRN   cc_out2
(0711)                            || 
(0712)                            || 
(0713)                            || 
(0714)                            || ;---------------------------------------------------------------------
(0715)                            || ;- DRAW_CURSOR_90
(0716)                            || ;---------------------------------------------------------------------
(0717)                            || 
(0718)                     0x1A3  || DRAW_CURSOR_90:	 
(0719)                            || 		 ;draw starting cursor 90 degrees
(0720)  CS-0x1A3  0x36730         || 		 MOV r7, 0x30
(0721)  CS-0x1A4  0x36819         || 		 MOV R8, 0x19
(0722)  CS-0x1A5  0x36935         || 		 MOV r9, 0x35
(0723)  CS-0x1A6  0x08B79         || 		 CALL draw_vertical_line
(0724)  CS-0x1A7  0x36731         || 		 MOV r7, 0x31
(0725)  CS-0x1A8  0x36818         || 		 MOV r8, 0x18
(0726)  CS-0x1A9  0x3691A         || 		 MOV r9, 0x1A
(0727)  CS-0x1AA  0x08B49         || 		 CALL draw_horizontal_line
(0728)  CS-0x1AB  0x36732         || 		 MOV r7, 0x32
(0729)  CS-0x1AC  0x36817         || 		 MOV r8, 0x17
(0730)  CS-0x1AD  0x08BF9         || 		 CALL draw_dot
(0731)  CS-0x1AE  0x36732         || 		 MOV r7, 0x32
(0732)  CS-0x1AF  0x3681B         || 		 MOV r8, 0x1B
(0733)  CS-0x1B0  0x08BF9         || 		 CALL draw_dot
(0734)  CS-0x1B1  0x18002         || 		 RET	
(0735)                            || 
(0736)                            || 		 
(0737)                            || ;---------------------------------------------------------------------
(0738)                            || ;- DRAW_CURSOR_RIGHT - draws a shifted cursor 45 degrees to the right
(0739)                            || ;---------------------------------------------------------------------
(0740)                     0x1B2  || DRAW_CURSOR_RIGHT:
(0741)  CS-0x1B2  0x36735         || 		MOV r7, 0x35
(0742)  CS-0x1B3  0x36819         || 		MOV r8, 0x19
(0743)  CS-0x1B4  0x08BF9         || 		CALL draw_dot
(0744)  CS-0x1B5  0x36734         || 		MOV r7, 0x34
(0745)  CS-0x1B6  0x3681A         || 		MOV r8, 0x1A
(0746)  CS-0x1B7  0x08BF9         || 		CALL draw_dot
(0747)  CS-0x1B8  0x36733         || 		MOV r7, 0x33
(0748)  CS-0x1B9  0x3681B         || 		MOV r8, 0x1B
(0749)  CS-0x1BA  0x08BF9         || 		CALL draw_dot
(0750)  CS-0x1BB  0x36732         || 		MOV r7, 0x32
(0751)  CS-0x1BC  0x3681C         || 		MOV r8, 0x1C
(0752)  CS-0x1BD  0x08BF9         || 		CALL draw_dot
(0753)  CS-0x1BE  0x36731         || 		MOV r7, 0x31
(0754)  CS-0x1BF  0x3681D         || 		MOV r8, 0x1D
(0755)  CS-0x1C0  0x08BF9         || 		CALL draw_dot
(0756)  CS-0x1C1  0x36731         || 		MOV r7, 0x31
(0757)  CS-0x1C2  0x3681A         || 		MOV r8, 0x1A
(0758)  CS-0x1C3  0x3691B         || 		MOV r9, 0x1B
(0759)  CS-0x1C4  0x08B49         || 		CALL draw_horizontal_line
(0760)  CS-0x1C5  0x36733         || 		MOV r7, 0x33
(0761)  CS-0x1C6  0x3681D         || 		MOV r8, 0x1D
(0762)  CS-0x1C7  0x36934         || 		MOV r9, 0x34
(0763)  CS-0x1C8  0x08B79         || 		CALL draw_vertical_line
(0764)  CS-0x1C9  0x18002         || 		RET
(0765)                            || 		
(0766)                            || ;---------------------------------------------------------------------
(0767)                            || ;- DRAW_CURSOR_LEFT - draws a shifted cursor 45 degrees to the left
(0768)                            || ;---------------------------------------------------------------------		
(0769)                     0x1CA  || DRAW_CURSOR_LEFT:
(0770)  CS-0x1CA  0x36735         || 		MOV r7, 0x35
(0771)  CS-0x1CB  0x36819         || 		MOV r8, 0x19
(0772)  CS-0x1CC  0x08BF9         || 		CALL draw_dot
(0773)  CS-0x1CD  0x36734         || 		MOV r7, 0x34
(0774)  CS-0x1CE  0x36818         || 		MOV r8, 0x18
(0775)  CS-0x1CF  0x08BF9         || 		CALL draw_dot
(0776)  CS-0x1D0  0x36733         || 		MOV r7, 0x33
(0777)  CS-0x1D1  0x36817         || 		MOV r8, 0x17
(0778)  CS-0x1D2  0x08BF9         || 		CALL draw_dot
(0779)  CS-0x1D3  0x36732         || 		MOV r7, 0x32
(0780)  CS-0x1D4  0x36816         || 		MOV r8, 0x16
(0781)  CS-0x1D5  0x08BF9         || 		CALL draw_dot
(0782)  CS-0x1D6  0x36731         || 		MOV r7, 0x31
(0783)  CS-0x1D7  0x36815         || 		MOV r8, 0x15
(0784)  CS-0x1D8  0x08BF9         || 		CALL draw_dot
(0785)  CS-0x1D9  0x36731         || 		MOV r7, 0x31
(0786)  CS-0x1DA  0x36817         || 		MOV r8, 0x17
(0787)  CS-0x1DB  0x36918         || 		MOV r9, 0x18
(0788)  CS-0x1DC  0x08B49         || 		CALL draw_horizontal_line
(0789)  CS-0x1DD  0x36733         || 		MOV r7, 0x33
(0790)  CS-0x1DE  0x36815         || 		MOV r8, 0x15
(0791)  CS-0x1DF  0x36934         || 		MOV r9, 0x34
(0792)  CS-0x1E0  0x08B79         || 		CALL draw_vertical_line
(0793)  CS-0x1E1  0x18002         || 		RET
(0794)                            || 		 
(0795)                            || 
(0796)                            || ;---------------------------------------------------------------------
(0797)                            || ;- LEFT - checks to see if the cursor is in the left position
(0798)                            || ;---------------------------------------------------------------------		 
(0799)                     0x1E2  || LEFT:
(0800)  CS-0x1E2  0x30001         || 		CMP 	r0, 0x01					; check to see if in right position
(0801)  CS-0x1E3  0x08F92         || 		BREQ 	ER_RIGHT_DR_CENTER
(0802)                            || 		
(0803)  CS-0x1E4  0x30000         || 		CMP 	r0, 0x00					; check to see if in center position
(0804)  CS-0x1E5  0x08F62         || 		BREQ 	ER_CENTER_DR_LEFT
(0805)  CS-0x1E6  0x08838         || 		BRN 	return_to_main				; if already in left position, do nothing
(0806)                            || 		 
(0807)                            || ;---------------------------------------------------------------------
(0808)                            || ;- RIGHT - checks to see if the cursor is in the left position
(0809)                            || ;---------------------------------------------------------------------
(0810)                     0x1E7  || RIGHT:
(0811)  CS-0x1E7  0x300FF         || 		CMP 	r0, 0xFF			; check to see if in left position
(0812)  CS-0x1E8  0x08FC2         || 		BREQ 	ER_LEFT_DR_CENTER
(0813)                            || 		;ADD		r0, 0x01			
(0814)                            || 		;CMP 	r0, 0x00			; check to see if in left pos first
(0815)                            || 		;BREQ	ER_LEFT_DR_CENTER
(0816)  CS-0x1E9  0x30000         || 		CMP 	r0, 0x00			; check to see if in center position
(0817)  CS-0x1EA  0x08FF2         || 		BREQ 	ER_CENTER_DR_RIGHT
(0818)  CS-0x1EB  0x08838         || 		BRN 	return_to_main		; if already in right position, do nothing
(0819)                            || 
(0820)                            || ;-----------------------------------------------------------------------
(0821)                            || ;-----------------------------------------------------------------------
(0822)                            || ;-----------ER_CENTER_DR_LEFT------------------------------------------		
(0823)                     0x1EC  || ER_CENTER_DR_LEFT:
(0824)  CS-0x1EC  0x360FF         || 		MOV r0, 0xFF				; reset position counter to be in right position
(0825)  CS-0x1ED  0x36600         || 		MOV r6, 0x00				; color over previous centered cursor
(0826)  CS-0x1EE  0x08D19         || 		CALL DRAW_CURSOR_90
(0827)                            || 		
(0828)  CS-0x1EF  0x366FF         || 		MOV r6, 0xFF				; draw right cursor
(0829)  CS-0x1F0  0x08E51         || 		CALL DRAW_CURSOR_LEFT
(0830)  CS-0x1F1  0x08838         || 		BRN	return_to_main			; always loop back to interrupt state
(0831)                            || 					
(0832)                            || ;-----------------------------------------------------------------------
(0833)                            || ;-----------------------------------------------------------------------
(0834)                            || ;-----------ER_RIGHT_DR_CENTER------------------------------------------
(0835)                     0x1F2  || ER_RIGHT_DR_CENTER:
(0836)  CS-0x1F2  0x36000         || 		MOV r0, 0x00				; reset position counter to be centered
(0837)  CS-0x1F3  0x36600         || 		MOV r6, 0x00				; color over right cursor
(0838)  CS-0x1F4  0x08D91         || 		CALL DRAW_CURSOR_RIGHT		
(0839)                            || 		
(0840)  CS-0x1F5  0x366FF         || 		MOV r6, 0xFF
(0841)  CS-0x1F6  0x08D19         || 		CALL DRAW_CURSOR_90			; draw center cursor
(0842)  CS-0x1F7  0x08838         || 		BRN	return_to_main			; always loop back to interrupt state
(0843)                            || 				
(0844)                            || 										
(0845)                            || ;-----------------------------------------------------------------------
(0846)                            || ;-----------------------------------------------------------------------
(0847)                            || ;-----------ER_LEFT_DR_CENTER------------------------------------------
(0848)                     0x1F8  || ER_LEFT_DR_CENTER:
(0849)  CS-0x1F8  0x36000         || 		MOV r0, 0x00				; reset position counter to be centered
(0850)  CS-0x1F9  0x36600         || 		MOV r6, 0x00				; color over left cursor
(0851)  CS-0x1FA  0x08E51         || 		CALL DRAW_CURSOR_LEFT		
(0852)                            || 		
(0853)  CS-0x1FB  0x366FF         || 		MOV r6, 0xFF
(0854)  CS-0x1FC  0x08D19         || 		CALL DRAW_CURSOR_90			; draw center cursor
(0855)  CS-0x1FD  0x08838         || 		BRN return_to_main			; always loop back to interrupt state
(0856)                            || 		
(0857)                            || 		
(0858)                            || ;-----------------------------------------------------------------------
(0859)                            || ;-----------------------------------------------------------------------
(0860)                            || ;-----------ER_CENTER_DR_RIGHT------------------------------------------
(0861)                            || 
(0862)                     0x1FE  || ER_CENTER_DR_RIGHT:
(0863)  CS-0x1FE  0x36001         || 		 MOV r0, 0x01				; reset position counter to be in right position
(0864)  CS-0x1FF  0x36600         || 		 MOV r6, 0x00				; color over previous cursor
(0865)  CS-0x200  0x08D19         || 		 CALL DRAW_CURSOR_90
(0866)                            || 		
(0867)  CS-0x201  0x366FF         || 		MOV r6, 0xFF				; draw right cursor
(0868)  CS-0x202  0x08D91         || 		CALL DRAW_CURSOR_RIGHT
(0869)  CS-0x203  0x08838         || 		BRN	return_to_main			; always loop back to interrupt state
(0870)                            || 
(0871)                            || 		
(0872)                            || ;---------------------------------------------------------------------
(0873)                            || ;- SHOOT - selects which angle to shoot at
(0874)                            || ;---------------------------------------------------------------------
(0875)                     0x204  || SHOOT:
(0876)  CS-0x204  0x32321         || 		IN r3, RANDOM_COLOR
(0877)                            || 		;CALL choose_color		
(0878)  CS-0x205  0x30000         || 	    CMP r0, 0x00
(0879)  CS-0x206  0x09062         || 		BREQ SHOOT_CENTER
(0880)  CS-0x207  0x300FF         || 		CMP r0, 0xFF
(0881)  CS-0x208  0x09152         || 		BREQ SHOOT_LEFT
(0882)  CS-0x209  0x30001         || 		CMP r0, 0x01
(0883)  CS-0x20A  0x09272         || 		BREQ SHOOT_RIGHT
(0884)  CS-0x20B  0x08838         || 		BRN return_to_main
(0885)                            || 
(0886)                            || ;---------------------------------------------------------------------
(0887)                            || ;- SHOOT_CENTER - shoots from the center position
(0888)                            || ;---------------------------------------------------------------------
(0889)                     0x20C  || SHOOT_CENTER:
(0890)  CS-0x20C  0x3672F         || 		MOV r7, 0x2F
(0891)  CS-0x20D  0x36819         || 		MOV r8, 0x19
(0892)  CS-0x20E  0x36600         || 		MOV r6, 0x00				; set color to randomly generated color
(0893)  CS-0x20F  0x08BF9         || 		CALL draw_dot
(0894)                            || 		;MOV r6, r17					; set color to randomly generated color
(0895)                            || 		;CALL draw_dot
(0896)                     0x210  || 	loop:
(0897)  CS-0x210  0x04A39         || 		MOV r10, r7					; store previous Y
(0898)  CS-0x211  0x04B41         || 		MOV r11, r8					; store previous x
(0899)  CS-0x212  0x04D39         || 		MOV r13, r7					; store previous Y again
(0900)  CS-0x213  0x04E41         || 		MOV r14, r8					; store previous  X again
(0901)  CS-0x214  0x2C701         || 		SUB r7, 0x01				; move up one y position
(0902)  CS-0x215  0x2CA01         || 		SUB r10, 0x01				; move stored position up one for deletion checking
(0903)  CS-0x216  0x09391         || 		CALL check_for_hit
(0904)  CS-0x217  0x09101         || 		CALL check_top_border		; checking for the top y position
(0905)                            || 		;CALL check_for_hit
(0906)                            || 		
(0907)  CS-0x218  0x097D9         || 		CALL FRAME_DELAY			; delay for moving dot
(0908)  CS-0x219  0x36600         || 		MOV r6, 0x00				; set color to black
(0909)  CS-0x21A  0x04769         || 		MOV r7, r13					; restore previous Y
(0910)  CS-0x21B  0x08BF9         || 		CALL draw_dot
(0911)  CS-0x21C  0x2C701         || 		SUB r7, 0x01				; get new Y position
(0912)  CS-0x21D  0x04689         || 		MOV r6, r17					; set color to randomly generated color
(0913)  CS-0x21E  0x08BF9         || 		CALL draw_dot
(0914)  CS-0x21F  0x09080         || 		brn loop
(0915)                            || 	
(0916)                            || ;---------------------------------------------------------------------
(0917)                            || ;- SHOOT_CENTER: check_top_border - checks if the bubble has reached border
(0918)                            || ;---------------------------------------------------------------------	
(0919)                     0x220  || check_top_border:
(0920)                            || 		;CMP r7, 0x04
(0921)                            || 		;OUT r7, VGA_HADD
(0922)                            || 		;OUT r8, VGA_LADD
(0923)                            || 		;IN r6, 0x93
(0924)  CS-0x220  0x08C59         || 		CALL check_color			; check next positions color
(0925)  CS-0x221  0x35F81         || 		OUT r31, 0x81
(0926)  CS-0x222  0x34482         || 		OUT r4, 0x82
(0927)  CS-0x223  0x31FFF         || 		CMP r31, 0xFF
(0928)  CS-0x224  0x09132         || 		BREQ draw_stopped_dot
(0929)  CS-0x225  0x18002         || 		RET
(0930)                            || 
(0931)                     0x226  || draw_stopped_dot:
(0932)  CS-0x226  0x13B02         || 		POP r27
(0933)  CS-0x227  0x36A00         || 		MOV r10, 0x00
(0934)  CS-0x228  0x36B00         || 		MOV r11, 0x00
(0935)  CS-0x229  0x08838         || 		brn return_to_main
(0936)                            || 		
(0937)                            || ;---------------------------------------------------------------------
(0938)                            || ;- SHOOT_LEFT - fires a shot from the left cursor
(0939)                            || ;---------------------------------------------------------------------
(0940)                     0x22A  || SHOOT_LEFT:
(0941)  CS-0x22A  0x36730         || 		MOV r7, 0x30
(0942)  CS-0x22B  0x36814         || 		MOV r8, 0x14
(0943)  CS-0x22C  0x04689         || 		MOV r6, r17					; set color to randomly generated color
(0944)  CS-0x22D  0x08BF9         || 		CALL draw_dot
(0945)                            || 		
(0946)                     0x22E  || 	left_loop:
(0947)  CS-0x22E  0x04A39         || 		MOV r10, r7					; store previous Y
(0948)  CS-0x22F  0x04B41         || 		MOV r11, r8			    	;store previous X
(0949)  CS-0x230  0x04D39         || 		MOV r13, r7					; store previous Y again
(0950)  CS-0x231  0x04E41         || 		MOV r14, r8					; store previous  X again
(0951)  CS-0x232  0x2C701         || 		SUB r7, 0x01				; move up one y position
(0952)  CS-0x233  0x09101         || 		CALL check_top_border
(0953)  CS-0x234  0x2C801         || 		SUB r8, 0x01				;move up one x position
(0954)  CS-0x235  0x09211         || 		CALL check_for_left_border	; checking for the top y position
(0955)  CS-0x236  0x2CA01         || 		SUB r10, 0x01
(0956)                            || 		;SUB r11, 0x01
(0957)  CS-0x237  0x09391         || 		CALL check_for_hit
(0958)                            || 		
(0959)  CS-0x238  0x097D9         || 		CALL FRAME_DELAY			; delay for moving dot
(0960)  CS-0x239  0x36600         || 		MOV r6, 0x00				; set color to black
(0961)  CS-0x23A  0x04769         || 		MOV r7, r13					; restore previous Y
(0962)  CS-0x23B  0x04871         || 		MOV r8, r14					; restore previous X
(0963)  CS-0x23C  0x08BF9         || 		CALL draw_dot
(0964)  CS-0x23D  0x2C701         || 		SUB r7, 0x01				; get new Y position
(0965)  CS-0x23E  0x2C801         || 		SUB r8, 0x01
(0966)  CS-0x23F  0x04689         || 		MOV r6, r17					; set color to randomly generated color
(0967)  CS-0x240  0x08BF9         || 		CALL draw_dot
(0968)  CS-0x241  0x09170         || 		brn left_loop
(0969)                            || 	
(0970)                            || ;---------------------------------------------------------------------
(0971)                            || ;- SHOOT_LEFT: check_for_border - checks if the bubble has reached border
(0972)                            || ;---------------------------------------------------------------------	
(0973)                     0x242  || check_for_left_border:
(0974)                            || 		;CMP r7, 0x04
(0975)                            || 		;OUT r7, VGA_HADD
(0976)                            || 		;OUT r8, VGA_LADD
(0977)                            || 		;IN r6, 0x93
(0978)  CS-0x242  0x08C59         || 		CALL check_color			; check next positions color
(0979)  CS-0x243  0x35F81         || 		OUT r31, 0x81
(0980)  CS-0x244  0x34482         || 		OUT r4, 0x82
(0981)  CS-0x245  0x31FFF         || 		CMP r31, 0xFF
(0982)  CS-0x246  0x09242         || 		BREQ draw_translated_dot
(0983)  CS-0x247  0x18002         || 		RET
(0984)                            || 
(0985)                     0x248  || draw_translated_dot:
(0986)  CS-0x248  0x13B02         || 		POP r27
(0987)  CS-0x249  0x04751         || 		MOV r7, r10
(0988)  CS-0x24A  0x04859         || 		MOV r8, r11
(0989)  CS-0x24B  0x36A00         || 		MOV r10, 0x00
(0990)  CS-0x24C  0x36B00         || 		MOV r11, 0x00
(0991)  CS-0x24D  0x09290         || 		brn right_loop            	;tranlsate to right
(0992)                            || 
(0993)                            || ;---------------------------------------------------------------------
(0994)                            || ;- SHOOT_RIGHT - fires a shot from the right cursor
(0995)                            || ;---------------------------------------------------------------------
(0996)                     0x24E  || SHOOT_RIGHT:
(0997)  CS-0x24E  0x36730         || 		MOV r7, 0x30
(0998)  CS-0x24F  0x3681E         || 		MOV r8, 0x1E
(0999)  CS-0x250  0x04689         || 		MOV r6, r17					; set color to randomly generated color
(1000)  CS-0x251  0x08BF9         || 		CALL draw_dot
(1001)                            || 		
(1002)                     0x252  || 	right_loop:
(1003)  CS-0x252  0x04A39         || 		MOV r10, r7					; store previous Y
(1004)  CS-0x253  0x04B41         || 		MOV r11, r8			    	;store previous X
(1005)  CS-0x254  0x04D39         || 		MOV r13, r7					; store previous Y again
(1006)  CS-0x255  0x04E41         || 		MOV r14, r8					; store previous  X again
(1007)  CS-0x256  0x2C701         || 		SUB r7, 0x01				; move up one y position
(1008)  CS-0x257  0x09101         || 		CALL check_top_border
(1009)  CS-0x258  0x28801         || 		ADD r8, 0x01				;move up one x position
(1010)  CS-0x259  0x09331         || 		CALL check_for_right_border	; checking for the top y position
(1011)  CS-0x25A  0x2CA01         || 		SUB	r10, 0x01
(1012)                            || 		;ADD r11, 0x01
(1013)  CS-0x25B  0x09391         || 		CALL check_for_hit
(1014)                            || 		
(1015)  CS-0x25C  0x097D9         || 		CALL FRAME_DELAY			; delay for moving dot
(1016)  CS-0x25D  0x36600         || 		MOV r6, 0x00				; set color to black
(1017)  CS-0x25E  0x04769         || 		MOV r7, r13					; restore previous Y
(1018)  CS-0x25F  0x04871         || 		MOV r8, r14					; restore previous X
(1019)  CS-0x260  0x08BF9         || 		CALL draw_dot
(1020)  CS-0x261  0x2C701         || 		SUB r7, 0x01				; get new Y position
(1021)  CS-0x262  0x28801         || 		ADD r8, 0x01
(1022)  CS-0x263  0x04689         || 		MOV r6, r17					; set color to randomly generated color
(1023)  CS-0x264  0x08BF9         || 		CALL draw_dot
(1024)  CS-0x265  0x09290         || 		brn right_loop
(1025)                            || 	
(1026)                            || ;---------------------------------------------------------------------
(1027)                            || ;- SHOOT_RIGHT: check_for_border
(1028)                            || ;---------------------------------------------------------------------	
(1029)                     0x266  || check_for_right_border:
(1030)                            || 		;CMP r7, 0x04
(1031)                            || 		;OUT r7, VGA_HADD
(1032)                            || 		;OUT r8, VGA_LADD
(1033)                            || 		;IN r6, 0x93
(1034)  CS-0x266  0x08C59         || 		CALL check_color			; check next positions color
(1035)  CS-0x267  0x35F81         || 		OUT r31, 0x81
(1036)  CS-0x268  0x34482         || 		OUT r4, 0x82
(1037)  CS-0x269  0x31FFF         || 		CMP r31, 0xFF
(1038)  CS-0x26A  0x09362         || 		BREQ draw_translated_right_dot
(1039)  CS-0x26B  0x18002         || 		RET
(1040)                            || 
(1041)                     0x26C  || draw_translated_right_dot:
(1042)  CS-0x26C  0x13B02         || 		POP r27
(1043)  CS-0x26D  0x04751         || 		MOV r7, r10
(1044)  CS-0x26E  0x04859         || 		MOV r8, r11			
(1045)  CS-0x26F  0x36A00         || 		MOV r10, 0x00				; reset the cursors previous position
(1046)  CS-0x270  0x36B00         || 		MOV r11, 0x00
(1047)  CS-0x271  0x09170         || 		brn left_loop       		; tranlsate left
(1048)                            || 
(1049)                            || 
(1050)                            || ;---------------------------------------------------------------------
(1051)                            || ;- check_for_hit
(1052)                            || ;---------------------------------------------------------------------	
(1053)                     0x272  || check_for_hit:
(1054)                            || 		
(1055)  CS-0x272  0x37B20         || 		MOV r27, 0x20
(1056)                            || 		;CMP r7, 0x04
(1057)                            || 		;OUT r7, VGA_HADD
(1058)                            || 		;OUT r8, VGA_LADD
(1059)                            || 		;IN r6, 0x93
(1060)                     0x273  ||   subsequent_hit:
(1061)  CS-0x273  0x37C00         || 		MOV r28, 0x00
(1062)                            || 		
(1063)  CS-0x274  0x08CB9  0x274  || 	one:	CALL check_color2			; check above color
(1064)                            || 											; check to see if at max number of bubbles to delete
(1065)                            || 		;CLC
(1066)  CS-0x275  0x29C01         || 		ADD r28, 0x01
(1067)  CS-0x276  0x04A68         || 		CMP  r10, r13
(1068)  CS-0x277  0x093DA         || 		BREQ two
(1069)  CS-0x278  0x05F88         || 		CMP r31, r17
(1070)  CS-0x279  0x35C82         || 		OUT r28, SSEG_ID2
(1071)  CS-0x27A  0x0959A         || 		BREQ store_position
(1072)                            || 		;CMP r25, 0x04
(1073)                            || 		;BREQ delete_bubbles
(1074)                            || 		
(1075)                     0x27B  || 	two:
(1076)  CS-0x27B  0x28B01         || 		ADD r11, 0x01 				;check diaganol right above
(1077)  CS-0x27C  0x08CB9         || 		CALL check_color2
(1078)                            || 								; check to see if at max number of bubbles to delete
(1079)                            || 		;CLC
(1080)  CS-0x27D  0x29C01         || 		ADD r28, 0x01
(1081)  CS-0x27E  0x05F88         || 		CMP r31, r17
(1082)  CS-0x27F  0x35C82         || 		OUT r28, SSEG_ID2
(1083)  CS-0x280  0x0959A         || 		BREQ store_position
(1084)                            || 		;CMP r25, 0x04
(1085)                            || 		;BREQ delete_bubbles			
(1086)                            || 		
(1087)  CS-0x281  0x28A01  0x281  || 	three:	ADD r10, 0x01				;check right
(1088)  CS-0x282  0x08CB9         || 		CALL check_color2
(1089)                            || 		
(1090)  CS-0x283  0x29C01         || 		ADD r28, 0x01
(1091)  CS-0x284  0x05F88         || 		CMP r31, r17
(1092)  CS-0x285  0x35C82         || 		OUT r28, SSEG_ID2
(1093)  CS-0x286  0x0959A         || 		BREQ store_position
(1094)                            || 	;	CMP r25, 0x04
(1095)                            || 	;	BREQ delete_bubbles				; check to see if at max number of bubbles to delete
(1096)                            || 		
(1097)                     0x287  || 	four:
(1098)  CS-0x287  0x28A01         || 		ADD r10, 0x01				;check below right diag
(1099)  CS-0x288  0x08CB9         || 		CALL check_color2
(1100)                            || 					; check to see if at max number of bubbles to delete
(1101)                            || 		;CLC
(1102)  CS-0x289  0x29C01         || 		ADD r28, 0x01
(1103)                            || 		;CMP  r0, 0x01
(1104)                            || 		;BREQ five
(1105)                            || 		;CLC
(1106)  CS-0x28A  0x05F88         || 		CMP r31, r17
(1107)  CS-0x28B  0x35C82         || 		OUT r28, SSEG_ID2
(1108)  CS-0x28C  0x0959A         || 		BREQ store_position
(1109)                            || 		;CMP r25, 0x04
(1110)                            || 		;BREQ delete_bubbles	
(1111)                     0x28D  || 	five:	
(1112)  CS-0x28D  0x2CB01         || 		SUB r11, 0x01				;check below
(1113)  CS-0x28E  0x08CB9         || 		CALL check_color2
(1114)                            || 		
(1115)  CS-0x28F  0x29C01         || 		ADD r28, 0x01
(1116)  CS-0x290  0x04A68         || 		CMP  r10, r13
(1117)  CS-0x291  0x094AA         || 		BREQ six
(1118)                            || 		;CMP r0, 0x00
(1119)                            || 		;BREQ six
(1120)                            || 		;CLC
(1121)  CS-0x292  0x05F88         || 		CMP r31, r17
(1122)  CS-0x293  0x35C82         || 		OUT r28, SSEG_ID2
(1123)  CS-0x294  0x0959A         || 		BREQ store_position
(1124)                            || 		;CMP r25, 0x04
(1125)                            || 		;BREQ delete_bubbles			; check to see if at max number of bubbles to delete
(1126)                            || 	
(1127)                     0x295  || 	six:
(1128)  CS-0x295  0x2CB01         || 		SUB r11, 0x01				;check left down diag
(1129)  CS-0x296  0x08CB9         || 		CALL check_color2
(1130)                            || 						; check to see if at max number of bubbles to delete
(1131)                            || 		;CLC
(1132)  CS-0x297  0x29C01         || 		ADD r28, 0x01
(1133)                            || 		;CMP r0, 0xFF
(1134)                            || 		;BREQ seven
(1135)                            || 		;CLC
(1136)  CS-0x298  0x05F88         || 		CMP r31, r17
(1137)  CS-0x299  0x35C82         || 		OUT r28, SSEG_ID2
(1138)  CS-0x29A  0x0959A         || 		BREQ store_position
(1139)                            || 		;CMP r25, 0x04
(1140)                            || 		;BREQ delete_bubbles	
(1141)                     0x29B  || 	seven:	
(1142)  CS-0x29B  0x2CA01         || 		SUB r10, 0x01				;check right
(1143)  CS-0x29C  0x08CB9         || 		CALL check_color2
(1144)                            || 							; check to see if at max number of bubbles to delete
(1145)                            || 		
(1146)  CS-0x29D  0x29C01         || 		ADD r28, 0x01
(1147)  CS-0x29E  0x05F88         || 		CMP r31, r17
(1148)  CS-0x29F  0x35C82         || 		OUT r28, SSEG_ID2
(1149)  CS-0x2A0  0x0959A         || 		BREQ store_position
(1150)                            || 		;CMP r25, 0x04
(1151)                            || 		;BREQ delete_bubbles	
(1152)                     0x2A1  || 	eight:	
(1153)  CS-0x2A1  0x2CA01         || 		SUB r10, 0x01				;check left up diag
(1154)  CS-0x2A2  0x08CB9         || 		CALL check_color2
(1155)                            || 					; check to see if at max number of bubbles to delete
(1156)                            || 		;CLC
(1157)  CS-0x2A3  0x29C01         || 		ADD r28, 0x01
(1158)  CS-0x2A4  0x05F88         || 		CMP r31, r17
(1159)  CS-0x2A5  0x35C81         || 		OUT r28, SSEG_ID1
(1160)  CS-0x2A6  0x0959A         || 		BREQ store_position
(1161)                            || 		;CMP r25, 0x04
(1162)                            || 		;BREQ delete_bubbles	
(1163)                     0x2A7  || 	finish:
(1164)  CS-0x2A7  0x31903         || 		CMP r25, 0x03
(1165)  CS-0x2A8  0x09662         || 		BREQ delete_bubbles			; check to see if at max number of bubbles to delete
(1166)                            || 		;CMP r25, 0x01
(1167)                            || 		;BREQ done
(1168)                            || 		;BRCS done
(1169)                            || 		;BRCS delete_bubbles
(1170)  CS-0x2A9  0x18000         || 		CLC
(1171)  CS-0x2AA  0x2DA01         || 		SUB r26, 0x01
(1172)  CS-0x2AB  0x04AD2         || 		LD r10, (r26)
(1173)  CS-0x2AC  0x041D3         || 		ST r1, (r26)
(1174)  CS-0x2AD  0x2DA01         || 		SUB r26, 0x01
(1175)  CS-0x2AE  0x04BD2         || 		LD r11, (r26)
(1176)  CS-0x2AF  0x041D3         || 		ST r1, (r26)
(1177)  CS-0x2B0  0x29901         || 		ADD r25, 0x01
(1178)  CS-0x2B1  0x09398         || 		BRN subsequent_hit
(1179)                            || 
(1180)                            || 		;CMP r28, 0x08
(1181)                            || 		;BREQ return_to_shoot
(1182)                            || 		;BRNE subsequent_hit
(1183)                            || 
(1184)                     0x2B2  || return_to_shoot:
(1185)                            || 		;reset color here
(1186)  CS-0x2B2  0x18002         || 		RET
(1187)                            || 
(1188)                     0x2B3  || store_position:
(1189)  CS-0x2B3  0x29D01         || 		ADD r29, 0x01
(1190)                            || 
(1191)  CS-0x2B4  0x04BD3         || 		ST r11, (r26)
(1192)  CS-0x2B5  0x29A01         || 		ADD r26,0x01
(1193)  CS-0x2B6  0x04AD3         || 		ST r10, (r26)
(1194)  CS-0x2B7  0x29A01         || 		ADD r26, 0x01
(1195)                            || 		
(1196)  CS-0x2B8  0x04BDB         || 		ST r11, (r27)
(1197)  CS-0x2B9  0x29B01         || 		ADD r27, 0x01
(1198)  CS-0x2BA  0x04ADB         || 		ST r10, (r27)
(1199)  CS-0x2BB  0x29B01         || 		ADD r27, 0x01
(1200)                            || 		
(1201)                            || 		;ADD r25, 0x01
(1202)                            || 		
(1203)  CS-0x2BC  0x31C01         || 		CMP r28, 0x01
(1204)  CS-0x2BD  0x093DA         || 		BREQ two
(1205)  CS-0x2BE  0x31C02         || 		CMP r28, 0x02
(1206)  CS-0x2BF  0x0940A         || 		BREQ three
(1207)  CS-0x2C0  0x31C03         || 		CMP r28, 0x03
(1208)  CS-0x2C1  0x0943A         || 		BREQ four
(1209)  CS-0x2C2  0x31C04         || 		CMP r28, 0x04
(1210)  CS-0x2C3  0x0946A         || 		BREQ five
(1211)  CS-0x2C4  0x31C05         || 		CMP r28, 0x05
(1212)  CS-0x2C5  0x094AA         || 		BREQ six
(1213)  CS-0x2C6  0x31C06         || 		CMP r28, 0x06
(1214)  CS-0x2C7  0x094DA         || 		BREQ seven
(1215)  CS-0x2C8  0x31C07         || 		CMP r28, 0x07
(1216)  CS-0x2C9  0x0950A         || 		BREQ eight
(1217)  CS-0x2CA  0x31C08         || 		CMP r28, 0x08
(1218)  CS-0x2CB  0x0953A         || 		BREQ finish
(1219)                            || 		
(1220)                            || ;---------------------------------------------------------------------
(1221)                            || ;- Delete bubbles 
(1222)                            || ;---------------------------------------------------------------------		
(1223)                            || 		
(1224)                     0x2CC  || 	delete_bubbles:
(1225)  CS-0x2CC  0x31D02         || 		CMP r29, 0x02				; check to make sure at least three bubbles found
(1226)  CS-0x2CD  0x0B710         || 		BRCS done					; branch if three not found
(1227)                            || 		
(1228)                            || 		;first delete the bubble at its current position
(1229)                            || 		;the bubble's current position should be the same when it was called
(1230)  CS-0x2CE  0x3620F         || 		MOV r2, 0x0F
(1231)  CS-0x2CF  0x34281         || 		OUT r2, SSEG_ID1 
(1232)  CS-0x2D0  0x36600         || 		MOV r6, 0x00				; set color to black
(1233)  CS-0x2D1  0x04769         || 		MOV r7, r13					; restore previous positions (secondary)
(1234)  CS-0x2D2  0x04871         || 		MOV r8, r14					
(1235)  CS-0x2D3  0x08BF9         || 		CALL draw_dot				; color over bubble's current position
(1236)                            || 
(1237)                     0x2D4  || 	loop_through_stack:
(1238)  CS-0x2D4  0x362FA         || 		MOV r2, 0xFA
(1239)  CS-0x2D5  0x35B81         || 		OUT r27, SSEG_ID1 
(1240)  CS-0x2D6  0x2DB01         || 		SUB r27, 0x01				; decrement pointer
(1241)  CS-0x2D7  0x047DA         || 		LD r7, (r27)				; load Y pos. from stack
(1242)                            || 		;SUB r27, 0x01				; decrement pointer
(1243)  CS-0x2D8  0x041DB         || 		ST r1, (r27)				; store zero to overwrite data
(1244)  CS-0x2D9  0x2DB01         || 		SUB r27, 0x01
(1245)  CS-0x2DA  0x048DA         || 		LD r8, (r27)				; load X pos. from stack
(1246)                            || 		;SUB r27, 0x01				; decrement pointer
(1247)  CS-0x2DB  0x041DB         || 		ST r1, (r27)				; store zero to overwrite data
(1248)  CS-0x2DC  0x08BF9         || 		CALL draw_dot				; color over similar color bubble
(1249)                            || 		
(1250)  CS-0x2DD  0x37D00         || 		MOV r29, 0x00				; reset total found bubble counters
(1251)  CS-0x2DE  0x37900         || 		MOV r25, 0x00
(1252)  CS-0x2DF  0x31B20         || 		CMP r27, 0x20 				; check for end of bubbles to delete
(1253)  CS-0x2E0  0x0883A         || 		BREQ return_to_main			; finish and exit back to main
(1254)                            || 		
(1255)  CS-0x2E1  0x096A0         || 		BRN loop_through_stack		; otherwise, continue to move through stack
(1256)                            || 		
(1257)                            || 						
(1258)                     0x2E2  || 	  done:
(1259)  CS-0x2E2  0x30000         || 		CMP r0, 0x00
(1260)  CS-0x2E3  0x0974A         || 		BREQ check_center_for_nonblack
(1261)  CS-0x2E4  0x300FF         || 		CMP r0, 0xFF
(1262)  CS-0x2E5  0x0977A         || 		BREQ check_left_for_nonblack
(1263)  CS-0x2E6  0x30001         || 		CMP r0, 0x01
(1264)  CS-0x2E7  0x097AA         || 		BREQ check_right_for_nonblack
(1265)  CS-0x2E8  0x09590         || 		brn return_to_shoot			; finish and exit back to shooting call
(1266)                            || 		
(1267)                            || 		
(1268)                     0x2E9  || check_center_for_nonblack:
(1269)                            || 		;MOV r11, r14				; restore original X value
(1270)  CS-0x2E9  0x08C59         || 		CALL check_color			; call to see if black
(1271)  CS-0x2EA  0x31F00         || 		CMP	r31, 0x00				; check if black
(1272)  CS-0x2EB  0x09592         || 		BREQ return_to_shoot
(1273)  CS-0x2EC  0x05F88         || 		CMP r31, r17
(1274)  CS-0x2ED  0x0939A         || 		BREQ subsequent_hit
(1275)  CS-0x2EE  0x0883B         || 		BRNE return_to_main			; check this for position
(1276)                            || 		
(1277)                     0x2EF  || check_left_for_nonblack:
(1278)  CS-0x2EF  0x08C59         || 		CALL check_color			; call to see if black
(1279)  CS-0x2F0  0x31F00         || 		CMP	r31, 0x00				; check if black
(1280)  CS-0x2F1  0x09592         || 		BREQ return_to_shoot
(1281)  CS-0x2F2  0x05F88         || 		CMP r31, r17
(1282)  CS-0x2F3  0x0939A         || 		BREQ subsequent_hit
(1283)  CS-0x2F4  0x0883B         || 		BRNE return_to_main			; check this for position
(1284)                            || 		
(1285)                     0x2F5  || check_right_for_nonblack:
(1286)  CS-0x2F5  0x08C59         || 		CALL check_color			; call to see if black
(1287)  CS-0x2F6  0x31F00         || 		CMP	r31, 0x00				; check if black
(1288)  CS-0x2F7  0x09592         || 		BREQ return_to_shoot
(1289)  CS-0x2F8  0x05F88         || 		CMP r31, r17
(1290)  CS-0x2F9  0x0939A         || 		BREQ subsequent_hit
(1291)  CS-0x2FA  0x0883B         || 		BRNE return_to_main			; check this for position
(1292)                            || 
(1293)                            || ;reload_before_next_check:
(1294)                            || 		;SUB r26, 0x01
(1295)                            || 		;LD r10, (r26)
(1296)                            || ;		ST r1, (r26)
(1297)                            || 		;SUB r26, 0x01
(1298)                            || 		;LD r11, (r26)
(1299)                            || ;		ST r1, (r26)
(1300)                            || ;		BRN check_for_hit
(1301)                            || 		
(1302)                            || ;---------------------------------------------------------------------
(1303)                            || ;- SHOOT: FRAME_DELAY - delays the movement of the bubble
(1304)                            || ;---------------------------------------------------------------------	
(1305)                     0x2FB  || FRAME_DELAY:
(1306)  CS-0x2FB  0x3740A         || 		MOV     R20, 0x0A    		; Start delay
(1307)  CS-0x2FC  0x2D401  0x2FC  || OUTSIDE_FOR0: 	SUB     R20, 0x01
(1308)                            || 
(1309)  CS-0x2FD  0x375AA         || 		MOV     R21, 0xAA
(1310)  CS-0x2FE  0x2D501  0x2FE  || MIDDLE_FOR0:  	SUB     R21, 0x01
(1311)                            ||              
(1312)  CS-0x2FF  0x376AA         || 		MOV     R22, 0xAA
(1313)  CS-0x300  0x2D601  0x300  || INSIDE_FOR0:  	SUB     R22, 0x01
(1314)  CS-0x301  0x09803         || 		BRNE    INSIDE_FOR0
(1315)  CS-0x302  0x23500         || 		OR      R21, 0x00
(1316)  CS-0x303  0x097F3         || 		BRNE    MIDDLE_FOR0
(1317)  CS-0x304  0x23400         || 		OR      R20, 0x00
(1318)  CS-0x305  0x097E3         || 		BRNE    OUTSIDE_FOR0
(1319)  CS-0x306  0x18002         || 		RET	
(1320)                            || 				
(1321)                            || ;---------------------------------------------------------------------
(1322)                            || ;- KEY_INT - ISR for the keyboard
(1323)                            || ;---------------------------------------------------------------------
(1324)                     0x307  || KEY_INT:
(1325)  CS-0x307  0x1A001         || 		CLI
(1326)  CS-0x308  0x33E44         || 		IN r30, KEYBOARD			; read in keycode value
(1327)  CS-0x309  0x31E74         || 		CMP r30, 0x74        		; check if right cursor movement key pressed
(1328)  CS-0x30A  0x08F3A         || 		BREQ RIGHT
(1329)  CS-0x30B  0x31E6B         || 		CMP r30, 0x6B        		; check if left cursor movement key pressed 
(1330)  CS-0x30C  0x08F12         || 		BREQ LEFT
(1331)  CS-0x30D  0x31E29         || 		CMP	r30, 0x29				; check if shoot key pressed
(1332)  CS-0x30E  0x09022         || 		BREQ SHOOT
(1333)  CS-0x30F  0x1A003         || 		RETIE
(1334)                            || 		
(1335)                            || ; --------------------------------------------------------------------
(1336)                            || 
(1337)                            || 
(1338)                       1023  || .ORG 0x3FF
(1339)  CS-0x3FF  0x09838         || BRN KEY_INT
(1340)                            || 
(1341)                            || 
(1342)                            || 





Symbol Table Key 
----------------------------------------------------------------------
C1             C2     C3      ||  C4+
-------------  ----   ----        -------
C1:  name of symbol
C2:  the value of symbol 
C3:  source code line number where symbol defined
C4+: source code line number of where symbol is referenced 
----------------------------------------------------------------------


-- Labels
------------------------------------------------------------ 
CC_ADD80       0x195   (0682)  ||  0675 
CC_ADD802      0x1A1   (0709)  ||  0702 
CC_OUT         0x191   (0677)  ||  0683 
CC_OUT2        0x19D   (0704)  ||  0710 
CHECK_CENTER_FOR_NONBLACK 0x2E9   (1268)  ||  1260 
CHECK_COLOR    0x18B   (0668)  ||  0924 0978 1034 1270 1278 1286 
CHECK_COLOR2   0x197   (0695)  ||  1063 1077 1088 1099 1113 1129 1143 1154 
CHECK_FOR_HIT  0x272   (1053)  ||  0903 0957 1013 
CHECK_FOR_LEFT_BORDER 0x242   (0973)  ||  0954 
CHECK_FOR_RIGHT_BORDER 0x266   (1029)  ||  1010 
CHECK_LEFT_FOR_NONBLACK 0x2EF   (1277)  ||  1262 
CHECK_RIGHT_FOR_NONBLACK 0x2F5   (1285)  ||  1264 
CHECK_TOP_BORDER 0x220   (0919)  ||  0904 0952 1008 
CHOOSE_COLOR   0x10A   (0410)  ||  0398 
DD_ADD80       0x189   (0654)  ||  0647 
DD_OUT         0x185   (0649)  ||  0655 
DELETE_BUBBLES 0x2CC   (1224)  ||  1165 
DONE           0x2E2   (1258)  ||  1226 
DRAW_BACKGROUND 0x175   (0617)  ||  0061 
DRAW_CHARACTER_B 0x145   (0515)  ||  0096 0115 0120 0147 
DRAW_CHARACTER_L 0x13A   (0485)  ||  0125 0152 
DRAW_CURSOR_90 0x1A3   (0718)  ||  0087 0826 0841 0854 0865 
DRAW_CURSOR_LEFT 0x1CA   (0769)  ||  0829 0851 
DRAW_CURSOR_RIGHT 0x1B2   (0740)  ||  0838 0868 
DRAW_DOT       0x17F   (0640)  ||  0138 0197 0204 0243 0247 0251 0255 0261 0265 0269 
                               ||  0273 0277 0281 0285 0289 0295 0299 0303 0307 0311 
                               ||  0315 0321 0325 0329 0333 0339 0343 0347 0353 0357 
                               ||  0361 0430 0438 0446 0454 0462 0470 0577 0602 0730 
                               ||  0733 0743 0746 0749 0752 0755 0772 0775 0778 0781 
                               ||  0784 0893 0910 0913 0944 0963 0967 1000 1019 1023 
                               ||  1235 1248 
DRAW_HORIZ1    0x16A   (0576)  ||  0580 
DRAW_HORIZONTAL_LINE 0x169   (0573)  ||  0079 0085 0106 0135 0142 0158 0170 0176 0184 0192 
                               ||  0201 0215 0219 0223 0227 0231 0235 0496 0529 0534 
                               ||  0539 0624 0727 0759 0788 
DRAW_STOPPED_DOT 0x226   (0931)  ||  0928 
DRAW_TRANSLATED_DOT 0x248   (0985)  ||  0982 
DRAW_TRANSLATED_RIGHT_DOT 0x26C   (1041)  ||  1038 
DRAW_VERT1     0x170   (0601)  ||  0605 
DRAW_VERTICAL_LINE 0x16F   (0598)  ||  0067 0073 0102 0110 0131 0162 0166 0180 0188 0208 
                               ||  0489 0520 0549 0555 0723 0763 0792 
EIGHT          0x2A1   (1152)  ||  1216 
ER_CENTER_DR_LEFT 0x1EC   (0823)  ||  0804 
ER_CENTER_DR_RIGHT 0x1FE   (0862)  ||  0817 
ER_LEFT_DR_CENTER 0x1F8   (0848)  ||  0812 
ER_RIGHT_DR_CENTER 0x1F2   (0835)  ||  0801 
FINISH         0x2A7   (1163)  ||  1218 
FIVE           0x28D   (1111)  ||  1210 
FOUR           0x287   (1097)  ||  1208 
FRAME_DELAY    0x2FB   (1305)  ||  0907 0959 1015 
INIT           0x010   (0060)  ||  
INSIDE_FOR0    0x300   (1313)  ||  1314 
KEY_INT        0x307   (1324)  ||  1339 
LEFT           0x1E2   (0799)  ||  1330 
LEFT_LOOP      0x22E   (0946)  ||  0968 1047 
LOOP           0x210   (0896)  ||  0914 
LOOP_THROUGH_STACK 0x2D4   (1237)  ||  1255 
MAIN           0x108   (0403)  ||  0405 
MIDDLE_FOR0    0x2FE   (1310)  ||  1316 
ONE            0x274   (1063)  ||  
OUTSIDE_FOR0   0x2FC   (1307)  ||  1318 
RETURN_TO_MAIN 0x107   (0395)  ||  0805 0818 0830 0842 0855 0869 0884 0935 1253 1275 
                               ||  1283 1291 
RETURN_TO_SHOOT 0x2B2   (1184)  ||  1265 1272 1280 1288 
RIGHT          0x1E7   (0810)  ||  1328 
RIGHT_LOOP     0x252   (1002)  ||  0991 1024 
SET_BLUE       0x122   (0441)  ||  0417 
SET_GREEN      0x116   (0425)  ||  0413 
SET_ORANGE     0x12E   (0457)  ||  0421 
SET_PURPLE     0x11C   (0433)  ||  0415 
SET_RED        0x128   (0449)  ||  0419 
SET_YELLOW     0x134   (0465)  ||  0423 
SEVEN          0x29B   (1141)  ||  1214 
SHOOT          0x204   (0875)  ||  1332 
SHOOT_CENTER   0x20C   (0889)  ||  0879 
SHOOT_LEFT     0x22A   (0940)  ||  0881 
SHOOT_RIGHT    0x24E   (0996)  ||  0883 
SIX            0x295   (1127)  ||  1117 1212 
START          0x177   (0620)  ||  0627 
STORE_POSITION 0x2B3   (1188)  ||  1071 1083 1093 1108 1123 1138 1149 1160 
SUBSEQUENT_HIT 0x273   (1060)  ||  1178 1274 1282 1290 
THREE          0x281   (1087)  ||  1206 
TWO            0x27B   (1075)  ||  1068 1204 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
BG_COLOR       0x000   (0031)  ||  0618 
COLOR_READ     0x093   (0023)  ||  0679 0706 
KEYBOARD       0x044   (0029)  ||  1326 
RANDOM_COLOR   0x021   (0024)  ||  0876 
SSEG_ID1       0x081   (0026)  ||  1159 1231 1239 
SSEG_ID2       0x082   (0027)  ||  1070 1082 1092 1107 1122 1137 1148 
VGA_COLOR      0x092   (0022)  ||  0651 
VGA_HADD       0x090   (0020)  ||  0650 0678 0705 
VGA_LADD       0x091   (0021)  ||  0649 0677 0704 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
