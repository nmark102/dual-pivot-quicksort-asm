.globl quicksort
.globl insertionSort

# ENABLED FOR TESTING ONLY
.globl partition

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
	# t0 = &num				- pointer to the left pivot
	move	$t0, $a0

	# t2 = &(num + len - 1) - pointer to the right pivot
	addi	$t2, $a1, -1
	sll		$t2, $t2, 2
	addiu	$t2, $t2, $a0

	# Load and swap the pivots as needed
	# t8 = num[0]
	lw		$t8, 0($t0)
	
	# t9 = num[len - 1]
	lw		$t9, 0($t2)

	# Swap the two pivots if t8 > t9
	ble		$t8, $t9, PIVOT_SWAP_COMPLETE

	move	$t5, $t8
	move	$t8, $t9
	move	$t9, $t5
	
	sw		$t8, 0($t0)
	sw		$t9, 0($t2)

PIVOT_SWAP_COMPLETE:
	# t0 = &num[1]			- "low" pointer
	addiu	$t0, $t0, 4
	# t1 = &num[1]			- "mid" pointer
	move	$t1, $t0
	# t2 = &num[len - 2]	- "high" pointer
	addiu	$t2, $t2, -4

	# t4: num[iterator - 1] = value of left pivot
	move	$t4, $t8

	# t7 = "partition is sorted" flag
	li		$t7, 1

	# while iterator <= hi: 
	# 		if arr[iterator] < arr[leftPivot]:
	#			sorted = false
	#			++iterator
	# 			++leftPivot
	#
	#		else if arr[iterator] 

PIVOT_LOOP:
	bgt		$t1, $t2, PARTITION_RETURN_POINTERS

	# t3: num[iterator]
	lw		$t3, 0($t1)

	# if num[iterator] < leftPivot:
	# set sorted flag to false
	bge		$t3, $t8 CHECK_BETWEEN_PIVOTS

	# If we get here: num[iterator] < leftPivot
	# Set the "sorted" flag to false
	li		$t7, 0

	# Swap num[iterator] with leftPivot
	sw		$t8, 0($t1)
	sw		$t3, 0($t0)

	# Increment iterator and leftPivot
	addiu	$t1, $t1, 4
	addiu	$t0, $t0, 4

	# Copy num[iterator] into num[iterator - 1]
	move	$t4, $t3
	j 		PIVOT_LOOP

CHECK_BETWEEN_PIVOTS:
	bgt		$t3, $t9, GREATER_THAN_RIGHT_PIVOT

	# Compare cur to the previous value
	ble		$t3, $t4, BETWEEN_PIVOTS_RESET_SORTED_FLAG

	li		$t7, 0

BETWEEN_PIVOTS_RESET_SORTED_FLAG:
	# Increment iterator only
	addi	$t1, $t1, 4

	# Again, back up num[iterator] into t4 and jump back to the beginning of the loop
	move	$t4, $t3
	j 		PIVOT_LOOP

GREATER_THAN_RIGHT_PIVOT:
	# Swap iterator with the right pivot index
	sw		$t9, 0($t2)
	sw		$t3, 0($t1)

	# Decrement the right pivot
	addiu	$t2, $t2, -4

	# Set the sorted flag to false
	li		$t7, 0

	# Again, back up num[iterator] into t4 and jump back to the beginning of the loop
	move	$t4, $t3
	j 		PIVOT_LOOP

PARTITION_RETURN_POINTERS: 
	bnez	$t7, PARTITION_IS_SORTED

	# Increment the left pointer and decrement the right pointer
	addiu	$t0, $t0, -4
	addiu	$t2, $t2, 4

	# Swap left pivot with arr[lo]

	
	# Swap right pivot with arr[hi]

	# Re-translate pivot pointers into indices
	subu	$v0, $t0, $a0
	sra		$v0, $v0, 2

	subu	$v1, $t2, $a0
	sra		$v1, $v1, 2

	j 		partition_RET

PARTITION_IS_SORTED:
	li		$v0, -1
	li		$v1, -1
	j 		partition_RET

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