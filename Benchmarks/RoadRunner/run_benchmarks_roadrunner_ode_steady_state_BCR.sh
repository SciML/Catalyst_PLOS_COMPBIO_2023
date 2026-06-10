#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_roadrunner_ode_steady_state_BCR.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

JULIA_THREADS_TO_USE=1

echo "Starts benchmark runs on the BCR model."
time julia --threads $JULIA_THREADS_TO_USE roadrunner_make_benchmark.jl BCR ODE 4.301 4.301 1 ss_sim
