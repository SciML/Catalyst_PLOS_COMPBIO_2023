### preparations ###

import Pkg
Pkg.DEFAULT_IO[] = stdout;

using Catalyst, BifurcationKit, Setfield, DifferentialEquations, Plots,OrdinaryDiffEq, ModelingToolkit, Latexify, StochasticDiffEq, JumpProcesses, DiffEqFlux

default(framestyle=:box,grid=:false,xticks=[],yticks=[],xguide="",yguide="",legend=:none)
 
using Catalyst
rn = @reaction_network begin
    v0+hill(S*σ,v,D*A,n), ∅ → σ
    d, σ → ∅
    (σ/τ,1/τ), ∅ ↔ A
end


### Simulation ###

using OrdinaryDiffEq, Plots
p = [:S => 5., :D => 5., :τ => 100., :v => 5.0, :v0 => 0.5, :n => 3, :d => 0.05]
u0 = [:σ => 5.0, :A => 1.0]
tspan = (0.,1000.)
prob = ODEProblem(rn,u0,tspan,p)
sol = solve(prob,Rosenbrock23())
plot(sol);

plot_rre = plot(sol,xguide="",lw=9,size=(900,300))

using StochasticDiffEq, Plots
p = [:S => 5., :D => 5., :τ => 100., :v => 5.0, :v0 => 0.5, :n => 3, :d => 0.05]
u0 = [:σ => 5.0, :A => 1.0]
tspan = (0.,1000.)
prob = SDEProblem(rn,u0,tspan,p)
sol = solve(prob,ImplicitEM())
plot(sol);

plot_cle = plot(sol,xguide="",lw=5,size=(900,300))

using JumpProcesses, Plots
p = [:S => 5., :D => 5., :τ => 100., :v => 0.5, :v0 => 0.05, :n => 3, :d => 0.05]
u0 = [:σ => 5, :A => 1]
tspan = (0.,1000.)
dprob = DiscreteProblem(rn,u0,tspan,p)
jprob = JumpProblem(rn,dprob,Direct())
sol = solve(jprob,SSAStepper())
plot(sol);

plot_ssa = plot(sol,xguide="",lw=4,size=(900,300))

savefig(plot_rre,"plot_rre.png")
savefig(plot_rre,"plot_rre.svg")
savefig(plot_cle,"plot_cle.png")
savefig(plot_cle,"plot_cle.svg")
savefig(plot_ssa,"plot_ssa.png")
savefig(plot_ssa,"plot_ssa.svg")


### Visualization ###

Graph(rn)

latexify(rn) 

latexify(rn; form=:ode)

### Bifurcation Diagram ###

p = Dict(:S => 5., :D => 5., :τ => 100., :v0 => 0.01,
         :v => 5., :n => 3, :d => 0.05)
bif_par = :S           # bifurcation parameter
p_span = (0.1, 15.)    # interval to vary S over
plot_var = :σ

p_bstart = copy(p)
p_bstart[bif_par] = p_span[1]
u0 = [:σ => 1.0, :A => 1.0]

oprob = ODEProblem(rn, u0, (0.0, 0.0), p_bstart; jac = true)
F = (u,p) -> oprob.f(u, p, 0)
J = (u,p) -> oprob.f.jac(u, p, 0)

# get S and X as symbolic variables
@unpack S, σ = rn

# find their indices in oprob.p and oprob.u0 respectively
bif_idx  = findfirst(isequal(S), parameters(rn))
plot_idx = findfirst(isequal(σ), species(rn))

using BifurcationKit, Plots, LinearAlgebra, Setfield

bprob = BifurcationProblem(F, oprob.u0, oprob.p, (@lens _[bif_idx]);
                           recordFromSolution = (x, p) -> x[plot_idx], J = J)

                           bopts = ContinuationPar(dsmax = 0.05,          # Max arclength in PACM.
                           dsmin = 1e-4,          # Min arclength in PACM.
                           ds = 0.001,            # Initial (positive) arclength in PACM.
                           maxSteps = 100000,     # Max number of steps.
                           pMin = p_span[1],      # Min p-val (if hit, the method stops).
                           pMax = p_span[2],      # Max p-val (if hit, the method stops).
                           detectBifurcation = 3) # Value in {0,1,2,3}

bf = bifurcationdiagram(bprob, PALC(), 2, (args...) -> bopts)

i1 = findfirst(getfield.(bf.γ.branch,:stable) .!= 1)
i2 = findlast(getfield.(bf.γ.branch,:stable) .!= 1)+1
p1 = getfield.(bf.γ.branch,:param)[1:i1]
p2 = getfield.(bf.γ.branch,:param)[i1:i2]
p3 = getfield.(bf.γ.branch,:param)[i2:end]
x1 = getfield.(bf.γ.branch,:x)[1:i1]
x2 = getfield.(bf.γ.branch,:x)[i1:i2]
x3 = getfield.(bf.γ.branch,:x)[i2:end]
plot(p1,x1,lw=6,la=0.9;color=:blue)
plot!(p2,x2,lw=6,la=0.9;color=:red,linestyle=:dash)
bif_plot = plot!(p3,x3,lw=6,la=0.9;color=:blue)

