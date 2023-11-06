### Import Packages ###
using JSON
using Plots
using Statistics

### ---------- ---------- Preparations ---------- ---------- ###

### NOTE: The benchmark files are currently from HPC runs. Please rerun all benchmarks on the same machine before loading. ###

rr_ode_multistate = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_ss_sim_ODE_multistate.json")["medians"][1]
rr_ode_multisite2 = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_ss_sim_ODE_multisite2.json")["medians"][1]
rr_ode_egfr_net = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_ss_sim_ODE_egfr_net.json")["medians"][1]
rr_ode_BCR = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_ss_sim_ODE_BCR.json")["medians"][1] # Abnormally slow, skipped.

catalyst_ode_multistate = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_ss_sim_Vern6_NoLinSolver_multistate.json")["medians"][1]
catalyst_ode_multisite2 = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_ss_sim_BS5_NoLinSolver_multisite2.json")["medians"][1]
catalyst_ode_egfr_net = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_ss_sim_VCABM_NoLinSolver_egfr_net.json")["medians"][1]
catalyst_ode_BCR = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_CVODE_BDF_sparse_pc_GMRES_BCR.json")["medians"][1]

rr_ssa_multistate = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_SSA_multistate.json")["medians"]
rr_ssa_multistate_lengs = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_SSA_multistate.json")["lengs"]
rr_ssa_multisite2 = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_SSA_multisite2.json")["medians"]
rr_ssa_multisite2_lengs = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_SSA_multisite2.json")["lengs"]
rr_ssa_egfr_net = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_SSA_egfr_net.json")["medians"]
rr_ssa_egfr_net_lengs = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_SSA_egfr_net.json")["lengs"]
# rr_ssa_BCR = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_SSA_BCR.json")["medians"]
# rr_ssa_BCR_lengs = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_SSA_BCR.json")["lengs"]

catalyst_ssa_multistate_direct = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_Direct_multistate.json")["medians"]
catalyst_ssa_multistate = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_RSSA_multistate.json")["medians"]
catalyst_ssa_multistate_lengs = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_RSSA_multistate.json")["lengs"]
catalyst_ssa_multisite2_direct = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_Direct_multisite2.json")["medians"]
catalyst_ssa_multisite2 = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_RSSA_multisite2.json")["medians"]
catalyst_ssa_multisite2_lengs = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_RSSA_multisite2.json")["lengs"]
catalyst_ssa_egfr_net_direct = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_Direct_egfr_net.json")["medians"]
catalyst_ssa_egfr_net_direct_lengs = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_Direct_egfr_net.json")["lengs"]
catalyst_ssa_egfr_net = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_RSSACR_egfr_net.json")["medians"]
catalyst_ssa_egfr_net_lengs = JSON.parsefile("../Benchmarking_results/Threads_1/catalyst_RSSACR_egfr_net.json")["lengs"]
# catalyst_ssa_BCR = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_RSSACR_BCR.json")["medians"]
# catalyst_ssa_BCR_lengs = JSON.parsefile("../Benchmarking_results/Threads_1/roadrunner_RSSACR_BCR.json")["lengs"]


### ---------- ---------- Make Figures ---------- ---------- ###
default(framestyle=:box, legendfontsize=12, guidefontsize=12,titlefontsize=12,gridalpha=0.2, gridlinewidth=2, legend=:topleft)

# SSA comparison plot.
plot(catalyst_ssa_multistate_lengs, catalyst_ssa_multistate; xaxis=:log10, yaxis=:log10, lw=4, label="Catalyst (RSSA, via JumpProcesses)")
plot!(rr_ssa_multistate_lengs, rr_ssa_multistate, ; xaxis=:log10, yaxis=:log10, lw=4, label="RoadRunner (Direct)", title="Multistate SSA benchmarks")
multistate_ssa_plot = plot!(catalyst_ssa_multistate_lengs, catalyst_ssa_multistate_direct; xaxis=:log10, yaxis=:log10, lw=4, label="Catalyst (Direct, via JumpProcesses)", xguide="Model (physical) final time (s)", yguide="Simulation runtime (ms)")

