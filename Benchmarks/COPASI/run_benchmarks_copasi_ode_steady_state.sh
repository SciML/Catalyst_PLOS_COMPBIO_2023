#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_copasi_ode_steady_state.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

echo "Starts benchmark runs on the multistate model."
time python3 copasi_make_benchmarks.py multistate deterministic 1.301 1.301 1 10 modName

echo "Starts benchmark runs on the multisite2 model."
time python3 copasi_make_benchmarks.py multisite2 deterministic 0.301 0.301 1 10 modName

echo "Starts benchmark runs on the egfr_net model."
time python3 copasi_make_benchmarks.py egfr_net deterministic 1 1 1 10 modName

# echo "Starts benchmark runs on the BCR model."
# time python3 copasi_make_benchmarks.py BCR deterministic 4.301 4.301 1 10 modName

echo "Starts benchmark runs on the fceri_gamma2 model."
time python3 copasi_make_benchmarks.py fceri_gamma2 deterministic 2.176 2.176 1 10 modName
