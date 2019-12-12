.data
.text

j jaltest
add $0, $0, $0
addi $t0, $0, 5

jaltest:
jal jrTest
add $0, $0, $0
addi $t1, $0, 3
j exit
add $0, $0, $0

jrTest:
addi $t2, $0, 2
addi $31, $31, -4
addi $31, $31, 4
jr $ra
add $0, $0, $0


exit:
addi $2, $0, 10
syscall