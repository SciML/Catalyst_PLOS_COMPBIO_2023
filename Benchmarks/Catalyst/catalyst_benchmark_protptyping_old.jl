# Do something with Pkg...
import Pkg
Pkg.activate(".")
Pkg.DEFAULT_IO[] = stdout;

using BenchmarkTools
using DifferentialEquations
#using DiffEqBase
using JumpProcesses
using JSON
using LSODA
using ModelingToolkit
using OrdinaryDiffEq
using Plots; mm = Plots.mm;
using ReactionNetworkImporters
using Sundials

# Fetch preconditioner functions.
include("preconditioners.jl")

# Sets plotting defaults
default(framestyle=:box,grid=false,lw=4,la=0.8,guidefontsize=11,legend=:topleft)

# Lists all possible methods (and jacobian combiantion options).
methods_julia_implicit_list = [TRBDF2, KenCarp4, QNDF, FBDF, Rodas4, Rodas5P, Rosenbrock23]
methods_julia_explicit_list = [Tsit5, BS5, VCABM, Vern6, Vern7, Vern8, Vern9, ROCK4]

methods_lsoda_n_CVODE = [(:normal,"Lsoda",lsoda()), (:normal,"CVODE_BDF",CVODE_BDF()), (:normal,"CVODE_BDF (LapackDense)",CVODE_BDF(linear_solver=:LapackDense)), (:normal,"CVODE_BDF (GMRES)",CVODE_BDF(linear_solver=:GMRES)), (:sparsejac,"CVODE_BDF (KLU)",CVODE_BDF(linear_solver=:KLU))]
methods_julia_implicit = map(method -> (:normal,String(Symbol(method)),method()), methods_julia_implicit_list)
methods_julia_implicit_GMRES = map(method -> (:normal,String(Symbol(method)),method(linsolve=KrylovJL_GMRES(),autodiff=false)), methods_julia_implicit_list)
methods_julia_implicit_KLU = map(method -> (:sparsejac,String(Symbol(method)),method(linsolve=KLUFactorization(), autodiff=false)), methods_julia_implicit_list)
methods_julia_explicit = map(method -> (:normal,String(Symbol(method)),method()), methods_julia_explicit_list)
methods_ssa = [("Direct", Direct()), ("SortingDirect", SortingDirect()), ("RSSA", RSSA()), ("RSSACR", RSSACR())];

# Checks the output plots of a set of ode simulations.
function check_plot_ode_sims_lsoda_CVODE(oprobs, methods, modelvars, figurename; foldername="../Plots/Trajectories/Catalyst/", print = false)
    print && (ode_sols = map(method -> (println(method[2],":"); @time solve(oprobs[method[1]],method[3];saveat=oprobs[method[1]].tspan[2]/200.0,abstol=1e-9,reltol=1e-6)), methods))
    !print && (ode_sols = map(method -> solve(oprobs[method[1]],method[3];saveat=oprobs[method[1]].tspan[2]/200.0,abstol=1e-9,reltol=1e-6), methods))
    ode_plot_1 = plot(ode_sols[1],vars=modelvars,xguide="Time (Seconds)",yguide="Concentration (au)",title=methods[1][2],left_margin=25mm)
    ode_plots = map((sol,name) -> plot(sol,vars=modelvars,xguide="Time (Seconds)",yguide="",yticks=[],title=name,left_margin=3mm), ode_sols[2:end], getindex.(methods,2)[2:end]);
    ode_plot = plot([ode_plot_1;ode_plots]...,layout=(1,length(methods)),size=(length(methods)*450,325),bottom_margin=20mm,top_margin=5mm)
    save_plot(ode_plot, foldername, figurename)
