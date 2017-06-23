        AREA     ARMex, CODE, READONLY
                                ; Name this block of code ARMex
        ENTRY                   ; Mark first instruction to execute
MAIN
		 SUB R0, R15, R15 	; R0 = 0						1110 000 0010 0 1111 0000 0000 0000 1111 E04F000F 0x00
		 SUB R7, R15, r15  ; R2=0xFF
		 add r7,r7,#255
		 add r7,r7,#255
		 add r7,r7,#255
		 
		 ADD R2, R0, #0xFF  ; R2=0xFF
		 STR R2, [R0, #0x804] ; Escreve FF no reg de dir do GPIOem 804h
 		 STR R2, [R0, #0x804] ; Escreve FF no reg de dir do GPIOem 804h
MAINA
		 ADD R2, R0, #0x55  ; R2=0xFF
		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
 		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
		 
		 add r14,r0,r15
		 b delay
		 
		 ADD R2, R0, #0xAA  ; R2=0xFF
		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
 		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h

		 add r14,r0,r15
		 b delay
		 
		 b MAINA
		 

; seta porta em FF
		 ADD R2, R0, #0xFF  ; R2=0xFF
		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
 		 STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h

delay
		sub r4,r15,r15
		sub r5,r4,#1
delayi
		subs r5,r5,r7
		bvc delayi
		add r15,r14,#0		
delayend    

         END                ; Mark end of fil