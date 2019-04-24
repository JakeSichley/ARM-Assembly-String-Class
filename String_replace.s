@	Subroutine String_replace: This method dynamically allocates enough memory
@		for a copy of string, and replaces all occurances of a given character
@		with the specified character in the new string.
@
@	R0: Contains the address of string 1
@	R1: Contains the old character
@	R2: Contains the new character
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Address of the string passed in
@	All Register contents are preserved except R0 - R3
.data
pStrA:			.word 0
pNewStr:		.word 0

.text
	.global	String_replace
	
String_replace:
@ 	Preserve AAPCS Registers
	push { r4-r8, r10, r11 }	@ Push AAPCS registers
	push { lr }			@ Push the link register
	push { r1, r2 }		@ Push characters
@ 	Store string into pointer variable
	ldr r1, =pStrA		@ Load the address of *strA into r1
	str r0, [r1]		@ Store the address of strA into *strA
@	Create new string
	bl	String_copy		@ Call subroutine to copy string
	ldr r1, =pNewStr	@ Load the address of *newStr into r1
	str r0, [r1]		@ Store the value of r0 into r1
@	Reload characters
	pop { r1, r2 }		@ Pop old characters
@ 	Compare Loop
cmp_loop:
	ldrb r3, [r0], #1	@ Load a byte from the string into r3
	cmp r3, r1			@ Compare to old character
	beq	replace			@ Branch if equal
	cmp r3, #0			@ Check current byte vs null character
	beq	return			@ Branch if equal
	b	cmp_loop		@ Else, continue checking bytes
replace:
	sub	r0, r0, #1		@ Decrement index before replacement
	strb r2, [r0], #1	@ Store the new character into the location of the old character
	b	cmp_loop		@ Continue checking bytes
@	Return
return:
	ldr r0, =pNewStr	@ Load the address of *strA into r0
	ldr r0, [r0]		@ Load the value of r0 into r0
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
