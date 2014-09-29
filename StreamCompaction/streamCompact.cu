#include "streamCompact.h"
#include "scatter.h"

int * ThrustStreamCompact(int * input, int size, int value){

	int * output = new int[size];
	//thrust::copy_if(input, input[size], output, is_not_zero());
	return output;
}

int * StreamCompact(int * input, int * bool_input, int size, int cnt){

	int * Md;
	int * Md2;
	int * Pd;
	int bsize = size * sizeof(int);
	int * output = new int[cnt];
	//int * temp;

	cudaMalloc(&Md, bsize); 
	cudaMalloc(&Md2, bsize); 
	cudaMalloc(&Pd, cnt*sizeof(int)); 
	//cudaMalloc(&temp, bsize);
	cudaMemcpy(Md, input, bsize, cudaMemcpyHostToDevice);
	cudaMemcpy(Md2, bool_input, bsize, cudaMemcpyHostToDevice);

	int numBlocks = (int)ceil(size/(float)block_size);

	//GPU version scatter
	GPUStreamCompact<<<numBlocks, block_size>>> (Md, Md2, Pd, size);

	cudaMemcpy(output, Pd, bsize, cudaMemcpyDeviceToHost);
	cudaFree(Md);
	cudaFree(Md2);
	cudaFree(Pd);

	return output;

}


__global__ void GPUStreamCompact(int *in, int * in2, int *out, int n){

	int thid = blockDim.x * blockIdx.x + threadIdx.x;
	if(thid<n){
		if(in2[thid]==1)
			out[thid] = in[thid];
	}
}