#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_catalyst_ode_julia_explicit.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

JULIA_THREADS_TO_USE=1

echo "Starts benchmark runs on the multistate model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Tsit5 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate BS5 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate VCABM 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Vern6 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Vern7 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Vern8 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Vern9 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate ROCK2 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate ROCK4 1 5 9 NoLinSolver

echo "Starts benchmark runs on the multisite2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Tsit5 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 BS5 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 VCABM 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Vern6 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Vern7 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Vern8 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Vern9 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 ROCK2 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 ROCK4 1 5 9 NoLinSolver

echo "Starts benchmark runs on the egfr_net model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Tsit5 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net BS5 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net VCABM 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Vern6 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Vern7 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Vern8 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Vern9 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net ROCK2 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net ROCK4 1 3 7 NoLinSolver

echo "Starts benchmark runs on the BCR model."

echo "Starts benchmark runs on the fceri_gamma2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Tsit5 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 BS5 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 VCABM 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Vern6 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Vern7 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Vern8 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Vern9 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 ROCK2 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 ROCK4 1 3 7 NoLinSolver