end
function check_plot_ode_sims(oprobs, methods, modelvars, figurename; foldername="../Plots/Trajectories/Catalyst/", print = false)
    print && (ode_sols = map(method -> (println(method[2],":"); @time solve(oprobs[method[1]],method[3];saveat=oprobs[method[1]].tspan[2]/200.0,abstol=1e-9,reltol=1e-6,maxiters=1e12,dtmin=1e-18)), methods))
    !print && (ode_sols = map(method -> solve(oprobs[method[1]],method[3];saveat=oprobs[method[1]].tspan[2]/200.0,abstol=1e-9,reltol=1e-6,maxiters=1e12,dtmin=1e-18), methods))
    ode_plot_1 = plot(ode_sols[1],vars=modelvars,xguide="Time (Seconds)",yguide="Concentration (au)",title=methods[1][2],left_margin=25mm)
    ode_plots = map((sol,name) -> plot(sol,vars=modelvars,xguide="Time (Seconds)",yguide="",yticks=[],title=name,left_margin=3mm), ode_sols[2:end], getindex.(methods,2)[2:end]);
    ode_plot = plot([ode_plot_1;ode_plots]...,layout=(1,length(methods)),size=(length(methods)*450,325),bottom_margin=20mm,top_margin=5mm)
    save_plot(ode_plot, foldername, figurename)
end
# Checks that a set of ode solvers simulate without error.
function check_ode_sims(oprobs, methods)
    foreach(method -> (println(method[2],":"); @time solve(oprobs[method[1]], method[3]);), methods)
end;

# Checks a set of ssa solvers on a model.
function check_plot_ssa_sims(dprob, methods, rn, modelvars, figurename; foldername="../Plots/Trajectories/Catalyst/", print = false)
    j_probs = map(method -> JumpProblem(rn,dprob,method[2],save_positions=(false,false)), methods)
    print && (ssa_sols = map((j_prob,name) -> (println(name,":"); @time solve(j_prob,SSAStepper();saveat=dprob.tspan[2]/200.0);), j_probs, getindex.(methods,1)))
    !print && (ssa_sols = map((j_prob,name) -> solve(j_prob,SSAStepper();saveat=dprob.tspan[2]/200.0), j_probs, getindex.(methods,1)))
    ssa_plot_1 = plot(ssa_sols[1],vars=modelvars,xguide="Time (Seconds)",yguide="Concentration (au)",title=methods[1][1],left_margin=25mm)
    ssa_plots = map((sol,name) -> plot(sol,vars=modelvars,xguide="Time (Seconds)",yguide="",title=name,left_margin=3mm), ssa_sols[2:end], getindex.(methods[2:end],1))
    ssa_plot = plot([ssa_plot_1;ssa_plots]...,layout=(1,length(methods)),size=(length(methods)*450,325),bottom_margin=20mm,top_margin=5mm)
    save_plot(ssa_plot, foldername, figurename)
end
# Checks that a set of ssa solvers simualte without error.
function check_ssa_sims(dprob,methods,rn)
    j_probs = map(method -> JumpProblem(rn,dprob,method[2],save_positions=(false,false)), methods);
    foreach((j_prob,name) -> (println(name,":"); @time solve(j_prob,SSAStepper());), j_probs, getindex.(methods,1));
end;

# Saves a plot in various formats.
function save_plot(plt, foldername, figurename)
    savefig(plt, foldername*figurename*".png")
    savefig(plt, foldername*figurename*".pdf")
    savefig(plt, foldername*figurename*".svg")
    return plt
end

# Set time until steady state.
multistate_ss_time = 20

# Load model.
multistate_model = loadrxnetwork(BNGNetwork(), "../Data/multistate.net"); 
multistate_ode = convert(ODESystem,multistate_model.rn);
multistate_model_no_obs = loadrxnetwork(BNGNetwork(), "../Data/multistate_no_obs.net"); 
multistate_ode_no_obs = convert(ODESystem,multistate_model_no_obs.rn);
@unpack A_P, A_unbound_P, A_bound_P, RLA_P = multistate_model.rn; multistate_obs = [A_P, A_unbound_P, A_bound_P, RLA_P]

# ODEProblems
multistate_odeprobs = Dict{Symbol,Any}()
multistate_odeprobs[:normal] = ODEProblem(multistate_ode, Float64[], (0.,multistate_ss_time), Float64[])
multistate_odeprobs[:sparsejac] = ODEProblem(multistate_ode, Float64[], (0.,multistate_ss_time), Float64[]; jac=true, sparse=true)

