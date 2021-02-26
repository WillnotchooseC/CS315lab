###########################################################
#       Lab 5 - Debugging
#   Name:
#   Date:
#
#   Objective:
#       The purpose of this lab assignment is to help you understand
#       debugging processes in assembly language using debug tools 
#       provided by QtSpim
#
#   Description:
#       1) Syntax, logic, and comment errors exist in:
#               - main
#               - print_array
#               - read_array
#      	        - allocate_array
#       2) Find and fix the syntax, logical, and comment errors
#	          *** Hint: Find all the "#To do" and fix bugs ***
#	          *** There are 23 total bugs to fix! ***
#       3) Test the code. If the code is working, submit to
#          the Lab #5 dropbox on Canvas
#
#   Note:
#       sort_array subprogram is correct and has no bug, do not modify sort_array!
#
#   Sample run:
#       Enter size of the array to allocate (size > 0): 5
#       Enter an integer: 4
#       Enter an integer: 3
#       Enter an integer: 2
#       Enter an integer: 1
#       Enter an integer: -5
#       Array: 4 3 2 1 -5 
#       Array: -5 1 2 3 4
#
########################################################### 
        .data
array_pointer_p:    .word 0     # holds address of dynamic array (address)
array_size_p:       .word 0     # hold size of dynamic array (value)

newline_p:          .asciiz "\n"
###########################################################
        .text
main:
# set up arguments for allocate_array subprogram
    la $a0, array_pointer_p # load the address of static variable array_pointer into register $a0
    la $a1, array_size_p    # load the address of static variable array_size into register $a1
    
    jal allocate_array      # call subprogram allocate_array
                            # arguments IN: address of static variable "array_pointer" & "array_size"
                            # arguments OUT: NONE

                          
# set up arguments for read_array subprogram
#To do: Think about the logic and syntax and fix errors

    la $a0, array_pointer_p # load the address of variable array_pointer into register $a0
                            
    la $a1, array_size_p    # load the address of variable array_size into register $a1
                            
                            
    jal read_array         # call subprogram read_array
                           # arguments IN: true address of dynamic array and array size value
                           # arguments OUT: NONE

                            
# calling subprogram print_array
#To do: Think about the logic and syntax and fix errors
    
    la $a0, array_pointer_p # load the address of variable array_pointer into register $a0
    la $a1, array_size_p    # load the address of variable array_size into register $a1
    
    jal print_array         # calling subprogram print_array

# print newline character
    la $a0, newline_p       # prints newline character
    li $v0, 4
    syscall
    
# calling subprogram sort_array 
#To do: Think about the logic and syntax and fix errors

    la $a0, array_pointer_p # load the address of variable array_pointer into register $a0
    la $a1, array_size_p    # load the address of variable array_size into register $a1
    
    jal sort_array          # calling subprogram sort_array 

    
# calling subprogram print_array 
#To do: Think about the logic and syntax and fix error
   
    la $a0, array_pointer_p # load the address of variable array_pointer into register $a0
    la $a1, array_size_p    # load the address of variable array_size into register $a1
    
    jal print_array         # calling subprogram print_array

mainEnd:
    li $v0, 4
    syscall                 # Halt
###########################################################
#       Arguments IN and OUT of subprogram
#   $a0  Holds array pointer (address)
#   $a1  Holds array size pointer (address)
#   $a2
#   $a3
#   $v0
#   $v1
#   $sp
#   $sp+4
#   $sp+8
#   $sp+12
###########################################################
#       Register Usage
#   $t0  Holds array pointer (address)
#   $t1  Holds array size pointer (address)
#   $t2  Holds array size, temporarily  
###########################################################
        .data
allocate_array_prompt_p:    .asciiz "Enter size of the array to allocate (size > 0): "
allocate_array_invalid_p:   .asciiz "Array size you entered is incorrect (size > 0)!\n"
###########################################################
        .text
allocate_array:
# save arguments so we do not lose them
#To do: Think about the logic and syntax and fix errors

    move $t0, $a0               # move array pointer (address) to $t0
    move $t1, $a1               # move array size pointer (address) to $t1
    
allocate_array_loop:
    li $v0, 4                   # prompt for array size
    la $a0, allocate_array_prompt_p
    syscall
 
