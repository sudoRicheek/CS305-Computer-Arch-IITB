.text

main:
    li t0 1      # Input 1
   	li t1 2      # Input 2
    li a0 3      # Input 3
    li a7 4      # Input 4
    add t0 t0 t1 
    li t1 5      # Input 5
    add a0 a0 a7 
    li a7 6      # Input 6
    add t0 t0 t1 
    li t1 7      # Input 7
    add a0 a0 a7 
    li a7 8      # Input 8
    add t0 t0 t1 
    li t1 9      # Input 9
    add a0 a0 a7 
    li a7 10     # Input 10
    add t0 t0 t1 
    add a0 a0 a7 
    li a7 1
    # gap of 1 instructions
    add a0 t0 a0 
    # gap of 3 instructions
    ecall