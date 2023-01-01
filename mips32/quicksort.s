.globl quicksort
.globl insertionSort

# ENABLED FOR TESTING ONLY
.globl partition

# Apparently, MARS doesn't recognize the .rodata directive
.data

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
	addiu	$sp, $sp, -16
	sw		$a1, 12($sp)
	sw		$a0,  8($sp)
	sw		$ra,  4($sp)
	sw		$fp,  0($sp)

	addiu	$fp, $sp, 12

	# TODO: Implement defaulting to insertion sort for small arrays

	jal		partition

	# If partition returns (-1, -1), the partition is already sorted!
	li		$t9, -1
	beq		$v0, $t9, quicksort_RET

	# TODO: Implement recursive call to smaller partitions
		
quicksort_RET:
	lw		$ra, 4($sp)
	lw		$fp, 0($sp)
	addiu	$sp, $sp, 16
	jr		$ra


# void partition(int* arr, int size)

# REGISTERS:
# t0: "low" pointer
# t1: "iterator" pointer
# t2: "high" pointer

# t3: arr[iterator]
# t4: arr[iterator - 1]

# t5: temporary register for miscellaneous purposes

# t7: array is sorted flag

# t8: value of left pivot
# t9: value of right pivot

partition:
	addiu	$sp, $sp, -4
	sw		$ra, 0($sp)

	# If the size of the partition is <= 1, the partition is already sorted
	# Therefore we return the "sorted" flags (-1, -1)
	li		$t0, 1
	ble		$a1, $t0, PARTITION_IS_SORTED

	# Set up the pivots
	# t0 = &arr				- pointer to the left pivot
	move	$t0, $a0

	# t2 = &(arr + len - 1) - pointer to the right pivot
	addi	$t2, $a1, -1
	sll		$t2, $t2, 2
	addu	$t2, $t2, $a0

	# Load and swap the pivots as needed
	# t8 = arr[0]
	lw		$t8, 0($t0)
	
	# t9 = arr[len - 1]
	lw		$t9, 0($t2)

	# Swap the two pivots if t8 > t9
	ble		$t8, $t9, PIVOT_SWAP_COMPLETE

	# If the left pivot is greater than the right pivot:
	# (i.e. if arr[0] > arr[len - 1]):

	# First swap the two pivots in the "pivot" registers (t8, t9)
	move	$t5, $t8
	move	$t8, $t9
	move	$t9, $t5
	
	# Re-sync the pivots in memory
	sw		$t8, 0($t0)
	sw		$t9, 0($t2)

PIVOT_SWAP_COMPLETE:
	# t0 = &arr[1]			- "low" pointer
	addiu	$t0, $t0, 4
	# t1 = &arr[1]			- "mid" pointer
	move	$t1, $t0
	# t2 = &arr[len - 2]	- "high" pointer
	addiu	$t2, $t2, -4

	# t4: arr[iterator - 1]
	# = value of the left pivot, for the first iteration
	move	$t4, $t8

	# t7 = "partition is sorted" flag
	li		$t7, 1


PIVOT_LOOP:
	# Break if iterator > rightPivotIndex
	bgt		$t1, $t2, PARTITION_RETURN_POINTERS

	# t3: arr[iterator]
	lw		$t3, 0($t1)

	# if arr[iterator] >= left pivot, check whether the current value
	# will end up in the middle partition
	bge		$t3, $t8 CHECK_BETWEEN_PIVOTS

	# If we get here: arr[iterator] < left pivot
	# Set the "sorted" flag to false
	li		$t7, 0

	# Swap arr[iterator] with arr[leftPivotIndex]
	lw		$t5, 0($t0)

	sw		$t3, 0($t0)
	sw		$t5, 0($t1)
	
	# Increment iterator and leftPivotIndex
	addiu	$t1, $t1, 4
	addiu	$t0, $t0, 4

	# Copy arr[iterator] into arr[iterator - 1]
	move	$t4, $t3
	j 		PIVOT_LOOP

