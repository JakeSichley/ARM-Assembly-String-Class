@	Subroutine String_startsWith_1: This method accepts a string, a prefix (string), and
@		and index. It checks whether or not the first string has prefix at the given index.
@
@	R0: Contains the address of string 1
@	R1: Contains the address of the prefix
@	R2: Contains the desired index
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Bool (0 or 1)
@	All Register contents are preserved R0 - R3
.data
iStrLenA:		.word 0
iStrLenB:		.word 0
iIndex:			.word 0
pStrA:			.word 0
pStrB:			.word 0
pNewStr:		.word 0
sStr:			.skip 12

.text
	.global	String_startsWith_1
	
String_startsWith_1:
@ 	Preserve AAPCS Registers
	push { r4-r8, r10, r11 }	@ Push AAPCS registers
	push { lr }			@ Push the link register
@ 	Store the index		@ Pop the index
	ldr r3, =iIndex		@ Load the address of iIndex into r1
	str r2, [r3]		@ Store the value of r2 into r1	
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
@ 	Create substring for comparison
	ldr r0, =pStrA		@ Load the address of *strA into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	ldr r1, =iIndex		@ Load the address of iIndex into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	ldr r2, =iStrLenB	@ Load the address of iStrLenB into r2
	ldr r2, [r2]		@ Load the value of r2 into r2
	add r2, r1, r2		@ Compute offset for ending index
	sub r2, r2, #1		@ Substract 1 from ending index
	bl	String_substring_1	@ Create substring
@	Compare substrings
	ldr r1, =pNewStr	@ Load the address of *newStr into r1
	str r0, [r1]		@ Load the value of r0 into r1
	ldr r1, =pStrB		@ Load the adress of *strB into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	bl	String_equals	@ Call subroutine to compare strings
	push { r0 } 		@ Save result
	ldr r0, =pNewStr	@ Load the address of *newStr into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	bl	free			@ Free the memory of our new substring
@	Return
	pop	{ r0 } 			@ Pop result
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
