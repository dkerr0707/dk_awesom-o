#!/usr/bin/env bash

nvcc cuda_add.cu -o cuda_add

nvcc saxpy.cu -o saxpy
