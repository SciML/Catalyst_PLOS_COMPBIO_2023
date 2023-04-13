#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_catalyst_ode_lsoda_n_CVODE.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

JULIA_THREADS_TO_USE=1

echo "Starts benchmark runs on the multistate model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate lsoda 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate CVODE_BDF 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate CVODE_BDF 1 5 9 LapackDense
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate CVODE_BDF 1 5 9 GMRES
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate CVODE_BDF 1 5 9 KLU jac sparse

echo "Starts benchmark runs on the multisite2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 lsoda 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 CVODE_BDF 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 CVODE_BDF 1 5 9 LapackDense
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 CVODE_BDF 1 5 9 GMRES
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 CVODE_BDF 1 5 9 KLU jac sparse

echo "Starts benchmark runs on the egfr_net model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net lsoda 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net CVODE_BDF 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net CVODE_BDF 1 3 7 LapackDense
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net CVODE_BDF 1 3 7 GMRES
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net CVODE_BDF 1 3 7 KLU jac sparse

echo "Starts benchmark runs on the BCR model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR lsoda 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR CVODE_BDF 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR CVODE_BDF 1 3 7 LapackDense
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR CVODE_BDF 1 3 7 GMRES
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR CVODE_BDF 1 3 7 GMRES preconditioner sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR CVODE_BDF 1 3 7 KLU jac sparse

echo "Starts benchmark runs on the fceri_gamma2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 lsoda 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 CVODE_BDF 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 CVODE_BDF 1 3 7 LapackDense
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 CVODE_BDF 1 3 7 GMRES
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 CVODE_BDF 1 3 7 GMRES preconditioner sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 CVODE_BDF 1 3 7 KLU jac sparse
