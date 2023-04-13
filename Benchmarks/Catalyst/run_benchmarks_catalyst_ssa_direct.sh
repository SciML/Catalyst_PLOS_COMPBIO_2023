#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_catalyst_ssa_direct.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

JULIA_THREADS_TO_USE=1

echo "Starts benchmark runs on the multistate model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Direct 1 5 9

echo "Starts benchmark runs on the multisite2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Direct 1 5 9

echo "Starts benchmark runs on the egfr_net model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Direct 1 2 4

echo "Starts benchmark runs on the BCR model."

echo "Starts benchmark runs on the fceri_gamma2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Direct 1 2 4
