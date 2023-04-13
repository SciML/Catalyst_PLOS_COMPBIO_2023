# Makes the (ODE)Problems so that they do not have to be re-creaetd in every benchmark. IO think this should make things run a bit faster for some large problems with sparse jacobians.

### Preparations ###

# Activate local environment.
import Pkg
Pkg.activate(".")

# Fetch packages.
using Catalyst
using DiffEqBase
using DifferentialEquations
using JumpProcesses
using ModelingToolkit
using ODEInterface
using ODEInterfaceDiffEq
using OrdinaryDiffEq
using ReactionNetworkImporters
using RecursiveFactorization
using Serialization

### Make Problems ###

for modelName in ["multistate", "multisite2", "egfr_net", "BCR", "fceri_gamma2"]
    println("\n\n",modelName)    
    model = loadrxnetwork(BNGNetwork(), "../Data/$(modelName)_no_obs.net");

    @time serialize("../Data/Problems/$(modelName)_odeprob.jls", ODEProblem(convert(ODESystem,model.rn),Float64[],(0.0,0.0),Float64[],sparse=false,jac=false))
    @time serialize("../Data/Problems/$(modelName)_odeprob_jac.jls", ODEProblem(convert(ODESystem,model.rn),Float64[],(0.0,0.0),Float64[],sparse=false,jac=true))
    @time serialize("../Data/Problems/$(modelName)_odeprob_sparse.jls", ODEProblem(convert(ODESystem,model.rn),Float64[],(0.0,0.0),Float64[],sparse=true,jac=false))
    @time serialize("../Data/Problems/$(modelName)_odeprob_sparse_jac.jls", ODEProblem(convert(ODESystem,model.rn),Float64[],(0.0,0.0),Float64[],sparse=true,jac=true))
end
