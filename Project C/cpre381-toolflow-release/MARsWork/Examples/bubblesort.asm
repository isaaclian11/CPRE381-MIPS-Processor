.data
arr:    .word 7, 4, 8, 4, 4, 1
size:   .word 6

.text
.globl main

main:
la $s0, size        #addr of size n
lw $s0, 0($s0)      #n
addi $s0, $s0, -1   #index starts at 0. n-1
sll $s6, $s0, 2     #byte addressing n
addi $s1, $0, 0     #i
sub $s3, $s0, $s1   #m = n-i-1
sll $s7, $s3, 2     #byte addressing m
addi $s2, $0, 0     #j
la $a0, arr         #addr of array

condition1:
sll $s4, $s1, 2     #byte addressing i
slt $t0, $s4, $s6   #i<n-1?
beq $t0, $0, print   #if not, exit
condition2:
sll $s5, $s2, 2     #byte addressing j
slt $t0, $s5, $s7   #j<m?
beq $t0, $0, incrementi   #if not, increment i
add $a1, $a0, $s5   #address of arr[j]
lw $t1, 0($a1)      #arr[j]
lw $t2, 4($a1)      #arr[j+1]
slt $t3, $t2, $t1   #arr[j+1]<arr[j]?
beq $t3, $0, incrementj #if not, increment j
addi $t4, $t1, 0    #temp = arr[j]
sw $t2, 0($a1)      #arr[j] = arr[j+1]
sw $t4, 4($a1)      #arr[j+1] = temp
j incrementj

incrementi:
addi $s1, $s1, 1    #i++
add $s2, $0, $0     #j=0
sub $s3, $s0, $s1   #m = n-i-1
sll $s7, $s3, 2     #byte addressing m


j condition1
incrementj:
addi $s2, $s2, 1    #j++
j condition2


print:
la $t0, arr
la $t2, size

loop:
slt $t5, $t0, $t2 
beq $t5, $0, exit
lw $t3, 0($t0)
addi $t0, $t0, 4
li $v0, 1
move $a0, $t3
syscall
j loop

exit:
li $v0, 10
syscall


