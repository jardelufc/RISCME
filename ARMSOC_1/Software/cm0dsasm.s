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
delay equ 4
gpio equ 12

Reset_Handler   PROC
                GLOBAL Reset_Handler
                ENTRY
				b main
        		b main
				DCD		teste ; delay
				DCD     0x800 ; gpio
main				
				subs r0,r7,r7
				subs r1,r7,r7
				subs r3,r7,r7
				subs r4,r7,r7
				adds r3,#0x55
				adds r4,#0xAA
				orrs r3,r4
                beq main
				ldr r3,[r0,#delay]
				ldr r3,[r0,#delay]
				blx r3
				;adds r0, teste
				b main
				nop
				nop
				nop
				nop
				nop
				nop
teste			
				subs r0,r7,r7
				ldr r1,[r0,#gpio]
				ldr r1,[r0,#gpio]
				subs r2,r7,r7
				adds r2,#0xFF
				str r2,[r1]
				str r2,[r1]
				str r2,[r1]

				bx lr
				endp				


		END         


				;ADDS <Rd>,<Rn>,<Rm>
				;SUBS <Rd>,<Rn>,<Rm>
				
				;ANDS <Rdn>,<Rm>
				;ORRS <Rdn>,<Rm>

				;ADDS <Rdn>,#<imm8>
				;SUBS <Rdn>,#<imm8>

				;LDR <Rt>, [<Rn>{,<imm5>}]
				
				;STR <Rt>, [<Rn>{,<imm5>}]

				;B<c> <label>
				;B      <label>
				;BLX <Rm>
				;BX <Rm>
   