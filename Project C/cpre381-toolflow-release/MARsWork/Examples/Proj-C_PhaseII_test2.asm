# data section
.data

# code/instruction section
.text
lui $1, 0x00001001
ori $1, $1, 0x00000000
addi  $2,  $0,  2		# Place â€œ2â€? in $2
add  $3,  $1,  $2		# add $1 and $2 and place it in $3
addiu  $4, $3,  5		# add $3 and 5, place it in $4
and  $5,  $3,  $4		# and $3 and $4, place it in $5
andi $5, $3, 10			# andi $3 and 10, place it in $5
lui $6, 1234	
sw $6, 0($1)			#store $6 into addr of $1
lw $7, 0($1)			#load value in addr $1 into $7
nor $8, $6, $7			#nor $6 and $7, place it in $8
xor $8, $5, $6			#xor $5 and $6, place it in $8
xori $8, $5, 4			#xori $5 and 4, place it in $8
or $8, $5, $8			#or $5 and $8, place it in $8
ori $8, $5, 4			#ori $5 and 4, place it in $8
add $9, $0, $8			# place value of $8 in $9
beq $9, $8, branch1		# if $9 and $8 are equal (which they are due to the line above) branch to branch1
add $0, $0, $0


preslt:

slt  $6,  $2,  $1		# 2<1?
slt  $6,  $1,  $2		# 1<2?
slti  $6,  $1,  8		# 1<5?
sll  $7,  $1,  1		# shift left 1 by 1
sllv  $8, $2,  $1		# shift left 2 by $1
sra $8, $4, 1			# shift right arithmetic $4 by 1
srl $8, $4, 1			# shift right logical $4 by 1
srav $8, $4, $2			# shift right arithmetic $4 by $2
srlv $8, $4, $2			# shift right logical $4 by $2

jal link				# jump and link to link
add $0, $0, $0
j prehalt				# unconditional jump to prehalt
add $0, $0, $0
halt:

addi  $2,  $0,  10              # Place "10" in $v0 to signal an "exit" or "halt"
syscall                         # Actually cause the halt

branch1:
bne $9, $1, preslt		# if $9 and $1 are not equal, branch to preslt
add $0, $0, $0


prehalt:
j halt					# unconditional jump back to halt
add $0, $0, $0


link:					# some filler instructions to test jal and jr
add $9, $8, $8			# $9 = $8 + $8
add $10, $9, $9			# $10 = $9 + $9
jr $ra					# return to instruction after our jal
add $0, $0, $0

