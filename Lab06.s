###########################################################
#       Lab 6 - System Stack
#
#	Description:
#		This template is the solution of a program using
#		pass by register method
#
#   TODO:
#       Modify this solution so that it uses system stack to pass arguments    
#       IN and OUT. Again, $a and $v registers should NOT be used to pass arguments,
#       only the stack should be used. Please do not modify the logic of code,
#       only change what is needed to use the stack.
#
###########################################################
#		Register Usage
#	$t0 
#	$t1 
#	$t2 
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
sum_p:      .asciiz "Sum: "
count_p:    .asciiz "\nCount: "
array_p:    .asciiz "\nDynamic Array: "

array:      .word	0
length:		.word	0
sum:    	.word	0
avg:		.word	0
###########################################################
		.text
main:

	jal allocate_array					# call allocate_array
	la $t0, array                      	# $t0 <- address of static variable "array"
	sw $v0, 0($t0)						# mem[array] <- base address

	la $t1, length                		# $t1 <- address of static variable "length"
	sw $v1, 0($t1)                      # mem[length] <- array length

	lw $a0, 0($t0)                      # $a0 <- base addresss
	lw $a1, 0($t1)                      # $a1 <- array length

	jal read_values                     # call read_values

	la $t1, sum					 		# $t1 <- address of static variable "sum"
	sw $v0, 0($t1)                      # mem[sum] <- sum of array

	li $v0, 4                           # $v0 <- 4 (setup syscall to print string)
	la $a0, sum_p						# $a0 <- address of static vairiable "sum_p:
	syscall

	li $v0, 1                           # $v0 <- 1 (setup syscall to print integer)
	lw $a0, 0($t1)						# $a0 <- sum of array
	syscall

	li $v0, 4                           # $v0 <- 4 (setup syscall to print string)
	la $a0, count_p						# $a0 <- address of static variable "count_p"
	syscall

	li $v0, 1                           # $v0 <- 1 (setup syscall to print integer)
	la $t1, length						# $t1 <- address of static variable "length"
	lw $a0, 0($t1)						# $a0 <- array length
	syscall

	la $a0, sum                   		# $a0 <- address of static variable "sum"
	lw $a0, 0($a0)                      # $a0 <- sum of array

	la $a1, length						# $a1 <- address of static variable "length"
	lw $a1, 0($a1)     					# $a1 <- array length

	jal print_average                   # call print_average

	li $v0, 4							# $v0 <- 4 (setup syscall to print string)
	la $a0, array_p						# $a0 <- address of static variable "array_p"
	syscall

	la $a0, array						# $a0 <- addresss of static variable "array"
	lw $a0, 0($a0)						# $a0 <- array base address

	la $a1, length						# $a0 <- address of static variable "length"
	lw $a1, 0($a1)                      # $a1 <- array length

	jal print_values					# call print_backwards

exit:
	li $v0, 10							# $v0 <- 10 (setup syscall to end program)
	syscall

###########################################################
#		Allocate Array
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0 array base address
#	$v1 array length
###########################################################
#		Register Usage
#	$t0 
#	$t1 array length
#	$t2 
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
allocate_array_length_p:       .asciiz   "Please enter array length: "
allocate_array_negative_p:     .asciiz   "Invalid length ( n > 0 )!\n"
###########################################################
		.text
allocate_array:

allocate_array_loop:

	li $v0, 4                           # $v0 <- 4 (setup syscall to print string)
	la $a0, allocate_array_length_p		# $a0 <- address of "allocate_array_length_p"
	syscall

	li $v0, 5                           # $v0 <- 5 (setup syscall to read integer)
	syscall								# $v0 <- user input length
	
	move $t1, $v0						# $t1 <- user input length

	blez $t1, allocate_array_neg_length # if (user input <= 0) -> allocate_array_neg_length

	li $v0, 9                           # $v0 <- 9 (setup syscall to allocate array)
	sll $a0, $t1, 2						# $a0 <- user input length * 2^2
	syscall								# $v0 <- array base address

	move $v1, $t1                       # $v1 <- user input length

	b allocate_array_end				# -> allocate_array_end
	
allocate_array_neg_length:
	li $v0, 4                           # $v0 <- 4 (setup syscall to print string)
	la $a0, allocate_array_negative_p	# $a0 <- address of "allocate_array_negative_p"
	syscall

	b allocate_array_loop				# -> allocate_array_loop
	
allocate_array_end:
	jr $ra								# return to calling location
###########################################################
#		Read Values
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0 array base address
#	$a1 array length
#	$a2 
#	$a3
#	$v0 sum of array
#	$v1
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
#	$t2 constant 2
#	$t3 constant 3
#	$t4 sum of array
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9 
###########################################################
		.data
read_values_prompt_p:       .asciiz "Enter a non-negative odd integer also divisible by 3: "
read_values_invalid_p:      .asciiz "Invalid Entry. Try Again\n"
###########################################################
		.text
