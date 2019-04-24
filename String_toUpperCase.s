@	Subroutine String_toUpperCase: This method makes a copy of a string and converts
@		the entire string to upper case.
@
@	R0: Contains the address of string 1
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Address of the dynamically allocated string
@	All Register contents are preserved except R0 - R3
.data
pStrA:			.word 0
pNewStr:		.word 0

.text
	.global	String_toUpperCase
	
String_toUpperCase:
@ 	Preserve AAPCS Registers
	push { r4-r8, r10, r11 }	@ Push AAPCS registers
	push { lr }			@ Push the link register
@ 	Store string into pointer variable
	ldr r1, =pStrA		@ Load the address of *strA into r1
	str r0, [r1]		@ Store the address of strA into *strA
@	Create new string
	bl	String_copy		@ Call subroutine to copy string
	ldr r1, =pNewStr	@ Load the address of *newStr into r1
	str r0, [r1]		@ Store the value of r0 into r1
@ 	Compare Loop
cmp_loop:
	ldrb r1, [r0], #1	@ Load a byte from the string into r3
	cmp r1, #97			@ 'a' = 97
	bmi	no_match		@ If negative, character is below 'a'
	cmp r1, #123		@ 'z' = 122 (1 above for PL)
	bpl	no_match		@ If positive, character is above 'z'
	sub r1, r1, #32		@ Subtract 32 to character (Offset between cases)
	sub	r0, r0, #1		@ Decrement address before storing byte
	strb r1, [r0], #1	@ Store a byte from r1 into r0
	b	cmp_loop		@ Byte cannot be equal to null, so keep checking
no_match:
	cmp r1, #0			@ Check for null
	bne	cmp_loop		@ If not equal, keep checking bytes
@	Return
	ldr r0, =pNewStr	@ Load the address of *strA into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
