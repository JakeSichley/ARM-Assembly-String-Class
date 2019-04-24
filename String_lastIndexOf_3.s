@	Subroutine String_lastIndexOf_3: This method accepts a string and a prefix.
@		It returns the last matching index of that prefix, or -1 if the character
@		is not found.
@
@	R0: Contains the address of string 1
@	R1: Contains the address of the prefix
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Matching index
@	All Register contents are preserved R0 - R3
.data
iStrLenA:		.word 0
iStrLenB:		.word 0
pStrA:			.word 0
pStrB:			.word 0
iIndex:			.word 0
iResult:		.word 0

.text
	.global	String_lastIndexOf_3
	
String_lastIndexOf_3:
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
@	Populate result variable
	ldr r0, =-1			@ Load #-1 into r0
	ldr r1, =iResult	@ Load the address of iResult into r1
	str r0, [r1]		@ Store the value of r0 into r1
@	Comparison Loops
cmp_loop:
@	Reload variable values
	ldr r0, =pStrA		@ Load the address of *strA into r0	
	ldr r0, [r0]		@ Load the value of r0 into r0
	ldr	r1, =pStrB		@ Load the address of *strB into r1
	ldr r1, [r1]		@ Load the value of r1 into r1
	ldrb r1, [r1], #1	@ Load the first byte of strB into r1
	ldr r2, =iIndex		@ Load the address of iIndex into r2
	ldr r2, [r2]		@ Load the value of r2 into r2
@	Check for possible substring
	bl	String_indexOf_2	@ Get the index of the first character of the prefix	
	cmp r0,	#0			@ Compare index result vs #-1
	bmi	end				@ If negative, there is not a match
@	If there is a match, create a substring from that index
	ldr r1, =iIndex		@ Load the address of iIndex into r1
	str r0, [r1]		@ Store the value of r0 into r1
@	Check to see if the prefix matches
	ldr r0, =pStrA		@ Load the address of *strA into r0	
	ldr r0, [r0]		@ Load the value of r0 into r0
	ldr r1, =pStrB		@ Load the address of *strB into r1	
	ldr r1, [r1]		@ Load the value of r1 into r1
	ldr r2, =iIndex		@ Load the address of iIndex into r2
	ldr r2, [r2]		@ Load the value of r2 into r2
	bl	String_startsWith_1	@ Call subroutine to see if the string starts with that prefix
	cmp r0, #1			@ Check for true (1)
	beq	match			@ Branch if equal	
	ldr r1, =iIndex		@ Else, load the address of iIndex into r1
	ldr r0, [r1]		@ Load the value of r1 into r0
	add	r0, r0, #1		@ Increment r0 by 1
	str r0, [r1]		@ Store the value back into iIndex
	b	cmp_loop		@ Continue checking	
@	Record highest matching index	
match:
	ldr r1, =iIndex		@ Else, load the address of iIndex into r1
	ldr r0, [r1]		@ Load the value of r1 into r0
	ldr r2, =iResult
	str r0, [r2]
	add	r0, r0, #1		@ Increment r0 by 1
	str r0, [r1]		@ Store the value back into iIndex
	b	cmp_loop		@ Continue checking		
@	No more possible matches, result best index
end:
	ldr r0, =iResult	@ Load the address of iResult into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
