@	Subroutine String_equalsIgnoreCase: This method accepts two pointers to strings
@					and returns whether or not the two strings are equal (CASE INSENSATIVE)
@
@	R0: Contains the address of string 1
@	R1: Contains the address of string 2
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Bool (0 or 1)
@	All Register contents are preserved except R0 - R3
.data
pLStrA:			.word 0
pLStrB:			.word 0
pStrA:			.word 0
pStrB:			.word 0

.text
	.global	String_equalsIgnoreCase
	.extern malloc
	.extern free
	
String_equalsIgnoreCase:
@ 	Preserve AAPCS Registers
	push { r4-r8, r10, r11 }	@ Push AAPCS registers
	push { lr }			@ Push the link register	
@ 	Store variables into pointer variables
	ldr r2, =pStrA		@ Load the address of *strA into r2
	str r0, [r2]		@ Store the address of strA into *strA
	ldr r2, =pStrB		@ Load the address of *strB into r2
	str r1, [r2]		@ Store the address of strB into *strB
@	Convert strings to lower case for comparison
	bl	String_toLowerCase	@ Call subroutine to convert string A to lower case
	ldr r1, =pLStrA		@ Load the address of *lStrA into r1
	str r0, [r1]		@ Store the value of r0 into r1
	ldr r0, =pStrB		@ Load the address *strB into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	bl	String_toLowerCase	@ Call subroutine to convert string B to lower case
	ldr r1, =pLStrB		@ Load the address of *lStrB into r1
	str r0, [r1]		@ Store the value of r0 into r1
@	Compare strings
	ldr r1, =pLStrA		@ Load the address of *lStrA into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	bl	String_equals	@ Call subroutine to compare strings
	push { r0 }			@ Push result
@	Free memory used by lower case strings
	ldr r0, =pLStrA		@ Load the address of *lStrA into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	bl	free			@ Call subroutine to free memory
	ldr r0, =pLStrB		@ Load the address of *lStrB into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	bl	free			@ Call subroutine to free memory
@	Return
	pop { r0 }			@ Pop result
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
	
