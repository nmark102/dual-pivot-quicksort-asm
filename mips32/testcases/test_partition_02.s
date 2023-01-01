.globl main

.data
buffer:
            .word 15
            .word 17
            .word 2
            .word 14
            .word 7
            .word 12
            .word 4
            .word 20
            .word 6
            .word 11
            .word 1
            .word 18
            .word 10
            .word 13
            .word 8
            .word 5
            .word 9
            .word 19
            .word 12
            .word 3

buffer_size:
            .word 20

pivots_msg:
            .asciiz "PIVOTS:\n"

.text
main:
    # Call quicksort
    la      $a0, buffer

    la      $a1, buffer_size
    lw      $a1, 0($a1)

    jal     partition

    # Back up the pivots
    addiu   $sp, $sp, -8
    sw      $v1, 4($sp)
    sw      $v0, 0($sp)

    # Print the array
    la      $a0, buffer

    la      $a1, buffer_size
    lw      $a1, 0($a1)

    jal     print_array

    # Prints "PIVOTS\n"
    la      $a0, pivots_msg
    addi    $v0, $zero, 4
    syscall

    # Print the left pivot
    lw      $a0, 0($sp)
    addiu   $sp, $sp, 4
    addi    $v0, $zero, 1
    syscall

    addi    $a0, $zero, '\n'
    addi    $v0, $zero, 11
    syscall

    # Print the right pivot
    lw      $a0, 0($sp)
    addiu   $sp, $sp, 4
    addi    $v0, $zero, 1
    syscall

    addi    $a0, $zero, '\n'
    addi    $v0, $zero, 11
    syscall

    # Exit
    li      $v0, 10
    syscall

