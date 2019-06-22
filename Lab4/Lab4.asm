##########################################################################
# Created by:  Baledio, Nathan
#              nbaledio
#              19 February 2019
## Assignment:  Lab 4: ASCII Conversion
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2019
## Description: This program takes two inputs in binary or hexadecimal, adds them, and outputs the sum in signed base 4
## Notes:       This program is intended to be run from the MARS IDE.
##########################################################################

#Pseudocode:
# 1. Read user inputs
# 2. Print user inputs
# 3. If (input starts with "0x") {do hexadecimal conversion}
#    If (input startes with "0b") {do binary conversion} *both will convert to 32-bit 2SC
# 4. $s1 = first argument
#    $s2 = second argument
# 5. $s0 = $s1 + $s2
# 6. Convert_to_signed_base_4($s0)
# 7. If($s0 is negative) {print negative symbol} else {do nothing}
# 8. Print $s0

#Register Usage:
# $t1 = first argument
# $t2 = second argument
# $t3 = x char to check is hexa
# $t4 = b char to check if binary
# $t5 = prefix for argument 1
# $t6 = prefix for argument 2
.text
main:  	  
 	li $v0, 4	#Prints prompt to echo inputs	
 	la $a0, prompt	
 	syscall
 	la $a0, newline	#Prints a new line
 	syscall
 	lw $a0, 0($a1)	#Prints first argument of program                    
   	syscall
   	la $a0, space	#Prints a space between first and second arguments
   	syscall
   	lw $a0, 4($a1)	#Prints second argument of program
   	syscall	
 	la $a0, newline	#Prints a new line
 	syscall
 	lw $t1, 0($a1)	#Loads 1st argument into $t1
 	lw $t2, 4($a1)	#Loads 2nd argument into $t2
 	li $t3, 'x'	#Loads char to check if binary
 	li $t4, 'b'	#Loads char to check if hexadecimal
 	lb $t5, 1($t1)	#Loads prefix of argument 1 into $t5
 	lb $t6, 1($t2)	#Loads prefix of argument 2 into $t6
 	beq $t5, $t3, HexConversion1	#Checks to see if it is written in hexadecimal and converts to decimal twos complement
 	beq $t5, $t4, BinConversion1	#Checks to see it if is written in binary and does a binary conversion
 	
################################################################################################################################ 
#Register Usage:
# $t7 = left number of hexa input
# $t8 =	right number of hexa input
# $t9 = value to check if number is 0-9 or A-F	
HexConversion1:
	lb $t7, 2($t1)	#Loads first bit into $t7
	lb $t8, 3($t1)	#Loads second bit into $t8
	li $t9, 65	#Loads value to compare to see if bit is greater than 9 (In terms of converted ASCII)
	slt $t9, $t7, $t9	#Less than comparasion that resets value of $t9 to result of comparasion
	beq $t9, 0, LetterConv	#Depending on result, subtracts proper value to convert number to decimal
	beq $t9, 1, NumbConv	#Depending on result, subtracts proper value to convert number to decimal
LetterConv:
	subi $t7,$t7, 55	#Subtracts for a value greater than 10
	j Return
NumbConv:
	subi $t7, $t7, '0' 	#Subtracts normally if less than 10
Return:	 	
	li $t9, 65		#Process repeats for second bit. Same as the first.
	slt $t9, $t8, $t9	#Less than comparasion that resets value of $t9 to result of comparasion
	beq $t9, 0, LetterConv2	#Depending on result, subtracts proper value to convert number to decimal
	beq $t9, 1, NumbConv2	#Depending on result, subtracts proper value to convert number to decimal
LetterConv2:
	subi $t8,$t8, 55	#Subtracts for a value greater than 10
	j Return2
NumbConv2:	
	subi $t8, $t8, '0'	#Subtracts normally if less than 10
Return2:	
	mul $t7,$t7 16		#Multiplies first bit by 16
	add $t7, $t7, $t8	#Adds value of second bit
	move $t1, $t7		#Moves result back into $t1, replacing it with its decimal value
	li $t9, 128		#Loads number to check if decimal is negative in 2SC
	slt $t9, $t1, $t9	#Compares and value is set to $t9
	beq $t9, 0, Hex2SC	#If value is negative, jumps to conversion
	beq $t9, 1, Return3	#Else number stays the same
Hex2SC:	 
	subi $t1, $t1, 256	#Subtracts 256 from decimal value to convert to 2SC in decimal
	j Return3
