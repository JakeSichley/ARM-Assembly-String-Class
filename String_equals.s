@	Subroutine String_equals: This method accepts two pointers to strings
@					and returns whether or not the two strings are equal (CASE SENSATIVE)
@
@	R0: Contains the address of string 1
@	R1: Contains the address of string 2
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Bool (0 or 1)
@	All Register contents are preserved except for R0 - R3
.data
iStrLenA:		.word 0
iStrLenB:		.word 0
pStrA:			.word 0
pStrB:			.word 0

.text
	.global	String_equals

String_equals:
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
@ Compare Length
	ldr r1, =iStrLenB	@ Load the address of *strLenB into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	cmp r1, r0			@ Compare the two string lengths
	bne	false			@ Branch if not equal
@ Compare Characters
	ldr r0, =pStrA		@ Load the address of strA into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	ldr r1, =pStrB		@ Load the address of strB into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	mov r4, #0			@ Current index
	ldr r5, =iStrLenA	@ Load the address of strLenA into r5
	ldr r5, [r5]		@ Load the value of r5 into r5
cmp_loop:
	ldrb r2, [r0], #1	@ Load a byte from r0 into r2
	ldrb r3, [r1], #1	@ Load a byte from r1 into r3
	cmp r2, r3			@ Compare the bytes
	bne	false			@ Branch if not equal
	cmp r2, #0			@ Check for null (end of string)
	beq	true			@ Branch if true
	add r4, r4, #1		@ Increment index by 1
	b	cmp_loop		@ Otherwise, keep looping
false:
	mov r0, #0			@ Move #0 into r0 for false
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
true:
	mov r0, #1			@ Move #1 into r0 for true
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
