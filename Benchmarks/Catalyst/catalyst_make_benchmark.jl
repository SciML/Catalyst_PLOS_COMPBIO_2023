### Preparations ###

# Activate local environment.
import Pkg
Pkg.activate(".")
println("Threads in use: $(Threads.nthreads())")

# Fetch packages.
using BenchmarkTools
using Catalyst
using DiffEqBase
using DifferentialEquations
using JSON
using JumpProcesses
using LinearAlgebra
using LSODA
using ModelingToolkit
using ODEInterface
using ODEInterfaceDiffEq
using OrdinaryDiffEq
using ReactionNetworkImporters
using RecursiveFactorization
using Sundials
using TimerOutputs


# Declares a serilization function.
function serialize_benchmarks(benchmarks,lengs,methodName)
    ss_sim && (methodName = "ss_sim_"*methodName)
    medians = map(bm -> median(bm.times)/1000000, benchmarks)
    open("../Benchmarking_results/Threads_$(Threads.nthreads())/catalyst_$(methodName)_$(modelName).json","w") do f
        JSON.print(f, Dict("benchmarks"=>benchmarks, "medians"=>medians, "lengs"=>lengs))
    end
end

# Reads input selection.
modelName,methodName,minT,maxT,nT = ARGS[1:5]
ss_sim = in("ss_sim", ARGS)

# Sets benchmarking lengths
lengs = 10 .^(range(parse(Float64,minT),stop=parse(Float64,maxT),length=parse(Int64,nT))); 

# Sets the method.
solver = Dict(["lsoda" => lsoda, "CVODE_BDF" => CVODE_BDF, "TRBDF2" => TRBDF2, "KenCarp4" => KenCarp4, "QNDF" => QNDF, "FBDF" => FBDF, "Rodas4" => Rodas4, "Rodas5P" => Rodas5P, "Rosenbrock23" => Rosenbrock23, "Tsit5" => Tsit5, "BS5" => BS5, "VCABM" => VCABM, "Vern6" => Vern6, "Vern7" => Vern7, "Vern8" => Vern8, "Vern9" => Vern9, "ROCK2" => ROCK2, "ROCK4" => ROCK4, "Direct" => Direct, "SortingDirect" => SortingDirect, "RSSA" => RSSA, "RSSACR" => RSSACR])[methodName]
in(methodName,["lsoda", "CVODE_BDF", "TRBDF2", "KenCarp4", "QNDF", "FBDF", "Rodas4", "Rodas5P", "Rosenbrock23", "Tsit5", "BS5", "VCABM", "Vern6", "Vern7", "Vern8", "Vern9", "ROCK2", "ROCK4"]) && (methodType = :ODE)
in(methodName,["Direct", "SortingDirect", "RSSA", "RSSACR"]) && (methodType = :Jump)

# Load model.
#if (modelName=="BCR") && (methodType == :Jump)
#    model = loadrxnetwork(BNGNetwork(), "../Data/postequil_c3.net");
#else
#    model = loadrxnetwork(BNGNetwork(), "../Data/$(modelName)_no_obs.net");
#end
model = loadrxnetwork(BNGNetwork(), "../Data/$(modelName)_no_obs.net");

### Benchmarking ###

# Benchmark model.
if methodType == :ODE
    # Read additional ODE options.
    linsolName = ARGS[6]
    jac = in("jac", ARGS)
    sparse = in("sparse", ARGS)
    preconditioner = in("preconditioner", ARGS)

    # Declares beginning of benchmark.
    println("\n-----     Beginning benchmarks for $(modelName) using $(methodName) with jac=$(jac),  with sparse=$(sparse), and with linsolver=$(linsolName).     -----")

    # Run ODE benchmark.
    if isfile("../Data/Problems/$(modelName)_odeprob"*(sparse ? "_sparse" : "")*(jac ? "_jac" : "")*".jls")
        using Serialization
        oprob = deserialize("../Data/Problems/$(modelName)_odeprob"*(sparse ? "_sparse" : "")*(jac ? "_jac" : "")*".jls")
    else
        oprob = ODEProblem(convert(ODESystem,model.rn),Float64[],(0.0,0.0),Float64[],sparse=sparse,jac=jac)
    end
    preconditioner && include("preconditioners.jl")

    # Decision tree could be made nicer and avoided, but the code works so why change it.
    if methodName=="lsoda"
        solver = solver()
    elseif methodName=="CVODE_BDF"
        linsolver = Dict(["NoLinSolver" => nothing, "KLU" => :KLU, "LapackDense" => :LapackDense, "GMRES" => :GMRES])[linsolName]
        if isnothing(linsolver)
            solver = solver()
        else    
            if preconditioner
                precilu,psetupilu = get_cvode_pcs((modelName=="fceri_gamma2") ? 5 : 1e2, model)
                solver = solver(linear_solver=linsolver,prec=precilu,psetup=psetupilu,prec_side=1)
            else 
                solver = solver(linear_solver=linsolver)
            end
        end
    else
        linsolver = Dict(["NoLinSolver" => nothing, "KLU" => KLUFactorization(), "GMRES" => KrylovJL_GMRES()])[linsolName]
        autodiff = !in("autodifffalse", ARGS)
        if isnothing(linsolver)
            solver = (autodiff ? solver() : solver(autodiff=false))
        else
            if preconditioner
                incompletelu = get_julia_pcs((modelName=="fceri_gamma2") ? 1e12 : 1e2)
                solver = solver(linsolve=linsolver,autodiff=autodiff,precs=incompletelu,concrete_jac=true)
            else 
                solver = solver(linsolve=linsolver,autodiff=autodiff)
            end
        end
    end
    if in(methodName,["lsoda", "CVODE_BDF"])
        benchmarks = map(leng -> (op_interal = remake(oprob,tspan=(0.0,leng)); (@benchmark solve($op_interal,$solver,abstol=1e-9,reltol=1e-6,saveat=$leng));), lengs);
    else
        benchmarks = map(leng -> (op_interal = remake(oprob,tspan=(0.0,leng)); (@benchmark solve($op_interal,$solver,abstol=1e-9,reltol=1e-6,saveat=$leng,maxiters=1e12,dtmin=1e-18));), lengs);
    end
    jac && (methodName=methodName*"_jac"); 
    sparse && (methodName=methodName*"_sparse");
    preconditioner && (methodName=methodName*"_pc");  
    serialize_benchmarks(benchmarks,lengs,"$(methodName)_$(linsolName)")
elseif methodType == :Jump
    # Declares beginning of benchmark.
    println("\n-----     Beginning benchmarks for $(modelName) using $(methodName)     -----")

    # Run jump benchmark.
    #if (modelName=="BCR") && (methodType == :Jump)
    #    dprob = DiscreteProblem(model.rn,JSON.parsefile("../Data/BCR_SSA_u0.json"),(0.0,0.0),model.p); 
    #else
    #    dprob = DiscreteProblem(model.rn,model.u₀,(0.0,0.0),model.p); dprob = remake(dprob,u0=Int64.(dprob.u0));
    #end
    dprob = DiscreteProblem(model.rn,model.u₀,(0.0,0.0),model.p); 
    dprob = remake(dprob,u0=Int64.(dprob.u0));
    jprob = JumpProblem(model.rn,dprob,solver(),save_positions=(false,false))
    benchmarks = map(leng -> (jp_internal = remake(jprob,tspan=(0.0,leng)); (@benchmark solve($jp_internal,$(SSAStepper())));), lengs);
    serialize_benchmarks(benchmarks,lengs,methodName)
end

# Proclaims benchmark over.
println("-----     Benchmark finished.     -----")