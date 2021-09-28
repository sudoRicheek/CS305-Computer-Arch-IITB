.text

main:
    li t0 2
   	li t1 10
    nop
    nop
  	add t0 t0 t1
   	li t2 5
    li a7 1
    nop
   	add t2 t0 t2
    nop
    nop
   	add a0 t2 x0
    nop
    nop
    nop
    ecall