CHECK_BETWEEN_PIVOTS:
	# If arr[iterator] > right pivot, it should end up in the right partition
	bgt		$t3, $t9, GREATER_THAN_RIGHT_PIVOT

	# Compare cur to the previous value
	# if arr[iterator] < arr[iterator - 1], set the sorted flag to false
	blt		$t3, $t4, BETWEEN_PIVOTS_RESET_SORTED_FLAG

	li		$t7, 0

BETWEEN_PIVOTS_RESET_SORTED_FLAG:
	# Increment iterator only
	addiu	$t1, $t1, 4

	# Again, back up arr[iterator] into t4 and jump back to the beginning of the loop
	move	$t4, $t3
	j 		PIVOT_LOOP

GREATER_THAN_RIGHT_PIVOT:
	# Swap arr[iterator] with right pivot
	lw		$t5, 0($t2)

	sw		$t3, 0($t2)
	sw		$t5, 0($t1)

	# Decrement the right pivot
	addiu	$t2, $t2, -4

	# Set the sorted flag to false
	li		$t7, 0

	# Again, back up arr[iterator] into t4 and jump back to the beginning of the loop
	move	$t4, $t3
	j 		PIVOT_LOOP

PARTITION_RETURN_POINTERS: 
	bnez	$t7, PARTITION_IS_SORTED

	# decrement leftPivotIndex and increment rightPivotIndex
	addiu	$t0, $t0, -4
	addiu	$t2, $t2, 4

	# Swap left pivot with arr[lo]
	# a0: &arr[lo]
	# t0: &arr[leftPivotIndex]
	# t8: left pivot

	# Load arr[leftPivotIndex]
	lw		$t5, 0($t0)

	# Store left pivot at arr[leftPivotIndex]
	sw		$t8, 0($t0)

	# Store arr[leftPivotIndex] at arr[lo]
	sw		$t5, 0($a0)


	# Swap right pivot with arr[hi]
	
	# t8: &arr[len - 1] = &arr[hi]
	addiu	$t3, $a1, -1
	sll		$t3, $t3, 2
	addu	$t3, $t3, $a0

	# t5: arr[hi]
	lw		$t5, 0($t2)
	
	# Store right pivot at arr[rightPivotIndex]
	sw		$t9, 0($t2)

	# Store arr[rightPivotIndex] at arr[hi]
	sw		$t5, 0($t3)

	# Re-translate pivot pointers into indices
	subu	$v0, $t0, $a0
	sra		$v0, $v0, 2

	subu	$v1, $t2, $a0
	sra		$v1, $v1, 2

	j 		partition_RET

# If the "array is sorted" flag is still true by the end of the pivoting loop:
# Set the pivot indices to this special flag (-1, -1)
PARTITION_IS_SORTED:
	li		$v0, -1
	li		$v1, -1
	
# Restore the return address and return
partition_RET:
	lw		$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr		$ra

insertionSort:
	addiu	$sp, $sp, -4
	sw		$ra, 0($sp)

# while(len >= 2) {
# 	for(int i = 0; i < len - 1; ++i) {
# 		
insertionSort_LOOP:
	addi	$a1, $a1, -1
	blez	$a1, insertionSort_RET

	move	$t0, $a0
	li		$t1, 0

insertionSort_INNER_LOOP:
	bge		$t1, $a1, insertionSort_LOOP

	lw		$t8, 0($t0)
	lw		$t9, 4($t0)

	ble		$t8, $t9, insertionSort_INNER_LOOP_ITER

	sw		$t8, 4($t0)
	sw		$t9, 0($t0)

insertionSort_INNER_LOOP_ITER:
	addi	$t0, $t0, 4
	addi	$t1, $t1, 1
	j		insertionSort_INNER_LOOP

insertionSort_RET:
	lw		$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr		$ra
