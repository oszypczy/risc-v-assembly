	.globl	main

	.include "syscalls.asm"
	
	.data
			.eqv    FHSIZE, 14
    			.eqv    IHSIZE, 40
    			.eqv    biWidthStart, 4
    			.eqv    biHeightStart, 8
    			.eqv    biTableSizeStart, 20

BitMapFileHeader: 	.space  14
headerbreak:	  	.space  2		
BitMapInfoHeader: 	.space  40
cwd:			.space  128
file: 			.space 	128

welc:			.asciz	"Welcome to bmp file editor!\n"
prompt:			.asciz	"File to reverse: "
fout:			.asciz  "_rotated.bmp"

	.text
main:
	la	a0, welc
	li  	a7, OUTSTR
	ecall
	
	la	a0, cwd
	li 	a1, 128
	li	a7, GETCWD
	ecall
	
	la 	t0, cwd	
	li	t1, '\\'
	
cwd_loop:
	lbu	t2, (t0)
	beqz	t2, end_of_cwd
	addi 	t0, t0, 1
	b 	cwd_loop

end_of_cwd:
	sb	t1, (t0)
	addi 	t0, t0, 1
	
	la	a0, prompt
	li  	a7, OUTSTR
	ecall
	
	la	a0, file
	li 	a1, 128
	li	a7, GETSTR
	ecall
	
	la	t3, file
	li	t5, ' '
	
join_file_cwd:
	lbu	t2, (t3)
	bltu 	t2, t5, cwd_joined
	addi 	t3, t3, 1
	sb 	t2, (t0)
	addi 	t0, t0, 1
	b 	join_file_cwd

cwd_joined:
	sb 	zero, (t0)
	mv 	s9, t0				# address of end of cwd in s9

open_source_file:
	la	a0, cwd	  			
	mv	a1, zero			# read-only
	li	a7, OPEN
	ecall
	li	t0, -1
	beq	a0, t0, open_error		# if not found, throw error
	mv	s0, a0				# save file descriptor to s0
	
	print_str("\ninput file found\n")

read_headers:
	mv	a0, s0
	la	a1, BitMapFileHeader
	li	a2, FHSIZE
	li	a7, READ
	ecall					# read file header info buff (14 B)

	la	t0, headerbreak
	sh	zero, (t0)			# move two bytes of 0 in the middle so the first byte of infoh will be at adrees divisible by 4
	
	mv	a0, s0			
	la	a1, BitMapInfoHeader
	li	a2, IHSIZE
	li	a7, READ
	ecall					# read info header info buff (40 B)

get_dims:
	la	t0, BitMapInfoHeader
	lw 	s1, biWidthStart(t0)		# s1 = width
	lw	s2, biHeightStart(t0)		# s2 = height
	lw	s3, biTableSizeStart(t0)	# s3 = full size in bytes

create_original_table:
	mv	a0, s3				# s3 = full size of pixel table in bytes
	li	a7, SBRK
	ecall					# allocate memory for the whole bit table

	mv	s5, a0				# s5 = original table pointer

copy_original_table:
	mv	a0, s0
	mv	a1, s5
	mv	a2, s3
	li	a7, READ
	ecall
	
close_source_file:
	mv	a0, s0
	li	a7, CLOSE
	ecall
	
	print_str("pixel array in memory\n")

calculate_paddings:
	li 	t4, 3
	mul 	t5, s2, t4
	li	t4, 4
	remu	t5, t5, t4
	sub	t5, t4, t5
	remu	t5, t5, t4			
	mv 	s7, t5				# new padding: s7 = (4 - (height * 3) % 4)) % 4

	li 	t4, 3
	mul 	t5, s1, t4
	li	t4, 4
	remu	t5, t5, t4
	sub	t5, t4, t5
	remu	t5, t5, t4			
	mv 	s8, t5				# old padding: s8 = (4 - (width * 3) % 4)) % 4

