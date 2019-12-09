.data
.text
lui $1, 0x00001001
ori $1, $1, 0x00000000
addi $t1, $0, 1
sw $t1, 0($1)
lw $t2, 0($1)
sw $t2, 8($1)
addi $t3, $t2, 0
addi $2, $0, 10
syscall   