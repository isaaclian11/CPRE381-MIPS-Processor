merge:
addiu $sp, $sp, -72
sw $fp, 68($sp)
sw $19, 64($sp)
sw $18, 60($sp)
sw $17, 56($sp)
sw $16, 52($sp)
or $fp, $sp, $0
sw $4, 72($fp)
sw $5, 76($fp)
sw $6, 80($fp)
sw $7, 84($fp)
or $4, $sp, $0
or $6, $4, $0
lw $5, 80($fp)
lw $4, 76($fp)
sll $0, $0, 0
subu $4, $5, $4
addiu $4, $4, 1
sw $4, 20($fp)
lw $5, 84($fp)
lw $4, 80($fp)
sll $0, $0, 0
subu $4, $5, $4
sw $4, 24($fp)
lw $4, 20($fp)
sll $0, $0, 0
addiu $5, $4, -1
sw $5, 28($fp)
or $5, $4, $0
or $19, $5, $0
or $18, $0, $0
srl $5, $19, 27
sll $12, $18, 5
or $12, $5, $12
sll $13, $19, 5
or $5, $4, $0
or $17, $5, $0
or $16, $0, $0
srl $5, $17, 27
sll $10, $16, 5
or $10, $5, $10
sll $11, $17, 5
sll $4, $4, 2
addiu $4, $4, 3
addiu $4, $4, 7
srl $4, $4, 3
sll $4, $4, 3
subu $sp, $sp, $4
or $4, $sp, $0
addiu $4, $4, 3
srl $4, $4, 2
sll $4, $4, 2
sw $4, 32($fp)
lw $4, 24($fp)
sll $0, $0, 0
addiu $5, $4, -1
sw $5, 36($fp)
or $5, $4, $0
or $25, $5, $0
or $24, $0, $0
srl $5, $25, 27
sll $8, $24, 5
or $8, $5, $8
sll $9, $25, 5
or $5, $4, $0
or $15, $5, $0
or $14, $0, $0
srl $5, $15, 27
sll $2, $14, 5
or $2, $5, $2
sll $3, $15, 5
or $2, $4, $0
sll $2, $2, 2
addiu $2, $2, 3
addiu $2, $2, 7
srl $2, $2, 3
sll $2, $2, 3
subu $sp, $sp, $2
or $2, $sp, $0
addiu $2, $2, 3
srl $2, $2, 2
sll $2, $2, 2
sw $2, 40($fp)
sw $0, 8($fp)
beq $0, $0, $L2
sll $0, $0, 0
$L3:
lw $3, 76($fp)
lw $2, 8($fp)
sll $0, $0, 0
addu $2, $3, $2
sll $2, $2, 2
lw $3, 72($fp)
sll $0, $0, 0
addu $2, $3, $2
lw $3, 0($2)
lw $4, 32($fp)
lw $2, 8($fp)
sll $0, $0, 0
sll $2, $2, 2
addu $2, $4, $2
sw $3, 0($2)
lw $2, 8($fp)
sll $0, $0, 0
addiu $2, $2, 1
sw $2, 8($fp)
$L2:
lw $3, 8($fp)
lw $2, 20($fp)
sll $0, $0, 0
slt $2, $3, $2
bne $2, $0, $L3
sll $0, $0, 0
sw $0, 12($fp)
beq $0, $0, $L4
sll $0, $0, 0
$L5:
lw $2, 80($fp)
sll $0, $0, 0
addiu $3, $2, 1
lw $2, 12($fp)
sll $0, $0, 0
addu $2, $3, $2
sll $2, $2, 2
lw $3, 72($fp)
sll $0, $0, 0
addu $2, $3, $2
lw $3, 0($2)
lw $4, 40($fp)
lw $2, 12($fp)
sll $0, $0, 0
sll $2, $2, 2
addu $2, $4, $2
sw $3, 0($2)
lw $2, 12($fp)
sll $0, $0, 0
addiu $2, $2, 1
sw $2, 12($fp)
$L4:
lw $3, 12($fp)
lw $2, 24($fp)
sll $0, $0, 0
slt $2, $3, $2
bne $2, $0, $L5
sll $0, $0, 0
sw $0, 8($fp)
sw $0, 12($fp)
lw $2, 76($fp)
sll $0, $0, 0
sw $2, 16($fp)
beq $0, $0, $L6
sll $0, $0, 0
$L10:
lw $3, 32($fp)
lw $2, 8($fp)
sll $0, $0, 0
sll $2, $2, 2
addu $2, $3, $2
lw $3, 0($2)
lw $4, 40($fp)
lw $2, 12($fp)
sll $0, $0, 0
sll $2, $2, 2
addu $2, $4, $2
lw $2, 0($2)
sll $0, $0, 0
slt $2, $2, $3
bne $2, $0, $L7
sll $0, $0, 0
lw $2, 16($fp)
sll $0, $0, 0
sll $2, $2, 2
lw $3, 72($fp)
sll $0, $0, 0
addu $2, $3, $2
lw $4, 32($fp)
lw $3, 8($fp)
sll $0, $0, 0
sll $3, $3, 2
addu $3, $4, $3
lw $3, 0($3)
sll $0, $0, 0
sw $3, 0($2)
lw $2, 8($fp)
sll $0, $0, 0
addiu $2, $2, 1
sw $2, 8($fp)
beq $0, $0, $L8
sll $0, $0, 0
$L7:
lw $2, 16($fp)
sll $0, $0, 0
sll $2, $2, 2
lw $3, 72($fp)
sll $0, $0, 0
addu $2, $3, $2
lw $4, 40($fp)
lw $3, 12($fp)
sll $0, $0, 0
sll $3, $3, 2
addu $3, $4, $3
lw $3, 0($3)
sll $0, $0, 0
sw $3, 0($2)
lw $2, 12($fp)
sll $0, $0, 0
addiu $2, $2, 1
sw $2, 12($fp)
$L8:
lw $2, 16($fp)
sll $0, $0, 0
addiu $2, $2, 1
sw $2, 16($fp)
$L6:
lw $3, 8($fp)
lw $2, 20($fp)
sll $0, $0, 0
slt $2, $3, $2
beq $2, $0, $L11
sll $0, $0, 0
lw $3, 12($fp)
lw $2, 24($fp)
sll $0, $0, 0
slt $2, $3, $2
bne $2, $0, $L10
sll $0, $0, 0
beq $0, $0, $L11
sll $0, $0, 0
$L12:
lw $2, 16($fp)
sll $0, $0, 0
sll $2, $2, 2
lw $3, 72($fp)
sll $0, $0, 0
addu $2, $3, $2
lw $4, 32($fp)
lw $3, 8($fp)
sll $0, $0, 0
sll $3, $3, 2
addu $3, $4, $3
lw $3, 0($3)
sll $0, $0, 0
sw $3, 0($2)
lw $2, 8($fp)
sll $0, $0, 0
addiu $2, $2, 1
sw $2, 8($fp)
lw $2, 16($fp)
sll $0, $0, 0
addiu $2, $2, 1
sw $2, 16($fp)
$L11:
lw $3, 8($fp)
lw $2, 20($fp)
sll $0, $0, 0
slt $2, $3, $2
bne $2, $0, $L12
sll $0, $0, 0
beq $0, $0, $L13
sll $0, $0, 0
$L14:
lw $2, 16($fp)
sll $0, $0, 0
sll $2, $2, 2
lw $3, 72($fp)
sll $0, $0, 0
addu $2, $3, $2
lw $4, 40($fp)
lw $3, 12($fp)
sll $0, $0, 0
sll $3, $3, 2
addu $3, $4, $3
lw $3, 0($3)
sll $0, $0, 0
sw $3, 0($2)
lw $2, 12($fp)
sll $0, $0, 0
addiu $2, $2, 1
sw $2, 12($fp)
lw $2, 16($fp)
sll $0, $0, 0
addiu $2, $2, 1
sw $2, 16($fp)
$L13:
lw $3, 12($fp)
lw $2, 24($fp)
sll $0, $0, 0
slt $2, $3, $2
bne $2, $0, $L14
sll $0, $0, 0
or $sp, $6, $0
sll $0, $0, 0
or $sp, $fp, $0
lw $fp, 68($sp)
lw $19, 64($sp)
lw $18, 60($sp)
lw $17, 56($sp)
lw $16, 52($sp)
addiu $sp, $sp, 72
jr $31
sll $0, $0, 0
mergeSort:
addiu $sp, $sp, -40
sw $31, 36($sp)
sw $fp, 32($sp)
or $fp, $sp, $0
sw $4, 40($fp)
sw $5, 44($fp)
sw $6, 48($fp)
lw $3, 44($fp)
lw $2, 48($fp)
sll $0, $0, 0
slt $2, $3, $2
beq $2, $0, $L17
sll $0, $0, 0
lw $3, 48($fp)
lw $2, 44($fp)
sll $0, $0, 0
subu $2, $3, $2
srl $3, $2, 31
addu $2, $3, $2
sra $2, $2, 1
or $3, $2, $0
lw $2, 44($fp)
sll $0, $0, 0
addu $2, $3, $2
sw $2, 24($fp)
lw $6, 24($fp)
lw $5, 44($fp)
lw $4, 40($fp)
jal mergeSort
sll $0, $0, 0
lw $2, 24($fp)
sll $0, $0, 0
addiu $2, $2, 1
lw $6, 48($fp)
or $5, $2, $0
lw $4, 40($fp)
jal mergeSort
sll $0, $0, 0
lw $7, 48($fp)
lw $6, 24($fp)
lw $5, 44($fp)
lw $4, 40($fp)
jal merge
sll $0, $0, 0
$L17:
sll $0, $0, 0
or $sp, $fp, $0
lw $31, 36($sp)
lw $fp, 32($sp)
addiu $sp, $sp, 40
jr $31
sll $0, $0, 0
main:
addi  $sp,  $0,  0x10010000
addiu $sp, $sp, -64
sw $31, 60($sp)
sw $fp, 56($sp)
or $fp, $sp, $0
ori $2, $0, 12 # 0xc
sw $2, 28($fp)
ori $2, $0, 11 # 0xb
sw $2, 32($fp)
ori $2, $0, 13 # 0xd
sw $2, 36($fp)
ori $2, $0, 5 # 0x5
sw $2, 40($fp)
ori $2, $0, 6 # 0x6
sw $2, 44($fp)
ori $2, $0, 7 # 0x7
sw $2, 48($fp)
ori $2, $0, 6 # 0x6
sw $2, 24($fp)
lw $2, 24($fp)
sll $0, $0, 0
addiu $3, $2, -1
addiu $2, $fp, 28
or $6, $3, $0
or $5, $0, $0
or $4, $2, $0
jal mergeSort
sll $0, $0, 0
or $2, $0, $0
or $sp, $fp, $0
lw $31, 60($sp)
lw $fp, 56($sp)
addiu $sp, $sp, 64
jr $31
sll $0, $0, 0
addi $2, $0, 10 # Place "10" in $v0 to signal an "exit" or "halt"
syscall # Actually cause the halt