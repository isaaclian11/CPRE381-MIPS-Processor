.data
	x: .word 0x12 0x23 0x34 0x45
.text
.globl main
main:

addi $1, $0, 100
add $3, $1, $1
addiu $3, $3, 17
addu $4, $3, $3
and $5, $4, $4
and $6, $5, $0
andi $1, $1, 100
andi $7, $3, 110
nor $1, $1, $1
xor $3, $3, $3
xori $7, $7, 111
or $9, $0, $1
ori $10, $0, 109
slt $11, $3, $4
slti $12, $4, 100




sltu $12, $4, $3
addi $1, $0, 10
sll $1, $1, 4
srl $1, $1, 2
sra $1, $1, 1
sllv $1, $1, $5 
srlv $1, $1, $5
srav $1, $1, $5
addi $1, $0, 1000
addi $2, $0, 200
sub $1, $1, $2

lui $8, 200
addi $15, $0, 789
addi $14, $0, 8
la $t0 x # Load Address
sw $15, 0($t0)
lw $16, 0($t0)
addi $5, $0, 2

sltiu $12 $4, -1
subu $1, $1, $2
#----------------------------------------------------------------
#test instructions in blue

#beq test
addi $1, $zero, 5
addi $2, $zero, 4
beq $1, $2, Exit
beq $1, $1, Exit #this should branch to exit
addi $3, $zero, 1 #this shouldn't be executed

Exit:
addi $3, $zero, 3


#bne test
addi $1, $zero, 5
addi $2, $zero, 4
bne $1, $1, Exits
bne $1, $2, Exits #this should branch to exit
addi $3, $zero, 1  #this shouldn't be executed

Exits:
addi $3, $zero, 3


#j test
addi $1, $zero, 1
j skip
addi $1, $zero, 0 #this instruction should be skipped

skip:

#jal/jr test

jal link
addi $2, $zero, 1
#End the program
addi  $2,  $0,  10              # Place "10" in $v0 to signal an "exit" or "halt"
syscall                         # Actually cause the halt

link:
addi $3, $zero, 12
jr $ra




#Not-previously tested commands below here don't work
#Move them to the top to see the waveforms and what is wrong. Can test 3 at once



