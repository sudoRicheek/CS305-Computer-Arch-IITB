.data

    prompt1: 
        .asciiz "Enter a: "
    prompt2: 
        .asciiz "Enter m: "
    prompt3:
        .asciiz "Wish to continue?: "

    outprompt1:
        .asciiz "*"
    outprompt2:
        .asciiz " = 1 (mod "
    outprompt3:
        .asciiz ")\n"

    newline:
        .asciiz "\n"
    doublenewline:
        .asciiz "\n\n"

.text

    eea:
        addi $sp $sp -12    # adjust stack for 3 items
        sw $ra 8($sp)       # save the ra
        sw $a0 4($sp)       # save the arg 'a'
        sw $a1 0($sp)       # save the arg 'm'

        bne $a0 $0 sub1_eea # if a!=0 goto sub1_eea

        li $v0 0
        li $v1 1

        addi $sp $sp 12
        jr $ra              # return (0,1)

    sub1_eea:
        div $a1 $a0         # div on a and m(b)
        move $a1 $a0        # a1 has a now
        mfhi $a0            # a0 has m(b)%a now
        jal eea
        
        move $t0 $v0        # x in $t0 [IMPORTANT]
        move $t1 $v1        # y in $t1 [IMPORTANT]
        
        lw $a1 0($sp)       # restore m
        lw $a0 4($sp)       # restore a
        lw $ra 8($sp)       # restore ra
        addi $sp $sp 12     # pop off 3 items from stack

        div $a1 $a0
        mflo $t2            # b/a in $t2
        mul $t3 $t0 $t2     # (b/a) * x in $t3
        sub $t4 $t1 $t3     # y - (b/a) * x in $t4

        move $v0 $t4        # y - (b/a) * x in v0
        move $v1 $t0        # x in v1
        jr $ra

    main:
        la $a0 prompt1      # get prompt1
        li $v0 4            # load print string opcode
        syscall             # print prompt1

        li $v0 5            # read int
        syscall
        move $s0 $v0        # $s0 has 'a' [IMPORTANT]

        la $a0 prompt2      # get prompt2
        li $v0 4            # load print string opcode
        syscall             # print prompt2

        li $v0 5            # read int
        syscall
        move $s1 $v0        # $s1 has 'm' [IMPORTANT]

        move $a0 $s0        # $a0 has 'a' arg [IMPORTANT]
        move $a1 $s1        # $a1 has 'm' arg [IMPORTANT]
        jal eea             # Jump to ncr label with $a0 and $a1 args
        
        move $t0 $v0        # x in $t0
        move $t1 $v1        # y in $t1

        div $t0 $s1         # div x,m
        mfhi $t2            # t2 has x%m
        add $t2 $t2 $s1     # t2 has x%m + m
        div $t2 $s1         # div x%m+m, m
        mfhi $t2            # t2 has (x%m+m)%m

        li $v0 1            # print a
        move $a0 $s0
        syscall
        
        la $a0 outprompt1   # print '*'
        li $v0 4
        syscall

        li $v0 1            # print the mult-inverse
        move $a0 $t2
        syscall

        la $a0 outprompt2   # print ' = 1 (mod '
        li $v0 4
        syscall

        li $v0 1            # print m
        move $a0 $s1
        syscall

        la $a0 outprompt3   # print ')\n'
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