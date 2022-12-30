.globl print_array
.globl check_sorted_array

.data

print_array:
    addiu   $sp, $sp, -24

    sw      $a1, 20($sp)
    sw      $a0, 16($sp)
    sw      $ra, 12($sp)
    sw      $s2,  8($sp)
    sw      $s1,  4($sp)
    sw      $s0,  0($sp)

    addi    $s0, $a0, 0
    addi    $s1, $zero, 0
    addi    $s2, $a1, 0


print_array_LOOP:
    bge     $s1, $s2, print_array_EXIT

    lw      $a0, 0($s0)
    addi    $v0, $zero, 1
    syscall

    addi    $a0, $zero, '\n'
    addi    $v0, $zero, 11
    syscall

    addi    $s0, $s0, 4
    addi    $s1, $s1, 1
    j       print_array_LOOP

print_array_EXIT:
    lw      $ra, 12($sp)
    lw      $s2,  8($sp)
    lw      $s1,  4($sp)
    lw      $s0,  0($sp)

    addiu   $sp, $sp, 24
    jr      $ra

# NOTICE: Syscalls 30 and higher are supported by MARS only, and are not supported by SPIM.
gen_random_array:
    addiu   $sp, $sp, -12
    sw      $a1, 8($sp)
    sw      $a0, 4($sp)
    sw      $ra, 0($sp)

    addiu   $sp, $sp, -8
    sw      $s1, 4($sp)
    sw      $s0, 0($sp)

    # Set seed?

    move    $s0, $a0
    li      $s1, 0

gen_random_array_LOOP:
    bge     $s1, $a1, gen_random_array_RET

    li      $v0, 41
    li      $a0, 0
    syscall

    sw      $v0, 0($s0)

    addiu   $s0, $s0, 4
    addi    $s1, $s1, 1
    j       gen_random_array_LOOP
    

gen_random_array_RET:
    lw      $s1, 4($sp)
    lw      $s0, 0($sp)
    addiu   $sp, $sp, 8

    lw      $ra, 0($sp)
    addiu   $sp, $sp, 12

    jr      $ra

check_sorted_array:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)

    addiu   $a1, $a1, -1

    li      $t0, 0
    li      $v0, 1

check_sorted_array_LOOP:
    bge     $t0, $a1, check_sorted_array_RET
    
    lw      $t8, 0($a0)
    lw      $t9, 4($a0)

    bgt     $t8, $t9, check_sorted_array_RET_FALSE

    addiu   $a0, $a0, 4
    addi    $t0, $t0, 1
    j       check_sorted_array_LOOP

check_sorted_array_RET_FALSE:
    li      $v0, 0

check_sorted_array_RET:
    lw      $ra, 0($sp)
    addiu   $sp, $sp, 4
    jr      $ra