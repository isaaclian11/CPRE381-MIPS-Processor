.data
.text

addi $t0, $0, 5
add $t1, $t0, $t0
bne $t1, $0, exit 
add $t2, $t0, $t1

exit:

addi $2, $0, 10
syscall