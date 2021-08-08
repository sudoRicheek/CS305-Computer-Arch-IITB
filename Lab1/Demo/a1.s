.data

    prompt1: 
        .asciiz "Enter the size of the array\n"
    
    prompt2: 
        .asciiz "Enter the elements of the array\n"

.text

    main: 
        la $a0 prompt1      # get prompt1
        li $v0 4            # load print string opcode
        syscall             # print prompt1

        li $v0 5            # read int
        syscall
        move $s0 $v0        # $s0 has 'n' [IMPORTANT]

        sll $a0 $v0 2       # number of bytes allocated now in $a0=$v0<<2
        li $v0 9            # sbrk heap allocation op code
        syscall             # address of space now in $v0
        move $s1 $v0        # $s1 has base address of the empty array [IMPORTANT]

        la $a0 prompt2      # get prompt2
        li $v0 4            # load print string opcode
        syscall             # print prompt2

        move $t0 $zero      # $t0 behaves like 'i' to loop and take inputs
        move $t1 $s1        # $t1 stores the address to store the current input
    
    # Take inputs in the array
    loop_input:
        li $v0 5            # read int
        syscall
        sw $v0 ($t1)        # store $v0 in 0($t1)

        addi $t0 $t0 1
        addi $t1 $t1 4
        
        bne $t0 $s0 loop_input

    
        move $t0 $zero
        move $t1 $s1

    ; loop_print:
    ;     li $v0 1
    ;     lw $a0 ($t1)
    ;     syscall

    ;     addi $t0 $t0 1
    ;     addi $t1 $t1 4

    ;     bne $t0 $s0 loop_print

    
    exit:
        li $v0 10           # load exit opcode
        syscall
