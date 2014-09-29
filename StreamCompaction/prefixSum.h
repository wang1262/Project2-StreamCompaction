#include <windows.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <cuda_gl_interop.h>
#include <string>
#include <iostream>
#include <sstream>
#include <fstream>
#include <stdio.h>
#include <time.h>
#include <cuda.h>
#include <cmath>
#include <vector>
#include "stdafx.h"

#define block_size 256
#define array_size 10


int * NaivePrefixSum(int * input, int size);
__global__ void GPUNaiveDoubleBuffer(int * in, int * out, int n, int d);

int * AdvancedPrefixSum(int * input, int size);
__global__ void GPUAdvancedSingleBlock(int * in, int * out, int n);

int * AdvancedPrefixSumArbiLength(int * input, int size);
__global__ void GPUAdvancedArbitraryLength(int * in, int * sum, int * out, int n);
