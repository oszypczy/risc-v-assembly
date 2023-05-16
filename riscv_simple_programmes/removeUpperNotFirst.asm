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
	la	a0, buf			# store given string into buf
	li 	a1, 100
	ecall
	
	la 	t0, buf			# t0 is reading pointer
	li	t1, 'A'	
	li	t2, 'Z'
	la	t3, buf			# t3 is writing pointer
	li	t4, ' '			# space char to check if end of str and if new sequence has started
	li	t5, 0			# t5 is flag if first letter has been red

loop:
	lbu	t6, (t0)		# store char into t6 form reading pointer
	bltu	t6, t4, end		# exit loop if end of string
	beq 	t6, t4, sequence	# if chars is space then new sequence
	blt	t6, t1, rewrite		# if char is less than 'A' then rewrite it
	bgt	t6, t2, rewrite		# if char is greater than 'Z' then rewrite it
	beqz	t5, rewrite		# if first letter hasn't been red, rewrite it
	addi	t0, t0, 1		# only increment reading pointer (remove char)
	b 	loop

rewrite:
	li	t5, 1			# set flag to true (first letter has been red)
	sb	t6, (t3)		# rewrite char
	addi	t0, t0, 1		# increment reading pointer
	addi	t3, t3, 1		# increment writing pointer
	b 	loop

sequence:
	li	t5, 0			# new sequence -> set flag to false
	sb	t6, (t3)		# rewrite space char
	addi	t0, t0, 1		# increment reading pointer
	addi	t3, t3, 1		# increment writing pointer
	b 	loop

end:
	sb	zero, (t3)		# add null at the end of new string in buf
		
	li	a7, PRINT_STR
	la	a0, output
	ecall	
	
	li	a7, PRINT_STR
	la	a0, buf
	ecall
	
	li	a7, SYS_EXIT0
	ecall
