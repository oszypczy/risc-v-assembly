	.global main
	
	.eqv	READ_STR, 8
	.eqv	PRINT_STR, 4
	.eqv	SYS_EXIT0, 10
	
	.data
input:	.asciz "Enter string: "
output: .asciz "Output: "
buf:	.space 100

	.text
main:	
	li	a7, PRINT_STR
	la	a0, input
	ecall
	
	li	a7, READ_STR
	la	a0, buf			# store inout into buf
	li	a1, 100
	ecall
	
	la	t0, buf			# reading pointer
	li	t1, '0'
	li	t2, '9'
	la	t3, buf			# writing pointer
	li	t5, ' '			# space char to check if end of str
	
loop:
	lbu	t4, (t0)		# read char
	bltu	t4, t5, end		# if char less than space then end of str
	blt	t4, t1, copy		# if char not a number then copy
	bgt	t4, t2, copy		# if char not a number then copy
	addi	t0, t0, 1		# only inrement reading pointer (remove char)
	b 	loop
copy:	
	sb	t4, (t3)		# rewrite char into buf using writing pointer
	addi	t0, t0, 1		# inrement reading pointer
	addi	t3, t3, 1		# inrement writing pointer
	b	loop
end:
	sb	zero, (t3)		# add null terminator at the end of new string

	li	a7, PRINT_STR
	la	a0, output
	ecall
	
	li	a7, PRINT_STR
	la	a0, buf
	ecall
	
	li	a7, SYS_EXIT0
	ecall