calculate_new_size:
	li 	t4, 3				
	mul 	t4, t4, s2
	add 	t4, t4, s7
	mul 	t4, t4, s1
	mv 	s3, t4				# new table size s3 = ((height * 3) + new_padding) * width
	
create_reversed_table:
	mv	a0, s3				# s3 = new full size of pixel table in bytes
	li	a7, SBRK
	ecall					# allocate memory for the whole bit table

	mv	s6, a0				# s6 = reversed table pointer

rotate: 					# in this example: rotate by 90 degrees right	
	mv 	t0, s6 				# temporary reversed table pointer

	li	t4, 3		
	mul   	t1, s1, t4    			# multiply row pixel width (s1) by bytes per pixel (3)
	add 	t1, t1, s8			# add old padding
	mv 	s4, t1				# save row jump distance into s4

	li 	t1, 3
	mv	t4, s1
	addi 	t4, t4, -1
	mul 	t1, t1, t4			# mul by (width in pixel - 1)

	mv 	t2, s5		
	add 	t2, t2, t1			# t2 = original table pointer (poiting to last pixel in last row)
	
	mv 	t1, s1				# save number of columns into t1
	
	mv 	t4, s2
	mv 	t6, s4
	mul 	t6, t6, t4			# column jump distance in t6
	
copy_column:
	mv 	t3, s2				# save number of rows into t3
	beqz 	t1, end_loop			# while number of columns left is > 0
	addi 	t1, t1, -1
	
copy_row:
	beqz 	t3, jump_next_column		# while number of rows left is > 0
	li	t4, 3
	
copy_pixel:
	lbu 	t5, (t2)			
	sb	t5, (t0)			# move every byte of pixel into new table
	addi 	t2, t2, 1			# increment old table pointer
	addi 	t0, t0, 1			# increment new table pointer
	addi 	t4, t4, -1			
	bnez	t4, copy_pixel			# do it 3 times (RGB - 24bpp)
	
	li	t4, 3
	sub	t2, t2, t4
	add 	t2, t2, s4			# move t2 to a new row
	addi	t3, t3, -1			# decrement number of rows in this column
	b 	copy_row

jump_next_column:
	sub 	t2, t2, t4			
	sub 	t2, t2, t6			# jump to next column

	mv 	t5, s7
	
padd_loop:
	beqz 	t5, copy_column			# add padding to new table if necessary
	addi 	t5, t5, -1
	sb 	zero, (t0)
	addi 	t0, t0, 1
	b 	padd_loop
	
# transorfmation done
end_loop:
	print_str("table rotation done\n")
	
change_info_header:
	la	t0, BitMapInfoHeader		# change width with height in new table
	sw 	s1, biHeightStart(t0)
	sw	s2, biWidthStart(t0)

create_dest_file:
	mv 	t0, s9
	addi	t0, t0, -4
	la	t1, fout

join_final_dest_file:
	lbu	t2, (t1)
	sb	t2, (t0)
	addi	t0, t0, 1
	addi 	t1, t1, 1
	bnez	t2, join_final_dest_file	

# save image
open_dest_file:
	la	a0, cwd
	li	a1, 1	
	li	a7, OPEN
	ecall
	mv	s0, a0

write_headers:
	mv	a0, s0
	la	a1, BitMapFileHeader
	li	a2, FHSIZE
	li	a7, WRITE
	ecall

	mv	a0, s0
	la	a1, BitMapInfoHeader
	li	a2, IHSIZE
	li	a7, WRITE
	ecall

write_table:
	mv	a0, s0
	mv	a1, s6
	mv	a2, s3
	li	a7, WRITE
	ecall

close_dest_file:
	mv	a0, s0
	li	a7, CLOSE
	ecall

	print_str("file saved\n")
exit:
	li	a7, EXIT
	ecall

open_error:
	print_str("\nCould not open file: ")
	
	la	a0, cwd
	li	a7, OUTSTR
	ecall
	
	li	a0, 2		# file error
	li	a7, EXITERR
	ecall
