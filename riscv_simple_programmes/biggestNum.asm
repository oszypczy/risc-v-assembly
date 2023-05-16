	.globl main
	.data
	
	.eqv	PRINT_STR, 4
	.eqv	READ_STR, 8
	.eqv	SYS_EXIT0, 10
	.eqv	PRINT_INT, 1
	
prompt:	.asciz "Enter String: "
header:	.asciz "The biggest number: "
buff:	.space 100

	.text
main:
	li	a7, PRINT_STR
	la	a0, prompt
	ecall
	
	li	a7, READ_STR
	la	a0, buff		# put given string into buff
	li	a1, 100
	ecall

	la	t0, buff		# reading pointer
	mv	t1, zero		# current number
	mv	t2, zero		# biggest number
	li	t4, 10			# base of decimal number digits
	li	t5, '0'	
	li	t6, '9'		

loop:
	lbu	t3, (t0)		# current character
	beqz	t3, end			# if end of string go to end
	blt	t3, t5, not_digit	# if less than 0 - not a digit
	bgt	t3, t6, not_digit	# if greater than 9 - not a digit
	
	sub 	t3, t3, t5 		# Convert ASCII digit to integer
 	mul 	t1, t1, t4 		# Shift previous digit left by one decimal place
  	add 	t1, t1, t3 		# Add new digit to current number into t1
	
	addi	t0, t0, 1		# increment reading pointer
	b 	loop
	
not_digit:
	bgt 	t1, t2, new_max		# if current number greater than max go to new_max
	mv	t1, zero		# reset current number
	addi	t0, t0, 1		# increment reading pointer
	b 	loop

new_max:
	mv	t2, t1			# set new max number
	mv	t1, zero		# reset current number
	addi	t0, t0, 1		# increment reading pointer
	b 	loop

end:
	li	a7, PRINT_STR
	la	a0, header
	ecall

	li	a7, PRINT_INT
	mv	a0, t2			# print max number
	ecall
	
	li	a7, SYS_EXIT0
	ecall
