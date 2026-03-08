#include <iostream>

int main() {

    int nDevices;

    cudaGetDeviceCount (&nDevices);
    for (int i = 0; i < nDevices; i++) {
    
        cudaDeviceProp prop;
        cudaGetDeviceProperties  (&prop, i);
        
        std::cout << "Device Number: " << i << std::endl;
        std::cout << "  Device Name: " << prop.name << std::endl;
        std::cout << "  Memory Clock Rate (KHz): " << prop.memoryClockRate << std::endl;
        std::cout << "  Memory Bus Width (bits): " << prop.memoryBusWidth << std::endl;

        float peakMemoryBandwidth = prop.memoryClockRate * (prop.memoryBusWidth / 8) / 1.0e6; 
        std::cout << "  Peak Memory Bandwidth (GB/s): " << peakMemoryBandwidth << std::endl;

    }

}
