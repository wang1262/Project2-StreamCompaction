
#include "scatter.h"


int * Scatter(int * input, int size){

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

	int numBlocks = (int)ceil(size/(float)block_size);

	//GPU version scatter
	GPUScatter<<<numBlocks, block_size>>> (Md, Pd, size);

	cudaMemcpy(output, Pd, bsize, cudaMemcpyDeviceToHost); 
	cudaFree(Md);
	cudaFree(Pd);

	return output;

}


__global__ void GPUScatter(int *in, int *out, int n){

	int thid = blockDim.x * blockIdx.x + threadIdx.x;

	if(thid<n){
		if(in[thid]!=0)
			out[thid] = 1;
		else
			out[thid] = 0;
	}
}
