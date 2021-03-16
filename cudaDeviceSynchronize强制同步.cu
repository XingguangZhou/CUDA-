#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>

__global__ void AddArray(int *a, int *b, int *c)
{
	int i = threadIdx.x;
	printf("GPU!\n");
	c[i] = a[i] + b[i];
}


int main(void)
{
	int h_a[4] = { 0, 0, 0, 1 };
	int h_b[4] = { 1, 2, 3, 4 };
	int h_c[4] = { 0 };
	int *d_a = NULL;
	int *d_b = NULL;
	int *d_c = NULL;
	int i;

	dim3 block(4);
	dim3 grid((4 + block.x - 1) / block.x);

	cudaMalloc((int **)&d_a, sizeof(int)* 4);
	cudaMalloc((int **)&d_b, sizeof(int)* 4);
	cudaMalloc((int **)&d_c, sizeof(int)* 4);

	cudaMemcpy(d_a, h_a, sizeof(int)* 4, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b, sizeof(int)* 4, cudaMemcpyHostToDevice);

	AddArray << <grid, block >> >(d_a, d_b, d_c);
	//cudaDeviceSynchronize(); // ǿ���豸�������໥ͬ����Ҫ��˺���������ɺ�CPU�ٽ��м��㣬�������飬����������ȥ����鿴�����
	for (i = 0; i < 3; i++)
	{
		printf("CPU!\n");
	}

	cudaMemcpy(h_c, d_c, sizeof(int)* 4, cudaMemcpyDeviceToHost);

	for (i = 0; i < 4; i++)
	{
		printf("%d\t", h_c[i]);
	}
	printf("\n");

	// free the memory
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	cudaDeviceReset();
	return 0;
}