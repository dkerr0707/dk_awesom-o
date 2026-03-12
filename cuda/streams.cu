#include <iostream>

__global__
void kernel (int n, float *a) {
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < n)
        a[i] = i;//a[i] + 1;

}

int main(int argc, char* argv[]) {

    bool v1 = true;
    if (argc > 1)
        v1 = false;

    std::cout << "v1: " << v1 << std::endl;

    int N = (1 << 20);// * 500;
    int bytes  = N * sizeof(float);
    int streamSize = 1024;
    int nStreams = N / streamSize;
    int streamBytes = streamSize * sizeof(float);

    float *a;
    cudaMallocHost(&a, bytes);

    float *d_a;
    cudaMalloc(&d_a, bytes);
    
    int threads = 1024;
    int blocks = streamSize / threads;
   // static_assert (N % threads == 0, "Invalid thread selection.");

    cudaStream_t stream[nStreams];
    cudaError_t result;
    for (int i = 0; i < nStreams; i++)
        result = cudaStreamCreate(&stream[i]);

    if (v1) {

        for (int i = 0; i < nStreams; i++ ) {
            int offset = i * streamSize;
            cudaMemcpyAsync (&d_a[offset], &a[offset], streamBytes, cudaMemcpyHostToDevice, stream[i]);
            kernel <<< blocks, threads, 0, stream[i]  >>>(N, &d_a[offset]);
            cudaMemcpyAsync (&a[offset], &d_a[offset], streamBytes, cudaMemcpyDeviceToHost, stream[i]);
        }

    } else {

        for (int i = 0; i < nStreams; i++) {
            int offset = i * streamSize;
            cudaMemcpyAsync(&d_a[offset], &a[offset], streamBytes, cudaMemcpyHostToDevice, stream[i]);
        }

        for (int i = 0; i < nStreams; i++) {
            int offset = i * streamSize;
            kernel <<< blocks, threads, 0, stream[i] >>> (N, &d_a[offset]);
        }

        for (int i = 0; i < nStreams; i++) {
            int offset = i * streamSize;
            cudaMemcpyAsync (&a[offset], &d_a[offset], streamBytes, cudaMemcpyDeviceToHost, stream[i]);
        }
    }

//    for (int i = 0; i < N; i++)
  //      std::cout << a[i] << " ";
    //std::cout << std::endl;

    for (int i = 0; i < nStreams; i++ )
        result = cudaStreamDestroy(stream[i]);

    cudaFree (d_a);
    cudaFreeHost (a);

    return EXIT_SUCCESS;
}
