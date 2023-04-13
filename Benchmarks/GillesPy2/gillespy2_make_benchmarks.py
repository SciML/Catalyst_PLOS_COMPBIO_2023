### Preparations ###

# Fetch packages.
import sys, numpy, gillespy2
import json
import statistics
import timeit
import numpy
from gillespy2 import  ODESolver, ODECSolver, SSACSolver, NumPySSASolver

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
def make_ODE_benchmark(model,n,leng,method):
    if method == 'csolver':
        def benchmark_func():
            model.run(solver=ODECSolver,t=leng,increment=leng,integrator_options={"atol":1e-9,"rtol":1e-6,"nsteps":100000})
    else:
        def benchmark_func():
            model.run(solver=ODESolver,t=leng,increment=leng,integrator=method,integrator_options={"atol":1e-9,"rtol":1e-6,"nsteps":100000})
    durations = timeit.Timer(benchmark_func).repeat(repeat=n, number=1)
    return durations
def make_Gillespie_benchmark(model,n,leng):
    if method == 'ssa':
        def benchmark_func():
            model.run(solver=SSACSolver,t=leng,increment=leng/50)
    elif method == 'numpyssa':
        def benchmark_func():
            model.run(solver=NumPySSASolver,t=leng,increment=leng/50)
    durations = timeit.Timer(benchmark_func).repeat(repeat=n, number=1)
    return durations

# Serialises a benchmarking output using JSON.
def serialize(benchmarks,lengs,filename):
    with open(f'../Benchmarking_results/Threads_{threading.active_count()}/%s.json'%(filename) , "w") as write:
        json.dump({"benchmarks": benchmarks, "medians": list(1000*numpy.array(list(map(statistics.median, benchmarks)))), "lengs": lengs.tolist()} , write)

NumPySSASolver
### Benchamrks ###

# Load model.
model = gillespy2.core.import_SBML(f'../Data/{modelname}_no_obs.xml')[0]
if modelname == 'BCR':
    for name, param in model.listOfParameters.items():
        param.expression = str(param.expression)

# Benchmark ODE simulations.
benchmarks = [-1.0] * len(lengs)
for i in range(0,len(lengs)):
    if method in {'lsoda', 'vode', 'zvode', 'csolver'}:
        benchmarks[i] = make_ODE_benchmark(model,n,lengs[i],method)
    elif method in {'ssa', 'numpyssa'}:
        benchmarks[i] = make_Gillespie_benchmark(model,n,lengs[i])
    else:
        print("Unknown method provided")
if 'modName' in sys.argv:
    serialize(benchmarks,lengs,f'gillespy2_ss_sim_{method}_{modelname}')
else:
    serialize(benchmarks,lengs,f'gillespy2_{method}_{modelname}')

