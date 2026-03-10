#!/usr/bin/env bash

DIRECTORY="bin/"

if [ ! -d "$DIRECTORY" ]; then
    mkdir bin/
fi

nvcc cuda_add.cu -o bin/cuda_add

nvcc saxpy.cu -o bin/saxpy

nvcc device.cu -o bin/device

nvcc data_transfer.cu -o bin/data_transfer

