#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_catalyst_ode_lsoda_n_CVODE_steady_state.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

JULIA_THREADS_TO_USE=1

echo "Starts benchmark runs on the multistate model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate lsoda 1.301 1.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate CVODE_BDF 1.301 1.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate CVODE_BDF 1.301 1.301 1 LapackDense ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate CVODE_BDF 1.301 1.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate CVODE_BDF 1.301 1.301 1 KLU jac sparse ss_sim

echo "Starts benchmark runs on the multisite2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 lsoda 0.301 0.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 CVODE_BDF 0.301 0.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 CVODE_BDF 0.301 0.301 1 LapackDense ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 CVODE_BDF 0.301 0.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 CVODE_BDF 0.301 0.301 1 KLU jac sparse ss_sim

echo "Starts benchmark runs on the egfr_net model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net lsoda 1 1 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net CVODE_BDF 1 1 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net CVODE_BDF 1 1 1 LapackDense ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net CVODE_BDF 1 1 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net CVODE_BDF 1 1 1 KLU jac sparse ss_sim

echo "Starts benchmark runs on the BCR model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR lsoda 4.301 4.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR CVODE_BDF 4.301 4.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR CVODE_BDF 4.301 4.301 1 LapackDense ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR CVODE_BDF 4.301 4.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR CVODE_BDF 4.301 4.301 1 GMRES preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR CVODE_BDF 4.301 4.301 1 KLU jac sparse ss_sim

echo "Starts benchmark runs on the fceri_gamma2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 lsoda 2.176 2.176 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 CVODE_BDF 2.176 2.176 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 CVODE_BDF 2.176 2.176 1 LapackDense ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 CVODE_BDF 2.176 2.176 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 CVODE_BDF 2.176 2.176 1 GMRES preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 CVODE_BDF 2.176 2.176 1 KLU jac sparse ss_sim
