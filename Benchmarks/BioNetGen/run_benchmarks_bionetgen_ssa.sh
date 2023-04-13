#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_bionetgen_ssa.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

# When HPC time limit limts job, comment all jobs but the one we want to run to avoid wasting time on other jobs.

echo "Starts benchmark runs on the multistate model."
time python3 bionetgen_make_benchmarks.py multistate \"ssa\" 1 5 9 10

echo "Starts benchmark runs on the multisite2 model."
time python3 bionetgen_make_benchmarks.py multisite2 \"ssa\" 1 4 7 10

echo "Starts benchmark runs on the egfr_net model."
time python3 bionetgen_make_benchmarks.py egfr_net \"ssa\" 1 3 7 10

echo "Starts benchmark runs on the BCR model."
time python3 bionetgen_make_benchmarks.py BCR \"ssa\" 3.398 4.204 2 4

echo "Starts benchmark runs on the fceri_gamma2 model."
time python3 bionetgen_make_benchmarks.py fceri_gamma2 \"ssa\" 1 3 7 5
