	.globl 	main
	
	.eqv	PRINT_STR, 4
	.eqv	PRINT_INT, 1
	.eqv	READ_STR, 8
	.eqv	SYS_EXIT0, 10
	
	.data
input:	.asciz	"Enter string: "
header:	.asciz 	"Number of integers: "
buf:	.space 	100

	.text
main:
	li	a7, PRINT_STR
	la	a0, input
	ecall				# print input prompt 
	
	li	a7, READ_STR
	la	a0, buf			# store input into buf
	li	a1, 100	
	ecall
	
	la	t0, buf			# t0 is reading pointer
	li	t1, '0'			
	li	t2, '9'
	li	t3, ' '
	li	t4, 0			# isDigit flag 
	li	t5, 0			# number of ints
	
loop:
	lbu	t6, (t0)		# store char into t5
	bltu 	t6, t3, lastcheck	# if char is less than space - end of string
	bltu	t6, t1, notdigit	# if char not a digit then copy without changing
	bgtu 	t6, t2, notdigit	# --||--
	li	t4, 1			# isDigit flag on
	addi	t0, t0, 1		# increment reading pointer
	b	loop

notdigit:
	addi	t0, t0, 1		# increment reading pointer
	beqz 	t4, loop		# if last digit was not a digit then go back to loop
	addi	t5, t5, 1		# if last char was a digit then increment number of ints by 1
	li	t4, 0			# set isDigit flag to 0
	b 	loop

lastcheck:
	beqz 	t4, end			# if last char was not a digit then go to end
	addi	t5, t5, 1		# if last char was a digit then increment amount of numbers in string

end:
	li	a7, PRINT_STR
	la	a0, header
	ecall

	li	a7, PRINT_INT
	mv	a0, t5
	ecall

	li	a7, SYS_EXIT0
	ecall
	
	
	
	
	
