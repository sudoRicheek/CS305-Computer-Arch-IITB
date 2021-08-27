.data

    prompt1: 
        .asciiz "Enter n: "
    prompt2: 
        .asciiz "Enter r: "
    prompt3:
        .asciiz "Wish to continue?: "

    outprompt1:
        .asciiz "C"
    outprompt2:
        .asciiz ": "

    newline:
        .asciiz "\n"
    doublenewline:
        .asciiz "\n\n"

.text

    ncr: 
        addi $sp $sp -12    # adjust stack for 3 items
        sw $ra 8($sp)       # save the return address
        sw $a0 4($sp)       # save the arg 'n'
        sw $a1 0($sp)       # save the arg 'r'
        
        beq $a0 $a1 ret_ncr # if r==n return 1 in ret_ncr

        slti $t0 $a1 1      # set $t0 if r<1
        beq $t0 $0 sub1     # if r>=1 branch to sub1 label

    ret_ncr:
        addi $v0 $0 1       # return 1 in the $v0 register
        addi $sp $sp 12     # pop off 3 items from the stack
        jr $ra              # return
    
    sub1:
        addi $a0 $a0 -1     # decrement n
        jal ncr             # call ncr with n-1,r

        addi $sp $sp -4
        sw $v0 0($sp)       # store output of n-1,r in stack

        lw $a1 4($sp)       # restore r
        lw $a0 8($sp)       # restore n
        lw $ra 12($sp)      # restore $ra
        addi $a0 $a0 -1     # decrement n
        addi $a1 $a1 -1     # decrement r
        jal ncr             # call ncr with n-1,r-1
        move $t2 $v0        # store output of n-1,r-1 in $t2

        lw $t1 0($sp)       # restore the result of n-1,r
        lw $a1 4($sp)       # restore r
        lw $a0 8($sp)       # restore n
        lw $ra 12($sp)      # restore $ra
        addi $sp $sp 16     # pop off 3 items from stack

        add $v0 $t1 $t2     # nCr = n-1Cr + n-1Cr-1
        jr $ra              # return

    main:
        la $a0 prompt1      # get prompt1
        li $v0 4            # load print string opcode
        syscall             # print prompt1

        li $v0 5            # read int
        syscall
        move $s0 $v0        # $s0 has 'n' [IMPORTANT]

        la $a0 prompt2      # get prompt2
        li $v0 4            # load print string opcode
        syscall             # print prompt2

        li $v0 5            # read int
        syscall
        move $s1 $v0        # $s1 has 'r' [IMPORTANT]

        move $a0 $s0        # $a0 has 'n' arg [IMPORTANT]
        move $a1 $s1        # $a1 has 'r' arg [IMPORTANT]
        jal ncr             # Jump to ncr label with $a0 and $a1 args
        move $t3 $v0        # move the result into $t3
        
        li $v0 1            # print n
        move $a0 $s0
        syscall
        
        la $a0 outprompt1   # print 'C'
        li $v0 4
        syscall

        li $v0 1            # print r
        move $a0 $s1
        syscall

        la $a0 outprompt2   # print ": "
        li $v0 4
        syscall

        li $v0 1            # print the factorial output
        move $a0 $t3        # move factorial output to print to $a0
        syscall

        la $a0 newline      # print the newline
        li $v0 4
        syscall

        la $a0 prompt3      # print "Wish to continue?: "
        li $v0 4
        syscall

        li $v0 12           # read character and character gets stored in $v0
        syscall
        move $t2 $v0        # store character in $t2

        la $a0 doublenewline # print the newline
        li $v0 4
        syscall

        li $t0 89           # 89 is the ASCII of 'Y'
        li $t1 78           # 78 is the ASCII of 'N'
        
        beq $t2 $t1 exit    # if 'N' exit immediately
        beq $t2 $t0 main    # if 'Y' start over from main

    exit:
        li $v0 10           # load exit opcode
        syscall
        