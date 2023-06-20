# risc-v-assembly

I wrote some mini RISC-V assembly programmes. They are stored in riscv_simple_programmes. They mainly work on string manipulation. I provide you with readme
to one of them but this hopefully will allow you to understand them all. You need RARS simulator to run them. You can download it for free using this link:

https://github.com/TheThirdOne/rars/releases/tag/v1.6

This readme provides detailed guide on how to use and understand swapNumsInPairs.asm programme

# README - RISC-V Assembly File

This README provides an explanation of the RISC-V assembly code provided. It describes the purpose and functionality of the code, as well as the structure and usage of the included instructions.

## File Description

The assembly file is written in RISC-V assembly language and contains a program that performs string manipulation. The code prompts the user to enter a string, reads the input, and then processes the string to swap pairs of digits within it.

The code is divided into two sections: `.data` and `.text`.

### `.data` Section

The `.data` section contains the declaration and initialization of data variables. The following variables are defined:

- `input`: A null-terminated string that serves as the prompt for the user to enter a string.
- `output`: A null-terminated string that serves as the prefix for the output message.
- `buf`: A byte array of size 100, which is used to store the user's input string.

### `.text` Section

The `.text` section contains the program's main logic. The entry point of the program is the `main` label. Here's a breakdown of the code:

1. The code starts by using the `li` (load immediate) instruction to load the system call number for printing a string (`PRINT_STR`) into register `a7`. It then uses the `la` (load address) instruction to load the address of the `input` string into register `a0`. Finally, the `ecall` instruction is used to invoke the system call and print the prompt.

2. Next, the code uses similar instructions to read a string from the user. It loads the system call number for reading a string (`READ_STR`) into register `a7`, loads the address of `buf` into register `a0` (to store the input), sets the maximum length of the input to 100 by loading the value 100 into register `a1`, and invokes the system call with `ecall`.

3. After reading the string, the code sets up some pointers and loop variables (`t0`, `t1`, `t2`, `t3`) to iterate over the string.

4. The program enters a loop that processes each character of the string until it reaches the end (a null character). It reads each character using the `lbu` (load byte unsigned) instruction and checks if it is a digit by comparing it with the ASCII values of '0' and '9'. If the character is not a digit, it jumps to `nextchar` to process the next character. If the character is a digit, it moves to `lookforpair` to find the next digit in the string and swap their positions.

5. The `lookforpair` section increments the pointer `t3` to move to the next character and checks if it is a digit. If it is not a digit, it continues searching for the next digit by jumping back to `lookforpair`.

6. Once a pair of digits is found, the program enters the `swap` section. It uses the `sb` (store byte) instruction to swap the two digits by writing the values of `t4` and `t5` to the memory locations pointed to by `t3` and `t0`, respectively. It then sets `t0` to `t3` and increments `t0` to move to the next character. The program jumps back to the beginning of the loop (`loop`) to continue processing the remaining characters.

7. When the end of the string is reached, the program uses system calls to print the output message (`output`) and the modified string stored in `buf`. Finally, it uses the system call `

SYS_EXIT0` to terminate the program.


# BMP rotations

I would like you to focus on remaining two folders: one displays rotated bmp file into RARS built-in display-simulator and the second one generates rotated file.
For them to work properly it is advised to place rars simulator, input 24bpp BMP file and assembly code in one directory. I will provide you with explanation on how
does BMP_rotation_new_file programme works. The second one is very similar however it just uses rars build-in features.

# README: RISC-V Assembly Code - BMP File Editor

This assembly code, `main.asm`, is a program written for the RISC-V architecture that performs basic operations on BMP (bitmap) files. It allows you to reverse the pixel order in a given BMP file and save the modified image as a new file.

## Program Overview

The program follows a modular structure and includes a separate file, `syscalls.asm`, that contains various syscall constants and utility macros for input/output operations.

The main functionality of the program can be summarized as follows:

1. Print a welcome message to the console.
2. Retrieve the current working directory (CWD) using the `GETCWD` syscall.
3. Prompt the user to enter the name of the file to reverse.
4. Join the file name with the CWD to obtain the complete file path.
5. Open the source file using the `OPEN` syscall.
6. Read the file headers (file header and info header) using the `READ` syscall.
7. Extract the dimensions and calculate the padding values for the new table.
8. Allocate memory for the original and reversed pixel tables using the `SBRK` syscall.
9. Copy the pixel data from the source file to the original table using the `READ` syscall.
10. Close the source file using the `CLOSE` syscall.
11. Reverse the pixel order in the original table to create the reversed table.
12. Update the info header with the new dimensions.
13. Create the destination file by appending "_rotated.bmp" to the CWD.
14. Write the file headers and the reversed pixel table to the destination file using the `WRITE` syscall.
15. Close the destination file.
16. Print a message indicating that the file has been saved.
17. Exit the program.

## Usage

To use this program, follow these steps:

1. Ensure you have a RISC-V emulator or processor capable of running RISC-V assembly code.
2. Save the `main.asm` and `syscalls.asm` files in the same directory.
3. Assemble and run the `main.asm` file using your RISC-V emulator or processor.
4. The program will prompt you to enter the name of the file to reverse. Provide the file name (e.g., `image.bmp`) and press Enter.
5. The program will perform the reversal operation and save the modified file as `_rotated.bmp` in the same directory.
6. The program will display a message indicating that the file has been saved.
7. The program will exit.

Note: Make sure the BMP file you want to reverse is in the same directory as the program files.

## Customization

This code is written to rotate the pixel order in a BMP file by 90 degrees to the right. If you want to modify the program for different operations or transformations, you can adapt the code accordingly. You can explore the existing code and the provided comments to understand the logic and make the necessary changes.

## Limitations

- This program assumes that the input BMP file is in the correct format and follows the BMP file structure. It may not work correctly or produce expected results if the file format is invalid or differs from the assumptions made in the code.
- The program does not perform any error handling or validation for file operations. It assumes the input file exists and can be opened successfully. If any errors occur during file operations, the program will display an error message and exit.
- The program uses hardcoded constants for various offsets and sizes related to the BMP file headers. If you modify the BMP file format or header structure, you will need to update these constants accordingly.
