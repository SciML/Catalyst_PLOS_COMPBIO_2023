#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_matlab_ssa.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

echo "Starts benchmark runs on the multistate model."
time matlab -nodisplay -singleCompThread -nosplash -nodesktop -r "run('benchmarking_scripts/matlab_make_multistate_ssa_benchmarks.m');exit;"

echo "Starts benchmark runs on the multisite2 model."
time matlab -nodisplay -singleCompThread -nosplash -nodesktop -r "run('benchmarking_scripts/matlab_make_multisite2_ssa_benchmarks.m');exit;"

echo "Starts benchmark runs on the egfr_net model."
time matlab -nodisplay -singleCompThread -nosplash -nodesktop -r "run('benchmarking_scripts/matlab_make_egfr_net_ssa_benchmarks.m');exit;"

echo "Starts benchmark runs on the BCR model."

echo "Starts benchmark runs on the fceri_gamma2 model."
