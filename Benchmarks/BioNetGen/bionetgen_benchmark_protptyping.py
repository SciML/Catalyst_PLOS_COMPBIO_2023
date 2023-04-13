# Fetch packages.
import bionetgen
import json
import matplotlib.pyplot as plt
import statistics
import timeit
import numpy

# Benchmarking functions.
def make_benchmark(model,n):
    def benchmark_func():
        bionetgen.run(model, suppress=True)
    return timeit.Timer(benchmark_func).repeat(repeat=n, number=1)

# Serialises a benchmarking output using JSON.
def serialize(benchmarks,lengs,filename):
    with open('../Benchmarking_results/Prototyping/%s.json'%(filename) , "w") as write:
        json.dump({"benchmarks": benchmarks, "medians": list(1000*numpy.array(list(map(statistics.median, benchmarks)))), "lengs": lengs.tolist()} , write)

# Function for plotting simulation output.
def plot_result(result):
    r = result[0]

    for name in r.dtype.names:
        if name != "time":
            plt.plot(r['time'], r[name], label = name)
    plt.xlabel("time")
    plt.ylabel("species (counts)")
    _ = plt.legend(frameon = False)
    return plt

# Function for plotting benchmarking output.
def plot_benchmark(benchmarks,lengs):
    medians = list(1000*numpy.array(list(map(statistics.median, benchmarks))))
    plt.plot(lengs,medians,linewidth=4)
    plt.xscale("log")
    plt.yscale("log")
    plt.xlim([lengs[0],lengs[-1]])
    plt.ylim([0.001,1.2*numpy.max(medians)])    # Choice of ymin does skew how plot appears.

