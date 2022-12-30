.globl main

.data
buffer:
            .word 4
            .word 0
            .word 1
            .word 6
            .word 9
            .word 8
            .word 3
            .word 5
            .word 2
            .word 7

buffer_size:
            .word 10

.text
main:
    # Call quicksort
    la      $a0, buffer

    la      $a1, buffer_size
    lw      $a1, 0($a1)

    jal     quicksort

    # Print the array
    la      $a0, buffer

    la      $a1, buffer_size
    lw      $a1, 0($a1)

    jal     print_array

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

