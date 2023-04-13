#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmark_prototyping_matlab.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

time matlab -nodisplay -singleCompThread -nosplash -nodesktop -r "run('benchmarking_scripts/matlab_benchmark_protptyping.m');exit;"
