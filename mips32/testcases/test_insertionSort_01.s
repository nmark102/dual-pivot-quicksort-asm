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

.text
main:
    # Run insertion sort
    la      $a0, buffer

    la      $a1, buffer_size
    lw      $a1, 0($a1)

    jal     insertionSort

    # Print the array
    la      $a0, buffer

    la      $a1, buffer_size
    lw      $a1, 0($a1)

    jal     print_array

# Verify that the array is indeed sorted
    la      $a0, buffer

    la      $a1, buffer_size
    lw      $a1, 0($a1)

    jal     check_sorted_array

    beqz    $v0, ARRAY_NOT_SORTED

    # If array is sorted: exit normally
    li      $v0, 10
    syscall

ARRAY_NOT_SORTED:
    # If array is not sorted: exit with error code 1
    li      $v0, 17
    li      $a0, 1
    syscall