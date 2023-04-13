#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_catalyst_ssa_RSSACR.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

JULIA_THREADS_TO_USE=1

echo "Starts benchmark runs on the multistate model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate RSSACR 1 5 9

echo "Starts benchmark runs on the multisite2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 RSSACR 1 5 9

echo "Starts benchmark runs on the egfr_net model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net RSSACR 1 3 7

echo "Starts benchmark runs on the BCR model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR RSSACR 3.398 5.01 3

echo "Starts benchmark runs on the fceri_gamma2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 RSSACR 1 3 7
