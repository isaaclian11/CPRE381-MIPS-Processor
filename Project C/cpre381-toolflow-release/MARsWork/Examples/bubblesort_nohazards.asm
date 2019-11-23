.data
arr:    .word 7, 4, 8, 10, 4, 1
size:   .word 5 	#size=size-1, will be used as an index in the for loop

.text
.globl main

main:
lui $at, 0x00001001				#first half of la
addi $s1, $0, 0     			#i
addi $s2, $0, 0     			#j
ori $s0, $at, 0x00000018       	#second half of la, addr of size n
add $0, $0, $0					#NOP
add $0, $0, $0					#NOP
lw $s0, 0($s0)      			#n
add $0, $0, $0					#NOP
lui $at, 0x00001001				#first half of la
sub $s3, $s0, $s1   			#m = n-i-1
sll $s6, $s0, 2    			 	#byte addressing n
ori $a0, $at, 0x00000000		#second half of la, addr of array
sll $s7, $s3, 2     			#byte addressing m

condition1:
sll $s4, $s1, 2     			#byte addressing i
add $0, $0, $0					#NOP
add $0, $0, $0					#NOP
slt $t0, $s4, $s6   			#i<n-1?
add $0, $0, $0					#NOP
add $0, $0, $0					#NOP
beq $t0, $0, exit   			#if not, exit

condition2:
sll $s5, $s2, 2     			#byte addressing j
add $0, $0, $0					#NOP
add $0, $0, $0					#NOP
slt $t0, $s5, $s7   			#j<m?
add $a1, $a0, $s5   			#address of arr[j]
add $0, $0, $0					#NOP
beq $t0, $0, incrementi   		#if j>m, increment i
lw $t1, 0($a1)      			#arr[j]
lw $t2, 4($a1)      			#arr[j+1]
add $0, $0, $0					#NOP
add $0, $0, $0					#NOP
slt $t3, $t2, $t1   			#arr[j+1]<arr[j]?
add $0, $0, $0					#NOP
add $0, $0, $0					#NOP
beq $t3, $0, incrementj 		#if not, increment j
addi $t4, $t1, 0    			#temp = arr[j]
add $0, $0, $0					#NOP
sw $t2, 0($a1)      			#arr[j] = arr[j+1]
sw $t4, 4($a1)      			#arr[j+1] = temp
j incrementj

incrementi:
addi $s1, $s1, 1    			#i++
add $s2, $0, $0     			#j=0
add $0, $0, $0					#NOP
sub $s3, $s0, $s1   			#m = n-i-1
add $0, $0, $0					#NOP
add $0, $0, $0					#NOP
sll $s7, $s3, 2     			#byte addressing m
j condition1

incrementj:
addi $s2, $s2, 1    			#j++
add $0, $0, $0					#NOP
add $0, $0, $0					#NOP
j condition2

exit:
li $v0, 10
syscall


