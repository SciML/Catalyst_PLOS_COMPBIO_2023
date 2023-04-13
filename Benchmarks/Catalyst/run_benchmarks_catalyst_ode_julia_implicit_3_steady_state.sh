#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_catalyst_ode_julia_implicit_3_steady_state.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

JULIA_THREADS_TO_USE=1

echo "Starts benchmark runs on the multistate model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Rodas4 1.301 1.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Rodas4 1.301 1.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Rodas4 1.301 1.301 1 KLU jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Rodas5P 1.301 1.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Rodas5P 1.301 1.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Rodas5P 1.301 1.301 1 KLU jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Rosenbrock23 1.301 1.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Rosenbrock23 1.301 1.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate Rosenbrock23 1.301 1.301 1 KLU jac sparse ss_sim

echo "Starts benchmark runs on the multisite2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Rodas4 0.301 0.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Rodas4 0.301 0.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Rodas4 0.301 0.301 1 KLU jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Rodas5P 0.301 0.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Rodas5P 0.301 0.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Rodas5P 0.301 0.301 1 KLU jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Rosenbrock23 0.301 0.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Rosenbrock23 0.301 0.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 Rosenbrock23 0.301 0.301 1 KLU jac sparse ss_sim

echo "Starts benchmark runs on the egfr_net model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Rodas4 1 1 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Rodas4 1 1 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Rodas4 1 1 1 KLU jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Rodas5P 1 1 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Rodas5P 1 1 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Rodas5P 1 1 1 KLU jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Rosenbrock23 1 1 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Rosenbrock23 1 1 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net Rosenbrock23 1 1 1 KLU jac sparse ss_sim

echo "Starts benchmark runs on the BCR model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rodas4 4.301 4.301 1 NoLinSolver autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rodas4 4.301 4.301 1 GMRES autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rodas4 4.301 4.301 1 GMRES autodifffalse preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rodas4 4.301 4.301 1 KLU autodifffalse jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rodas5P 4.301 4.301 1 NoLinSolver autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rodas5P 4.301 4.301 1 GMRES autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rodas5P 4.301 4.301 1 GMRES autodifffalse preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rodas5P 4.301 4.301 1 KLU autodifffalse jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rosenbrock23 4.301 4.301 1 NoLinSolver autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rosenbrock23 4.301 4.301 1 GMRES autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rosenbrock23 4.301 4.301 1 GMRES autodifffalse preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR Rosenbrock23 4.301 4.301 1 KLU autodifffalse jac sparse ss_sim

echo "Starts benchmark runs on the fceri_gamma2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rodas4 2.176 2.176 1 NoLinSolver autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rodas4 2.176 2.176 1 GMRES autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rodas4 2.176 2.176 1 GMRES autodifffalse preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rodas4 2.176 2.176 1 KLU autodifffalse jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rodas5P 2.176 2.176 1 NoLinSolver autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rodas5P 2.176 2.176 1 GMRES autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rodas5P 2.176 2.176 1 GMRES autodifffalse preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rodas5P 2.176 2.176 1 KLU autodifffalse jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rosenbrock23 2.176 2.176 1 NoLinSolver autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rosenbrock23 2.176 2.176 1 GMRES autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rosenbrock23 2.176 2.176 1 GMRES autodifffalse preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 Rosenbrock23 2.176 2.176 1 KLU autodifffalse jac sparse ss_sim