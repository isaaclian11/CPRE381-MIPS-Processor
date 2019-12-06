.data
.text
lui $1, 0x00001001
add $0, $0, $0			#NOP
add $0, $0, $0			#NOP
add $0, $0, $0			#NOP
ori $1, $1, 0x00000000
addi $t1, $0, 1
sw $t1, 0($1)
add $0, $0, $0			#NOP
add $0, $0, $0			#NOP
add $0, $0, $0			#NOP
lw $t2, 0($1)
addi $t3, $t2, 0
addi $2, $0, 10
syscall   