@	Subroutine String_indexOf_2: This method accepts a string, a character, and an index.
@		It returns the first matching index of that character starting with the provided
@		index, or -1 if the character is not found.
@
@	R0: Contains the address of string 1
@	R1: Contains the address of the character
@	R2: Contains the starting index
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Matching index
@	All Register contents are preserved except R0 - R3
.data
iStrLenA:		.word 0
iStart:			.word 0
pStrA:			.word 0
pNewStr:		.word 0
cChar:			.byte 0

.text
	.global	String_indexOf_2
	
String_indexOf_2:
@ 	Preserve AAPCS Registers
	push { r4-r8, r10, r11 }	@ Push AAPCS registers
	push { lr }			@ Push the link register
	push { r2 }			@ Push Index
@ 	Store string into pointer variable
	ldr r2, =pStrA		@ Load the address of *strA into r2
	str r0, [r2]		@ Store the address of strA into *strA
@	Store character into char variable
	ldr r2, =cChar		@ Load the address of cChar into r2
	str r1, [r2]		@ Store the value of r1 into r2
@	Store Indexes
	pop { r2 }			@ Pop Index
	ldr r0, =iStart		@ Load the address of iStart into r0
	str r2, [r0]		@ Store the value of r1 into r0
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
@ 	Prepare for compare loop
	ldr r3, =iStart		@ Load the address of iStart into r3
	ldr r3, [r3]		@ Load the value of r3 into r3
	ldr r1, =cChar		@ Load the address of cChar into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
@	Compare Loop
cmp_loop:
	ldrb r2, [r0], #1	@ Load a byte from r0 into r2
	cmp r1, r2			@ Compare the byte from r0 to the desired character
	beq	true			@ Branch if equal
	add r3, #1			@ Else, increment index
	cmp r2, #0			@ Compare the byte vs null
	bne	cmp_loop		@ If not null, continue checking
@	Invalid offset or character not found	
error:
	ldr r0, =-1			@ Load #-1 into r0 to signal bad index
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
@ Character found
true:
	mov r0, r3			@ Move the current index to r0
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