read_values:

	move $t0, $a0                       # $t0 <- array base address (pointer)
	move $t1, $a1						# $t1 <- array size (counter)
	li $t2, 2							# $t2 <- 2
	li $t3, 3							# $t3 <- 3
	li $t4, 0							# $t4 <- 0 (initialize sum)

read_values_loop:

	blez $t1, read_values_end			# if (counter <= 0) -> read_values_end

	li $v0, 4                          	# $v0 <- 4 (setup syscall to print string)
	la $a0, read_values_prompt_p		# $a0 <- base address of "read_values_prompt_p"
	syscall

	li $v0, 5                          	# $v0 <- 5 (setup syscall to read integer)
	syscall								# $v0 <- user input

	bltz $v0, read_values_invalid_entry # if (user input < 0) -> read_values_invalid_entry

	rem $t9, $v0, $t2					# $t9 <- user input mod 2
	beqz $t9, read_values_invalid_entry # if (remainder == 0) -> read_values_invalid_entry

	rem $t9, $v0, $t3                 	# $t9 <- user input mod 3
	bnez $t9, read_values_invalid_entry # if (remainder != 0) -> read_values_invalid_entry

	sw $v0, 0($t0)                   	# mem[pointer] <- valid input
	addi $t0, $t0, 4                 	# $t0 <- pointer + 4
	addi $t1, $t1, -1					# $t1 <- counter - 1
	add $t4, $t4, $v0					# $t4 <- sum + valid input
	
	b read_values_loop					# -> read_values_loop
	
read_values_invalid_entry:

	li $v0, 4                        	# $v0 <- 4 (setup syscall for print string)
	la $a0, read_values_invalid_p		# $a0 <- address of "read_values_invalid_p
	syscall
	
	b read_values_loop             		# -> read_values_loop

read_values_end:

	move $v0, $t4                   	# $v0 <- sum of array
	jr $ra	                            # return to calling location.   

###########################################################
#		Print Values
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0 array base address
#	$a1 array length
#	$a2
#	$a3
#	$v0
#	$v1
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
#	$t2 
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
print_values_tab_p:    .asciiz  "\t"
###########################################################
		.text
print_values:

	move $t0, $a0                       # $t0 <- array base address (pointer)
	move $t1, $a1                       # $t1 <- array length (counter)

print_values_loop:

	blez $t1, print_values_end       # if (counter <= 0) -> print_backwards_end
	
	li $v0, 1							# $v0 <- 1 (setup syscall to print integer
	lw $a0, 0($t0)						# $a0 <- mem[pointer]
	syscall

	li $v0 4							# $v0 <- 4 (setup syscall to print string)
	la $a0, print_values_tab_p		# $a0 <- address of "print_backwards_tab_p"
	syscall

	addi $t1, $t1, -1					# $t1 <- counter - 1
	addi $t0, $t0, 4					# $t0 <- counter - 4

	b print_values_loop				# -> print_backwards_loop

print_values_end:

	jr $ra								# return to calling location
###########################################################
#		Print Average
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0 Sum of array
#	$a1 array length
#	$a2
#	$a3
#	$v0
#	$v1
###########################################################
#		Register Usage
#	$t0 Sum of array
#	$t1 array length
#	$t2 quotient
#	$t3 remainder
#	$t4 
#	$t5
#	$t6
#	$t7 Number 4.
#	$t8 Keeps the count of how many digits after the decimal pointed has been printed.
#	$t9 Number 10.
###########################################################
		.data
print_average_p:      .asciiz "\nAverage: "
print_average_period_p:      .asciiz "."
###########################################################
		.text
print_average:

	move $t0, $a0						# $t0 <- sum of array
	move $t1, $a1						# $t1 <- length of array
	li $t8, 0							# $t8 <- 0 (counter)
	li $t7, 4							# $t7 <- 4 (num of digits)
	li $t9, 10							# $t9 <- 10 (multiplier)

	li $v0, 4							# $v0 <- 4 (setup syscall for print string)
	la $a0, print_average_p 			# $a0 <- addresss of "print_average_p"
	syscall

	div $t2,$t0, $t1					# $t2 <- sum of array / array length
	li $v0, 1							# $v0 <- 1 (setup syscall to print integer)
	move $a0, $t2						# $a0 <- quotient
	syscall

	li $v0, 4							# $v0 <- 4 (setup syscall to print string)
	la $a0, print_average_period_p		# $a0 <- address of "print_average_period_p"
	syscall

print_average_loop:
	beq $t8, $t7, print_average_end		# if (counter == 4) -> print_average_end

	mfhi $t3							# $t3 <- remainder
	mul $t3, $t3, $t9					# $t3 <- remainder * 10
	div $t3, $t1						# do $t3 / length of array

	li $v0, 1							# $v0 <- 1 (setup syscall to print integer)
	mflo $a0							# $a0 <- quotient
	syscall

	addi $t8, $t8, 1					# $t8 <- counter + 1

	b print_average_loop				# -> print_average_loop
		
print_average_end:

	jr $ra								# return to calling location
###########################################################