@	Subroutine String_concat: This method accepts two pointers to strings
@		and dynamically allocates enough memory to append them to each other.
@
@	R0: Contains the address of string 1
@	R1: Contains the address of string 2
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Address of the concatenated string
@	All Register contents are preserved except for R0 - R3
.data
iStrLenA:		.word 0
iStrLenB:		.word 0
pStrA:			.word 0
pStrB:			.word 0
pNewStr:		.word 0

.text
	.global	String_concat
	.extern malloc
	.extern free

String_concat:
@ 	Preserve AAPCS Registers
	push { r4-r8, r10, r11 }	@ Push AAPCS registers
	push { lr }			@ Push the link register	
@ 	Store variables into pointer variables
	ldr r2, =pStrA		@ Load the address of *strA into r2
	str r0, [r2]		@ Store the address of strA into *strA
	ldr r2, =pStrB		@ Load the address of *strB into r2
	str r1, [r2]		@ Store the address of strB into *strB
@	Calculate string Length
	bl	String_length	@ Call subroutine to get string length
	ldr r1, =iStrLenB	@ Load the address of *strLenB into r1
	str r0, [r1]		@ Store the value of r0 into r1
	ldr r1, =pStrA		@ Load the address of *strA into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	bl	String_length	@ Call subroutine to get string length
	ldr r1, =iStrLenA	@ Load the address of *strLenA into r1
	str r0, [r1]		@ Store the value of r0 into r1
@ 	Calculate new length
	ldr r1, =iStrLenB	@ Load the address of iStrLenB into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	add	r0, r0, r1		@ Add the two lengths together
	add r0, r0, #1		@ Add #1 to the length to account for null
@	Allocate memory and store pointer
	bl	malloc			@ Call subroutine to dynamically allocate memory
	ldr r1, =pNewStr	@ Load the address of *newStr into r1
	str r0, [r1]		@ Store the value of r0 into r1
@	First copy loop
	ldr r1, =pStrA		@ Load the address of *strA into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
cmp_loop_1:
	ldrb r2, [r1], #1	@ Load a byte from r1 into r2
	cmp	r2, #0			@ Check for null
	beq	copy_loop_2		@ If equal, branch to next copy loop
	strb r2, [r0], #1	@ Else, store a byte from r2 into r0
	b	cmp_loop_1		@ Continue storing bytes
@	Second copy loop
copy_loop_2:
	ldr	r1, =pStrB		@ Load the address of *strB into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
cmp_loop_2:
	ldrb r2, [r1], #1	@ Load a byte from r1 into r2
	strb r2, [r0], #1	@ Store a byte from r2 into r0
	cmp r2, #0			@ Check for null character
	bne	cmp_loop_2		@ If not equal, keep storing bytes
@	Return				@ Else, return
	ldr r0, =pNewStr	@ Load the address of *newStr into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
