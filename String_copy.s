@	Subroutine String_copy: This method accepts a pointer to a string and
@		dynamically allocates enough memory for a new copy.
@
@	R0: Contains the address of string 1
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Pointer to the newly allocated string
@	All Register contents are preserved except for R0
.data
iStrLenA:		.word 0
pStrA:			.word 0
pNewStr:		.word 0

.text
	.global	String_copy	
	.extern malloc
	.extern free
	
String_copy:
@ 	Preserve AAPCS Registers
	push { r4-r8, r10, r11 }	@ Push AAPCS registers
	push { lr }			@ Push the link register	
@ 	Store string into pointer variable
	ldr r1, =pStrA		@ Load the address of *strA into r1
	str r0, [r1]		@ Store the address of strA into *strA
	mov r1, r0			@ Move r0 into r1
@	Calculate string Length
	bl	String_length	@ Call subroutine to get string length
	ldr r1, =iStrLenA	@ Load the address of *strLenA into r1
	str r0, [r1]		@ Store the value of r0 into r1
@	Allocate new memory
	add r0, #1			@ Increment length to account for null
	bl	malloc			@ Call subroutine to allocate memory
	ldr r1, =pNewStr	@ Load the address of *newStr into r1
	str r0, [r1]		@ Store the value of r0 into r1
@	Prepare for loop (copy)
	ldr r1, =pStrA		@ Load the address of *strA into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
@	Copy loop
copy_loop:
	ldrb r2, [r1], #1	@ Load a byte from r1 into r2
	strb r2, [r0], #1	@ Store a byte from r2 into r0
	cmp r2, #0			@ Compare current byte vs null
	bne	copy_loop		@ If not equal, continue copying bytes
@	Return
	ldr r0, =pNewStr	@ Load the address of *newStr into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
