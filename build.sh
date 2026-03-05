#!/usr/bin/env bash

g++ cpu_add.cpp -o cpu_add
g++ --std=c++17 optional.cpp -o optional
g++ --std=c++11 move.cpp -o move
g++ --std=c++17 selection_statement_initializer.cpp -o ssi

nvcc cuda_add.cu -o cuda_add
