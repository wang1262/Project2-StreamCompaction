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
#include <Windows.h>
//#include <thrust\detail\device_ptr.inl>
//#include <thrust/copy.h>
//#include <thrust/device_vector.h>
//#include <thrust/host_vector.h>
#include "stdafx.h"

#define block_size 256
#define array_size 10

struct is_not_zero
  {
    __host__ __device__
    bool operator()(const int x)
    {
      return (x != 0);
    }
};


int * StreamCompact(int * input, int * bool_input, int size, int cnt);
__global__ void GPUStreamCompact(int *in, int * in2, int *out, int n);

int * ThrustStreamCompact(int * input, int size, int value);