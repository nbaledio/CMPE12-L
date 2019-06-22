##########################################################################
# Created by:  Baledio, Nathan
#              nbaledio
#              7 March 2019
## Assignment:  Lab 5: Subroutines
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2019
## Description: Encrypts/Decrpts inputs based on given key using Caesar Cipher method
## Notes:       This program is intended to be run from the MARS IDE.
##########################################################################

.text
#WORKS
#--------------------------------------------------------------------
give_prompt:
	la $t0, ($a0)		#Saves address of string into $t0
	beq $a1, 0, p0		#Branches to prompt0
	beq $a1, 1, p1		#Branches to prompt1
	beq $a1, 2, p2		#Branches to prompt2
p0:
	li $v0, 4
	la $a0, ($t0)		#Prints prompt
	syscall
	li $v0, 8		#Takes in userinput (of up to two characters so enter can be pressed)
	la $a0, userchoice
	li $a1, 3		
	syscall
	lb $t1, ($a0)		#Loads letter entered
	beq $t1, 68, p0load	#Checks if letter is D, E or X. Branches if it is
	beq $t1, 69, p0load
	beq $t1, 88, p0load
	li $v0, 4		#Prints error and re-loops if it is an invalid input
	la $a0, error
	syscall
	j p0
		
p0load:
	move $v0, $a0		#Loads data into $v0
	jr $ra	
p1:
	li $v0, 4		#Asks for key
	syscall
	li $v0, 8		#Takes user input (of up to 101 characters so enter can be pressed)
	la $a0, key
	li $a1, 102
	syscall
	la $v0, ($a0)		#Saves value into $v0
	jr $ra
p2:
	li $v0, 4		#Asks for input string
	syscall
	li $v0, 8
	la $a0, inputstring
	li $a1, 102		#Takes user input (of up to 101 characters so enter can be pressed)
	syscall
	move $s6, $a0
	move $a0, $s6
	la $v0, ($a0)		#Saves value into $v0
	jr $ra
#--------------------------------------------------------------------

#WORKS:
#--------------------------------------------------------------------
cipher:	
	addi $sp, $sp, -4
	sw $ra, ($sp)
	move $t4, $a1			#Moves string to $t4
	li $t1, 0			#Sets iterator to 0
	jal compute_checksum
	move $a1, $v0			#Saves original arguments
	move $t0, $a0
	move $t1, $a1
	move $t7, $a2
	li $t3, 0
	lb $t5, ($a0)			#Checks if input is decrypting or encrypting
	beq $t5, 68, decrypt_loop
	beq $t5, 69, encrypt_loop
decrypt_loop:
	add $t4, $t7, $t3		#Iterates through string
	lb $a0, 0($t4)			#Loads char
	beq $a0, $zero, cipher_return
	beq $a0, 10, cipher_return
	jal decrypt			#Decrypts char
	sb $v0, ($t4)
	addi $t3, $t3, 1		#Increments iterator
	j decrypt_loop	
encrypt_loop:
	add $t4, $t7, $t3		#Iterates through string
	lb $a0, 0($t4)			#Loads char
	beq $a0, $zero, cipher_return
	beq $a0, 10, cipher_return
	jal encrypt			#Encrypts char
	sb $v0, ($t4)
	addi $t3, $t3, 1		#Increments iterator
	j encrypt_loop	
cipher_return:
	move $v0, $t7
	lw $ra, ($sp)
	addi $sp, $sp, 4 
	jr $ra		
#--------------------------------------------------------------------

#WORKS
#--------------------------------------------------------------------
compute_checksum:
	add $t2, $t4, $t1		#Sets $t2 to char at iterator
	lb $t3, 0($t2)			#Loads current char into $t3
	beq $t3, 10, checksum_mod	#Returns if newline is reached
	beq $t3, $zero, checksum_mod	#Returns if end of string is reached
	addi $t1, $t1 1			#Increments iterator
	j compute_checksum_loop
compute_checksum_loop:
	add $t2, $t4, $t1		#Sets $t2 to char at iterator
	lb $t6, 0($t2)			#Loads current char into $t3
	beq $t6, 10, checksum_mod	#Returns if newline is reached
	beq $t6, $zero, checksum_mod	#Returns if end of string is reached
	xor $t3, $t3, $t6		#Xors current char and previous char and sets it into $t3
	addi $t1, $t1 1			#Increments iterator
	j compute_checksum_loop
checksum_mod:
	li $t5, 26
	rem $v0, $t3, $t5
	jr $ra

#--------------------------------------------------------------------

#WORKS
#--------------------------------------------------------------------
encrypt:
	addi $sp, $sp, -4		#Save return address
	sw $ra,($sp)
	jal check_ascii
	lw $ra,($sp)			#Restores return address
	addi $sp, $sp, 4
	beq $v0, 0, upper_encrypt	#Checks if char is uppercase or lowercase or neither
	beq  $v0, 1, lower_encrypt
	move $v0, $a0	
	jr $ra