# Load model.
# multistate_ss_time = 20
# model_multistate = bionetgen.bngmodel('../Data/multistate.bngl')
# model_multistate_no_obs = bionetgen.bngmodel('../Data/multistate_no_obs.bngl')
# 
# # Check ODE simulation output.
# model_multistate.actions[0].args['atol'] = 1e-12
# model_multistate.actions[0].args['rtol'] = 1e-6
# model_multistate.actions[0].args['t_end'] = multistate_ss_time   
# model_multistate.actions[0].args['n_steps'] = 50
# result_multistate_ODE = bionetgen.run(model_multistate, suppress=True);
# fig1 = plot_result(result_multistate_ODE)
# plt.savefig('../Plots/Trajectories/BioNetGen/multistate_ode.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/multistate_ode.pdf')
# plt.close()
# 
# # Check ODE simulation time.
# model_multistate_no_obs.actions[0].args['atol'] = 1e-12
# model_multistate_no_obs.actions[0].args['rtol'] = 1e-6
# model_multistate_no_obs.actions[0].args['t_end'] = multistate_ss_time   
# model_multistate_no_obs.actions[0].args['n_steps'] = 50
# bionetgen.run(model_multistate_no_obs, suppress=True);
# 
# # Check (sparse) ODE simulation output.
# model_multistate.actions[0].args['sparse'] = 1
# result_multistate_ODE_sparse = bionetgen.run(model_multistate, suppress=True);
# plot_result(result_multistate_ODE_sparse)
# plt.savefig('../Plots/Trajectories/BioNetGen/multistate_ode_sparse.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/multistate_ode_sparse.pdf')
# plt.close()
# 
# # Check (sparse) ODE simulation time.
# model_multistate_no_obs.actions[0].args['sparse'] = 1
# bionetgen.run(model_multistate_no_obs, suppress=True);
# 
# # Prepare model for Gillespie simulations.
# model_multistate.actions[0].args['t_end'] = multistate_ss_time 
# model_multistate.actions[0].args['n_steps'] = 50
# model_multistate.actions[0].args['method'] = '"ssa"'    
# model_multistate_no_obs.actions[0].args['t_end'] = multistate_ss_time 
# model_multistate_no_obs.actions[0].args['n_steps'] = 50
# model_multistate_no_obs.actions[0].args['method'] = '"ssa"'    
# 
# # Check Gillespie simulation output.
# result_multistate_Gillespie = bionetgen.run(model_multistate, suppress=True);
# plot_result(result_multistate_Gillespie)
# plt.savefig('../Plots/Trajectories/BioNetGen/multistate_ssa.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/multistate_ssa.pdf')
# plt.close()
# 
# # Check Gillespie simulation time.
# bionetgen.run(model_multistate_no_obs, suppress=True);
# 
# # Load model.
# multisite2_ss_time = 2
# model_multisite2 = bionetgen.bngmodel('../Data/multisite2.bngl')
# model_multisite2_no_obs = bionetgen.bngmodel('../Data/multisite2_no_obs.bngl')
# 
# # Check ODE simulation output.
# model_multisite2.actions[0].args['atol'] = 1e-12
# model_multisite2.actions[0].args['rtol'] = 1e-6
# model_multisite2.actions[0].args['t_end'] = multisite2_ss_time 
# model_multisite2.actions[0].args['n_steps'] = 50
# result_multisite2_ODE = bionetgen.run(model_multisite2, suppress=True);
# plot_result(result_multisite2_ODE)
# plt.savefig('../Plots/Trajectories/BioNetGen/multisite2_ode.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/multisite2_ode.pdf')
# plt.close()
# 
# # Check ODE simulation time.
# model_multisite2_no_obs.actions[0].args['atol'] = 1e-12
# model_multisite2_no_obs.actions[0].args['rtol'] = 1e-6
# model_multisite2_no_obs.actions[0].args['t_end'] = multisite2_ss_time 
# model_multisite2_no_obs.actions[0].args['n_steps'] = 50
# bionetgen.run(model_multisite2_no_obs, suppress=True);
# 
# # Check (sparse) ODE simulation output.
# model_multisite2.actions[0].args['sparse'] = 1
# result_multisite2_ODE_sparse = bionetgen.run(model_multisite2, suppress=True);
# plot_result(result_multisite2_ODE_sparse)
# plt.savefig('../Plots/Trajectories/BioNetGen/multisite2_ode_sparse.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/multisite2_ode_sparse.pdf')
# plt.close()
# 
# # Check (sparse) ODE simulation time.
# model_multisite2_no_obs.actions[0].args['sparse'] = 1
# bionetgen.run(model_multisite2_no_obs, suppress=True);
# 
# # Prepare model for Gillespie simulations.
# model_multisite2.actions[0].args['t_end'] = multisite2_ss_time 
# model_multisite2.actions[0].args['n_steps'] = 50
# model_multisite2.actions[0].args['method'] = '"ssa"'    
# model_multisite2_no_obs.actions[0].args['t_end'] = multisite2_ss_time 
# model_multisite2_no_obs.actions[0].args['n_steps'] = 50
# model_multisite2_no_obs.actions[0].args['method'] = '"ssa"' 
# 
# # Check Gillespie simulation output.
# result_multisite2_Gillespie = bionetgen.run(model_multisite2, suppress=True);
# plot_result(result_multisite2_Gillespie)
# plt.savefig('../Plots/Trajectories/BioNetGen/multisite2_ssa.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/multisite2_ssa.pdf')
# plt.close()
# 
# # Check Gillespie simulation time.
# bionetgen.run(model_multisite2_no_obs, suppress=True);
# 
# # Load model.
# egfr_net_ss_time = 10
# model_egfr_net = bionetgen.bngmodel('../Data/egfr_net.bngl')
# model_egfr_net_no_obs = bionetgen.bngmodel('../Data/egfr_net_no_obs.bngl')
# 
# # Check ODE simulation output.
# model_egfr_net.actions[0].args['atol'] = 1e-12
# model_egfr_net.actions[0].args['rtol'] = 1e-6
# model_egfr_net.actions[0].args['t_end'] = egfr_net_ss_time   
# model_egfr_net.actions[0].args['n_steps'] = 50
# result_egfr_net_ODE = bionetgen.run(model_egfr_net, suppress=True);
# plot_result(result_egfr_net_ODE)
# plt.savefig('../Plots/Trajectories/BioNetGen/egfr_net_ode.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/egfr_net_ode.pdf')
# plt.close()
# 
# # Check ODE simulation time.
# model_egfr_net_no_obs.actions[0].args['atol'] = 1e-12
# model_egfr_net_no_obs.actions[0].args['rtol'] = 1e-6
# model_egfr_net_no_obs.actions[0].args['t_end'] = egfr_net_ss_time   
# model_egfr_net_no_obs.actions[0].args['n_steps'] = 50
# bionetgen.run(model_egfr_net_no_obs, suppress=True);
# 
# # Check (sparse) ODE simulation output.
# model_egfr_net.actions[0].args['sparse'] = 1
# result_egfr_net_ODE_sparse = bionetgen.run(model_egfr_net, suppress=True);
# plot_result(result_egfr_net_ODE_sparse)
# plt.savefig('../Plots/Trajectories/BioNetGen/egfr_net_ode_sparse.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/egfr_net_ode_sparse.pdf')
# plt.close()
# 
# # Check (sparse) ODE simulation time.
# model_egfr_net_no_obs.actions[0].args['sparse'] = 1
# bionetgen.run(model_egfr_net_no_obs, suppress=True);
# 
# # Prepare model for Gillespie simulations.
# model_egfr_net.actions[0].args['t_end'] = egfr_net_ss_time   
# model_egfr_net.actions[0].args['n_steps'] = 50
# model_egfr_net.actions[0].args['method'] = '"ssa"'   
# model_egfr_net_no_obs.actions[0].args['t_end'] = egfr_net_ss_time   
# model_egfr_net_no_obs.actions[0].args['n_steps'] = 50
# model_egfr_net_no_obs.actions[0].args['method'] = '"ssa"'    
# 
# # Check Gillespie simulation output.
# result_egfr_net_Gillespie = bionetgen.run(model_egfr_net, suppress=True);
# plot_result(result_egfr_net_Gillespie)
# plt.savefig('../Plots/Trajectories/BioNetGen/egfr_net_ssa.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/egfr_net_ssa.pdf')
# plt.close()
# 
# # Check Gillespie simulation time.
# bionetgen.run(model_egfr_net_no_obs, suppress=True);

