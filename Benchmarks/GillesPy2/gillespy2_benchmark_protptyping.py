# Fetch packages.
import sys, os, numpy, libsbml, gillespy2
import matplotlib.pyplot as plt
import json
import statistics
import timeit
import numpy
from gillespy2 import TauHybridSolver, NumPySSASolver, ODESolver, ODECSolver, TauLeapingSolver, SSACSolver

# Plots the model simulation output.
def plot_results(result,species):
    for s in species:
      plt.plot(result['time'],result[s])

# Function for plotting benchmarking output.
def plot_benchmark(benchmarks,lengs):
    medians = list(1000*numpy.array(list(map(statistics.median, benchmarks))))
    plt.plot(lengs,medians,linewidth=4)
    plt.xscale("log")
    plt.yscale("log")
    plt.xlim([lengs[0],lengs[-1]])
    plt.ylim([0.001,1.2*numpy.max(medians)])    # Choice of ymin does skew how plot appears.

# Benchmarking functions.
def make_ODE_benchmark(model,n,leng):
    def benchmark_func():
        model.run(solver=ODESolver,t=leng,integrator='lsoda')
    return timeit.Timer(benchmark_func).repeat(repeat=n, number=1)
def make_Gillespie_benchmark(model,n,leng):
    def benchmark_func():
        model.run(solver=SSACSolver,t=leng)
    return timeit.Timer(benchmark_func).repeat(repeat=n, number=1)

# Serialises a benchmarking output using JSON.
def serialize(benchmarks,lengs,filename):
    with open('../Benchmarking_results/Prototyping/%s.json'%(filename) , "w") as write:
        json.dump({"benchmarks": benchmarks, "medians": list(1000*numpy.array(list(map(statistics.median, benchmarks)))), "lengs": lengs.tolist()} , write)

# Benchmarking parameters
n = 10

# Load model.
# multistate_ss_time = 20
# model_multistate = gillespy2.core.import_SBML('../Data/multistate.xml')[0]
# model_multistate_no_obs = gillespy2.core.import_SBML('../Data/multistate_no_obs.xml')[0]
# 
# # Check output (plotting currently only possible using TauHybridSolver algorithm).
# tc_multistate_THS = model_multistate.run(solver=TauHybridSolver,t=multistate_ss_time,increment=multistate_ss_time/50.0)
# plot_results(tc_multistate_THS,['A_P', 'A_unbound_P', 'A_bound_P','RLA_P'])
# plt.savefig('../Plots/Trajectories/GillesPy2/multistate_ths.png')
# plt.savefig('../Plots/Trajectories/GillesPy2/multistate_ths.pdf')
# plt.close()
# 
# # Check ODE simulation time (plotting currently not possible).
# tc_multistate_ODE = model_multistate_no_obs.run(solver=ODESolver,t=multistate_ss_time,increment=multistate_ss_time/20.0,integrator='lsoda',integrator_options={"atol":10e-12,"rtol":10e-6})
# 
# # Check SSA simulation time (plotting currently not possible).
# tc_multistate_ODE = model_multistate_no_obs.run(solver=SSACSolver,t=multistate_ss_time,increment=multistate_ss_time/20.0)
# 
# # Load model.
# multisite2_ss_time = 2
# model_multisite2 = gillespy2.core.import_SBML('../Data/multisite2.xml')[0]
# model_multisite2_no_obs = gillespy2.core.import_SBML('../Data/multisite2_no_obs.xml')[0]
# 
# # Check output (plotting currently only possible using TauHybridSolver algorithm).
# tc_multisite2_THS = model_multisite2.run(solver=TauHybridSolver,t=multisite2_ss_time,increment=multisite2_ss_time/50.0)
# plot_results(tc_multisite2_THS,['Rfree', 'Lfree', 'A1P'])
# plt.savefig('../Plots/Trajectories/GillesPy2/multisite2_ths.png')
# plt.savefig('../Plots/Trajectories/GillesPy2/multisite2_ths.pdf')
# plt.close()
# 
# # Check ODE simulation time (plotting currently not possible).
# tc_multisite2_ODE = model_multisite2_no_obs.run(solver=ODESolver,t=multisite2_ss_time,increment=multisite2_ss_time/50.0,integrator='lsoda',integrator_options={"atol":10e-12,"rtol":10e-6})
# 
# # Check SSA simulation time (plotting currently not possible).
# tc_multisite2_ODE = model_multisite2_no_obs.run(solver=SSACSolver,t=multisite2_ss_time,increment=multisite2_ss_time/50.0)
# 
# # Load model.
# egfr_net_ss_time = 10
# model_egfr_net = gillespy2.core.import_SBML('../Data/egfr_net.xml')[0]
# model_egfr_net_no_obs = gillespy2.core.import_SBML('../Data/egfr_net_no_obs.xml')[0]
# 
# # Check output (plotting currently only possible using TauHybridSolver algorithm).
# tc_egfr_net_THS = model_egfr_net.run(solver=TauHybridSolver,t=egfr_net_ss_time,increment=egfr_net_ss_time/50.0)
# plot_results(tc_egfr_net_THS,['Dimers', 'Sos_act', 'Y1068', 'Y1148', 'Shc_Grb', 'Shc_Grb_Sos', 'R_Grb2', 'R_Shc', 'R_ShcP', 'ShcP', 'R_G_S', 'R_S_G_S', 'Efgr_tot'])
# plt.savefig('../Plots/Trajectories/GillesPy2/egfr_net_ths.png')
# plt.savefig('../Plots/Trajectories/GillesPy2/egfr_net_ths.pdf')
# plt.close()
# 
# # Check ODE simulation time (plotting currently not possible).
# tc_egfr_net_ODE = model_egfr_net_no_obs.run(solver=ODESolver,t=egfr_net_ss_time,increment=egfr_net_ss_time/50.0,integrator='lsoda',integrator_options={"atol":10e-12,"rtol":10e-6})
# 
# # Check SSA simulation time (plotting currently not possible).
# tc_egfr_net_ODE = model_egfr_net_no_obs.run(solver=SSACSolver,t=egfr_net_ss_time,increment=egfr_net_ss_time/50.0)
# 
# Load model.
bcr_ss_time = 20000
model_BCR = gillespy2.core.import_SBML('../Data/BCR.xml')[0]
model_BCR_no_obs = gillespy2.core.import_SBML('../Data/BCR_no_obs.xml')[0]

