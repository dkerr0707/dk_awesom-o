#include <iostream>
#include <math.h>
#include <vector>

// function to add the elements of two arrays
void add(int n, float *x, float *y) {
    for (int i = 0; i < n; i++) {
        y[i] = x[i] + y[i];
    }
}

int main(void) {

    int N = 1<<25; // 1M elements
    
    std::vector<float> x(N, 0.5f);
    std::vector<float> y(N, 1.25f);

    //Run the kernel with 1M elements on the cpu
    add(N, x.data(), y.data());

    //Check for errors
    float maxError = 0.0f;
    for (int i = 0; i < N; i++) {
        maxError = fmax(maxError, fabs(y[i] - 3.0f));
    }

    std::cout << "Max error: " << maxError << std::endl;

    return 0;
}
