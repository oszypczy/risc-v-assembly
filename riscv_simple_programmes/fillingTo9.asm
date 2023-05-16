	.globl 	main
	
	.eqv	PRINT_STR, 4
	.eqv	READ_STR, 8
	.eqv	SYS_EXIT0, 10
	
	.data
input:	.asciz	"Enter numbers: "
header:	.asciz 	"Filled to 9: "
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
	li	t3, '\n'
	li	t4, 105			# 105 - digit = [digit filled to 9]
	
loop:
	lbu	t5, (t0)		# store char into t5
	beq 	t5, t3, end		# if char is \n end of string
	bltu	t5, t1, copy		# if char not a digit then copy without changing
	bgtu 	t5, t2, copy		# --||--
	sub	t5, t4, t5		# fill to 9 in t5
	sb	t5, (t0)		# write to buf changed digit
	addi	t0, t0, 1		# increment reading pointer
	b 	loop

copy:
	addi	t0, t0, 1		# only increment pointer
	b 	loop
	
end:
	li	a7, PRINT_STR
	la	a0, header
	ecall

	li	a7, PRINT_STR
	la	a0, buf
	ecall

	li	a7, SYS_EXIT0
	ecall
