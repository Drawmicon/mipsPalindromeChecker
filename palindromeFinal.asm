#Author: Heili Zhang, Mtch Rosenlof, Steven
#Instructor: Jeffrey Griffith
#Course : CST 307 MWF@9:45 am
#Date: 2017/10/8
#describe: This program will read a line of text and determine whether or not the text is a palindrome.
.data
isPal:		.asciiz		"Text is palindrome."
notPal:		.asciiz		"Text is not palindrome."
start:		.asciiz		"Please input the test text:"
input:		.space		50
inputs:		.space		50
#
# Main routine.
# Get the input from the user
# Store the input
.text
.globl main
.ent main
main:
	# print the string
	li 		$v0, 4		# parameter print prompt string
	la 		$a0, start	# parameter the starting string
	syscall				# print the string
	# get input
	li 		$v0, 8		# parameter read prompt string
	la 		$a0, input	# parameter the input adress
	li 		$a1, 50		# parameter the limitation of 50
	syscall				# get input
	
	#---------------------------------------------------------Steven
	#put starting $a0 address in stack
	subu $sp, $sp, 20	# 
	sw $a0, ($sp)
	
	letterCheck:
		lb		$t1, ($a0)		# read byte by byte
	#If the byte is null, go to doneLetterCheck
		beq		$t1, 10, doneLetterCheck
		
	#If the ascii character's decimal value is under 65
	#not a letter, go to notPa
		blt $t1, 65, notPa	
		
	#If the ascii character's decimal value is under 64
	#not a letter, go to notPa
		bgt $t1, 122, notPa
		
	#If byte is equla to other non-alphabet characters, go to notPa
		beq $t1, 91, notPa
		beq $t1, 92, notPa	
		beq $t1, 93, notPa	
		beq $t1, 94, notPa	
		beq $t1, 95, notPa	
		beq $t1, 96, notPa	

		#Go to the next byte and then restart loop
		addi 	$a0, $a0, 1 	# point to next location
		j		letterCheck		# read next char in the loop
	
	doneLetterCheck:
	
	#put original starting address back in $a0
	lw $a0, ($sp)
	#--------------------------------------------------------

	#---------------------------------------------------------
	#read and store the text char by char. And make t2 point to the end.
	la		$t2, inputs
	read:
		lb		$t1, ($a0)		# read byte by byte
		beq		$t1, 10, checkStart	# read till the end, goto check palindrome
		sb		$t1, ($t2)		#Store it char by char
		addi 	$a0, $a0, 1 	# point to next location
		addi	$t2, $t2, 1		# point to next location
		j		read			# read next char in the loop
	checkStart:
		la		$t3, inputs		# load the adress of char by char text
		addi	$t2, $t2, -1	# as t2 is now point to the position after the last char, make it go back one position
		check1:
			lb		$t4, ($t3)		#read the text byte by byte from forward
			lb		$t5, ($t2)		#read the text byte by byte from backward
			beq		$t4, $t5, checkNext		#this pair equal, go to next pair
			#----------------Steven
			#Check if letter is upper or lower case version
			add $t6, $t5, 32
			subu $t7, $t5, 32
			beq		$t4, $t6, checkNext
			beq		$t4, $t7, checkNext
			#----------------
			j		notPa		# as one pair didn't equal, text is not palindrome
			checkNext:
				jal		mid					#check if reach to the middle of the text
				addi	$t3, $t3, 1 		#point to next char from forward
				addi	$t2, $t2, -1 		#point to next char from backward
				j		check1				#back to pair checking
			mid:
				
				
				
				beq		$t3, $t2, isPa		#reach to the middle, done checking
				#----------------Steven
				#Check if letter is upper or lower case version
				add $t6, $t5, 32
				subu $t7, $t5, 32
				beq		$t4, $t6, isPa
				beq		$t4, $t7, isPa
				#----------------
				
				addi	$t3, $t3, 1			#maybe number is even, plus one to check position
				beq		$t3, $t2, isPa		#reach to the middle, done checking
				#----------------Steven
				#Check if letter is upper or lower case version
				add $t6, $t5, 32
				subu $t7, $t5, 32
				beq		$t4, $t6, isPa
				beq		$t4, $t7, isPa
				#----------------				
				
				addi	$t3, $t3, -1		#decrease it back
				jr		$ra					#back to checking
	isPa:
		# print the string
		li 		$v0, 4		# parameter print prompt string
		la 		$a0, isPal	# parameter the starting string
		syscall				# print the string
		j		ex			#done, end the checking
	notPa:
		# print the string
		li 		$v0, 4		# parameter print prompt string
		la 		$a0, notPal	# parameter the starting string
		syscall				# print the string
		
	ex:
		# Done, terminate program.
		#
		li $v0, 10 			# parameter call code for terminate
		syscall 
		

		#
		# Tell compiler that we are ending the main program with end directive
		#	
.end main