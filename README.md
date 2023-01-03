# dual-pivot-quicksort-asm

This project is for me to remember my high notes of the Fall 2022 semester, combined from my passion for being a TA for CSC 252: Computer Organization, and from one of my finest assignments in CSC 345: Analysis of Discrete Structures. 

Here, I'll be implementing a hybrid sorting function, using dual-pivot quicksort with sorted partition detection, and defaulting to insertion sort for small partitions. Adapted from one of my (finest) assignments in CSC 345: Analysis of Discrete Structures, I'll be re-implementing it in MIPS32 Release 5 Assembly, and (possibly) RISC-V 32-bit assembly. 

# Backstory

A key topic in any data structures & algorithms class is sorting, where we learn how to write a computer program that arranges a list of values, typically plain old numbers, into an order, commonly from smallest to largest. My iteration of CSC 345 is no exception. One of our assignments this semester involved implementing different ways of sorting numbers (in CS terms, sorting algorithms), and, depending on a given input scenario, choose the fastest tool for the job. For different reasons, I believe our sorting implementations are gauged on the number of memory accesses to produce an unambiguous, reproducible performance gauge. Of course, part of the test suite involved an array of relatively random numbers. Without going into too much detail about different sorting algorithms, Quicksort function that reverts to insertion sort to handle the smallest partitions was an obvious choice. But there's a plot twist: for whatever reason, the Quicksort implementation just didn't click with me. And in a seemingly infinite cycle of looking at Quicksort pseudocode and running them on pen and paper, I stumbled upon dual-pivot Quicksort. Save from a small initial hiccup, dual-pivot Quicksort blew my mind, and at the same time, I seemed to figure out how to run dual-pivot Quicksort on pen and paper rather quickly.

So, off to dual-pivot Quicksort I go. 

While less likely than the standard Quicksort function, the worst-case scenario of dual-pivot Quicksort is identical: given a sorted array, each iteration of the pivoting function does not evenly split the partition into 2 (or 3) smaller partitions, but instead simply shrinks the partition by a constant amount. This degrades Quicksort into an O(N^2) algorithm in the worst case. 

Or so I thought. 

Given a sorted array, the left and right pivots would have already been the minimum and maximum values, respectively. Which means that every value in the middle should fall in between our two pivots. As we iterate through the array, all that's left to do is compare an element to the previous, triggering a flag if they're not in non-decreasing order. All that's left to do is to return to the main Quicksort driver function with a set of special values, to let it know the partition is already sorted and not bother with it further!

And that became my solution to sorting random arrays. Our test suites included test cases that ran our sorting algorithms on arrays of up to 10,000 integers (which, in hindsight, I don't think the input size is *that* big. Again, Quicksort is far from the only sorting algorithm we had to implement, and certainly isn't the ideal choice for different edge cases, such as mostly-sorted arrays. However, the biggest test cases were the ones with random elements, and I was more than happy to submit my version dual-pivot Quicksort as described above. 

__Without delaying the climax further__: I produced the **third-lowest array access count** among all submissions in a class of **109 students.**

I only felt the gravity of what I did as the good news came. Even more so as my friends all seem to be impressed with the tricks I did to my Quicksort implementation. 

While this assignment was certainly among the highlights of this semester, I'm also extremely greatful for having been chosen to be a TA for CSC 252: Computer Organization. The satisfaction of explaining new concepts to someone else and watch their Eureka moment, to me, will simply never get old. Being able to come back to one of my favorite classes, and uncover (again) the magic behind fancy circuits called "processors" is just something I can not turn down. To have had the honor to work with a great lecturer, an equally great team of teaching assistants, and having received truly heartfelt appreciation messages from my students at the end of the semester completes the cherry on top of the pie.

With that being said, what better way to remember this semester by re-implementing dual-pivot Quicksort, with sorted partition detection... in Assembly.

# A note on my MIPS32 Assembly implementation
__January 3, 2023 update:__ Apparently, the official MIPS specifications require a branch/jump delay slot. The version I currently have assumes no branch/jump delay slots are needed, as MARS does not enable delayed branching by default. Tweaking my current code to accommodate the branch/jump delay slots won't be too difficult, but nonetheless could turn into a headache. We'll see what comes out of it.

While I have for the most part stayed true to the style guidelines in CSC 252, there are a few significant deviations. The most significant of which includes my extensive use of pseudo branch instructions, when pseudo-instructions remained banned in CSC 252 up until the very last assignment. I'm doing this in the interest of disability; however, conceptually, all of these pseudo branch instructions could be done with some combination of SLT, BEQ, and/or BNE. MOVE and LI also follow this principle, though the former can easily be translated to ADDI, and the latter with LUI and ORI.

# Future RISC-V Assembly Implementation
To be done as I re-familiarize myself with RISC-V. Unlike the MIPS version, however, I plan to support the 64-bit (RV64I) and the 16-bit compressed (RVC) instruction extensions.