################################################################################################################################
#Register Usage:
# $t7 = holds current bit being evaluated
# $t8 = holds sum in decimal	
BinConversion1:	
	lb $t7, 2($t1)		#Loads MSB into $t7
	subi $t7, $t7, 48	#Converts bit into integer value
	li $t8, 0		#Resets $t8 value so it can hold binary conversion in decimal
	mul $t7,$t7, 128	#Multilpies MSB by 2^7
	add $t8, $t8, $t7	#Adds it to sum
	lb $t7, 3($t1)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 64		#Multilpies MSB by 2^6
	add $t8, $t8, $t7	#Adds it to sum
	lb $t7, 4($t1)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 32		#Multilpies MSB by 2^5
	add $t8, $t8, $t7	#Adds it to sum
	lb $t7, 5($t1)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 16		#Multilpies MSB by 2^4
	add $t8, $t8, $t7	#Adds it to sum
	lb $t7, 6($t1)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 8		#Multilpies MSB by 2^3
	add $t8, $t8, $t7	#Adds it to sum
	lb $t7, 7($t1)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 4		#Multilpies MSB by 2^2
	add $t8, $t8, $t7	#Adds it to sum
	lb $t7, 8($t1)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 2		#Multilpies MSB by 2^1
	add $t8, $t8, $t7	#Adds it to sum
	lb $t7, 9($t1)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	add $t8, $t8, $t7	#Adds it to sum
	move $t1, $t8		#Overwrites $t1 and moves sum into register
	li $t7, 128		#Loads 128 into $t7 to see if decimal value is negative in 2SC
	slt $t7, $t1, $t7	#Compares the two and overwrites value in $t7 to result
	beq $t7, 0, Bin2SC	#If false(number is negative in 2SC)  converts to 2SC
	beq $t7, 1, Return3	#If true (number is positive in 2SC) continues
Bin2SC:
	subi $t1, $t1, 256	#Subtracts 256 from decimal value to convert to 2SC in decimal
	j Return3
################################################################################################################################
#Register Usage:	
Return3:	
	beq $t6, $t3, HexConversion2	#Checks to see if it is written in hexadecimal and converts to decimal twos complement
	beq $t6, $t4, BinConversion2	#Checks to see it if is written in binary and does a binary conversion
################################################################################################################################
#Register Usage:
# $t7 = left number of hexa input
# $t8 =	right number of hexa input
# $t9  = value to check if number is 0-9 or A-F	
HexConversion2:
	lb $t7, 2($t2)	#Loads first bit into $t7
	lb $t8, 3($t2)	#Loads second bit into $t8
	li $t9, 65	#Loads value to compare to see if bit is greater than 9 (In terms of converted ASCII)
	slt $t9, $t7, $t9	#Less than comparasion that resets value of $t9 to result of comparasion
	beq $t9, 0, LetterConv3	#Depending on result, subtracts proper value to convert number to decimal
	beq $t9, 1, NumbConv3	#Depending on result, subtracts proper value to convert number to decimal
LetterConv3:
	subi $t7,$t7, 55	#Subtracts for a value greater than 10
	j Return4
NumbConv3:
	subi $t7, $t7, '0' 	#Subtracts normally if less than 10
Return4:	 	
	li $t9, 65		#Process repeats for second bit. Same as the first.
	slt $t9, $t8, $t9	#Less than comparasion that resets value of $t9 to result of comparasion
	beq $t9, 0, LetterConv4	#Depending on result, subtracts proper value to convert number to decimal
	beq $t9, 1, NumbConv4	#Depending on result, subtracts proper value to convert number to decimal
LetterConv4:
	subi $t8,$t8, 55	#Subtracts for a value greater than 10
	j Return5
NumbConv4:	
	subi $t8, $t8, '0'	#Subtracts normally if less than 10
Return5:	
	mul $t7,$t7 16		#Multiplies first bit by 16
	add $t7, $t7, $t8	#Adds value of second bit
	move $t2, $t7		#Moves result back into $t1, replacing it with its decimal value
	li $t9, 128		#Loads number to check if decimal is negative in 2SC
	slt $t9, $t2, $t9	#Compares and value is set to $t9
	beq $t9, 0, Hex2SC2	#If value is negative, jumps to conversion
	beq $t9, 1, Return6	#Else number stays the same
Hex2SC2:	 
	subi $t2, $t2, 256	#Subtracts 256 from decimal value to convert to 2SC in decimal
	j Return6
