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
Reset_Handler   PROC
                GLOBAL Reset_Handler
                ENTRY
				

main								
				subs r0,r7,r7
				subs r1,r7,r7
				adds r0,#0
				ldr r1,[r0,#0]
				subs r1,r7,r7
				adds r0,#0xFF
				str r0,[r1,#0]
				str r0,[r1,#0]
				;beq main
				;bx lr
				subs r0,r7,r7
				;ldr r1,[r0,teste]
				;adds r0, teste
				 blx r0
teste				
				endp				
        		DCD		main
				DCD		teste

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
   