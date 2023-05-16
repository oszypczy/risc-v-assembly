	.globl main

	.eqv	READ_STR, 8
	.eqv	PRINT_STR, 4
	.eqv	SYS_EXIT0, 10
	.eqv	PRINT_INT, 1

	.data
input:	.asciz "Enter string: "
output:	.asciz "Output: "
return:	.asciz "\nLetters removed: "
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
	li	t1, 'a'	
	li	t2, 'z'
	la	t3, buf			# t3 is writing pointer
	li	t4, ' '			# sapce char to check if end of string
	li	t6, 0
	
loop:
	lbu	t5, (t0)		# store char into t5 form reading pointer
	bltu	t5, t4, end		# exit loop if end of string
	blt	t5, t1, rewrite		# if char is less than 'a' then rewrite it
	bgt	t5, t2, rewrite		# if char is grater than 'z' then rewrite it
	addi	t0, t0, 1		# increment only reading pointer (removing char)
	addi	t6, t6, 1		# increment number of chars removed
	b 	loop		

rewrite:
	sb	t5, (t3)		# rewrite char from t5 info buf using writing pointer
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
	
	li	a7, PRINT_STR
	la	a0, return
	ecall	
	
	li	a7, PRINT_INT
	mv	a0, t6
	ecall
	
	li	a7, SYS_EXIT0
	ecall
	
