	.globl	main

	.include "syscalls.asm"
	
	.data
	.eqv    FHSIZE, 14
    	.eqv    IHSIZE, 40
    	.eqv    biWidthStart, 4
    	.eqv    biHeightStart, 8
    	.eqv	rowJump, 4096
    	.eqv	maxHeight, 960
    	.eqv	maxWidth, 1024
    	.eqv	BMPFormatHeader, 0x4d42

			.align  0
BitMapFileHeader: 	.space  14
headerbreak:	  	.space  2		
BitMapInfoHeader: 	.space  40
PixelRow:		.space  5760		# allows files that have max 1920 pixels in width
cwd:			.space  256
file: 			.space 	128

	.text
main:
	print_str("Welcome to bmp file editor!\n")
	
	la	a0, cwd
	li 	a1, 128
	li	a7, GETCWD			# download cwd into buffor
	ecall
	
	la 	t0, cwd	
	li	t1, '\\'
	
cwd_loop:
	lbu	t2, (t0)			# prepare cwd to join with indirect path
	addi 	t0, t0, 1
	bnez	t2, cwd_loop
	addi	t0, t0, -1

end_of_cwd:
	sb	t1, (t0)
	addi	t0, t0, 1
	
	print_str("File to reverse: ")
	
	la	a0, file
	li 	a1, 128
	li	a7, GETSTR			# ask user for file to reverse (indirect path for example: "abc.bmp")
	ecall
	
	la	t3, file
	li	t5, ' '
	
join_file_cwd:					# join cwd with indirect path user had given
	lbu	t2, (t3)
	addi 	t3, t3, 1
	sb 	t2, (t0)
	addi 	t0, t0, 1
	bgeu	t2, t5, join_file_cwd

cwd_joined:
	addi	t0, t0, -1
	sb 	zero, (t0)

open_source_file:
	la	a0, cwd	  			# open prepared path
	mv	a1, zero			# read-only
	li	a7, OPEN
	ecall
	
	li	t0, -1
	beq	a0, t0, open_error		# if not found, throw error
	mv	s0, a0				# save file descriptor to s0
	
	print_str("Input file found\n")

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

check_format:
	la	t0, BitMapFileHeader
	lh	t1, (t0)
	li	t2, BMPFormatHeader
	bne	t1, t2, format_error		# if file found is different format than BMP, throw an error

get_dims:
	la	t0, BitMapInfoHeader		# get dimensions of original image
	lw 	s1, biWidthStart(t0)		# s1 = width of original image in pixels
	lw	s2, biHeightStart(t0)		# s2 = height of original image in pixels

check_max_width:
	li	t0, 5760
	li	t1, 3
	mv	t2, s1
	mul	t2, t2, t1
	bgtu	t2, t0, size_error		# if size of original row is bigger tham 1920 pixels then throw size_error

calculate_original_padding:
	li 	t4, 3
	mul 	t5, s1, t4
	andi	t5, t5, 3
	li	t4, 4
	sub	t5, t4, t5
	andi 	t5, t5, 3			
	mv 	s3, t5				# original padding: s3 = (4 - (width * 3) % 4)) % 4

prepare_before_displaying: 			
	li	t4, 3
	mv	s4, s1
	mul	s4, s4, t4
	add	s4, s4, s3			# s4 = length of original row size + padding (in bytes)
	
	li	s5, rowJump			# row jump distance in s5
	
	li	t0, 0x10040000 			# display pointer
	
	mv	s6, t0
	addi	s6, s6, 4			# next column address in s6

check_display_height:
	li	t1, maxHeight
	bltu	s1, t1, check_display_width	# adjust if neccesary max display height (rars limits)
	li	s1, maxHeight

check_display_width:
	mv 	t1, s2				
	li	t2, maxWidth
	bltu	t1, t2, display_column		# adjust if neccesary max display width (rars limits)
	li	t1, maxWidth

display_column:					# while number of rows left is > 0 - display next column
	addi 	t1, t1, -1

read_next_row:
	mv	a0, s0
	la	a1, PixelRow
	mv	a2, s4
	li	a7, READ			# read next row into PixelRow buffer to display 
	ecall
	
	la	t3, PixelRow			# original pixel pointer (pointing to first pixel in row)
	
	mv	t2, s1				# save number of columns into t2
	
display_row:					# while number of columns left is > 0 - display next pixel
	addi 	t2, t2, -1
				
	li	t4, 3				# loop counter
	mv	t6, zero			# prepare t6 to store pixel data
	addi	t3, t3, 2			# addjust reading pointer 
	
download_pixel:					# read each pixel byte by byte into one register
	lbu 	t5, (t3)			
	addi 	t3, t3, -1			
	slli	t6, t6, 8
	or 	t6, t6, t5
	addi 	t4, t4, -1			
	bnez	t4, download_pixel		# do it 3 times (RGB - 24bpp)

display_pixel:
	addi	t3, t3, 4			# move reading pointer to next pixel
	sw	t6, (t0)			# display pixel as whole word (32B)
	add	t0, t0, s5			# increment display pointer to next row
	bnez	t2, display_row			# if no pixels in row left, jump tp next column

jump_next_column:			
	mv 	t0, s6				# jump to next column
	addi	s6, s6, 4			# save address of next column
	bnez	t1, display_column		# if no more rows to display, end of loop

end_loop:
	print_str("Pixel map displayed\n")

close_source_file:
	mv	a0, s0
	li	a7, CLOSE			# close file after reading all rows
	ecall
	
	print_str("Source file closed\n")

exit:	
	li	a7, EXIT			# exit programme without errors
	ecall

open_error:
	print_str("\nCould not find file: ")
	
	la	a0, cwd
	li	a7, OUTSTR			# give the path for user to know what file he had given
	ecall
	
	li	a0, 2		
	li	a7, EXITERR			# exit programme with error
	ecall

format_error:
	mv	a0, s0
	li	a7, CLOSE			# close file
	ecall

	print_str("\nSource file closed\nFile is in wrong format! Only BMP files are allowed")
	
	li	a0, 2		
	li	a7, EXITERR			# exit programme with error
	ecall	

size_error:
	mv	a0, s0
	li	a7, CLOSE			# close file
	ecall

	print_str("\nSource file closed\nFile too big to display! Max 1920p in width is allowed")
	
	li	a0, 2		
	li	a7, EXITERR			# exit programme with error
	ecall