upper_encrypt:
	add $v0, $a0, $a1		#Shifts by checksum
	slti $t9, $v0, 91
	beq $t9, 0, reset_val		#Checks if value > Z and resets it
	jr $ra
lower_encrypt:	
	add $v0, $a0, $a1		#Shifts by checksum
	slti $t9, $v0, 123
	beq $t9, 0, reset_val		#Checks if value > Z and resets it
	jr $ra	
reset_val:
	subi $v0, $v0, 26
	jr $ra	
#--------------------------------------------------------------------

#WORKS
#--------------------------------------------------------------------
decrypt:
	addi $sp, $sp, -4		#Saves return address
	sw $ra,($sp)
	jal check_ascii
	lw $ra,($sp)			#Restores return address
	addi $sp, $sp, 4
	beq $v0, 0, upper_decrypt	#Checks if char is uppercase or lowercase or neither
	beq  $v0, 1, lower_decrypt
	move $v0, $a0	
	jr $ra
upper_decrypt:
	sub $v0, $a0, $a1		#Shifts by checksum
	slti $t9, $v0, 65
	beq $t9, 1, reset_val2		#Checks if value < A and resets it
	jr $ra
lower_decrypt:
	sub $v0, $a0, $a1		#Shifts by checksum
	slti $t9, $v0, 97
	beq $t9, 1, reset_val2		#Checks if value < a and resets it
	jr $ra	
reset_val2:
	addi $v0, $v0, 26
	jr $ra	

#--------------------------------------------------------------------

#WORKS
#--------------------------------------------------------------------
check_ascii:
	slti $t0, $a0, 91		#Checks if value is at least A or greater
	beq $t0, 1, uppercheck2		#Branches to second check
	slti $t0, $a0, 123		#Checks if value is at least a or greater
	beq $t0, 1, lowercheck2		#Branches to second check
loadneg:
	li $v0 -1			#Returns -1 if both checks fail
	jr $ra
uppercheck2:
	slti $t0, $a0, 65		#Checks if value is Z or less and rerturns 0 if true. Jumps to loadneg if false
	beq $t0, 1, loadneg
	li $v0, 0
	jr $ra
lowercheck2:
	slti $t0, $a0, 97		#Checks if value is z or less and rerturns 1 if true. Jumps to loadneg if false
	beq $t0, 1, loadneg
	li $v0, 1
	jr $ra	
#--------------------------------------------------------------------

#WORKS
#--------------------------------------------------------------------
print_strings:
	move $t0, $a0			#Saves $a0 and $a1 into $t0 and $t1
	move $t1, $a1			
	lb $t3, ($a2)
	beq $t3, 68, printdecrypted	#Checks if user string is decrypted string
	li $v0, 4
	la $a0, encrypted		#Prints encrypted prompt
	syscall
	move $a0, $t1			#Prints encrypted string
	syscall
	la $a0, decrypted		#Prints decrypted prompt
	syscall
	la $a0, inputstring		#Encrypts string
	la $a1, key
	move $a2, $t1
	addi $sp, $sp, -4		#Saves return address
	sw $ra,($sp)
	jal cipher
	lw $ra, ($sp)
	addi $sp, $sp, 4		#Restores return address
	move $a0, $v0
	li $v0, 4			#Prints user string
	syscall
	jr $ra
printdecrypted:
	move $t9, $t1			#I think this ended up not being used
	li $v0, 4
	la $a0, encrypted		#Prints encrypted prompt
	syscall	
	
	la $a0, encryptin		#Encrypts string
	la $a1, key
	la $a2, inputstring
	
	addi $sp, $sp, -4
	sw $ra,($sp)			#Saves return address
	jal cipher
	lw $ra, ($sp)			#Restores return address
	addi $sp, $sp, 4
	move $a0, $v0			#Prints encrypted string
	li $v0, 4	
	syscall
	
	#move $a0, $s6			#Prints user string
	#syscall
	
	
	la $a0, decrypted		#Prints decrypted prompt
	syscall
	
	la $a0, decryptin		#Decrypts string
	la $a1, key
	la $a2, inputstring
	addi $sp, $sp, -4		#Saves return address
	sw $ra,($sp)
	jal cipher
	lw $ra, ($sp)			#Restores return address
	addi $sp, $sp, 4
	move $a0, $v0
	li $v0, 4			#Prints decrypted string
	syscall
	
	#move $a0, $t9			#Prints decrypted string
	#syscall
	jr $ra
#--------------------------------------------------------------------

.data
encryptin: .asciiz "E\n"
decryptin: .asciiz "D\n"
newline: .asciiz "\n"
error: .asciiz "Invalid input: Please input E, D, or X.\n"
encrypted: .asciiz "<Encrypted> "
decrypted: .asciiz "<Decrypted> "
inputstring: .space 100
resultstring: .space 100
key: .space 100
userchoice: .space 1 
