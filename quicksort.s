.globl quicksort

.rodata

# For arrays (or partitions) of at most 5 elements: I've decided to default to 
# run insertion sort on them.
# This number is simply an arbitrary choice I've determined experimentally,
# from the original version of my assignment in CSC 345 and a few of my own
# testcases. The "best" threshold from which one should default to insertion sort
# may differ, though one thing we know for certain is that, for insertion sort
# to work well, the size of the array has to be rather small.

INSERTION_SORT_THRESHOLD:
			.word		6
.text

# void quicksort(int* arr, int size) {
quicksort:
	addiu		$sp, $sp, -8
	sw		$ra, 4($sp)
	sw		$fp, 0($sp)
	
	jal		partition

	# If partition returns (-1, -1), the partition is already sorted!
	li		$t9, -1
	beq		$v0, $t9, quicksort_RET

	
	
quicksort_RET:
	lw		$ra, 4($sp)
	lw		$fp, 0($sp)
	addiu		$sp, $sp, 8
	jr		$ra

partition:
	addiu		$sp, $sp, -4
	sw		$ra, 0($sp)

	# If the size of the partition is <= 1, the partition is already sorted
	# Therefore we return the "sorted" flags (-1, -1)
	li		$t0, 2
	blt		$v1, $t0, PARTITION_IS_SORTED

	# Set up the pivots
	# $v0 and $v1 will store the indices of the left and right pivots, respectively

	li		$v0, 0
	move		$v1, $a1
	addi		$v1, $v1, -1

	# t9 = &(num + size - 1)
	sll		$t9, $v1, 2
	addu		$t9, $t9, $a0

	# t0 = value of left pivot
	# t1 = value of right pivot
	lw		$t0, 0($a0)
	lw		$t1, 0($t9)
	
	# If I understand load delay slots correctly: this is where it would be inserted. 
	# With further reading, however, it seems like only the first release of MIPS
	# required load delay slots. So we might just ignore it.

	bge		$t1, $t0, 

PIVOT_SWAP_COMPLETE:
	

PARTITION_IS_SORTED:
	li		$v0, -1
	li		$v1, -1
	j 		partition_RET

partition_RET:
	lw		$ra, 0($sp)
	addiu		$sp, $sp, 4
	jr		$ra

insertion_sort:
	addiu		$sp, $sp, -4
	sw		$ra, 0($sp)

	
