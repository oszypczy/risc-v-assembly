	.global main
	
	.eqv	PRINT_STR, 4
	.eqv	READ_STR, 8
	.eqv	SYS_EXIT0, 10
	
	.data
input:	.asciz "Enter string: "
output: .asciz "Output: "
buf:	.space 100
nums:	.space 100

	.text
main:
	li	a7, PRINT_STR
	la	a0, input
	ecall				# printing input string
	
	li	a7, READ_STR
	la	a0, buf
	li	a1, 100
	ecall				# storing given string into buf
	
	la	t0, buf			# reading pointer
	la	t1, nums		# writing num pointern
	li	t3, ' '			# space in t3 to end the loop
	li	t5, '0'
	li	t6, '9'

numreverse:
	lbu	t4, (t0)		# reading char from buf	
	bltu 	t4, t3, nextstep 	# reading pointer pointing to \n
	bltu	t4, t5, skip		# if char not a digit then skip
	bgtu 	t4, t6, skip		# --||--
	sb	t4, (t1)		# if digit then store in nums
	addi	t0, t0, 1		# next char
	addi	t1, t1, 1		# moving writing num pointer
	b	numreverse
	
skip:
	addi	t0, t0, 1		# next char			
	b	numreverse
	
nextstep:
	la	t0, buf			# reading num pointer
	addi	t1, t1, -1		# num pointer pointing to last num
	
loop:
	lbu	t4, (t0)		# reading char from buf
	bltu 	t4, t3, end 		# reading pointer pointing to \n
	bltu	t4, t5, pass		# if char not a digit then copy without changing
	bgtu 	t4, t6, pass		# --||--
	lbu	s0, (t1)		# read num from nums 
	sb	s0, (t0)		# write it to the buf
	addi	t0, t0, 1		# increment reading pointer
	addi	t1, t1, -1		# decrement num pointer
	b	loop

pass:
	addi	t0, t0, 1		# next char			
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