# Check output (plotting currently only possible using TauHybridSolver algorithm).
tc_BCR_THS = model_BCR.run(solver=TauHybridSolver,t=bcr_ss_time,increment=bcr_ss_time/200.0)
plot_results(tc_BCR_THS,['Activated_Syk', 'Ig_alpha_P', 'Ig_alpha_PP', 'Ig_beta_PP', 'Activated_Lyn', 'Autoinhibited_Lyn', 'Activated_Fyn', 'Autoinhibited_Fyn', 'PAG1_Csk'])
plt.savefig('../Plots/Trajectories/GillesPy2/BCR_ths.png')
plt.savefig('../Plots/Trajectories/GillesPy2/BCR_ths.pdf')
plt.close()

# Check ODE simulation time (plotting currently not possible).
tc_BCR_ODE = model_multisite2_no_obs.run(solver=ODESolver,t=bcr_ss_time,increment=bcr_ss_time/200.0,integrator='lsoda',integrator_options={"atol":10e-12,"rtol":10e-6})

# Check SSA simulation time (plotting currently not possible).
tc_BCR_ODE = model_multisite2_no_obs.run(solver=SSACSolver,t=bcr_ss_time,increment=bcr_ss_time/200.0)

# Load model.
#fceri_gamma2_ss_time = 150
#model_fceri_gamma2 = gillespy2.core.import_SBML('../Data/fceri_gamma2.xml')[0]
#model_fceri_gamma2_no_obs = gillespy2.core.import_SBML('../Data/fceri_gamma2_no_obs.xml')[0]

# Check output (plotting currently only possible using TauHybridSolver algorithm).
#tc_fceri_gamma2_THS = model_fceri_gamma2.run(solver=TauHybridSolver,t=fceri_gamma2_ss_time,increment=fceri_gamma2_ss_time/50.0)
#plot_results(tc_fceri_gamma2_THS,['Lyn_Free', 'RecMon', 'RecPbeta', 'RecPgamma', 'RecSyk', 'RecSykP5'])
#plt.savefig('../Plots/Trajectories/GillesPy2/fceri_gamma2_ths.png')
#plt.savefig('../Plots/Trajectories/GillesPy2/fceri_gamma2_ths.pdf')

# Check ODE simulation time (plotting currently not possible).
#tc_fceri_gamma2_ODE = model_fceri_gamma2_no_obs.run(solver=ODESolver,t=fceri_gamma2_ss_time,increment=fceri_gamma2_ss_time/50.0,integrator='lsoda',integrator_options={"atol":10e-12,"rtol":10e-6})

# Check SSA simulation time (plotting currently not possible).
#tc_fceri_gamma2_ODE = model_fceri_gamma2_no_obs.run(solver=SSACSolver,t=fceri_gamma2_ss_time,increment=fceri_gamma2_ss_time/50.0)