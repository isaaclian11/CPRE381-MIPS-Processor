merge:
        addiu   $sp,$sp,-72
        sw      $fp,68($sp)
        sw      $19,64($sp)
        sw      $18,60($sp)
        sw      $17,56($sp)
        sw      $16,52($sp)
        move    $fp,$sp
        sw      $4,72($fp)
        sw      $5,76($fp)
        sw      $6,80($fp)
        sw      $7,84($fp)
        move    $4,$sp
        move    $6,$4
        lw      $5,80($fp)
        lw      $4,76($fp)
        nop
        subu    $4,$5,$4
        addiu   $4,$4,1
        sw      $4,20($fp)
        lw      $5,84($fp)
        lw      $4,80($fp)
        nop
        subu    $4,$5,$4
        sw      $4,24($fp)
        lw      $4,20($fp)
        nop
        addiu   $5,$4,-1
        sw      $5,28($fp)
        move    $5,$4
        move    $18,$5
        move    $19,$0
        srl     $5,$18,27
        sll     $13,$19,5
        or      $13,$5,$13
        sll     $12,$18,5
        move    $5,$4
        move    $16,$5
        move    $17,$0
        srl     $5,$16,27
        sll     $11,$17,5
        or      $11,$5,$11
        sll     $10,$16,5
        sll     $4,$4,2
        addiu   $4,$4,3
        addiu   $4,$4,7
        srl     $4,$4,3
        sll     $4,$4,3
        subu    $sp,$sp,$4
        move    $4,$sp
        addiu   $4,$4,3
        srl     $4,$4,2
        sll     $4,$4,2
        sw      $4,32($fp)
        lw      $4,24($fp)
        nop
        addiu   $5,$4,-1
        sw      $5,36($fp)
        move    $5,$4
        move    $24,$5
        move    $25,$0
        srl     $5,$24,27
        sll     $9,$25,5
        or      $9,$5,$9
        sll     $8,$24,5
        move    $5,$4
        move    $14,$5
        move    $15,$0
        srl     $5,$14,27
        sll     $3,$15,5
        or      $3,$5,$3
        sll     $2,$14,5
        move    $2,$4
        sll     $2,$2,2
        addiu   $2,$2,3
        addiu   $2,$2,7
        srl     $2,$2,3
        sll     $2,$2,3
        subu    $sp,$sp,$2
        move    $2,$sp
        addiu   $2,$2,3
        srl     $2,$2,2
        sll     $2,$2,2
        sw      $2,40($fp)
        sw      $0,8($fp)
        b       $L2
        nop

$L3:
        lw      $3,76($fp)
        lw      $2,8($fp)
        nop
        addu    $2,$3,$2
        sll     $2,$2,2
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $4,32($fp)
        lw      $2,8($fp)
        nop
        sll     $2,$2,2
        addu    $2,$4,$2
        sw      $3,0($2)
        lw      $2,8($fp)
        nop
        addiu   $2,$2,1
        sw      $2,8($fp)
