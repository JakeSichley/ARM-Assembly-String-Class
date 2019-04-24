@	Subroutine String_charAt: This method returns the character at the specified
@		index. If the index is invalid, it returns -1
@
@	R0: Contains the address of string 1
@	R1: Contains the desired index
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Character at the specified index
@	All Register contents are preserved except R0 - R3
.data
iStrLenA:		.word 0
iStart:			.word 0
pStrA:			.word 0
pNewStr:		.word 0

.text
	.global	String_charAt
	
String_charAt:
@ 	Preserve AAPCS Registers
	push { r4-r8, r10, r11 }	@ Push AAPCS registers
	push { lr }			@ Push the link register
	push { r1 }			@ Push Index
@ 	Store string into pointer variable
	ldr r1, =pStrA		@ Load the address of *strA into r1
	str r0, [r1]		@ Store the address of strA into *strA
@	Store Indexes
	pop { r1 }			@ Pop Index
	ldr r0, =iStart		@ Load the address of iStart into r0
	str r1, [r0]		@ Store the value of r1 into r0
@	Calculate string Length
	ldr r1, =pStrA		@ Load the address of *strA into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	bl	String_length	@ Call subroutine to get string length
	ldr r1, =iStrLenA	@ Load the address of *strLenA into r1
	str r0, [r1]		@ Store the value of r0 into r1
@	Check Bounds
	ldr r1, =iStart		@ Load the address of iStart into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	cmp r1, #0			@ Check for negative
	bmi	error			@ Branch if negative
	cmp	r0, r1			@ Check for out of bounds index ( > length)
	bmi	error			@ Branch if negative
@	Valid index, offset by index
	ldr r0, =pStrA		@ Load *strA into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	add r0, r0, r1		@ Offset by index
	ldrb r0, [r0], #1	@ Load a byte from r0 into r0
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
error:
	ldr r0, =-1			@ Load #-1 into r0 to signal bad index
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
