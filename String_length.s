@	Subroutine String_length: This method accepts the address of a string and counts the 
@		characters in the string, excluding the NULL character and returns value as an
@		int (word) in R0. 
@	R1: Points to first byte of the string
@	LR: Contains the return address

@	Returned register contents:
@	R0: Length of the string.
@	All registers except R0 are preserved.
.text

        .global String_length		@ Pass entry point name to linker.
        
String_length:      
	push { R1-R2, R4-R8, R10, R11 }	@ AAPC Preserve r4-r8, r10, r11
	push { sp }			@ Push stack pointer
			
	mov	R0, #0			@ R0 will store the running length of the string.
nxtchar:
	ldrb	R2,[R1],#1		@ Load next character from string.
	subs	R2, #0			@ Subtract the null bias.
	beq	return			@ if (zero flag is set)
					@	branch to print section
					@ else
	add	R0, #1			@ 	increment length by 1
	b	nxtchar			@ 	branch to top of loop
			
return:	
	pop { sp }			@ Pop stack pointer
	pop { R1-R2, R4-R8, R10, R11 }	@ AAPC Restore r4-r8, r10, r11
	bx      LR             		@ Return to the calling program.
	.end
