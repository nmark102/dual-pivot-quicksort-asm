# dual-pivot-quicksort-asm

This project is for me to remember my finest hours of the Fall 2022 semester, combined from my passion for being a TA for CSC 252: Computer Organization, and from one of my finest assignments in CSC 345: Analysis of Discrete Structures. 

Here, I'll be implementing a hybrid sorting function, using dual-pivot quicksort with sorted partition detection, and defaulting to insertion sort for small partitions. Adapted from one of my (finest) assignments in CSC 345: Analysis of Discrete Structures, I'll be re-implementing it in MIPS32 Release 5 Assembly, and (possibly) RISC-V 32-bit assembly. 

# Backstory

One of our assignments in CSC 345 this semester involved implementing a variety of sorting algorithms and, depending on the prescribed scenarios, select an algorithm that will require the fewest memory accesses. For lots of different reasons, I believe our sorting implementations are gauged on the number of memory accesses to produce an unambiguous, reproducible performance gauge. Of course, part of the test suite involved random arrays - and this is where 
