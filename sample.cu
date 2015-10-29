/*
 * "sample.cu"
 *
 * An example for CUDA: summing vectors
 * 		c[i] = a[i]+b[i], where a[i]=i, b[i]=2*i
 *
 * This program implements the case above on both
 * CPU and GPU, check their results and also
 * compares their performances.
 *
 * Prefixes:
 * 		"d_" indicates device (GPU) memory pointer;
 *		"h_" indicates host (CPU) memory pointer.
 *
 * Same timing function is called in both cases.
 */

#include <stdio.h>
#include <stdlib.h>
//includes CUDA
#include "cuda.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#define	N	(1000*1000)
#define	block_size	512// no more than 512
#define block_num	(N+block_size-1)/block_size// no more than 65535

// return type of a CUDA kernel should always be "void"
__global__ void kernel_sum(int *d_a, int *d_b, int *d_c, int num){
	int tid = blockIdx.x*blockDim.x+threadIdx.x;
	if(tid<num){
		d_a[tid] = tid;
		d_b[tid] = tid*2;
		d_c[tid] = d_a[tid]+d_b[tid];
	}
}

double gpusum(int *result){
	// create cudaEvents for timing
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	// allocate memory on device (GPU)
	int *d_a, *d_b, *d_c;
	cudaMalloc((void **)&d_a, N*sizeof(int));
	cudaMalloc((void **)&d_b, N*sizeof(int));
	cudaMalloc((void **)&d_c, N*sizeof(int));

	cudaEventRecord(start, 0);// record start

	// put everything you want to record here
	kernel_sum<<<block_num, block_size>>>(d_a, d_b, d_c, N);// launch the kernel

	cudaEventRecord(stop, 0);// record stop
	cudaEventSynchronize(stop);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start, stop);// calculate elapsedTime
	cudaEventDestroy(start);
	cudaEventDestroy(stop);

	// copy data from device (GPU) to host (CPU)
	cudaMemcpy(result, d_c, N*sizeof(int), cudaMemcpyDeviceToHost);
	return double(elapsedTime);
}

double cpusum(int *result){
	int *h_a = new int[N];
	int *h_b = new int[N];

	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0);// record start

	for(int i=0; i<N; i++){
		h_a[i] = i;
		h_b[i] = i*2;
		result[i] = h_a[i]+h_b[i];
	}

	cudaEventRecord(stop, 0);// record stop
	cudaEventSynchronize(stop);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start, stop);// calculate elapsedTime
	cudaEventDestroy(start);
	cudaEventDestroy(stop);

	delete [] h_a;
	delete [] h_b;

	return double(elapsedTime);
}

bool check_result(int *vec_x, int *vec_y, int num){
	for(int i=0; i<num; i++)
		if(vec_x[i] != vec_y[i])
			return false;
	return true;
}

int main(){
	int *result_cpu = new int[N];
	int *result_gpu = new int[N];

	double time_cpu = cpusum(result_cpu);
	double time_gpu = gpusum(result_gpu);

	if(check_result(result_cpu, result_gpu, N)){
		printf("Results are correct!\n");
		printf("CPU Time:\t%f ms.\n", time_cpu);
		printf("GPU Time:\t%f ms.\n", time_gpu);
		printf("Speedup:\t%f.\n", time_cpu/time_gpu);
	}
	else{
		printf("Results are incorrect!\n");
	}

	delete [] result_cpu;
	delete [] result_gpu;
	return 0;
}