multistate_odeprobs_no_obs = Dict{Symbol,Any}()
multistate_odeprobs_no_obs[:normal] = ODEProblem(multistate_ode_no_obs, Float64[], (0.,multistate_ss_time), Float64[])
multistate_odeprobs_no_obs[:sparsejac] = ODEProblem(multistate_ode_no_obs, Float64[], (0.,multistate_ss_time), Float64[]; jac=true, sparse=true)

# DiscreteProblems
multistate_dprob = DiscreteProblem(multistate_model.rn, multistate_model.u₀, (0.,multistate_ss_time), multistate_model.p); multistate_dprob = remake(multistate_dprob; u0=Int64.(multistate_dprob.u0));
multistate_dprob_no_obs = DiscreteProblem(multistate_model_no_obs.rn, multistate_model_no_obs.u₀, (0.,multistate_ss_time), multistate_model_no_obs.p); multistate_dprob_no_obs = remake(multistate_dprob_no_obs; u0=Int64.(multistate_dprob_no_obs.u0));

# Checks Lsoda and CVODE simulation trajectories.
check_plot_ode_sims_lsoda_CVODE(multistate_odeprobs, methods_lsoda_n_CVODE, multistate_obs, "Multistate/lsoda_n_cvode")

# Checks implicit Julia solvers (no linear solver) simulation trajectories.
check_plot_ode_sims(multistate_odeprobs, methods_julia_implicit, multistate_obs, "Multistate/implicit_julia")

# Checks implicit Julia solvers (GMRES linear solver) simulation trajectories.
check_plot_ode_sims(multistate_odeprobs, methods_julia_implicit_GMRES, multistate_obs, "Multistate/implicit_julia_GMRES")

# Checks implicit Julia solvers (KLU linear solver) simulation trajectories.
check_plot_ode_sims(multistate_odeprobs, methods_julia_implicit_KLU, multistate_obs, "Multistate/implicit_julia_KLU")

# Checks explicit Julia solvers simulation trajectories.
check_plot_ode_sims(multistate_odeprobs, methods_julia_explicit, multistate_obs, "Multistate/explicit_julia")

# Checks SSA solvers simulation trajectories.
check_plot_ssa_sims(multistate_dprob, methods_ssa, multistate_model.rn, multistate_obs, "Multistate/ssa")


# Set time until steady state.
multisite2_ss_time = 2

# Load model.
multisite2_model = loadrxnetwork(BNGNetwork(), "../Data/multisite2.net"); 
multisite2_ode = convert(ODESystem,multisite2_model.rn);
multisite2_model_no_obs = loadrxnetwork(BNGNetwork(), "../Data/multisite2_no_obs.net"); 
multisite2_ode_no_obs = convert(ODESystem,multisite2_model_no_obs.rn);
@unpack Rfree,Lfree,A1P = multisite2_model.rn; multisite2_obs = [Rfree,Lfree,A1P]

# ODEProblems
multisite2_odeprobs = Dict{Symbol,Any}()
multisite2_odeprobs[:normal] = ODEProblem(multisite2_ode, Float64[], (0.,multisite2_ss_time), Float64[])
multisite2_odeprobs[:sparsejac] = ODEProblem(multisite2_ode, Float64[], (0.,multisite2_ss_time), Float64[]; jac=true, sparse=true)

multisite2_odeprobs_no_obs = Dict{Symbol,Any}()
multisite2_odeprobs_no_obs[:normal] = ODEProblem(multisite2_ode_no_obs, Float64[], (0.,multisite2_ss_time), Float64[])
multisite2_odeprobs_no_obs[:sparsejac] = ODEProblem(multisite2_ode_no_obs, Float64[], (0.,multisite2_ss_time), Float64[]; jac=true, sparse=true)

# DiscreteProblems
multisite2_dprob = DiscreteProblem(multisite2_model.rn, multisite2_model.u₀, (0.,multisite2_ss_time), multisite2_model.p); multisite2_dprob = remake(multisite2_dprob; u0=Int64.(multisite2_dprob.u0));
multisite2_dprob_no_obs = DiscreteProblem(multisite2_model_no_obs.rn, multisite2_model_no_obs.u₀, (0.,multisite2_ss_time), multisite2_model_no_obs.p); multisite2_dprob_no_obs = remake(multisite2_dprob_no_obs; u0=Int64.(multisite2_dprob_no_obs.u0));

