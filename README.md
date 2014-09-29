Project-2
=========



# PART 2 : NAIVE PREFIX SUM
We will now parallelize this the previous section's code.  Recall from lecture
that we can parallelize this using a series of kernel calls.  In this portion,
you are NOT allowed to use shared memory.

### Questions 
* Compare this version to the serial version of exclusive prefix scan. Please
  include a table of how the runtimes compare on different lengths of arrays.
* Plot a graph of the comparison and write a short explanation of the phenomenon you
  see here.

Solution: I just printed the data table for comparing the serial CPU prefix sum and GPU Naive version.
From the data table we can see in the beginning when size is pretty small(less than 10^4), the CPU version cost very little time for the prefix sum. But GPU naive one cost much more. However, with the size growing to 10^6 or 10^7, the GPU naive one seems cost as same as the CPU version. We can predict the CPU prefix sum will cost more time when the size is big enough.
It is because the CPU version use only one thread but GPU version use multiple threads. When size is big, CPU will be much slower.


### Questions
* Compare this version to the parallel prefix sum using global memory.
* Plot a graph of the comparison and write a short explanation of the phenomenon
  you see here.

Solution: The global memory is used by multiple blocks, but the shared memory is only used within the single block. The threads in the single block access the shared memory much faster than accessing the global memory. So the single block version is faster.


### Questions
* Compare your version of stream compact to your version using thrust.  How do
  they compare?  How might you optimize yours more, or how might thrust's stream
  compact be optimized.

Solution: There are some compile error in the thrust method I implemented. But I guess the given thrust method of stream compact will be faster.
