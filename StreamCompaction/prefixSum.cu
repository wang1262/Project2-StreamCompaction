#include "prefixSum.h"


__global__ void GPUAdvancedArbitraryLength(int * in, int * blocksum, int * out, int n){

	//allocate shared memory of this single block
	__shared__ int Md[block_size];
	__shared__ int Pd[block_size];

	int thid = blockDim.x * blockIdx.x + threadIdx.x;
	int cur_thidx = threadIdx.x;

	if(thid<n){

		Md[cur_thidx] = in[thid];
		__syncthreads();

		//after the input array been loaded into shared memory then do the Sum
		int d_max = (int)ceil(log2((float)n));
		for(int d=1; d<=d_max; d++){
			if(cur_thidx>= (int)pow(2.0, d-1))
				Pd[cur_thidx] = Md[cur_thidx - (int)pow(2.0, d-1)] + Md[cur_thidx];
			else
				Pd[cur_thidx] = Md[cur_thidx];
			Md[cur_thidx] = Pd[cur_thidx];
			__syncthreads();
		}

		if(cur_thidx == block_size-1)
			blocksum[blockIdx.x] = Pd[cur_thidx];

		out[thid] = Pd[cur_thidx];
	}
}

__global__ void AddSum(int * input, int * output){

	int thid = blockDim.x * blockIdx.x + threadIdx.x;
	//add the sum from all blocks to final output
	int blockSumIndex = blockIdx.x - 1;

	if(blockSumIndex!=0)
	    output[thid] += input[blockSumIndex];

}

int * AdvancedPrefixSumArbiLength(int * input, int size){

	int * Md;
	int * Pd;
	int * blockSum;
	int * finalValue;
	int bsize = size * sizeof(int);
	int * output = new int[size];
	//int * temp;
	int numBlocks = (int)ceil(size/(float)block_size);
	//calculate how many blocks needed for the sum

	cudaMalloc(&Md, bsize); 
	cudaMalloc(&Pd, bsize); 
	cudaMalloc(&blockSum, sizeof(int)*numBlocks);
	//cudaMalloc(&temp, bsize);
	cudaMemcpy(Md, input, bsize, cudaMemcpyHostToDevice);

	GPUAdvancedArbitraryLength<<<numBlocks, block_size>>> (Md, blockSum, Pd, size);

	//Perform scan independantly on each chunch while storing the total sum in a new array sums
	if(numBlocks>1)
	{
		int numBlocks2 = (int)ceil(numBlocks/(float)block_size);
		for(int d=1; (int)pow(2.0,d-1)<=numBlocks; d++)
		{
			GPUAdvancedSingleBlock<<<numBlocks2, block_size>>> (blockSum, finalValue, size);
			
			std::swap(finalValue, blockSum);
		}

		//Add up SUM value from each block
		AddSum<<<numBlocks, block_size>>> (finalValue, Pd);
	}


	output[0] = 0;
	cudaMemcpy(&output[1], Pd, bsize, cudaMemcpyDeviceToHost); 
	cudaFree(Md);
	cudaFree(Pd);

	return output;

}


__global__ void GPUAdvancedSingleBlock(int *in, int *out, int n){

	if(n>1000){
		//printf("WARNING: BUFFER SIZE OVER SHARED MEMORY LIMIT!\n");
		return;
	}

	//allocate shared memory of this single block
	__shared__ int Md[block_size];
	__shared__ int Pd[block_size];

	int thid = threadIdx.x;
	if(thid<n){

		Md[thid] = in[thid];

		__syncthreads();
		//after the input array been loaded into shared memory then do the Sum
		int d_max = (int)ceil(log2((float)n));
		for(int d=1; d<=d_max; d++){
			if(thid>= (int)pow(2.0, d-1))
				Pd[thid] = Md[thid - (int)pow(2.0, d-1)] + Md[thid];
			else
				Pd[thid] = Md[thid];
			Md[thid] = Pd[thid];
			__syncthreads();
		}	

		out[thid] = Pd[thid];
	}
}

int * AdvancedPrefixSum(int * input, int size){

	int * Md;
	int * Pd;
	int bsize = size * sizeof(int);
	int * output = new int[size];
	//int * temp;

	cudaMalloc(&Md, bsize); 
	cudaMalloc(&Pd, bsize); 
	//cudaMalloc(&temp, bsize);
	cudaMemcpy(Md, input, bsize, cudaMemcpyHostToDevice);
	if(size>block_size){
		printf("WARNING: Array Size Over Block Size!\n");
		return NULL;
	}

	//single block
	int numBlocks = 1;
	//Double buffer version of sum scan
	GPUAdvancedSingleBlock<<<numBlocks, block_size>>> (Md, Pd, size);

	output[0] = 0;
	cudaMemcpy(&output[1], Pd, bsize, cudaMemcpyDeviceToHost); 
	cudaFree(Md);
	cudaFree(Pd);

	return output;

}


__global__ void GPUNaiveDoubleBuffer(int *in, int *out, int n, int d)
{
	int thid = blockDim.x * blockIdx.x + threadIdx.x;

	if(thid < n)
	{
		if(thid>= (int)pow(2.0, d-1))
			out[thid] = in[thid - (int)pow(2.0, d-1)] + in[thid];
		else
			out[thid] = in[thid];
	}	
}

int * NaivePrefixSum(int * input, int size){

	int * Md;
	int * Pd;
	int bsize = size * sizeof(int);
	int * output = new int[size];
	//int * temp;

	cudaMalloc(&Md, bsize); 
	cudaMalloc(&Pd, bsize); 
	//cudaMalloc(&temp, bsize);
	cudaMemcpy(Md, input, bsize, cudaMemcpyHostToDevice);
	int numBlocks = (int)ceil(size/(float)block_size);

	int d_max = (int)ceil(log2((float)size));

	for(int d=1; d<=d_max; d++){
		//Double buffer version of sum scan
		GPUNaiveDoubleBuffer<<<numBlocks, block_size>>> (Md, Pd, size, d);
		std::swap(Md, Pd);
	}

	output[0] = 0;
	cudaMemcpy(&output[1], Pd, bsize, cudaMemcpyDeviceToHost); 
	cudaFree(Md);
	cudaFree(Pd);

	return output;
}