# Checks Lsoda and CVODE simulation trajectories.
check_plot_ode_sims_lsoda_CVODE(multisite2_odeprobs, methods_lsoda_n_CVODE, multisite2_obs, "Multisite2/lsoda_n_cvode")

# Checks implicit Julia solvers (no linear solver) simulation trajectories.
check_plot_ode_sims(multisite2_odeprobs, methods_julia_implicit, multisite2_obs, "Multisite2/implicit_julia")

# Checks implicit Julia solvers (GMRES linear solver) simulation trajectories.
check_plot_ode_sims(multisite2_odeprobs, methods_julia_implicit_GMRES, multisite2_obs, "Multisite2/implicit_julia_GMRES")

# Checks implicit Julia solvers (KLU linear solver) simulation trajectories.
check_plot_ode_sims(multisite2_odeprobs, methods_julia_implicit_KLU, multisite2_obs, "Multisite2/implicit_julia_KLU")

# Checks explicit Julia solvers simulation trajectories.
check_plot_ode_sims(multisite2_odeprobs, methods_julia_explicit, multisite2_obs, "Multisite2/explicit_julia")

# Checks SSA solvers simulation trajectories.
check_plot_ssa_sims(multisite2_dprob, methods_ssa, multisite2_model.rn, multisite2_obs, "Multisite2/ssa")

# Set time until steady state.
egfr_net_ss_time = 10

# Load model.
egfr_net_model = loadrxnetwork(BNGNetwork(), "../Data/egfr_net.net"); 
egfr_net_ode = convert(ODESystem,egfr_net_model.rn);
egfr_net_model_no_obs = loadrxnetwork(BNGNetwork(), "../Data/egfr_net_no_obs.net"); 
egfr_net_ode_no_obs = convert(ODESystem,egfr_net_model_no_obs.rn);
@unpack Dimers,Sos_act,Y1068,Y1148,Shc_Grb,Shc_Grb_Sos,R_Grb2,R_Shc,R_ShcP,ShcP,R_G_S,R_S_G_S,Efgr_tot = egfr_net_model.rn; egfr_net_obs = [Dimers,Sos_act,Y1068,Y1148,Shc_Grb,Shc_Grb_Sos,R_Grb2,R_Shc,R_ShcP,ShcP,R_G_S,R_S_G_S,Efgr_tot]

# ODEProblems
egfr_net_odeprobs = Dict{Symbol,Any}()
egfr_net_odeprobs[:normal] = ODEProblem(egfr_net_ode, Float64[], (0.,egfr_net_ss_time), Float64[])
egfr_net_odeprobs[:sparsejac] = ODEProblem(egfr_net_ode, Float64[], (0.,egfr_net_ss_time), Float64[]; jac=true, sparse=true)

egfr_net_odeprobs_no_obs = Dict{Symbol,Any}()
egfr_net_odeprobs_no_obs[:normal] = ODEProblem(egfr_net_ode_no_obs, Float64[], (0.,egfr_net_ss_time), Float64[])
egfr_net_odeprobs_no_obs[:sparsejac] = ODEProblem(egfr_net_ode_no_obs, Float64[], (0.,egfr_net_ss_time), Float64[]; jac=true, sparse=true)

# DiscreteProblems
egfr_net_dprob = DiscreteProblem(egfr_net_model.rn, egfr_net_model.u₀, (0.,egfr_net_ss_time), egfr_net_model.p); egfr_net_dprob = remake(egfr_net_dprob; u0=Int64.(egfr_net_dprob.u0));
egfr_net_dprob_no_obs = DiscreteProblem(egfr_net_model_no_obs.rn, egfr_net_model_no_obs.u₀, (0.,egfr_net_ss_time), egfr_net_model_no_obs.p); egfr_net_dprob_no_obs = remake(egfr_net_dprob_no_obs; u0=Int64.(egfr_net_dprob_no_obs.u0));

# Checks Lsoda and CVODE simulation trajectories.
check_plot_ode_sims_lsoda_CVODE(egfr_net_odeprobs, methods_lsoda_n_CVODE, egfr_net_obs, "Egfr_net/lsoda_n_cvode")

