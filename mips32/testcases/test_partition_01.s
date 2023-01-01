.globl main

.data
buffer:
            .word 4
            .word 1
            .word 6
            .word 9
            .word 8
            .word 3
            .word 5
            .word 2
            .word 7

buffer_size:
            .word 9

pivots_msg:
            .asciiz "PIVOTS:\n"

.text
main:
    # Call quicksort
    la      $a0, buffer

    la      $a1, buffer_size
    lw      $a1, 0($a1)

    jal     partition

    # Back up the right pivot as we will not need it right away
    addiu   $sp, $sp, -4
    sw      $v1, 0($sp)

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
    move    $a0, $v0
    addi    $v0, $zero, 1
    syscall

    addi    $a0, $zero, '\n'
    addi    $v0, $zero, 11
    syscall

    # Print the right pivot
    lw      $v0, 0($sp)
    addiu   $sp, $sp, 4
    addi    $v0, $zero, 1
    syscall

    addi    $a0, $zero, '\n'
    addi    $v0, $zero, 11
    syscall

    # Verify that the array is indeed sorted
    # NOTE: Temporarily disabled while I check the partition function
    # la      $a0, buffer

    # la      $a1, buffer_size
    # lw      $a1, 0($a1)

    # jal     check_sorted_array

    # beqz    $v0, ARRAY_IS_SORTED

ARRAY_IS_SORTED:
    # If array is sorted: Exit normally
    li      $v0, 10
    syscall

ARRAY_NOT_SORTED:
    # If array is not sorted: Exit with error code 1
    li      $v0, 17
    li      $a0, 1
    syscall