# Load model.
bcr_ss_time = 20000
bcr_ssa_time = 15996
model_BCR = bionetgen.bngmodel('../Data/BCR.bngl')
model_BCR_no_obs = bionetgen.bngmodel('../Data/BCR_no_obs.bngl')

# Check ODE simulation output.
# model_BCR.actions[0].args['atol'] = 1e-12
# model_BCR.actions[0].args['rtol'] = 1e-6
# model_BCR.actions[0].args['t_end'] = bcr_ss_time   
# model_BCR.actions[0].args['n_steps'] = 500
# result_BCR_ODE = bionetgen.run(model_BCR, suppress=True);
# plot_result(result_BCR_ODE)
# plt.savefig('../Plots/Trajectories/BioNetGen/BCR_ode.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/BCR_ode.pdf')
# plt.close()

# Check ODE simulation time.
# model_BCR_no_obs.actions[0].args['atol'] = 1e-12
# model_BCR_no_obs.actions[0].args['rtol'] = 1e-6
# model_BCR_no_obs.actions[0].args['t_end'] = bcr_ss_time   
# model_BCR_no_obs.actions[0].args['n_steps'] = 50
# bionetgen.run(model_BCR_no_obs, suppress=True);

# Check (sparse) ODE simulation output.
# model_BCR.actions[0].args['sparse'] = 1
# result_BCR_ODE_sparse = bionetgen.run(model_BCR, suppress=True);
# plot_result(result_BCR_ODE_sparse)
# plt.savefig('../Plots/Trajectories/BioNetGen/BCR_ode_sparse.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/BCR_ode_sparse.pdf')
# plt.close()

# Check (sparse) ODE simulation time.
# model_BCR_no_obs.actions[0].args['sparse'] = 1
# bionetgen.run(model_BCR_no_obs, suppress=True);

