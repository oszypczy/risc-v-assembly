	.globl main
	
	.eqv	PRINT_STR, 4
	.eqv	READ_INT, 5
	.eqv	PRINT_INT, 1
	.eqv	SYS_EXIT0, 10
	
	.data
input:	.asciz "Enter int: "
output:	.asciz "Sum: "
buf:	.space 100

	.text
main:
	li	a7, PRINT_STR
	la 	a0, input
	ecall

	li	a7, READ_INT
	ecall
	
	mv	t0, a0
	
	li 	a7, PRINT_INT
	mv	a0, t0
	ecall
	
	li	a7, SYS_EXIT0
	ecall
