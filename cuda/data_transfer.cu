#include <iostream>

int main () {

    const unsigned int N = 20 * (1 << 20);
    const unsigned int bytes = N * sizeof (float);

//    int *h_a = (int*) malloc (bytes);
    int *h_aPinned;
    cudaError_t status = cudaMallocHost((void**) &h_aPinned, bytes);
    if (status != cudaSuccess) {
        std::cout << "Error allocating pinned host memory" << std::endl;
    }

    int *d_a;
    cudaMalloc((int**) &d_a, bytes);

    memset (h_aPinned, 0, bytes);
    cudaMemcpy (d_a, h_aPinned, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy (h_aPinned, d_a, bytes, cudaMemcpyDeviceToHost);

    cudaFree (d_a);
    cudaFreeHost (h_aPinned); 
    //free(h_a);

    return EXIT_SUCCESS;
}

