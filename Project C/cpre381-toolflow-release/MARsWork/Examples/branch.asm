.data
.text

addi $t0, $0, 5
addi $t1, $t0, 5
bne $t1, $0, exit
add $0, $0, $0
add $t2, $t0, $t1
addi $t3, $0, 1
addi $t3, $0, 1
addi $t3, $0, 1
addi $t3, $0, 1

exit:
addi $t4, $t0, 15

addi $2, $0, 10
syscall