plot(catalyst_ssa_multisite2_lengs, catalyst_ssa_multisite2; xaxis=:log10, yaxis=:log10, lw=4, label="Catalyst (Direct, via JumpProcesses)")
plot!(rr_ssa_multisite2_lengs, rr_ssa_multisite2, ; xaxis=:log10, yaxis=:log10, lw=4, label="RoadRunner (Direct)", xguide="Model (physical) final time (s)", title="Multisite2 SSA benchmarks", yguide="Simulation runtime (ms)")
multisite2_ssa_plot = plot!(catalyst_ssa_multisite2_lengs, catalyst_ssa_multisite2_direct; xaxis=:log10, yaxis=:log10, lw=4, label="Catalyst (Direct, via JumpProcesses)", xguide="Model (physical) final time (s)", yguide="Simulation runtime (ms)")

plot(catalyst_ssa_egfr_net_lengs, catalyst_ssa_egfr_net; xaxis=:log10, yaxis=:log10, lw=4, label="JumpProcesses (RSSA)")
plot!(rr_ssa_egfr_net_lengs, rr_ssa_egfr_net, ; xaxis=:log10, yaxis=:log10, lw=4, label="RoadRunner (Direct)", xguide="Model (physical) final time (s)", title="Egfr_net SSA benchmarks", yguide="Simulation runtime (ms)")
egfr_net_ssa_plot = plot!(catalyst_ssa_egfr_net_direct_lengs, catalyst_ssa_egfr_net_direct; xaxis=:log10, yaxis=:log10, lw=4, legend=:bottomright, label="Catalyst (Direct, via JumpProcesses)", xguide="Model (physical) final time (s)", yguide="Simulation runtime (ms)")

plot_ssa = plot(multistate_ssa_plot, multisite2_ssa_plot, egfr_net_ssa_plot, layout=(1,3), size=(1500,450),left_margin=10Plots.Measures.mm,bottom_margin=10Plots.Measures.mm,top_margin=6Plots.Measures.mm)
savefig(plot_ssa, "Benchmark_results/roadrunner_comparison_ssa.png")

# ODE comparison plot.
plot([1], [catalyst_ode_multistate]; color = 1, label = "Catalyst (via OrdinaryDiffEq)", seriestype=:bar, fillrange=0.09, yaxis=:log10)
multistate_ode_plot = plot!([2], [rr_ode_multistate]; color = 2, label = "RoadRunner", fillrange=0.09, seriestype=:bar, yaxis=:log10, xtick=[], title="Multistate ODE benchmarks", yguide="Simulation runtime (ms)", ylimit=(0.09, 1.01))

plot([1], [catalyst_ode_multisite2]; color = 1, label = "Catalyst (via OrdinaryDiffEq)", seriestype=:bar, fillrange=0.09, yaxis=:log10, ylimit=(0.09, 10.01))
multisite2_ode_plot = plot!([2], [rr_ode_multisite2]; color = 2, label = "RoadRunner", fillrange=0.09, seriestype=:bar, yaxis=:log10, xtick=[], title="Multisite2 ODE benchmarks", yguide="Simulation runtime (ms)", ylimit=(0.09, 10.01))

plot([1], [catalyst_ode_egfr_net]; color = 1, label = "Catalyst (via OrdinaryDiffEq)", seriestype=:bar, yaxis=:log10, fillrange=9.0, ylimit=(9.0, 1001.0))
egfr_net_ode_plot = plot!([2], [rr_ode_egfr_net]; color = 2, label = "RoadRunner", seriestype=:bar, yaxis=:log10, fillrange=9.0, xtick=[], title="Egfr_net ODE benchmarks", yguide="Simulation runtime (ms)", ylimit=(9.0, 1001.0))

plot_ode = plot(multistate_ode_plot, multisite2_ode_plot, egfr_net_ode_plot, layout=(1,3), size=(1500,450),left_margin=10Plots.Measures.mm,top_margin=6Plots.Measures.mm)
savefig(plot_ode, "Benchmark_results/roadrunner_comparison_ode.png")
