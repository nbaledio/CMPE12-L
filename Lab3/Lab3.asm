##########################################################################
# Created by: Baledio, Nathan
# nbaledio
# 8 February, 2019
#
# Assignment: Lab3: ASCII Art
# CMPE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Winter 2019
#
# Description: This program prints triangles, with length and number defined by the user
#
# Notes: This program is intended to be run from the MARS IDE.
##########################################################################


# REGISTER USAGE:
# #v0: Changed for system calls
# #a0: Temporary value holder
# $s0: Triangle length (user input)
# $s1: Number of triangles (user input)
# $s2: Termination value for spaces for loop
# $t0: Upper-half triangle loop iterator
# $t1: Spaces loop iterator
# $t2: Lower-half triangle loop iterator
# $t3: Main loop iterator

.text

main:
	# Prompt for triangle leg length
 	li $v0, 4	#Calls syscall 4 to print a string
 	la $a0, prompt	#Loads address of prompt (string asking for leg length)
 	syscall

 	# Read the integer and save it in $s0
 	li $v0, 5	#Calls syscall 5 to read an integer from user input
 	syscall
 	move $s0, $v0	#writes value recorded from $v0 and saves it into $s0
 	
 	# Prompt for number of triangles
 	li $v0, 4	#Calls syscall 4 to print a string
 	la $a0,prompt2	#Loads address of prompt (string asking for number of traingles)
	syscall
	
	# Read the integer and save it in $s1
 	li $v0, 5	#Calls syscall 5 to read an integer from user input
 	syscall
 	move $s1, $v0	#Writes value recorded from $v0 and saves it into $s1
 		
 	add $s0, $s0, -1	#Decrements $s0 for loop so that it does not output an extra '\'
 	add $s1, $s1, -1
 	li $s2, -1 		#Sets $s2 for the for loop so that it does not output an extra space
 	j mainloop		#Jumps to mainloop

upperloop:			#Loop that handles printing the upper half of the triangle
	bgt $t0,$s0,exit	#Loop condition from 0 to $s0 (User input)
	li $v0, 11		#Calls syscall 11 to print the '\' character (This will not need to change, until program termination)	
	j spaceloop		#Jumps to spaceloop (Nested for loop)
	loopreturn:		#Return point from the spaceloop
	li $a0, 92		#Sets $a0 to '\' character
	syscall
	li $a0, 10		#Sets $a0 to LF character (Newline) and prints it
	syscall
	li $t1, 0		#Resets spaceloop iterator
	addi $s2,$s2,1		#Increments spaceloop termination value
	addi $t0,$t0,1		#Increments $t0
	j upperloop		#Returns to top of loop
 	
spaceloop:			#Loop that handles printing the lower half of the triangle
	bgt $t1,$s2,exit2	#Loop condition from 0 to termination point (increments)
	li $a0, 32		#Sets $a0 to ' ' character
	syscall
	addi $t1,$t1, 1		#Increments $t1
	j spaceloop		#Returns to top of loop
	
lowerloop:			#Loop that handles printing of lower half of triangle
	bgt $t2,$s0,exit3	#Loop condition from 0 to $s0 (User input)
	addi $s2, $s2, -1	#Decrements $s2
	j spaceloop2		#Jumps to spaceloop2
	loopreturn2:		#Return point from spaceloop2
	li $a0, 47		#Sets $a0 to '/' character and prints it
	syscall
	j lowerchecker		#Jumps to lowerchecker to prevent extra LF character from being printed
	checkerreturn:		#Return point for lowerchecker
	li $a0, 10		#Sets $a0 to LF character (Newline) and prints it
	syscall
	li $t1, 0		#Resets spaceloop iterator
	addi $t2,$t2,1		#Increments $t2
	j lowerloop
	
spaceloop2:			#Loop that handles printing the lower half of the triangle
	bgt $t1,$s2,exit4	#Loop condition from 0 to termination point (decrements)
	li $a0, 32		#Sets $a0 to ' ' character
	syscall
	addi $t1,$t1, 1		#Increments $t1
	j spaceloop2		#Returns to top of loop
	
mainloop:			#Loop that handles how many triangles are printed
	bgt $t3,$s1,exit5	#Loop condition from 0 to $s1 (User input)
	j upperloop		#Jumps to upperloop
	mloopreturn:		#Return point from lowerloop
	addi $t3,$t3, 1		#Increments $t3
	li $t0, 0		#Resets upperloop iterator
	li $t2, 0		#Resets lowerloop iterator
	j mainloop		#Jumps to top of loop
 	
exit:
	j lowerloop		#Jumps to lowerloop
 	
exit2: 	
	j loopreturn		#Jumps to return point

exit3:
	j mloopreturn		#Jumps to main loop return point
 	
exit4:
 	j loopreturn2		#Jumps to return point
 	
exit5:
	li $v0, 10		# End the program
 	syscall
 	 
lowerchecker:
	beq $t2, $s0, mainchecker	#Checks if lower-triangle is on last iteration and jumps to main checker if true
	j checkerreturn			#Returns to lowerloop if false

mainchecker: 
	beq $t3, $s1, exit5		#Checks if mainloop is on last iteration and exits if true
	j checkerreturn			#Returns to lowerloop if false						

.data
prompt: .asciiz "Enter the length of one of the triangle legs: "
prompt2: .asciiz "Enter the number of triangles to print: "
