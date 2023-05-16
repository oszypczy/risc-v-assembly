# input - output
	.eqv	OUTSTR, 4
	.eqv	GETSTR, 8
    	
    	.macro 	print_str(%str)
	.data
label:  .asciz %str
	.text
		li 	a7, 4
		la 	a0, label
		ecall
	.end_macro

# files
	.eqv	OPEN, 1024
	# a0 = Null terminated string for the path
	# flag a1 - read-only (0), write-only (1) and write-append (9)
	# write-only flag creates file if it does not exist, so it is technically write-create. 
	# write-append will start writing at end of existing file
	# returns a0 = the file decriptor or -1 if an error occurred
	.eqv	CLOSE, 57
	# a0 = the file descriptor to close
	.eqv	READ, 63
	# a0 = the file descriptor
	# a1 = address of the buffer to write from a file
	# a2 = maximum length to read
	# returns a0 = the length read or -1 if error
	
# misc
	.eqv 	GETCWD, 17
	# Writes the path of the current working directory into a buffer
	# a0 = the buffer to write into 
	# a1 = the length of the buffer
	# returns a0 = -1 if the path is longer than the buffer
	.eqv	EXITERR, 93
	# a0 = the number to exit with
	.eqv	EXIT, 10
