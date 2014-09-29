#include "project2_kernel.h"
#include "prefixSum.h"
#include "scatter.h"
#include "streamCompact.h"

using namespace std;


int * randomIntArray(int size){
	int * M = new int[size];
	for(int i=0; i<size; i++){
		M[i] = rand()%10;
		//printf("orig_array[%d] = %d\n", i, M[i]);
	}
	return M;
}

void printOutput(int* arr, int size){

	for(int i=0; i<size; i++)
		printf("output[%d] = %d\n", i, arr[i]);
}


void project2_kernel()
{

	//initilize the input array
	int * input = new int[array_size];
	input = randomIntArray(array_size);
	printf("The input array generated below:\n");
	printOutput(input, array_size);


	//part1.....
	int * output = new int[array_size];
	printf("\nPart1 CPU prefix Sum.....\n");
	clock_t t1,t2;
	t1=clock();
	output = serialSum(input, array_size);
	t2=clock(); 
	double diff = ((double)t2-(double)t1);
	//double diffms=(diff)/(CLOCKS_PER_SEC/1000);
	printf("The CPU serial version of sum cost: %f ms.\n", diff);

	//printOutput(output, array_size);


	//part2.....
	printf("\n\nPart2 GPU prefix Sum.....\n");
	int * output2 = new int[array_size];
	t1=clock();
	output2 = NaivePrefixSum(input, array_size);
	t2=clock(); 
	diff = ((double)t2-(double)t1);
	//diffms=(diff)/(CLOCKS_PER_SEC/1000);
	printf("The GPU Naive prefix sum cost: %f ms.\n", diff);

	//printOutput(output2, array_size);


	//Part3a.....
	printf("\n\nPart3a GPU prefix Sum with Shared Memory on one block.....\n");
	int * output3 = new int[array_size];
	t1=clock();
	output3 = AdvancedPrefixSum(input, array_size);
	t2=clock(); 
	diff = ((double)t2-(double)t1);
	//diffms=(diff)/(CLOCKS_PER_SEC/1000);
	printf("The GPU Advanced prefix sum cost on single block: %f ms.\n", diff);

	//printOutput(output3, array_size);


	//Part3b.....
	printf("\n\nPart3b GPU prefix Sum with Shared Memory of Arbitrary Length.....\n");
	int * output4 = new int[array_size];
	t1=clock();
	output4 = AdvancedPrefixSumArbiLength(input, array_size);
	t2=clock(); 
	diff = ((double)t2-(double)t1);
	//diffms=(diff)/(CLOCKS_PER_SEC/1000);
	printf("The GPU Advanced prefix sum cost with arbitrary length: %f ms.\n", diff);

	//printOutput(output4, array_size);


	//Part4.....
	printf("\n\nPart4 GPU Scatter.....\n");
	int * output5_bool = new int[array_size];
	t1=clock();
	output5_bool = Scatter(input, array_size);
	t2=clock(); 
	diff = ((double)t2-(double)t1);
	//diffms=(diff)/(CLOCKS_PER_SEC/1000);
	printf("The GPU Scatter cost: %f ms.\n", diff);
	//printOutput(output5_bool, array_size);

	int cnt = 0;
	for(int i=0; i<array_size; i++)
		if(output5_bool[i]==1) 
			cnt++;

	printf("\n\n(Cont.)Stream Compact.....\n");
	int * output5 = new int[cnt];
	t1=clock();
	output5 = StreamCompact(input, output5_bool, array_size, cnt);
	t2=clock(); 
	diff = ((double)t2-(double)t1);
	//diffms=(diff)/(CLOCKS_PER_SEC/1000);
	printf("The GPU Scatter cost: %f ms.\n", diff);
	//printOutput(output5, cnt);
	

	printf("\n\n(Cont.)Thrust Version Stream Compact.....\n");
	int * output6 = new int[cnt];
	t1=clock();
	output6 = ThrustStreamCompact(input, cnt, 1);
	t2=clock(); 
	diff = ((double)t2-(double)t1);
	//diffms=(diff)/(CLOCKS_PER_SEC/1000);
	printf("The GPU Scatter cost: %f ms.\n", diff);
	//printOutput(output6, cnt);


	printf("\n\n<-----Work Done!----->\n\n");

}