# Load model.
model_BCR.add_action('simulate', {'method':'"ssa"', 't_end':bcr_ssa_time, 'n_steps':500})

# Check Gillespie simulation output.
result_BCRSSA_Gillespie = bionetgen.run(model_BCR, suppress=True);
plot_result(result_BCRSSA_Gillespie)
plt.savefig('../Plots/Trajectories/BioNetGen/BCR_ssa.png')
plt.savefig('../Plots/Trajectories/BioNetGen/BCR_ssa.pdf')
plt.close()

# # Check Gillespie simulation time.
# bionetgen.run(model_BCRSSA, suppress=True);
# 
# # Load model.
# fceri_gamma2_ss_time = 150
# model_fceri_gamma2 = bionetgen.bngmodel('../Data/fceri_gamma2.bngl')
# model_fceri_gamma2_no_obs = bionetgen.bngmodel('../Data/fceri_gamma2_no_obs.bngl')
# 
# # Check ODE simulation output.
# model_fceri_gamma2.actions[0].args['atol'] = 1e-12
# model_fceri_gamma2.actions[0].args['rtol'] = 1e-6
# model_fceri_gamma2.actions[0].args['t_end'] = fceri_gamma2_ss_time   
# model_fceri_gamma2.actions[0].args['n_steps'] = 50
# result_fceri_gamma2_ODE = bionetgen.run(model_fceri_gamma2, suppress=True);
# plot_result(result_fceri_gamma2_ODE)
# plt.savefig('../Plots/Trajectories/BioNetGen/fceri_gamma2_ode.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/fceri_gamma2_ode.pdf')
# plt.close()
# 
# # Check ODE simulation time.
# model_fceri_gamma2_no_obs.actions[0].args['atol'] = 1e-12
# model_fceri_gamma2_no_obs.actions[0].args['rtol'] = 1e-6
# model_fceri_gamma2_no_obs.actions[0].args['t_end'] = fceri_gamma2_ss_time   
# model_fceri_gamma2_no_obs.actions[0].args['n_steps'] = 50
# bionetgen.run(model_fceri_gamma2_no_obs, suppress=True);
# 
# # Check (sparse) ODE simulation output.
# model_fceri_gamma2.actions[0].args['sparse'] = 1
# result_fceri_gamma2_ODE_sparse = bionetgen.run(model_fceri_gamma2, suppress=True);
# plot_result(result_fceri_gamma2_ODE_sparse)
# plt.savefig('../Plots/Trajectories/BioNetGen/fceri_gamma2_ode_sparse.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/fceri_gamma2_ode_sparse.pdf')
# plt.close()
# 
# # Check (sparse) ODE simulation time.
# model_fceri_gamma2_no_obs.actions[0].args['sparse'] = 1
# bionetgen.run(model_fceri_gamma2_no_obs, suppress=True);
# 
# # Prepare model for Gillespie simulations.
# model_fceri_gamma2.actions[0].args['t_end'] = fceri_gamma2_ss_time   
# model_fceri_gamma2.actions[0].args['n_steps'] = 50
# model_fceri_gamma2.actions[0].args['method'] = '"ssa"'  
# model_fceri_gamma2_no_obs.actions[0].args['t_end'] = fceri_gamma2_ss_time   
# model_fceri_gamma2_no_obs.actions[0].args['n_steps'] = 50
# model_fceri_gamma2_no_obs.actions[0].args['method'] = '"ssa"'    
# 
# # Check Gillespie simulation output.
# result_fceri_gamma2_Gillespie = bionetgen.run(model_fceri_gamma2, suppress=True);
# plot_result(result_fceri_gamma2_Gillespie)
# plt.savefig('../Plots/Trajectories/BioNetGen/fceri_gamma2_ssa.png')
# plt.savefig('../Plots/Trajectories/BioNetGen/fceri_gamma2_ssa.pdf')
# plt.close()
# 
# # Check Gillespie simulation time.
# bionetgen.run(model_fceri_gamma2_no_obs, suppress=True);
# 
# 
# 
# 
# 
# 
# 