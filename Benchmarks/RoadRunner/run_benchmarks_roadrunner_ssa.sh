#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_copasi_ssa.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

JULIA_THREADS_TO_USE=1

# When HPC time limit limts job, comment all jobs but the one we want to run to avoid wasting time on other jobs.

echo "Starts benchmark runs on the multistate model."
time julia --threads $JULIA_THREADS_TO_USE roadrunner_make_benchmark.jl multistate SSA 1 5 9

echo "Starts benchmark runs on the multisite2 model."
time julia --threads $JULIA_THREADS_TO_USE roadrunner_make_benchmark.jl multisite2 SSA 1 4 7

echo "Starts benchmark runs on the egfr_net model."
time julia --threads $JULIA_THREADS_TO_USE roadrunner_make_benchmark.jl egfr_net SSA 1 2 4

# echo "Starts benchmark runs on the BCR model."
# time julia --threads $JULIA_THREADS_TO_USE roadrunner_make_benchmark.jl BCR SSA 3.398 4.204 2

# echo "Starts benchmark runs on the fceri_gamma2 model."
# time julia --threads $JULIA_THREADS_TO_USE roadrunner_make_benchmark.jl fceri_gamma2 SSA 1 2 4