#To do: Think about syntax and fix error
   
    li $v0, 5                   # reads integer for array size
    syscall

#To do: Think about logic and fix error
    blez $v0, allocate_array_invalid_size   # branch to error section as array size is
                                            # less than or equal to zero
    
    move $t2, $v0               # store valid array size in register $t2

#To do: Think about syntax and fix error    
    li $v0, 9                   # dynamically allocate an array (using system call 9)
    move $a0, $t2               # puts array size in register $a0

#To do: Think about logic and fix error
    sll $a0, $a0, 2             # multiply array size by 4, as word in MIPS is 4 bytes
    syscall

    b allocate_array_end        # branch unconditionally to the end of subprogram
    
allocate_array_invalid_size:
    li $v0, 4                   # prints error saying that array size is less than or equal to zero
    la $a0, allocate_array_invalid_p
    syscall
    
    b allocate_array_loop       # branch unconditionally back to beginning of the loop
    
allocate_array_end:
    sw $v0, 0($t0)              # store address of dynamic array in static variable (array_pointer)

#To do: Think about logic and fix error
    sw $t2, 0($t1)              # store size of dynamic array in static variable (array_size)

    jr $ra                      # jump back to the main
###########################################################
#      read_array subprogram
#
#   Subprogram description:
#       This subprogram will receive as argument IN address of integer array and then
#       prompts for integer and read integer for each array element (or index). This 
#       subprogram does not return anything as argument OUT.
#
########################################################### 
#       Arguments IN and OUT of subprogram
#   $a0  Holds array pointer (address)
#   $a1  Holds array size (value)
#   $a2
#   $a3
#   $v0
#   $v1
#   $sp
#   $sp+4
#   $sp+8
#   $sp+12
###########################################################
#       Register Usage
#   $t0  Holds array pointer (address)
#   $t1  Holds array index
###########################################################
        .data
read_array_prompt_p:  .asciiz "Enter an integer: "
###########################################################
        .text
read_array:
# save arguments so we do not lose them
#To do: Think about syntax, logic, and fix errors

    move $t1, $a0               # move array pointer (address) to $t0
    move $t0, $a1               # move array size (value) to $t1
    
read_array_loop:
#To do: Think about logic and fix error

    bge $t1, read_array_end    # branch to read_array_end if counter is less than or equal to zero

#To do: Think about syntax and fix error   
    li $v0, 5                   # prompt array element
    la $a0, read_array_prompt_p
    syscall

#To do: Think about syntax and fix error   
    li $v0, 4                   # reads integer
    syscall

#To do: Think about logic and syntax and fix errors    
    sw $a0, 4($t0)              # memory[$t0 + 0] <-- $v0
                                # store a value that is in register $v0 into memory

#To do: Think about syntax and fix error    
    addi $t0, $t0, 6            # increment array pointer (address) to next word (each word is 4 bytes)
    addi $t1, $t1, -1           # decrement array counter (index)
    
    b read_array_loop           # branch unconditionally back to beginning of the loop
    
read_array_end:

#To do: Think about syntax, comments and fix errors

###########################################################
#      sort_array subprogram
#
#   ***                                   ***  <<<<<<
#   *** DO NOT MODIFY this subprogram !!! ***  <<<<<<
#   ***                                   ***  <<<<<<
#
#   Subprogram description:
#       This subprogram will receive as argument IN address of integer
#       array and size and it iterates through array via two nested loops
#       and sorts all elements of array (in-place sort). This subprogram
#       does not return anything as argument OUT.
#
#   Algorithm O(n^2) running time (highly inefficient, too slow):
#
#       for (i = 0; i < array.length; i++) {
#           for (i = 0; i < array.length; i++) {
#               if (array[index] >= array[index + 1]) {
#                   swap(array[index], array[index + 1])
#               }
#           }
#       }
#
###########################################################
#       Arguments IN and OUT of subprogram
#   $a0  Holds array pointer (address)
#   $a1  Holds array size (value)
#   $a2
#   $a3
#   $v0
#   $v1
#   $sp
#   $sp+4
#   $sp+8
#   $sp+12
###########################################################
#       Register Usage
#   $t0  Holds array pointer (address)
#   $t1  Holds array index
#   $t2  Holds (unmodified / original) array pointer (address)
#   $t3  Holds inner-loop counter (count-down from array size to 0) 
#   $t4  Holds outer-loop counter (count-down from array size to 0)  
#   $t5  
#   $t6  
#   $t7  
#   $t8  temporarily
#   $t9  temporarily 
###########################################################
        .data