$L2:
        lw      $3,8($fp)
        lw      $2,20($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L3
        nop

        sw      $0,12($fp)
        b       $L4
        nop

$L5:
        lw      $2,80($fp)
        nop
        addiu   $3,$2,1
        lw      $2,12($fp)
        nop
        addu    $2,$3,$2
        sll     $2,$2,2
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $4,40($fp)
        lw      $2,12($fp)
        nop
        sll     $2,$2,2
        addu    $2,$4,$2
        sw      $3,0($2)
        lw      $2,12($fp)
        nop
        addiu   $2,$2,1
        sw      $2,12($fp)
$L4:
        lw      $3,12($fp)
        lw      $2,24($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L5
        nop

        sw      $0,8($fp)
        sw      $0,12($fp)
        lw      $2,76($fp)
        nop
        sw      $2,16($fp)
        b       $L6
        nop

$L10:
        lw      $3,32($fp)
        lw      $2,8($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $4,40($fp)
        lw      $2,12($fp)
        nop
        sll     $2,$2,2
        addu    $2,$4,$2
        lw      $2,0($2)
        nop
        slt     $2,$2,$3
        bne     $2,$0,$L7
        nop

        lw      $2,16($fp)
        nop
        sll     $2,$2,2
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $4,32($fp)
        lw      $3,8($fp)
        nop
        sll     $3,$3,2
        addu    $3,$4,$3
        lw      $3,0($3)
        nop
        sw      $3,0($2)
        lw      $2,8($fp)
        nop
        addiu   $2,$2,1
        sw      $2,8($fp)
        b       $L8
        nop

$L7:
        lw      $2,16($fp)
        nop
        sll     $2,$2,2
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $4,40($fp)
        lw      $3,12($fp)
        nop
        sll     $3,$3,2
        addu    $3,$4,$3
        lw      $3,0($3)
        nop
        sw      $3,0($2)
        lw      $2,12($fp)
        nop
        addiu   $2,$2,1
        sw      $2,12($fp)
$L8:
        lw      $2,16($fp)
        nop
        addiu   $2,$2,1
        sw      $2,16($fp)
$L6:
        lw      $3,8($fp)
        lw      $2,20($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L11
        nop

        lw      $3,12($fp)
        lw      $2,24($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L10
        nop

        b       $L11
        nop

$L12:
        lw      $2,16($fp)
        nop
        sll     $2,$2,2
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $4,32($fp)
        lw      $3,8($fp)
        nop
        sll     $3,$3,2
        addu    $3,$4,$3
        lw      $3,0($3)
        nop
        sw      $3,0($2)
        lw      $2,8($fp)
        nop
        addiu   $2,$2,1
        sw      $2,8($fp)
        lw      $2,16($fp)
        nop
        addiu   $2,$2,1
        sw      $2,16($fp)
$L11:
        lw      $3,8($fp)
        lw      $2,20($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L12
        nop

        b       $L13
        nop

$L14:
        lw      $2,16($fp)
        nop
        sll     $2,$2,2
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $4,40($fp)
        lw      $3,12($fp)
        nop
        sll     $3,$3,2
        addu    $3,$4,$3
        lw      $3,0($3)
        nop
        sw      $3,0($2)
        lw      $2,12($fp)
        nop
        addiu   $2,$2,1
        sw      $2,12($fp)
        lw      $2,16($fp)
        nop
        addiu   $2,$2,1
        sw      $2,16($fp)
$L13:
        lw      $3,12($fp)
        lw      $2,24($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L14
        nop

        move    $sp,$6
        nop
        move    $sp,$fp
        lw      $fp,68($sp)
        lw      $19,64($sp)
        lw      $18,60($sp)
        lw      $17,56($sp)
        lw      $16,52($sp)
        addiu   $sp,$sp,72
        jr       $31
        nop

mergeSort:
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        move    $fp,$sp
        sw      $4,40($fp)
        sw      $5,44($fp)
        sw      $6,48($fp)
        lw      $3,44($fp)
        lw      $2,48($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L17
        nop

        lw      $3,48($fp)
        lw      $2,44($fp)
        nop
        subu    $2,$3,$2
        srl     $3,$2,31
        addu    $2,$3,$2
        sra     $2,$2,1
        move    $3,$2
        lw      $2,44($fp)
        nop
        addu    $2,$3,$2
        sw      $2,24($fp)
        lw      $6,24($fp)
        lw      $5,44($fp)
        lw      $4,40($fp)
        jal     mergeSort
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        lw      $6,48($fp)
        move    $5,$2
        lw      $4,40($fp)
        jal     mergeSort
        nop

        lw      $7,48($fp)
        lw      $6,24($fp)
        lw      $5,44($fp)
        lw      $4,40($fp)
        jal     merge
        nop

$L17:
        nop
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        jr      $31
        nop

main:
        addiu   $sp,$sp,-64
        sw      $31,60($sp)
        sw      $fp,56($sp)
        move    $fp,$sp
        li      $2,12                 # 0xc
        sw      $2,28($fp)
        li      $2,11                 # 0xb
        sw      $2,32($fp)
        li      $2,13                 # 0xd
        sw      $2,36($fp)
        li      $2,5                        # 0x5
        sw      $2,40($fp)
        li      $2,6                        # 0x6
        sw      $2,44($fp)
        li      $2,7                        # 0x7
        sw      $2,48($fp)
        li      $2,6                        # 0x6
        sw      $2,24($fp)
        lw      $2,24($fp)
        nop
        addiu   $3,$2,-1
        addiu   $2,$fp,28
        move    $6,$3
        move    $5,$0
        move    $4,$2
        jal     mergeSort
        nop

        move    $2,$0
        move    $sp,$fp
        lw      $31,60($sp)
        lw      $fp,56($sp)
        addiu   $sp,$sp,64
        jr      $31
        nop