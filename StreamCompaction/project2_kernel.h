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

#include "main.h"

#define array_size 10
#define block_size 256
#define N 16

void project2_kernel();
int * randomIntArray(int);
void printOutput(int*, int);