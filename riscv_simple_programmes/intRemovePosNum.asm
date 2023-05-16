	.globl main
	
	.eqv	PRINT_STR, 4
	.eqv	READ_STR, 8
	.eqv	READ_INT, 5
	.eqv	PRINT_INT, 1
	.eqv	SYS_EXIT0, 10
	
	.data
input:	.asciz "Enter string: "
pos:	.asciz "Enter position: "
num:	.asciz "Enter number: "
output:	.asciz "Final string: "
buf:	.space 100

	.text
main:
	li	a7, PRINT_STR
	la 	a0, input
	ecall
	
	li	a7, READ_STR
	la	a0, buf			# string put inside buf
	li 	a1, 100
	ecall
	
	li	a7, PRINT_STR
	la 	a0, pos			
	ecall

	li	a7, READ_INT
	ecall
	
	mv	t0, a0			# position to start removing in t0
	
	li	a7, PRINT_STR
	la 	a0, num
	ecall

	li	a7, READ_INT
	ecall
	
	mv	t1, a0			# number of chars to remove in t1
	
	la 	t2, buf			# reading pointer in t2
	la	t3, buf			# writing pointer in t3
	li	t4, ' '			# space to end string
	li	t5, 0			# current position in string
	
loop:
	lbu	t6, (t2)		# load char from string
	bltu	t6, t4, end		# if char less than space - end of string
	beq	t5, t0, remove		# if current position equal to given position - remove
	sb	t6, (t3)		# store char into buf using writing pointer
	addi	t5, t5, 1		# increment current position
	addi	t2, t2, 1		# increment reading pointer
	addi	t3, t3, 1		# increment writing pointer
	b 	loop

remove:
	addi	t2, t2, 1		# increment reading pointer
	addi	t1, t1, -1		# decrement numbers of chars to remove
	addi 	t5, t5, 1		# increment current position
	beqz	t1, loop		# if numbers of chars to remove == 0 then go back to loop
	b 	remove

end:	
	sb	zero, (t3)		# add null terminator at the end of new string in buf
	
	li	a7, PRINT_STR
	la	a0, output
	ecall	
	
	li	a7, PRINT_STR
	la	a0, buf
	ecall
	
	li	a7, SYS_EXIT0
	ecall
