#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_copasi_ode_BCR.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

echo "Starts benchmark runs on the BCR model."
time python3 copasi_make_benchmarks.py BCR deterministic 1 2 4 10
