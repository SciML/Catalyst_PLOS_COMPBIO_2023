#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_copasi_ode.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

echo "Starts benchmark runs on the multistate model."
time python3 copasi_make_benchmarks.py multistate deterministic 1 5 9 10

echo "Starts benchmark runs on the multisite2 model."
time python3 copasi_make_benchmarks.py multisite2 deterministic 1 4 7 10

echo "Starts benchmark runs on the egfr_net model."
time python3 copasi_make_benchmarks.py egfr_net deterministic 1 3 7 10

# echo "Starts benchmark runs on the BCR model."
# time python3 copasi_make_benchmarks.py BCR deterministic 1 2 4 10

echo "Starts benchmark runs on the fceri_gamma2 model."
time python3 copasi_make_benchmarks.py fceri_gamma2 deterministic 1 2 4 10