# Checks implicit Julia solvers (no linear solver) simulation trajectories.
check_plot_ode_sims(egfr_net_odeprobs, methods_julia_implicit, egfr_net_obs, "Egfr_net/implicit_julia")

# Checks implicit Julia solvers (GMRES linear solver) simulation trajectories.
check_plot_ode_sims(egfr_net_odeprobs, methods_julia_implicit_GMRES, egfr_net_obs, "Egfr_net/implicit_julia_GMRES")

# Checks implicit Julia solvers (KLU linear solver) simulation trajectories.
check_plot_ode_sims(egfr_net_odeprobs, methods_julia_implicit_KLU, egfr_net_obs, "Egfr_net/implicit_julia_KLU")

# Checks explicit Julia solvers simulation trajectories.
check_plot_ode_sims(egfr_net_odeprobs, methods_julia_explicit, egfr_net_obs, "Egfr_net/explicit_julia")

# Checks SSA solvers simulation trajectories.
check_plot_ssa_sims(egfr_net_dprob, methods_ssa, egfr_net_model.rn, egfr_net_obs, "Egfr_net/ssa")

# Set time until steady state.
BCR_ss_time = 20000
BCR_ssa_time = 2000

# Load model.
BCR_model = loadrxnetwork(BNGNetwork(), "../Data/BCR.net"); 
BCR_ode = convert(ODESystem,BCR_model.rn);
BCR_model_no_obs = loadrxnetwork(BNGNetwork(), "../Data/BCR_no_obs.net"); 
BCR_ode_no_obs = convert(ODESystem,BCR_model_no_obs.rn);
@unpack Activated_Syk,Ig_alpha_P,Ig_alpha_PP,Ig_beta_PP,Activated_Lyn,Autoinhibited_Lyn,Activated_Fyn,Autoinhibited_Fyn,PAG1_Csk = BCR_model.rn; BCR_obs = [Activated_Syk,Ig_alpha_P,Ig_alpha_PP,Ig_beta_PP,Activated_Lyn,Autoinhibited_Lyn,Activated_Fyn,Autoinhibited_Fyn,PAG1_Csk]

# ODEProblems
BCR_odeprobs = Dict{Symbol,Any}()
BCR_odeprobs[:normal] = ODEProblem(BCR_ode, Float64[], (0.,BCR_ss_time), Float64[])
BCR_odeprobs[:sparse] = ODEProblem(BCR_ode, Float64[], (0.,BCR_ss_time), Float64[]; sparse=true)
BCR_odeprobs[:sparsejac] = ODEProblem(BCR_ode, Float64[], (0.,BCR_ss_time), Float64[]; jac=true, sparse=true)

BCR_odeprobs_no_obs = Dict{Symbol,Any}()
BCR_odeprobs_no_obs[:normal] = ODEProblem(BCR_ode_no_obs, Float64[], (0.,BCR_ss_time), Float64[])
BCR_odeprobs_no_obs[:sparsejac] = ODEProblem(BCR_ode_no_obs, Float64[], (0.,BCR_ss_time), Float64[]; jac=true, sparse=true)

# DiscreteProblems
BCR_dprob = DiscreteProblem(BCR_model.rn, BCR_model.u₀, (0.,BCR_ssa_time), BCR_model.p); BCR_dprob = remake(BCR_dprob; u0=Int64.(BCR_dprob.u0));
BCR_dprob_no_obs = DiscreteProblem(BCR_model_no_obs.rn, BCR_model_no_obs.u₀, (0.,BCR_ssa_time), BCR_model_no_obs.p); BCR_dprob_no_obs = remake(BCR_dprob_no_obs; u0=Int64.(BCR_dprob_no_obs.u0));