########################################################### 
        .text
sort_array:
# save arguments so we do not lose them
    move $t0, $a0               # move array pointer (address) to $t0
    move $t1, $a1               # move array size (value) to $t1
    
    addi $t1, $t1, -1           # subtract one from array size 
    
    blez $t1, sort_array_end    # if array size was originally 1 then array
                                # is already sorted
    
    move $t2, $t0               # backup base address into register $t2
    
    move $t3, $t1               # backup $t1 which is array size - 1 into $t3
    move $t4, $t1               # backup $t1 which is array size - 1 into $t4
    
sort_array_loop1:
    blez $t3, sort_array_loop1_end      # if outer-looper counter <= 0 then stop outer-loop

    sort_array_loop2:       
        blez $t4, sort_array_loop2_end  # if inner-looper counter <= 0 then stop inner-loop
        
        lw $t8, 0($t0)          # $t8 <-- array[index]
        lw $t9, 4($t0)          # $t9 <-- array[index + 1]
        
        ble $t8, $t9, sort_array_no_swap # if $t8 < $t9 then no need to swap in-place
            
        sort_array_swap:
            sw $t9, 0($t0)      # array[index] = $t9
            sw $t8, 4($t0)      # array[index] = $t8
        
        sort_array_no_swap:
            addi $t0, $t0, 4    # increment base address by 4 (because integers are 4 bytes)
            addi $t4, $t4, -1   # decrement inner-loop counter by 1
    
        b sort_array_loop1      # branch unconditionally to the beginning of inner-loop
        
    sort_array_loop2_end:
        move $t0, $t2           # restore inner-loop counter to array size - 1
        move $t4, $t1           # restore array address to first element of array or base address
        
        addi $t3, $t3, -1       # decrement outer-loop counter by 1
        
        b sort_array_loop2      # branch unconditionally to the beginning of outer-loop-loop
    
sort_array_loop1_end:   
    
sort_array_end:
    jr $ra                      # jump back to the main
###########################################################
#      print_array subprogram
#
#   Subprogram description:
#       This subprogram will receive as argument IN address of integer
#       array and size and it iterates through array and prints all
#       elements of array. This subprogram does not return anything
#       as argument OUT.
#
###########################################################
#       Arguments IN and OUT of subprogram
#   $a0  Holds array pointer (address)
#   $a1  Holds array size (value)
#   $a2
#   $a3
#   $v0
#   $v1
#   $sp
#   $sp+4
#   $sp+8
#   $sp+12
###########################################################
#       Register Usage
#   $t0  Holds array pointer (address)
#   $t1  Holds array index
###########################################################
        .data
print_array_array_p:    .asciiz     "Array: "
print_array_space_p:    .asciiz     " " 
###########################################################
        .text
print_array:
# save arguments so we do not lose them
#To do: Think about syntax and fix errors

    move $t1, $a0               # move array pointer (address) to $t0
    move $t0, $a1               # move array size (value) to $t1
    
    li $v0, 4                   # prints array is:
    la $a0, print_array_array_p
    syscall
    
print_array_while:
#To do: Think about logic and fix errors

    blt $t9, print_array_end   # branch to print_array_end if counter is less than or equal to zero
    
# print value from array
#To do: Think about logic, syntax, and fix errors
    li $v0, 4
    sw $a0, 0($t0)              # $a0 <-- memory[$t0 + 0]
                                # load a value from memory to register $a0
    syscall
    
    li $v0, 4                   # space character
    la $a0, print_array_space_p
    syscall 

#To do: Think about logic and fix errors   
    addi $t0, $t0, 8            # increment array pointer (address) to next word (each word is 4 bytes)
    addi $t1, $t1, -1           # decrement array counter (index)

#To do: Think about logic, syntax, comments and fix errors    
    b print_array               # branch unconditionally back to beginning of the loop
    
print_array_end:

#To do: Think about syntax, comments, and fix errors
########################################################### 
