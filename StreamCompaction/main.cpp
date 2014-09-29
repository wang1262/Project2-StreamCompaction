// StreamCompaction.cpp : Defines the entry point for the console application.
//
#include "stdafx.h"
#include <windows.h>
#include "project2_kernel.h"
#include "main.h"
using namespace std;


int * serialSum(int * input, int size){
	//CPU serial prefix SUM
	
	int * orig_array = input;
	int * sum_array = new int[size];

	sum_array[0] = 0;
	for(int i=1; i<size; i++)
		sum_array[i] = sum_array[i-1] + orig_array[i-1];

	return sum_array;
}

int * serialScatter(int * input, int size){
	//CPU serial scatter
	
	int * orig_array = input;
	int * scatter_bool_array = new int[size];

	for(int i=0; i<size; i++){
		if(orig_array[i]!=0)
			scatter_bool_array[i] = 1;
		else
			scatter_bool_array[i] = 0;
	}

	return scatter_bool_array;
}


void main(){
	printf("<-----Start program----->\n");

	printf("\n");
	project2_kernel();

	system("PAUSE");
}