################################################################################################################################
#Register Usage:
# $t7 = holds current bit being evaluated
# $t8 = holds sum in decimal	
BinConversion2:
	lb $t7, 2($t2)		#Loads MSB into $t7
	subi $t7, $t7, 48	#Converts bit into integer value
	li $t8, 0		#Resets $t8 value so it can hold binary conversion in decimal
	mul $t7,$t7, 128	#Multilpies MSB by 2^7
	add $t8, $t8, $t7	#Adds it to sum
	lb $t7, 3($t2)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 64		#Multiplies bit by 2^6
	add $t8, $t8, $t7	#Adds to sum
	lb $t7, 4($t2)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 32		#Multiplies bit by 2^5
	add $t8, $t8, $t7	#Adds to sum
	lb $t7, 5($t2)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 16		#Multiplies bit by 2^4
	add $t8, $t8, $t7	#Adds to sum
	lb $t7, 6($t2)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 8		#Multiplies bit by 2^3
	add $t8, $t8, $t7	#Adds to sum
	lb $t7, 7($t2)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 4		#Multiplies bit by 2^2
	add $t8, $t8, $t7	#Adds to sum
	lb $t7, 8($t2)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	mul $t7,$t7, 2		#Multiplies bit by 2^1
	add $t8, $t8, $t7	#Adds to sum
	lb $t7, 9($t2)		#Loads next bit
	subi $t7, $t7, 48	#Converts to integer value
	add $t8, $t8, $t7	#Adds to sum
	move $t2, $t8		#Moves sum to overwrite value in $t2
	li $t7, 128		#Loads 128 into $t7 to see if decimal value is negative in 2SC
	slt $t7, $t2, $t7	#Compares the two and overwrites value in $t7 to result
	beq $t7, 0, Bin2SC2	#If false(number is negative in 2SC)  converts to 2SC
	beq $t7, 1, Return6	#If true (number is positive in 2SC) continues
Bin2SC2:
	subi $t2, $t2, 256	#Subtracts 256 from value to gain corresponding 2SC value
	j Return6	
################################################################################################################################
#Register Usage:
# $t0 = value to compare for negatives
# $t1 = argument 1 in 2SC/dividend
# $t2 = argument 2 in 2SC/multiplier
# $t3 = divisor (4)
# $t4 = Sum for integer form of base 4 number
# $t5 = remainder holder
		
Return6:
	li $v0, 4	
 	la $a0, prompt2	#Prints prompt to show sum
 	syscall
 	
 	la $a0, newline	#Prints a new line
 	syscall
 	
 	add $s0, $t1, $t2#Sums both numbers together to get result in 2SC decimal
 	li $t1, 0	#Sets value of $t1 to zero to compare it to sum
 	slt $t1, $s0, $t1#Checks if sum is negative and writes result to $t1
 	beq $t1, 1, PrintNegative#If true, moves to print negative sign
 	li $t0, 0	#Clears value for $t0
 	move $t1, $s0	#Dividend
 	li $t2, 1	#Remainder multiplier
 	li $t3, 4	#Divisor for base 4
 	li $t4, 0	#Base 4 sum as an integer
 	j ConvBaseFour
PrintNegative:
 	li $v0, 11	#Loads character print command
 	li $a0, 45	#Loads negative sign into $a0 and prints it
 	syscall
 	li $t0, 0	#Sets $t0 to 0 for negative comparision
 	move $t1, $s0	#Dividend
 	li $t2, 1	#Remainder multiplier
 	li $t3, 4	#Divisor for base 4
 	li $t4, 0	#Base 4 sum as an integer
 	j ConvBaseFour
ConvBaseFour:
 	beq $t0, $t1,PrintNumber#Condition to end once quotient equals zero
 	div $t1, $t3		#Divides quotient by 4
 	mflo $t1		#Moves new quotient to $t1
 	mfhi $t5		#Moves remainder to $t5
 	mul $t5, $t5, $t2	#Multiplies by multiplier
 	mul $t2, $t2, 10	#Increment one space to left for next run
 	add $t4, $t4, $t5	#Add value to sum
 	move $s0, $t4
 	j ConvBaseFour		
################################################################################################################################
#Register Usage:
# $t0 = value to compare for negatives/divisor of 10
# $t1 = 1st digit of base 4 value
# $t2 = 2nd digit of base 4 value
# $t3 = 3rd digit of base 4 value
# $t4 = 4th digit of base 4 value
# s0 = sum of base 4 value in integer form
PrintNumber:
	li $t0, 0		#Sets $t0 to 0 for negative comparision
	slt $t0, $s0, $t0	#Checks to see if sum is negative
	beq $t0, 1, MakePositive#If true, make is positive or continue
	j Return7
MakePositive:
	mul $s0, $s0, -1	#Multiplies sum by -1 to make it positive
	j Return7