# Checks Lsoda and CVODE simulation trajectories.
precilu_BCR,psetupilu_BCR = get_cvode_pcs(1e2, BCR_model)
methods_lsoda_n_CVODE_iLU_BCR = [(:normal,"Lsoda",lsoda()), (:normal,"CVODE_BDF",CVODE_BDF()), (:normal,"CVODE_BDF (LapackDense)",CVODE_BDF(linear_solver=:LapackDense)), (:normal,"CVODE_BDF (GMRES)",CVODE_BDF(linear_solver=:GMRES)), (:sparse,"CVODE_BDF (GMRES, iLU)",CVODE_BDF(linear_solver=:GMRES,prec=precilu_BCR,psetup=psetupilu_BCR,prec_side=1)), (:sparsejac,"CVODE_BDF (KLU)",CVODE_BDF(linear_solver=:KLU))]
check_plot_ode_sims_lsoda_CVODE(BCR_odeprobs, methods_lsoda_n_CVODE_iLU_BCR, BCR_obs, "BCR/lsoda_n_cvode")

# Checks implicit Julia solvers (no linear solver) simulation trajectories.
check_plot_ode_sims(BCR_odeprobs, methods_julia_implicit, BCR_obs, "BCR/implicit_julia")

# Checks implicit Julia solvers (GMRES linear solver) simulation trajectories.
check_plot_ode_sims(BCR_odeprobs, methods_julia_implicit_GMRES, BCR_obs, "BCR/implicit_julia_GMRES")

# Checks implicit Julia solvers (GMRES linear solver, iLU preconditoner) simulation trajectories.
incompletelu_BCR = get_julia_pcs(1e2)
methods_julia_implicit_GMRES_iLU_BCR = map(method -> (:sparse,String(Symbol(method)),method(linsolve=KrylovJL_GMRES(),autodiff=false,precs=incompletelu_BCR,concrete_jac=true)), methods_julia_implicit_list)
check_plot_ode_sims(BCR_odeprobs, methods_julia_implicit_GMRES_iLU_BCR, BCR_obs, "BCR/implicit_julia_GMRES_iLU")

check_plot_ode_sims(BCR_odeprobs, methods_julia_implicit_GMRES, BCR_obs, "BCR/implicit_julia_GMRES")

# Checks implicit Julia solvers (KLU linear solver) simulation trajectories.
check_plot_ode_sims(BCR_odeprobs, methods_julia_implicit_KLU, BCR_obs, "BCR/implicit_julia_KLU")

# Checks SSA solvers simulation trajectories.
check_plot_ssa_sims(BCR_dprob, methods_ssa[2:4], BCR_model.rn, BCR_obs, "BCR/ssa")


# Set time until steady state.
fceri_gamma2_ss_time = 150

# Load model.
fceri_gamma2_model = loadrxnetwork(BNGNetwork(), "../Data/fceri_gamma2.net"); 
fceri_gamma2_ode = convert(ODESystem,fceri_gamma2_model.rn);
fceri_gamma2_model_no_obs = loadrxnetwork(BNGNetwork(), "../Data/fceri_gamma2_no_obs.net"); 
fceri_gamma2_ode_no_obs = convert(ODESystem,fceri_gamma2_model_no_obs.rn);
@unpack LynFree,RecMon,RecPbeta,RecPgamma,RecSyk,RecSykPS = fceri_gamma2_model.rn; fceri_gamma2_obs = [LynFree,RecMon,RecPbeta,RecPgamma,RecSyk,RecSykPS]

# ODEProblems
fceri_gamma2_odeprobs = Dict{Symbol,Any}()
fceri_gamma2_odeprobs[:normal] = ODEProblem(fceri_gamma2_ode, Float64[], (0.,fceri_gamma2_ss_time), Float64[])
fceri_gamma2_odeprobs[:sparse] = ODEProblem(fceri_gamma2_ode, Float64[], (0.,fceri_gamma2_ss_time), Float64[]; sparse=true)
fceri_gamma2_odeprobs[:sparsejac] = ODEProblem(fceri_gamma2_ode, Float64[], (0.,fceri_gamma2_ss_time), Float64[]; jac=true, sparse=true)

fceri_gamma2_odeprobs_no_obs = Dict{Symbol,Any}()
fceri_gamma2_odeprobs_no_obs[:normal] = ODEProblem(fceri_gamma2_ode_no_obs, Float64[], (0.,fceri_gamma2_ss_time), Float64[])
fceri_gamma2_odeprobs_no_obs[:sparsejac] = ODEProblem(fceri_gamma2_ode_no_obs, Float64[], (0.,fceri_gamma2_ss_time), Float64[]; jac=true, sparse=true)

