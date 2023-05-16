	.globl main

	.eqv	READ_STR, 8
	.eqv	PRINT_STR, 4
	.eqv	SYS_EXIT0, 10

	.data
input:	.asciz "Enter string: "
output:	.asciz "Output: "
buf:	.space 100

	.text
main:
	li	a7, PRINT_STR
	la 	a0, input
	ecall
	
	li	a7, READ_STR
	la	a0, buf	
	li 	a1, 100
	ecall
	
	la 	t0, buf			# reading and writing pointer
	li	t1, 'a'	
	li	t2, 'z'
	li	t3, 0x20		# 0x20 = 32 is the distance between lower and upper char in ASCII
	li	t5, ' '			# space char to end the loop
loop:
	lbu	t4, (t0)		# load char into t4
	bltu	t4, t5, end		# if char smaller than space (\n) - end of string
	blt	t4, t1, skip		# if char not a small letter then skip
	bgt	t4, t2, skip		# if char not a small letter then skip
	sub	t4, t4, t3		# upper() for char in t4 into t4
	sb	t4, (t0)		# store uppered letter into buf
skip:
	addi	t0, t0, 1		# increment reading/writing pointer 
	b	loop
end:
	li	a7, PRINT_STR
	la	a0, output
	ecall	
	
	li	a7, PRINT_STR
	la	a0, buf
	ecall
	
	li	a7, SYS_EXIT0
	ecall
	
	
