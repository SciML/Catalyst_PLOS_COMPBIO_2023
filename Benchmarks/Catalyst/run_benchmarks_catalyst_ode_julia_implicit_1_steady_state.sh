#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_catalyst_ode_julia_implicit_1_steady_state.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

JULIA_THREADS_TO_USE=1

echo "Starts benchmark runs on the multistate model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate TRBDF2 1.301 1.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate TRBDF2 1.301 1.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate TRBDF2 1.301 1.301 1 KLU jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate KenCarp4 1.301 1.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate KenCarp4 1.301 1.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multistate KenCarp4 1.301 1.301 1 KLU jac sparse ss_sim

echo "Starts benchmark runs on the multisite2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 TRBDF2 0.301 0.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 TRBDF2 0.301 0.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 TRBDF2 0.301 0.301 1 KLU jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 KenCarp4 0.301 0.301 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 KenCarp4 0.301 0.301 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl multisite2 KenCarp4 0.301 0.301 1 KLU jac sparse ss_sim

echo "Starts benchmark runs on the egfr_net model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net TRBDF2 1 1 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net TRBDF2 1 1 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net TRBDF2 1 1 1 KLU jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net KenCarp4 1 1 1 NoLinSolver ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net KenCarp4 1 1 1 GMRES ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl egfr_net KenCarp4 1 1 1 KLU jac sparse ss_sim
 
echo "Starts benchmark runs on the BCR model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR TRBDF2 4.301 4.301 1 NoLinSolver autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR TRBDF2 4.301 4.301 1 GMRES autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR TRBDF2 4.301 4.301 1 GMRES autodifffalse preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR TRBDF2 4.301 4.301 1 KLU autodifffalse jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR KenCarp4 4.301 4.301 1 NoLinSolver autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR KenCarp4 4.301 4.301 1 GMRES autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR KenCarp4 4.301 4.301 1 GMRES autodifffalse preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl BCR KenCarp4 4.301 4.301 1 KLU autodifffalse jac sparse ss_sim

echo "Starts benchmark runs on the fceri_gamma2 model."
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 TRBDF2 2.176 2.176 1 NoLinSolver autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 TRBDF2 2.176 2.176 1 GMRES autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 TRBDF2 2.176 2.176 1 GMRES autodifffalse preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 TRBDF2 2.176 2.176 1 KLU autodifffalse jac sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 KenCarp4 2.176 2.176 1 NoLinSolver autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 KenCarp4 2.176 2.176 1 GMRES autodifffalse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 KenCarp4 2.176 2.176 1 GMRES autodifffalse preconditioner sparse ss_sim
time julia --threads $JULIA_THREADS_TO_USE catalyst_make_benchmark.jl fceri_gamma2 KenCarp4 2.176 2.176 1 KLU autodifffalse jac sparse ss_sim