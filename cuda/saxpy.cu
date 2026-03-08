#include <iostream>
#include <vector>

__global__
void saxpy(int n, float a, float *x, float *y) {

    int i = blockDim.x * blockIdx.x + threadIdx.x;
//    printf("%d\n", i);

    if (i < n) {
        y[i] = a * x[i] + y[i];
    }
}

int main(void) {

    int N = 20 * (1 << 20);
    float *d_x, *d_y;
    std::vector<float> x(N, 1.5f);
    std::vector<float> y(N, 2.0f);

    cudaEvent_t start, stop;
    cudaEventCreate (&start);
    cudaEventCreate (&stop);

    cudaMalloc (&d_x, N * sizeof(float));
    cudaMalloc (&d_y, N * sizeof(float));

    cudaMemcpy (d_x, &x[0], N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy (d_y, &y[0], N * sizeof(float), cudaMemcpyHostToDevice);

    cudaEventRecord (start);
    saxpy<<<(N+511) / 512, 512>>> (N, 2.0f, d_x, d_y);
    cudaEventRecord (stop);

    cudaMemcpy (&y[0], d_y, N * sizeof(float), cudaMemcpyDeviceToHost);

    cudaEventSynchronize (stop);
    float ms = 0;
    cudaEventElapsedTime (&ms, start, stop);
    std::cout << "ms: " << ms << std::endl;

    float maxError = 0.0f;
    for (int i = 0; i < N; i++) {
        maxError = fmax(maxError, fabs (y[i] - 4.0f));
    }
    std::cout << "Max error: " << maxError << std::endl;

    int bandwidth = N * 4 * 3 / ms / 1e6;
    std::cout << "Effective Bandwidht (GB/s):" << bandwidth << std::endl;

    cudaFree(d_x);
    cudaFree(d_y);
}


