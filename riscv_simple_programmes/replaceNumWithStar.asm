	.globl 	main
	
	.eqv	PRINT_STR, 4
	.eqv	READ_STR, 8
	.eqv	PRINT_INT, 1
	.eqv	SYS_EXIT0, 10
	
	.data
input:	.asciz	"Enter string: "
output:	.asciz 	"Final string: "
return:	.asciz 	"Return value: "
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
	
	la	t0, buf			# t0 is reading and writing pointer
	li	t1, '0'			
	li	t2, '9'
	li	t3, ' '			# space char to check if end of str
	li	t4, '*'			# * char to replace digits with it
	li	t6, 0			# number of chars replaced
	
loop:
	lbu	t5, (t0)		# store char into t5
	bltu 	t5, t3, end		# if char is less than space -> end of string
	bltu	t5, t1, copy		# if char not a digit then copy without changing
	bgtu 	t5, t2, copy		# --||--
	sb	t4, (t0)		# replace digit wirh a *
	addi	t0, t0, 1		# inrement reading/writing pointer
	addi 	t6, t6, 1		# increment number of chars replaced
	b 	loop
	
copy:
	addi	t0, t0, 1		# only increment pointer
	b 	loop

end:
	li	a7, PRINT_STR
	la	a0, output
	ecall

	li	a7, PRINT_STR
	la	a0, buf
	ecall

	li	a7, PRINT_STR
	la	a0, return
	ecall
	
	li	a7, PRINT_INT
	mv	a0, t6
	ecall

	li	a7, SYS_EXIT0
	ecall
