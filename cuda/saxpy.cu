#include <iostream>
#include <vector>

__global__
void saxpy(int n, float a, float *x, float *y) {

    int i = blockIdx.x * blockDim.x + threadIdx.x;
//    printf("%d\n", i);

    if (i < n) {
        y[i] = a * x[i] + y[i];
    }
}

int main(void) {

    int N = 1 << 20;
    float *d_x, *d_y;
    std::vector<float> x(N, 1.5f);
    std::vector<float> y(N, 2.0f);

    cudaMalloc (&d_x, N * sizeof(float));
    cudaMalloc (&d_y, N * sizeof(float));

    cudaMemcpy (d_x, &x[0], N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy (d_y, &y[0], N * sizeof(float), cudaMemcpyHostToDevice);

    std::cout << "Run it" << std::endl;

    saxpy<<<(N+255) / 256, 256>>> (N, 2.0f, d_x, d_y);

    std::cout << "Done" << std::endl;

    cudaMemcpy (&y[0], d_y, N * sizeof(float), cudaMemcpyDeviceToHost);

    std::cout << "Get max error" << std::endl;
    float maxError = 0.0f;
    for (int i = 0; i < N; i++) {
        maxError = fmax(maxError, fabs (y[i] - 4.0f));
    }
    std::cout << "Max error: " << maxError << std::endl;

    cudaFree(d_x);
    cudaFree(d_y);
}


