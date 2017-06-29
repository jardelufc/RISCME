; Vector Table Mapped to Address 0 at Reset

						PRESERVE8
                		THUMB

        				AREA	RESET, DATA, READONLY	  			; First 32 WORDS is VECTOR TABLE
        				EXPORT 	__Vectors
					
__Vectors		    	;DCD		0x000003FC							; 1K Internal Memory
        				;DCD		Reset_Handler
        				;DCD		0  			
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD 	0
        				;DCD		0
        				;DCD		0
        				;DCD 	0
        				;DCD		0
        				
        				; External Interrupts
						        				
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
        				;DCD		0
                AREA |.text|, CODE, READONLY
;Reset Handler
fdelay equ 4
gpio equ 8
gpiodir equ 12

Reset_Handler   PROC
                GLOBAL Reset_Handler
                ENTRY
				b main
        		b main
				DCD		delay ; delay equ 4
				DCD     0x800 ; gpio  equ 8
				DCD     0x804 ; gpiodir  equ 12

;R0 sempre em zero
;R1 gpio
;R2 
;R3 
;R4
;R5 temporário
;R6 delay
;R7 inicializacao do contador

main
		 SUBS R0, R7, R7 	; R0 = 0						1110 000 0010 0 1111 0000 0000 0000 1111 E04F000F 0x00
		 SUBS R7, R7, R7  ; R2=0xFF
		 adds r7,#255
		 adds r7,#255
		 adds r7,#255
		 
		 ADDS R2, #0xFF  ; R2=0xFF
		 ldr r1,[r0,#gpiodir]
		 ldr r1,[r0,#gpiodir]
		 STR R2, [R1] ; Escreve FF no reg de dir do GPIOem 804h
 		 STR R2, [R1] ; Escreve FF no reg de dir do GPIOem 804h
		 ldr r1,[r0,#gpio]
		 ldr r1,[r0,#gpio]
		 ldr r6,[r0,#fdelay]
		 ldr r6,[r0,#fdelay]
		 
MAINA
		 SUBS R2,R7,R7
		 ADDS R2, #0x55  ; R2=0xFF
		 STR R2, [R1] ; Escreve FF no reg de dir do GPIOem 804h
 		 STR R2, [R1] ; Escreve FF no reg de dir do GPIOem 804h
		 
		 blx r6; b delay
		 
		 SUBS R2,R7,R7		
   		 ADDS R2, #0xAA  ; R2=0xFF
		 STR R2, [R1] ; Escreve FF no reg de dir do GPIOem 804h
 		 STR R2, [R1] ; Escreve FF no reg de dir do GPIOem 804h


		 blx r6; b delay
		 
		 b MAINA

		endp
; seta porta em FF
		 ;ADDS R2, #0xFF  ; R2=0xFF
		 ;STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h
 		 ;STR R2, [R0, #0x800] ; Escreve FF no reg de dir do GPIOem 804h

delay
		subs r5,r7,r7
		subs r5,#1
delayi
		subs r5,r5,r7
		bvc delayi
		bx lr ; adds r15,r14,#0		
delayend    


         END                ; Mark end of fil