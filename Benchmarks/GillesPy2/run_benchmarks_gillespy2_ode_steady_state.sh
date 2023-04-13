#!/bin/bash

#SBATCH -o ../Benchmarking_results/Threads_1/Logs/run_benchmarks_gillespy2_ode_steady_state.log
#SBATCH -N 1  
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=1
#SBATCH --exclusive=user
#SBATCH --mem-per-cpu=192000MB

# zvode and vode works poorly, see https://github.com/StochSS/GillesPy2/issues/927.

echo "Starts benchmark runs on the multistate model."
time python3 gillespy2_make_benchmarks.py multistate lsoda 1.301 1.301 1 10 modName
time python3 gillespy2_make_benchmarks.py multistate csolver 1.301 1.301 1 10 modName

echo "Starts benchmark runs on the multisite2 model."
time python3 gillespy2_make_benchmarks.py multisite2 lsoda 0.301 0.301 1 10 modName
time python3 gillespy2_make_benchmarks.py multisite2 csolver 0.301 0.301 1 10 modName

echo "Starts benchmark runs on the egfr_net model."
time python3 gillespy2_make_benchmarks.py egfr_net lsoda 1 1 1 10 modName
time python3 gillespy2_make_benchmarks.py egfr_net csolver 1 1 1 10 modName

# echo "Starts benchmark runs on the BCR model."
# time python3 gillespy2_make_benchmarks.py BCR lsoda 4.301 4.301 1 5 modName
# time python3 gillespy2_make_benchmarks.py BCR csolver 4.301 4.301 1 5 modName

echo "Starts benchmark runs on the fceri_gamma2 model."
time python3 gillespy2_make_benchmarks.py fceri_gamma2 lsoda 2.176 2.176 1 10 modName
time python3 gillespy2_make_benchmarks.py fceri_gamma2 csolver 2.176 2.176 1 10 modName
