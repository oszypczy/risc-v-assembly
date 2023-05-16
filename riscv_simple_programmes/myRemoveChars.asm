	.globl 	main
	
	.eqv	PRINT_STR, 4
	.eqv	READ_STR, 8
	.eqv	SYS_EXIT0, 10
	
	.data
prt0:	.asciz	"Enter string: "
prt1: 	.asciz 	"Enter letters to remove: "
header:	.asciz 	"Final string: "
buf:	.space 	128
chars:	.space 	128


	.text
main:
	li	a7, PRINT_STR
	la	a0, prt0
	ecall
	
	li	a7, READ_STR
	la	a0, buf			# input string in buf
	li	a1, 128
	ecall
	
	li	a7, PRINT_STR
	la	a0, prt1
	ecall
	
	li	a7, READ_STR
	la	a0, chars		# chars to remove in chars
	li	a1, 128
	ecall

	la	t0, buf			# reading iterator
	la	t1, chars		# char iterator
	la	t2, buf			# writing iterator
	li	t3, '\n'		# end of string
	
loop:
	lbu	t4, (t0)		# reading char from string
	beq	t4, t3, end		# if end of input string - go to end

charloop:
	lbu	t5, (t1)		# reading char from removal chars
	beq	t5, t3, save		# if end of chars - go to save
	beq	t4, t5, remove		# if char to remove equal char in string - remove
	addi	t1, t1, 1		# increment char iterator
	b	charloop
	
save:	
	la	t1, chars		# reset char pointer
	sb	t4, (t2)		# write current char
	addi	t0, t0, 1		# increment reading iterator
	addi	t2, t2, 1		# increment writing iterator
	b   	loop

remove:	
	addi	t0, t0, 1		# increment only reading iterator
	b 	loop

end:
	sb	zero, (t2)		# add null terminator and the end of new string
	
	li	a7, PRINT_STR
	la	a0, header
	ecall

	li	a7, PRINT_STR
	la	a0, buf
	ecall

	li	a7, SYS_EXIT0
	ecall
