@	Subroutine String_lastIndexOf_1: This method accepts a string and a character. It
@		returns the last matching index of that character, or -1 if the character
@		is not found.
@
@	R0: Contains the address of string 1
@	R1: Contains the address of the character
@	LR: Contains the return address
@
@	Returned Register Contents:
@	R0: Matching index
@	All Register contents are preserved R0 - R3

.text
	.global	String_lastIndexOf_1
	
String_lastIndexOf_1:
@ 	Preserve AAPCS Registers
	push { r4-r8, r10, r11 }	@ Push AAPCS registers
	push { lr }			@ Push the link register
	mov r3, #0			@ Move #0 into r3
	mov r4, #-1			@ Load #-1 into r4
@	Compare Loop
cmp_loop:
	ldrb r2, [r0], #1		@ Load a byte from r0 into r2
	cmp r1, r2			@ Compare the byte from r0 to the desired character
	beq	match			@ Branch if equal
mid_loop:
	add r3, #1			@ Else, increment index
	cmp r2, #0			@ Compare the byte vs null
	beq	return			@ If null, stop checking
	b	cmp_loop		@ Else, continue checking bytes
match:
	mov r4, r3			@ Move the current index into r4 (match holder)
	b	mid_loop		@ Branch to mid_loop
return:
	cmp r4, #0			@ Compare match holder with #0
	bmi	false			@ If negative, no match was found
	mov r0, r4			@ Move the index to r0
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
false:
	ldr r0, =-1			@ Load #-1 into r0 (no match)
	pop { lr }			@ Pop the link register
	pop { r4-r8, r10, r11}	@ Pop AAPCS registers
	bx	lr				@ Return to calling program
	.end
