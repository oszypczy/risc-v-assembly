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
	la	a0, buf			# store input into buf
	li	a1, 100
	ecall
	
	la	t0, buf			# reading pointer
	li	t1, '0'
	li	t2, '9'
	la	t3, buf			# num pointer
	
loop:
	lbu	t4, (t0)		# read char
	beqz 	t4, end			# end of str
	blt	t4, t1, nextchar	# if char not a number then look for next digit
	bgt	t4, t2, nextchar	# if char not a number then look for next digit
	mv	t3, t0			# t3 pointing to the same adress as t0
	b 	lookforpair

nextchar:
	addi	t0, t0, 1		# increment reading pointer
	b 	loop
	
lookforpair:
	addi	t3, t3, 1		# move t3 to next char
	lbu	t5, (t3)		# load char to t5
	beqz 	t5, end			# end of str
	blt	t5, t1, lookforpair	# if char not a number then look for next digit
	bgt	t5, t2, lookforpair	# if char not a number then look for next digit
	
swap:
	sb	t4, (t3)		# swap numbers
	sb 	t5, (t0)		# swap numbers
	mv	t0, t3			# set t0 to t3
	addi	t0, t0, 1
	b 	loop

end:
	li	a7, PRINT_STR
	la	a0, output
	ecall
	
	li	a7, PRINT_STR
	la	a0, buf
	ecall
	
	li	a7, SYS_EXIT0
	ecall