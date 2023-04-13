#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmark_prototyping_catalyst.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

JULIA_THREADS_TO_USE=1
time julia --threads $JULIA_THREADS_TO_USE catalyst_benchmark_protptyping.jl
