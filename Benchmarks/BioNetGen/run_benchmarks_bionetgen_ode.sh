#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_bionetgen_ode.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

echo "Starts benchmark runs on the multistate model."
time python3 bionetgen_make_benchmarks.py multistate \"ode\" 1 5 9 10
time python3 bionetgen_make_benchmarks.py multistate \"ode\" 1 5 9 10 sparse
# 
echo "Starts benchmark runs on the multisite2 model."
time python3 bionetgen_make_benchmarks.py multisite2 \"ode\" 1 4 7 10
time python3 bionetgen_make_benchmarks.py multisite2 \"ode\" 1 4 7 10 sparse
# 
echo "Starts benchmark runs on the egfr_net model."
time python3 bionetgen_make_benchmarks.py egfr_net \"ode\" 1 3 7 10
time python3 bionetgen_make_benchmarks.py egfr_net \"ode\" 1 3 7 10 sparse

echo "Starts benchmark runs on the BCR model."
time python3 bionetgen_make_benchmarks.py BCR \"ode\" 1 3 7 10
time python3 bionetgen_make_benchmarks.py BCR \"ode\" 1 3 7 10 sparse

echo "Starts benchmark runs on the fceri_gamma2 model."
time python3 bionetgen_make_benchmarks.py fceri_gamma2 \"ode\" 1 3 7 10
time python3 bionetgen_make_benchmarks.py fceri_gamma2 \"ode\" 1 3 7 10 sparse