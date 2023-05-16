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
	la	a0, buf
	li 	a1, 100
	ecall
	
	la 	t0, buf			# reading/writing pointer
	li	t1, 'a'			
	li	t2, 'z'
	li	t3, 32			# 32 is the distance in ASCII between small and big letters
	li	t4, 2			# char counter 

loop:
	lbu	t6, (t0)		# load char
	beqz	t6, end			# if null terminator then end
	blt	t6, t1, skip		# if not a small letter then skip
	bgt	t6, t2, skip		# if not a small letter then skip
	beqz	t4, up			# if char counter == 0 then upper() the char
	addi	t4, t4, -1		# decrement char counter
	b	skip

up:
	sub	t6, t6, t3		# upper() the char
	sb	t6, (t0)		# store changed char into buf
	li	t4, 2			# reset char counter

skip:
	addi	t0, t0, 1		# increment reading/writing pointer
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
