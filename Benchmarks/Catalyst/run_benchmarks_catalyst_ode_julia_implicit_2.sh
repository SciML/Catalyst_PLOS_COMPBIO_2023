#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_catalyst_ode_julia_implicit_2.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

JULIA_THREADS_TO_USE=1

echo "Starts benchmark runs on the multistate model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate QNDF 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate QNDF 1 5 9 GMRES
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate QNDF 1 5 9 KLU jac sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate FBDF 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate FBDF 1 5 9 GMRES
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate FBDF 1 5 9 KLU jac sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate ROCK4 1 5 9 NoLinSolver

echo "Starts benchmark runs on the multisite2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 QNDF 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 QNDF 1 5 9 GMRES
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 QNDF 1 5 9 KLU jac sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 FBDF 1 5 9 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 FBDF 1 5 9 GMRES
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 FBDF 1 5 9 KLU jac sparse

echo "Starts benchmark runs on the egfr_net model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net QNDF 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net QNDF 1 3 7 GMRES
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net QNDF 1 3 7 KLU jac sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net FBDF 1 3 7 NoLinSolver
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net FBDF 1 3 7 GMRES
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net FBDF 1 3 7 KLU jac sparse

echo "Starts benchmark runs on the BCR model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR QNDF 1 3 7 NoLinSolver autodifffalse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR QNDF 1 3 7 GMRES autodifffalse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR QNDF 1 3 7 GMRES autodifffalse preconditioner sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR QNDF 1 3 7 KLU autodifffalse jac sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR FBDF 1 3 7 NoLinSolver autodifffalse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR FBDF 1 3 7 GMRES autodifffalse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR FBDF 1 3 7 GMRES autodifffalse preconditioner sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR FBDF 1 3 7 KLU autodifffalse jac sparse

echo "Starts benchmark runs on the fceri_gamma2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 QNDF 1 3 7 NoLinSolver autodifffalse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 QNDF 1 3 7 GMRES autodifffalse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 QNDF 1 3 7 GMRES autodifffalse preconditioner sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 QNDF 1 3 7 KLU autodifffalse jac sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 FBDF 1 3 7 NoLinSolver autodifffalse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 FBDF 1 3 7 GMRES autodifffalse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 FBDF 1 3 7 GMRES autodifffalse preconditioner sparse
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 FBDF 1 3 7 KLU autodifffalse jac sparse