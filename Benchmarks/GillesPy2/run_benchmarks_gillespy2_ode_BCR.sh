#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_gillespy2_ode_BCR.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

# zvode and vode works poorly, see https://github.com/StochSS/GillesPy2/issues/927.

echo "Starts benchmark runs on the BCR model."
time python3 gillespy2_make_benchmarks.py BCR lsoda 1 2 4 5
time python3 gillespy2_make_benchmarks.py BCR csolver 1 2 4 5