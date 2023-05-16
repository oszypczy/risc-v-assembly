# dla długośći nieparzystej stringa zastąp co 4 znak !, dla parzystej zastąp poprzednim znakiem ascii

	.globl 	main
	
	.eqv	PRINT_STR, 4
	.eqv	READ_STR, 8
	.eqv	SYS_EXIT0, 10
	
	.data
input:	.asciz	"Enter string: "
output:	.asciz 	"Final string: "
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
	li	t1, '!'			
	li	t2, 0			# length of string
	li	t3, 4			# char counter
	li	t5, ' '			# space char to check if end of string
	
length:
	lbu	t4, (t0)
	bltu 	t4, t5, endOfStr
	addi	t2, t2, 1		# increment char length
	addi	t0, t0, 1		# increment reading pointer
	b 	length

endOfStr:
	andi	t2, t2, 1		# convert even number into 0, odd into 1
	la	t0, buf			# reset reading pointer
	
loop:
	lbu	t4, (t0)		# read char from string
	bltu 	t4, t5, end		# if end of string go to end
	addi	t3, t3, -1		# decrement char counter
	beqz 	t3, replace		# if char counter == 0, then replace that char
	addi	t0, t0, 1		# increment reading counter
	b 	loop

replace:
	li	t3, 3			# reset char counter
	beqz 	t2, even		# if length of string is even, go to even
	sb	t1, (t0)		# if length is odd then replace char with *
	addi	t0, t0, 1		# increment reading pointer
	b 	loop
	
even:
	addi 	t4, t4, -1		# move char to next one in ASCII
	sb	t4, (t0)		# replace current char with the changed one
	addi	t0, t0, 1		# increment reading pointer
	b 	loop

end:
	li	a7, PRINT_STR
	la	a0, output
	ecall

	li	a7, PRINT_STR
	la	a0, buf
	ecall

	li	a7, SYS_EXIT0
	ecall
