#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_matlab_ode_steady_state.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

echo "Starts benchmark runs on the multistate model."
time matlab -nodisplay -singleCompThread -nosplash -nodesktop -r "run('benchmarking_scripts/matlab_make_multistate_ode_ss_benchmarks.m');exit;"

echo "Starts benchmark runs on the multisite2 model."
time matlab -nodisplay -singleCompThread -nosplash -nodesktop -r "run('benchmarking_scripts/matlab_make_multisite2_ode_ss_benchmarks.m');exit;"

echo "Starts benchmark runs on the egfr_net model."
time matlab -nodisplay -singleCompThread -nosplash -nodesktop -r "run('benchmarking_scripts/matlab_make_egfr_net_ode_ss_benchmarks.m');exit;"

echo "Starts benchmark runs on the BCR model."
time matlab -nodisplay -singleCompThread -nosplash -nodesktop -r "run('benchmarking_scripts/matlab_make_BCR_ode_ss_benchmarks.m');exit;"

echo "Starts benchmark runs on the fceri_gamma2 model."
time matlab -nodisplay -singleCompThread -nosplash -nodesktop -r "run('benchmarking_scripts/matlab_make_fceri_gamma2_ode_ss_benchmarks.m');exit;"