# DiscreteProblems
fceri_gamma2_dprob = DiscreteProblem(fceri_gamma2_model.rn, fceri_gamma2_model.u₀, (0.,fceri_gamma2_ss_time), fceri_gamma2_model.p); fceri_gamma2_dprob = remake(fceri_gamma2_dprob; u0=Int64.(fceri_gamma2_dprob.u0));
fceri_gamma2_dprob_no_obs = DiscreteProblem(fceri_gamma2_model_no_obs.rn, fceri_gamma2_model_no_obs.u₀, (0.,fceri_gamma2_ss_time), fceri_gamma2_model_no_obs.p); fceri_gamma2_dprob_no_obs = remake(fceri_gamma2_dprob_no_obs; u0=Int64.(fceri_gamma2_dprob_no_obs.u0));

# Checks Lsoda and CVODE simulation trajectories.
precilu_fceri_gamma2,psetupilu_fceri_gamma2 = get_cvode_pcs(5, fceri_gamma2_model)
methods_lsoda_n_CVODE_iLU_fceri_gamma2 = [(:normal,"Lsoda",lsoda()), (:normal,"CVODE_BDF",CVODE_BDF()), (:normal,"CVODE_BDF (LapackDense)",CVODE_BDF(linear_solver=:LapackDense)), (:normal,"CVODE_BDF (GMRES)",CVODE_BDF(linear_solver=:GMRES)), (:sparse,"CVODE_BDF (GMRES, iLU)",CVODE_BDF(linear_solver=:GMRES,prec=precilu_fceri_gamma2,psetup=psetupilu_fceri_gamma2,prec_side=1)), (:sparsejac,"CVODE_BDF (KLU)",CVODE_BDF(linear_solver=:KLU))]
check_plot_ode_sims_lsoda_CVODE(fceri_gamma2_odeprobs, methods_lsoda_n_CVODE_iLU_fceri_gamma2, fceri_gamma2_obs, "Fceri_gamma2/lsoda_n_cvode_iLU")

# Checks implicit Julia solvers (no linear solver) simulation trajectories.
check_plot_ode_sims(fceri_gamma2_odeprobs, methods_julia_implicit, fceri_gamma2_obs, "Fceri_gamma2/implicit_julia")

# Checks implicit Julia solvers (GMRES linear solver) simulation trajectories.
check_plot_ode_sims(fceri_gamma2_odeprobs, methods_julia_implicit_GMRES, fceri_gamma2_obs, "Fceri_gamma2/implicit_julia_GMRES")

# Checks implicit Julia solvers (GMRES linear solver, iLU preconditoner) simulation trajectories.
incompletelu_fceri_gamma2 = get_julia_pcs(1e12)
methods_julia_implicit_GMRES_iLU_fceri_gamma2 = map(method -> (:sparse,String(Symbol(method)),method(linsolve=KrylovJL_GMRES(),autodiff=false,precs=incompletelu_fceri_gamma2,concrete_jac=true)), methods_julia_implicit_list)
check_plot_ode_sims(fceri_gamma2_odeprobs, methods_julia_implicit_GMRES_iLU_fceri_gamma2, fceri_gamma2_obs, "Fceri_gamma2/implicit_julia_GMRES_iLU")

# Checks implicit Julia solvers (KLU linear solver) simulation trajectories.
check_plot_ode_sims(fceri_gamma2_odeprobs, methods_julia_implicit_KLU, fceri_gamma2_obs, "Fceri_gamma2/implicit_julia_KLU")

# Checks explicit Julia solvers simulation trajectories.
check_plot_ode_sims(fceri_gamma2_odeprobs, methods_julia_explicit, fceri_gamma2_obs, "Fceri_gamma2/explicit_julia")

# Checks SSA solvers simulation trajectories.
check_plot_ssa_sims(fceri_gamma2_dprob, methods_ssa, fceri_gamma2_model.rn, fceri_gamma2_obs, "Fceri_gamma2/ssa")