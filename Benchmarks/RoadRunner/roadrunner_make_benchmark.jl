### Preparations ###

# Activate local environment.
import Pkg
Pkg.activate(".")
println("Threads in use: $(Threads.nthreads())")

# Fetch packages.
using BenchmarkTools
using JSON
using RoadRunner
using Plots
using TimerOutputs

# Declares a serilization function.
function serialize_benchmarks(benchmarks,lengs,methodName)
    ss_sim && (methodName = "ss_sim_"*methodName)
    medians = map(bm -> median(bm.times)/1000000, benchmarks)
    open("../Benchmarking_results/Threads_$(Threads.nthreads())/roadrunner_$(methodName)_$(modelName).json","w") do f
        JSON.print(f, Dict("benchmarks"=>benchmarks, "medians"=>medians, "lengs"=>lengs))
    end
end

# Reads input selection.
if isempty(ARGS) # For running in VSCode
    modelName,methodName,minT,maxT,nT = ["multistate", "ODE", "1.301", "1.301", "1"]
    ss_sim = true
else
    modelName,methodName,minT,maxT,nT = ARGS[1:5]
    ss_sim = in("ss_sim", ARGS)
end

# Sets benchmarking lengths
lengs = 10 .^(range(parse(Float64,minT),stop=parse(Float64,maxT),length=parse(Int64,nT))); 

# Helper functions

# Load model.
begin
    filename = "../Data/$(modelName)_no_obs.xml"
    opened_file = open(filename)
    sbml_str = read(filename,String)
    close(opened_file)
    model = RoadRunner.createRRInstance()
    RoadRunner.loadSBML(model, sbml_str)
end

# Benchmark_models model
function benchmark_model(model, l, methodName)
    RoadRunner.setTimeCourseSelectionList(model, "")

    if methodName == "ODE"
        return @benchmark ode_simulate_model($model, $l)
    elseif methodName == "SSA"
        return @benchmark ssa_simulate_model($model, $l)
    else
        error("Invalid method name given: $(methodName)")
    end
end
function ode_simulate_model(model, l)
    RoadRunner.resetRR(model)
    RoadRunner.simulateEx(model, 0., l, 2)
end
function ssa_simulate_model(model, l)
    RoadRunner.resetRR(model)
    RoadRunner.gillespieEx(model, 0., l)
end

### Benchmarking ###

# Proclaims benchmark begins.
println("\n-----     Beginning benchmarks for $(modelName) using $(methodName).     -----")

# Make benchmarks.
benchmarks = map(leng -> benchmark_model(model, leng, methodName), lengs)
serialize_benchmarks(benchmarks,lengs,methodName)

# Proclaims benchmark over.
println("-----     Benchmark finished.     -----")