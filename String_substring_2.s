@	Subroutine String_substring_2: This creates a substring based on a starting index.
@		String::Substring(start, Length). A dynamically allocated string is created.
@
@	R0: Contains the address of string 1
@	R1: Contains the starting index
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Dynamically allocated substring address
@	All Register contents are preserved except R0 - R3
.data
iStrLenA:		.word 0
iStart:			.word 0
pStrA:			.word 0
pNewStr:		.word 0

.text
	.global	String_substring_2
	.extern malloc
	.extern free
	
String_substring_2:
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
@	Allocate new memory { Length = (Length - Start) + 1 }
	ldr r1, =iStart		@ Load the address of iStart into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	sub r0, r0, r1		@ Calculate Length - Starting index
	add r0, r0, #1		@ Increment length to account for null
	bl	malloc			@ Call subroutine to allocate memory
	ldr r1, =pNewStr	@ Load the address of *newStr into r1
	str r0, [r1]		@ Store the value of r0 into r1
@	Prepare for loop (copy)
	ldr r1, =pStrA		@ Load the address of *strA into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	ldr r2, =iStart		@ Load the address of iStart into r2
	ldr r2, [r2]		@ Load the value of r2 into r2
	add r1, r1, r2		@ Offset start by starting index
@	Copy loop
copy_loop:
	ldrb r3, [r1], #1	@ Load a byte from r1 into r2
	strb r3, [r0], #1	@ Store a byte from r2 into r0
	cmp r3, #0			@ Compare current byte vs null
	bne	copy_loop		@ If not equal, continue copying bytes
@	Return
	ldr r0, =pNewStr	@ Load the address of *newStr into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