savefig(bif_plot,"bif_dia.svg")


### Parameter Fitting ###

tspan = (0.,1000.)
p = [:S => 5., :D => 5., :τ => 100., :v => 5.0, :v0 => 0.5, :n => 3, :d => 0.05]
u0 = [:σ => 5.0, :A => 1.0]

sample_times = range(tspan[1],stop=tspan[2],length=100)     # Times where teh data samples are taken.
sol_real = solve(ODEProblem(rn,u0,tspan,p),Rosenbrock23())                  # Makes the real simulation (using RRE).
sample_vals = [sol_real.u[findfirst(sol_real.t .>= ts)][var] * (1+(0.1rand()-0.05)) for var in 1:2, ts in sample_times];  # Takes the (perturbed) data samples at the sample times.

# Plots the real solution and samples (just to check).
plot(sol_real,size=(1200,400),label="",framestyle=:box,lw=3,color=[:darkblue :darkred])
plot!(sample_times,sample_vals',seriestype=:scatter,color=[:blue :red],label="")

# Makes function to fit a parameter set to the data, for some initial parameter value and a limited time-frame.
function positive_domain()
    condition(u,t,integrator) = minimum(u) < 0
    affect!(integrator) = integrator.u .= integrator.uprev
    return DiscreteCallback(condition,affect!,save_positions = (false,false))
end
function optimise_p(p_init,tend)
    function loss(p_in)
        any(p_in .< 0) && (return 1000000,sol_real)
        p = copy(p_in);
        (p[4]<0) && (p[4] = -p[4])
        rre_sol = solve(ODEProblem(rn,u0,tspan,p),Rosenbrock23(),tstops=sample_times,callback=positive_domain())  
        vals = hcat(map(ts -> rre_sol.u[findfirst(rre_sol.t .>= ts)], sample_times[1:findlast(sample_times .<= tend)])...)    
        loss = sum(abs2, vals .- sample_vals[:,1:size(vals)[2]])   
        return loss, sol
    end
    return DiffEqFlux.sciml_train(loss,p_init,maxiters = 100)
end;

# Need to run this in several iterations, for the fitting algorithm to handle oscillations.
p0 = [5.,5.,100.,5.0,0.5,3,0.05];
t1 = 100.0;
p_estimate = optimise_p(p0,t1).minimizer

# Fits on the interval (0.0,t1), and plots the solution.
sol_estimate = solve(ODEProblem(rn,u0,(0.,t1),p_estimate),Rosenbrock23(),tstops=sample_times,callback=positive_domain())
plot(sol_real,size=(1200,400),color=[:blue :red],framestyle=:box,lw=3,label=["X real" "Y real"],linealpha=0.2)
plot!(sample_times,sample_vals',seriestype=:scatter,color=[:blue :red],label=["Samples of X" "Samples of Y"],alpha=0.4)
plot!(sol_estimate,color=[:darkblue :darkred], linestyle=:dash,lw=3,label=["X estimated" "Y estimated"],xlimit=tspan)

# Fits on the interval (0.0,t2), and plots the solution. uses the previous paraemter set to start the fitting.
t2 = 150.0;
p_estimate = optimise_p(p_estimate,t2).minimizer

sol_estimate = solve(ODEProblem(rn,u0,(0.,t2),p_estimate),Rosenbrock23(),tstops=sample_times,callback=positive_domain())
plot(sol_real,size=(1200,400),color=[:blue :red],framestyle=:box,lw=3,label=["X real" "Y real"],linealpha=0.2)
plot!(sample_times,sample_vals',seriestype=:scatter,color=[:blue :red],label=["Samples of X" "Samples of Y"],alpha=0.4)
plot!(sol_estimate,color=[:darkblue :darkred], linestyle=:dash,lw=3,label=["X estimated" "Y estimated"],xlimit=tspan)

t3 = 200.0;
p_estimate = optimise_p(p_estimate,t3).minimizer

sol_estimate = solve(ODEProblem(rn,u0,(0.,t3),p_estimate),Rosenbrock23(),tstops=sample_times,callback=positive_domain())
plot(sol_real,size=(1200,400),color=[:blue :red],framestyle=:box,lw=3,label=["X real" "Y real"],linealpha=0.2)
plot!(sample_times,sample_vals',seriestype=:scatter,color=[:blue :red],label=["Samples of X" "Samples of Y"],alpha=0.4)
plot!(sol_estimate,color=[:darkblue :darkred], linestyle=:dash,lw=3,label=["X estimated" "Y estimated"],xlimit=tspan)

t4 = 250.0;
p_estimate = optimise_p(p_estimate,t4).minimizer

sol_estimate = solve(ODEProblem(rn,u0,(0.,t4),p_estimate),Rosenbrock23(),tstops=sample_times,callback=positive_domain())
plot(sol_real,size=(1200,400),color=[:blue :red],framestyle=:box,lw=3,label=["X real" "Y real"],linealpha=0.2)
plot!(sample_times,sample_vals',seriestype=:scatter,color=[:blue :red],label=["Samples of X" "Samples of Y"],alpha=0.4)
plot!(sol_estimate,color=[:darkblue :darkred], linestyle=:dash,lw=3,label=["X estimated" "Y estimated"],xlimit=tspan)

t5 = 350.0;
p_estimate = optimise_p(p_estimate,t5).minimizer

sol_estimate = solve(ODEProblem(rn,u0,(0.,t5),p_estimate),Rosenbrock23(),tstops=sample_times,callback=positive_domain())
plot(sol_real,size=(1200,400),color=[:blue :red],framestyle=:box,lw=3,label=["X real" "Y real"],linealpha=0.2)
plot!(sample_times,sample_vals',seriestype=:scatter,color=[:blue :red],label=["Samples of X" "Samples of Y"],alpha=0.4)
plot!(sol_estimate,color=[:darkblue :darkred], linestyle=:dash,lw=3,label=["X estimated" "Y estimated"],xlimit=tspan)

t6 = 500.0;
p_estimate = optimise_p(p_estimate,t6).minimizer

sol_estimate = solve(ODEProblem(rn,u0,(0.,t6),p_estimate),Rosenbrock23(),tstops=sample_times,callback=positive_domain())
plot(sol_real,size=(1200,400),color=[:blue :red],framestyle=:box,lw=3,label=["X real" "Y real"],linealpha=0.2)
plot!(sample_times,sample_vals',seriestype=:scatter,color=[:blue :red],label=["Samples of X" "Samples of Y"],alpha=0.4)
plot!(sol_estimate,color=[:darkblue :darkred], linestyle=:dash,lw=3,label=["X estimated" "Y estimated"],xlimit=tspan)

t7 = 650.0;
p_estimate = optimise_p(p_estimate,t7).minimizer

sol_estimate = solve(ODEProblem(rn,u0,(0.,t7),p_estimate),Rosenbrock23(),tstops=sample_times,callback=positive_domain())
plot(sol_real,size=(1200,400),color=[:blue :red],framestyle=:box,lw=3,label=["X real" "Y real"],linealpha=0.2)
plot!(sample_times,sample_vals',seriestype=:scatter,color=[:blue :red],label=["Samples of X" "Samples of Y"],alpha=0.4)
plot!(sol_estimate,color=[:darkblue :darkred], linestyle=:dash,lw=3,label=["X estimated" "Y estimated"],xlimit=tspan)

t8 = 800.0;
p_estimate = optimise_p(p_estimate,t8).minimizer

sol_estimate = solve(ODEProblem(rn,u0,(0.,t8),p_estimate),Rosenbrock23(),tstops=sample_times,callback=positive_domain())
plot(sol_real,size=(1200,400),color=[:blue :red],framestyle=:box,lw=3,label=["X real" "Y real"],linealpha=0.2)
plot!(sample_times,sample_vals',seriestype=:scatter,color=[:blue :red],label=["Samples of X" "Samples of Y"],alpha=0.4)
plot!(sol_estimate,color=[:darkblue :darkred], linestyle=:dash,lw=3,label=["X estimated" "Y estimated"],xlimit=tspan)

t9 = 1000.0;
p_estimate = optimise_p(p_estimate,t9).minimizer

sol_estimate = solve(ODEProblem(rn,u0,(0.,t9),p_estimate),Rosenbrock23(),tstops=sample_times,callback=positive_domain())
plot(sol_real,size=(1200,400),color=[:blue :red],framestyle=:box,lw=3,label=["X real" "Y real"],linealpha=0.2)
plot!(sample_times,sample_vals',seriestype=:scatter,color=[:blue :red],label=["Samples of X" "Samples of Y"],alpha=0.4)
plot!(sol_estimate,color=[:darkblue :darkred], linestyle=:dash,lw=3,label=["X estimated" "Y estimated"],xlimit=tspan)

plot(sol_real,size=(1200,400),color=[:blue :red],framestyle=:box,lw=8,label=["X real" "Y real"],linealpha=0.2)
plot!(sample_times,sample_vals',seriestype=:scatter,color=[:blue :red],label=["Samples of X" "Samples of Y"],alpha=0.5,markersize=7)
plot!(sol_estimate,color=[:darkblue :darkred], linestyle=:dash,lw=8,label=["X estimated" "Y estimated"],xlimit=tspan)
param_estim_plot = plot!(xguide="Time",yguide="Species concentration",guidefontsize=14,tickfontsize=10,legend=:topleft,legendfontsize=10)

save_figure(plot!(param_estim_plot,xticks=[],yticks=[]),"Feature_Diagram";tag="Parameter_Fitting_")