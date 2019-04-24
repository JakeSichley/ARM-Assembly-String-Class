@	Subroutine String_indexOf_1: This method accepts a string and a character. It
@		returns the first matching index of that character, or -1 if the character
@		is not found.
@
@	R0: Contains the address of string 1
@	R1: Contains the address of the character
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Matching index
@	All Register contents are preserved R0 - R3

.text
	.global	String_indexOf_1
	
String_indexOf_1:
@ 	Preserve AAPCS Registers
	push { r4-r8, r10, r11 }	@ Push AAPCS registers
	push { lr }			@ Push the link register
	mov r3, #0			@ Move #0 into r3
@	Compare Loop
cmp_loop:
	ldrb r2, [r0], #1		@ Load a byte from r0 into r2
	cmp r1, r2			@ Compare the byte from r0 to the desired character
	beq	true			@ Branch if equal
	add r3, #1			@ Else, increment index
	cmp r2, #0			@ Compare the byte vs null
	bne	cmp_loop		@ If not null, continue checking
	ldr r3, =-1			@ Else, load a #-1 in r3
true:
	mov r0, r3			@ Move the index to r0
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
