# data section
.data

# code/instruction section
.text
lui $1, 0x00001001
add $0, $0, $0			#NOP
add $0, $0, $0			#NOP
add $0, $0, $0			#NOP
ori $1, $1, 0x00000000
addi $3, $0, 3
addi $4, $0, 4
add $0, $0, $0			#NOP
add $0, $0, $0			#NOP
add $0, $0, $0			#NOP
slt $5, $4, $3
add $0, $0, $0			#NOP
add $0, $0, $0			#NOP
add $0, $0, $0			#NOP
beq $5, $0, branch
add $0, $0, $0
addi $11, $0, 11
branch: 
addi $6, $0, 6
j exit
add $0, $0, $0

exit:
addi  $2,  $0,  10              # Place "10" in $v0 to signal an "exit" or "halt"
syscall          