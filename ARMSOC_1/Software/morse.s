        AREA     ARMex, CODE, READONLY
                                ; Name this block of code ARMex
        ENTRY                   ; Mark first instruction to execute

		 SUB R0, R15, R15 	; R0 = 0						1110 000 0010 0 1111 0000 0000 0000 1111 E04F000F 0x00
		 SUB R7, R15, r15   ; R7=0
		 add r7,r7,#255
 		 add r7,r7,#255
		 add r7,r7,#255
 

;R0 - SEMPRE EM ZERO
;R1 - Armazena inicialmente a letra e depoiso código da letra
;R2 - Temporário usado para armazenar dado a ser enviado para a porta do GPIO
;R3 - TEMPORÁRIO
;R4 - TEMPORÁRIO contador da delay
;R5 - TEMPORÁRIO contador da delay
;R6 - Armazena letra a ser impressa
;R7 - Passo de decremento da delay
;R8 - LR da linha e da ponto
;R9 - LR da Delay
;R10 - LR da MORSE
;R11 -
;R12 -
;R13 - 
;R14 - 
;R15 - PC


		 
		 ADD R2, R0, #0xFF  ; R2=0xFF
		 STR R2, [R0, #0x804] ; Escreve FF no reg de dir do GPIOem 804h
 		 STR R2, [R0, #0x804] ; Escreve FF no reg de dir do GPIOem 804h
		 
		add r6,r0,#'P'
		add r10,r0,r15
		b MORSE
		
		add r6,r0,#'A'
		add r10,r0,r15
		b MORSE
		
		add r6,r0,#'I'
		add r10,r0,r15
		b MORSE



FIM
		B FIM

MORSE

		add r1,r6,#0

		
		subs r3,r1,#65
		beq CHARA 
		subs r3,r1,#66
		beq CHARB 
		subs r3,r1,#67
		beq CHARC 
		subs r3,r1,#68
		beq CHARD 
		subs r3,r1,#69
		beq CHARE 
		subs r3,r1,#70
		beq CHARF 
		subs r3,r1,#71
		beq CHARG 
		subs r3,r1,#72
		beq CHARH 
		subs r3,r1,#73
		beq CHARI 
		subs r3,r1,#74
		beq CHARJ 
		subs r3,r1,#75
		beq CHARK 	
		subs r3,r1,#76
		beq CHARL 
		subs r3,r1,#77
		beq CHARM 
		subs r3,r1,#78
		beq CHARN 
		subs r3,r1,#79
		beq CHARO 
		subs r3,r1,#80
		beq CHARP 
		subs r3,r1,#81
		beq CHARQ 
		subs r3,r1,#82
		beq CHARR 
		subs r3,r1,#83
		beq CHARS 
		subs r3,r1,#84
		beq CHART 
		subs r3,r1,#85
		beq CHARU 
		subs r3,r1,#86
		beq CHARV 
		subs r3,r1,#87
		beq CHARW 
		subs r3,r1,#88
		beq CHARX 
		subs r3,r1,#89
		beq CHARY 
		subs r3,r1,#90
		beq CHARZ 
		
; para imprimir os 	   4 -> 0xF
; para imprimir apenas 3 -> 0xE
; para imprimir apenas 2 -> 0xC
; para imprimir apenas 1 -> 0x8

; 0xC4 ".-",   // A
; 0xF8 "-...", // B
; 0xFA "-.-.", // C
; 0xE8 "-..",  // D
; 0x80 ".",    // E
; 0xF2 "..-.", // F
; 0xEC "--.",  // G
; 0xF0 "....", // H
; 0xC0 "..",   // I
; 0xF7 ".---", // J
; 0xEA "-.-",  // K
; 0xF4 ".-..", // L
; 0xCF "--",   // M
; 0xC8 "-.",   // N
; 0xEF "---",  // O
; 0xF6 ".--.", // P
; 0xFD "--.-", // Q
; 0xE4 ".-.",  // R
; 0xE0 "...",  // S
; 0x8F "-",    // T
; 0xE2 "..-",  // U
; 0xF1 "...-", // V
; 0xE6 ".--",  // W
; 0xF9 "-..-", // X
; 0xFB "-.--", // Y
; 0xFC "--.."  // Z 		
		

CHARA
		add r1,r0,#0xC4
		b imprima

CHARB
		add r1,r0,#0xF8
		b imprima

CHARC
		add r1,r0,#0xFA
		b imprima
		
CHARD
		add r1,r0,#0xE8
		b imprima
		
CHARE
		add r1,r0,#0x80
		b imprima
		
CHARF
		add r1,r0,#0xF2
		b imprima
		
CHARG
		add r1,r0,#0xEC
		b imprima
		
CHARH
		add r1,r0,#0xF0
		b imprima
		
CHARI
		add r1,r0,#0xC0
		b imprima
		
CHARJ
		add r1,r0,#0xF7
		b imprima
		
CHARK
		add r1,r0,#0xEA
		b imprima
		
CHARL
		add r1,r0,#0xF4
		b imprima
		
CHARM
		add r1,r0,#0xCF
		b imprima
		
CHARN
		add r1,r0,#0xC8
		b imprima
		
CHARO
		add r1,r0,#0xEF
		b imprima
		
CHARP
		add r1,r0,#0xF6
		b imprima
		
CHARQ
		add r1,r0,#0xFD
		b imprima
		
CHARR
		add r1,r0,#0xE4
		b imprima
		
CHARS
		add r1,r0,#0xE0
		b imprima
		
CHART
		add r1,r0,#0x8F
		b imprima
		
CHARU
		add r1,r0,#0xE2
		b imprima
		
CHARV
		add r1,r0,#0xF1
		b imprima
		
CHARW
		add r1,r0,#0xE6
		b imprima
		
CHARX
		add r1,r0,#0xF9
		b imprima
		
CHARY
		add r1,r0,#0xFB
		b imprima
		
CHARZ
		add r1,r0,#0xFC
		b imprima
		
imprima

		ands r3,r1,#0x08
    	add r8,r0,r15
		beq ponto
		ands r3,r1,#0x08
    	add r8,r0,r15
		bne linha

		ands r3,r1,#0x40
		beq fimchar

		ands r3,r1,#0x04
    	add r8,r0,r15
		beq ponto
		ands r3,r1,#0x04
		add r8,r0,r15
		bne linha
		
		ands r3,r1,#0x20
		beq fimchar
		
		
		ands r3,r1,#0x02
        add r8,r0,r15
		beq ponto
		ands r3,r1,#0x02
		add r8,r0,r15
		bne linha

		ands r3,r1,#0x10
		beq fimchar
		
		ands r3,r1,#0x01
    	add r8,r0,r15
        beq ponto
		ands r3,r1,#0x01
		add r8,r0,r15
		bne linha

fimchar
		 ;ADD R2, R0, #0x55  ; R2=0xFF
		 ;STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
		 ;STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h

		 add r9,r0,r15
		 b delay
		 add r9,r0,r15
		 b delay
		add r15,r10,#0		

		;add r6,r6,#1
		
		;add r1,r6,#0
		;subs r3,r1,#91
		;addeq r6,r0,#65
		;b MAIN

ponto		

		 ADD R2, R0, #0x01  ; R2=0xFF
		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
		 
		 add r9,r0,r15
		 b delay
		 
		 ADD R2, R0, #0x00  ; R2=0xFF
		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h

		 add r9,r0,r15
		 b delay

		add r15,r8,#0		
		
		
linha		

		 ADD R2, R0, #0x01  ; R2=0xFF
		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
	 
		 add r9,r0,r15
		 b delay
		add r9,r0,r15
		 b delay
		add r9,r0,r15
		 b delay
			 
		 ADD R2, R0, #0x00  ; R2=0xFF
		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h

		 add r9,r0,r15
		 b delay

		add r15,r8,#0		
		
delay
		sub r4,r15,r15
		sub r5,r4,#1
delayi
		subs r5,r5,r7
		bvc delayi
		add r15,r9,#0		
delayend    

         END                ; Mark end of fil