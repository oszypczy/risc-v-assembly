	.globl main
	.data
	
	.eqv	PRINT_STR, 4
	.eqv	READ_STR, 8
	.eqv	SYS_EXIT0, 10
	
prompt:	.asciz "Enter String: "
header:	.asciz "The longest number: "
buff:	.space 100

	.text
main:
	li	a7, PRINT_STR
	la	a0, prompt
	ecall
	
	li	a7, READ_STR
	la	a0, buff
	li	a1, 100
	ecall

	la	t0, buff		# reading pointer
	mv	t1, zero		# current size
	la	t2, buff		# longest-array pointer
	mv	t3, zero		# maximal size
	li	t5, '0'
	li	t6, '9'		

loop:
	lbu	t4, (t0)		# current character
	beqz	t4, end			# if end of string go to end
	blt	t4, t5, not_digit	# if less than 0 - not a digit
	bgt	t4, t6, not_digit	# if greater than 9 - not a digit
	addi	t1, t1, 1		# increment current size
	addi	t0, t0, 1		# increment reading pointer
	b 	loop
not_digit:
	bgt	t1, t3, new_max		# if current size is bigger than max size - go to new_max
	mv	t1, zero		# clear current size
	addi	t0, t0, 1		# increment reading pointer
	b 	loop
new_max:
	sub	t2, t0, t1		# max_pointer is current pointer minus size
	mv	t3, t1			# max size is current size
	mv	t1, zero		# clear current size
	addi 	t0, t0, 1 		# increment reading pointer
	b	loop

end:
	li	a7, PRINT_STR
	la	a0, header
	ecall

	add	t0, t2, t3		# t0 pointing to begin of longest number (t2) + size (t3) 
	sb	zero, (t0)		# adding null to the end of longest number 

	li	a7, PRINT_STR
	mv	a0, t2			# reading from t2 (begin of longest num) to null terminator after t0 - longest num
	ecall
	
	li	a7, SYS_EXIT0
	ecall
