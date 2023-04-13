#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_gillespy2_ssa_BCR.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

# We also tried numpyssa, which had very slow performance.

# When HPC time limit limts job, comment all jobs but the one we want to run to avoid wasting time on other jobs.

echo "Starts benchmark runs on the BCR model."
time python3 gillespy2_make_benchmarks.py BCR ssa 3.398 4.204 2 2