Return7:	
	li $v0, 11		#Loads print char command
	li $t0, 10		#Loads 10 to $to to check number of digits in value
	slt $t0, $s0, $t0	#Checks to see if sum is < 10
	beq $t0, 1, Print1	#If true, jumps to printing for 1 digit
	li $t0, 100		#Loads 100 to $to to check number of digits in value
	slt $t0, $s0, $t0	#Checks to see if sum is < 100
	beq $t0, 1, Print2	#If true, jumps to printing for 2 digits
	li $t0, 1000		#Loads 1000 to $to to check number of digits in value
	slt $t0, $s0, $t0	#Checks to see if sum is < 1000
	beq $t0, 1, Print3	#If true, jumps to printing for 3 digits
	j Print4		#If all else fails, umps to printing for 4 digits
	
Print1:
	addi $s0, $s0, 48	#Converts to ASCII value
	move $a0, $s0		#Loads character into $a0 and prints
	syscall
	j End			#Jumps to end
Print2:
	li $t0, 10		#Loads divisor 10 into $t0
	div $s0, $t0		#Divide by 10 to isolate rightmost digit
	mflo $s0		#Overwrites $s0 with quotient
	mfhi $t4		#Moves rightmost digit (remainder) to $t4
	addi $t4, $t4, 48	#Converts to ASCII value
	div $s0, $t0		#Divide by 10 to isolate rightmost digit
	mflo $s0		#Overwrites $s0 with quotient
	mfhi $t3		#Moves rightmost digit (remainder) to $t3
	addi $t3, $t3, 48	#Converts to ASCII value
	move $a0, $t3		#Loads character into $a0 and prints
	syscall
	move $a0, $t4		#Loads character into $a0 and prints
	syscall
	j End
Print3:
	li $t0, 10		#Loads divisor 10 into $t0
	div $s0, $t0		#Divide by 10 to isolate rightmost digit
	mflo $s0		#Overwrites $s0 with quotient
	mfhi $t4		#Moves rightmost digit (remainder) to $t4
	addi $t4, $t4, 48	#Converts to ASCII value
	div $s0, $t0		#Divide by 10 to isolate rightmost digit
	mflo $s0		#Overwrites $s0 with quotient
	mfhi $t3		#Moves rightmost digit (remainder) to $t3
	addi $t3, $t3, 48	#Converts to ASCII value
	div $s0, $t0		#Divide by 10 to isolate rightmost digit
	mflo $s0		#Overwrites $s0 with quotient
	mfhi $t2		#Moves rightmost digit (remainder) to $t2
	addi $t2, $t2, 48	#Converts to ASCII value
	move $a0, $t2		#Loads character into $a0 and prints
	syscall
	move $a0, $t3		#Loads character into $a0 and prints
	syscall
	move $a0, $t4		#Loads character into $a0 and prints
	syscall
	j End	
Print4:
	li $t0, 10		#Loads divisor 10 into $t0
	div $s0, $t0		#Divide by 10 to isolate rightmost digit
	mflo $s0		#Overwrites $s0 with quotient
	mfhi $t4		#Moves rightmost digit (remainder) to $t4
	addi $t4, $t4, 48	#Converts to ASCII value
	div $s0, $t0		#Divide by 10 to isolate rightmost digit
	mflo $s0		#Overwrites $s0 with quotient
	mfhi $t3		#Moves rightmost digit (remainder) to $t3
	addi $t3, $t3, 48	#Converts to ASCII value
	div $s0, $t0		#Divide by 10 to isolate rightmost digit
	mflo $s0		#Overwrites $s0 with quotient
	mfhi $t2		#Moves rightmost digit (remainder) to $t2
	addi $t2, $t2, 48	#Converts to ASCII value
	div $s0, $t0		#Divide by 10 to isolate rightmost digit
	mflo $s0		#Overwrites $s0 with quotient
	mfhi $t1		#Moves rightmost digit (remainder) to $t1
	addi $t1, $t1, 48	#Converts to ASCII value
	move $a0, $t1		#Loads character into $a0 and prints
	syscall
	move $a0, $t2		#Loads character into $a0 and prints
	syscall
	move $a0, $t3		#Loads character into $a0 and prints
	syscall
	move $a0, $t4		#Loads character into $a0 and prints
	syscall

End:
	li $v0, 10	#Exits the program
	syscall
	
.data
prompt: .asciiz "You entered the numbers:"
prompt2: .asciiz "The sum in base 4 is:"
newline: .asciiz "\n"
space: .asciiz " "
