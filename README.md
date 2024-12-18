ARM Assembly Shell for Linux

This project is a simple shell written entirely in ARM assembly for Linux. It lets you enter commands, parse them, and execute them—just like a mini version of Bash! The shell handles user input, breaks it into commands and arguments, and uses system calls to fork and run processes.

Key concepts used in this project include:

System Calls: Direct interactions with the Linux kernel to read input, write output, fork processes, and execute commands.
Input Parsing: Breaking down user input into commands and arguments, even handling quoted strings for arguments with spaces.
Process Control: Forking child processes to execute commands and managing errors if the fork or exec calls fail.
This project showcases a good understanding of low-level programming, Linux internals, and how shells work under the hood—all using pure ARM assembly.

Environment Setup & Running the ARM Shell
Follow these steps to set up your environment and get the ARM Shell up and running. The steps depend on whether your CPU is ARM native or not.

Step 1: Check Your CPU Architecture
Run this command to check your CPU architecture:

$ cat /proc/cpu
Non-ARM Native (Intel)
Install the Required Tools:
$ sudo apt install build-essential gcc-arm-linux-gnueabihf qemu-user

Clone the Repository:
$ git clone https://github.com/KarolNarozniak/ARM_Shell.git
$ cd ARM_Shell

Compile the Shell:
$ arm-linux-gnueabihf-gcc -o shell shell.s -nostdlib -static

Run the Shell:
$ qemu-arm ./shell

Exit the Shell:
Use Ctrl+C to exit the program.

---------------------------------------

ARM Native

Install the Required Tools:
$ sudo apt install build-essential

Clone the Repository:
$ git clone https://github.com/KarolNarozniak/ARM_Shell.git
$ cd ARM_Shell

Compile the Shell:
$ gcc -o shell shell.s -nostdlib -static

Run the Shell:
$ ./shell

Exit the Shell:
Use Ctrl+C to exit the program.
