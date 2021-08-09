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
        beq $s0 $zero pz_m  # if n==0 branch to print zero max zig-zag length

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


    # Section to calculate max ZigZag length
    zz_init:
        move $t0 $zero      # lastSign in $t0
        li $t1 1            # length of zigzag in $t1
        li $t2 1            # i of the loop_mzz in $t2

        move $t3 $s1        # base address of the array, i.e. array[0] in $t3
        addi $t4 $s1 4      # address of array[1] in $t4
    
    loop_mzz:               # loop for calculating the max zig-zag length
        beq $t2 $s0 p_m

        lw $t5 ($t3)        # array[i-1]
        lw $t6 ($t4)        # array[i]

            slt $t7 $t5 $t6 # $t7=1 if array[i-1]<array[i]
            beq $t7 $0 elif # if array[i-1]>=array[i] goto [elif]
            j enif          # if $t7==1 sign=1
        elif:
            slt $t7 $t6 $t5 # $t7=1 if array[i-1]>array[i] --> if $t7==0 sign=0 
            beq $t7 $0 enif # if array[i-1]==array[i] goto [enif]
            li $t7 2        # if array[i-1]>array[i] --> sign=2 [-ve] 
            j enif              
        enif:
                                    # $t7 contains the sign [IMPORTANT]
                                    # 0 -> equal, 1-> +ve, 2-> -ve
        
            bne $t7 $t0 s_neq_ls    # $t0 has the ls
            j j_loop_mzz
        s_neq_ls:
            beq $t7 $0 j_loop_mzz   # if s neq ls and s neq 0
            move $t0 $t7            # ls = s
            addi $t1 $t1 1          # length++
            j j_loop_mzz
        j_loop_mzz:
            addi $t2 $t2 1          # increment i
            move $t3 $t4            # point to array[i-1]
            addi $t4 $t4 4          # point to array[i]
            j loop_mzz

    p_m:                    # print length of max zigzag
        move $s2 $t1        # $s2 stores the length of maxZigZag
        li $v0 1
        move $a0 $s2
        syscall                     
        j exit

    pz_m:                   # print length of max zigzag is zero
        li $v0 1
        move $a0 $zero
        syscall
        j exit

    exit:
        li $v0 10           # load exit opcode
        syscall