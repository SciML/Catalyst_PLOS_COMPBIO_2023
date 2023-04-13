### Preparations ###

# Fetch packages.
from basico import *
import json
import numpy
import statistics
import sys
import timeit

# Check thread count.
import threading
print(f'Threads in use: {threading.active_count()}')

# Read input.
modelname = sys.argv[1]
method = sys.argv[2]
minT = float(sys.argv[3])
maxT = float(sys.argv[4])
nT = int(sys.argv[5])
num_sims = int(sys.argv[6])

# Benchmarking parameters
n = num_sims
lengs = numpy.logspace(minT, maxT, num=nT)

# Benchmarking functions.
def make_benchmark(n,leng,method):
    if method == 'deterministic':
        def benchmark_func():
            run_time_course(duration=leng, stepsize=leng, method=method, atol=1e-9, r_tol=1e-6)
    if method == 'directMethod':
        def benchmark_func():
            run_time_course(duration=leng, stepsize=leng, method=method, max_steps=1000000000)
    durations = timeit.Timer(benchmark_func).repeat(repeat=n, number=1)
    return durations

# Serialises a benchmarking output using JSON.
def serialize(benchmarks,lengs,filename):
    with open(f'../Benchmarking_results/Threads_{threading.active_count()}/%s.json'%(filename) , "w") as write:
        json.dump({"benchmarks": benchmarks, "medians": list(1000*numpy.array(list(map(statistics.median, benchmarks)))), "lengs": lengs.tolist()} , write)


### Benchamrks ###

# Load model.
load_model(f'../Data/{modelname}_no_obs.xml');

# Benchmark ODE simulations.
benchmarks = [-1.0] * len(lengs)
for i in range(0,len(lengs)):
    benchmarks[i] = make_benchmark(n,lengs[i],method)
if 'modName' in sys.argv:
    serialize(benchmarks,lengs,f'copasi_ss_sim_{method}_{modelname}')
else:
    serialize(benchmarks,lengs,f'copasi_{method}_{modelname}')



