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
    addi    $s1, $s1, 4
    jr      print_array_LOOP

print_array_EXIT:
    lw      $ra, 0($sp)
    addiu   $sp, $sp, 4
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