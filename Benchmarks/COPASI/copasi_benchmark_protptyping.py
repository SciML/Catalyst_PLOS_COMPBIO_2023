# Fetch packages.
from basico import *
import json
import matplotlib.pyplot as plt
import statistics
import timeit
import numpy

# Function for plotting benchmarking output.
def plot_benchmark(benchmarks,lengs):
    medians = list(1000*numpy.array(list(map(statistics.median, benchmarks))))
    plt.plot(lengs,medians,linewidth=4)
    plt.xscale("log")
    plt.yscale("log")
    plt.xlim([lengs[0],lengs[-1]])
    plt.ylim([0.001,1.2*numpy.max(medians)])    # Choice of ymin does skew how plot appears.

# Benchmarking functions.
def make_benchmark(n,leng,method):
    def benchmark_func():
        run_time_course(duration=leng, stepsize=10, method=method)
    return timeit.Timer(benchmark_func).repeat(repeat=n, number=1)

# Serialises a benchmarking output using JSON.
def serialize(benchmarks,lengs,filename):
    with open('../Benchmarking_results/Prototyping/%s.json'%(filename) , "w") as write:
        json.dump({"benchmarks": benchmarks, "medians": list(1000*numpy.array(list(map(statistics.median, benchmarks)))), "lengs": lengs.tolist()} , write)

# Load model.
# multistate_ss_time = 20
# load_model('../Data/multistate.xml');
# 
# # Check ODE simulation output.
# tc_multistate_ODE = run_time_course(duration = multistate_ss_time, method='deterministic')
# tc_multistate_ODE.loc[:, ['Values[A_P]', 'Values[A_unbound_P]', 'Values[A_bound_P]', 'Values[RLA_P]']].plot()
# plt.savefig('../Plots/Trajectories/COPASI/multistate_ode.png')
# plt.savefig('../Plots/Trajectories/COPASI/multistate_ode.pdf')
# plt.close()
# 
# # Check Gillespie simulation output.
# tc_multistate_Gillespie = run_time_course(duration = multistate_ss_time, method='directMethod')
# tc_multistate_Gillespie.loc[:, ['Values[A_P]', 'Values[A_unbound_P]', 'Values[A_bound_P]', 'Values[RLA_P]']].plot()
# plt.savefig('../Plots/Trajectories/COPASI/multistate_ssa.png')
# plt.savefig('../Plots/Trajectories/COPASI/multistate_ssa.pdf')
# plt.close()
# 
# # Load model (without observables).
# load_model('../Data/multistate_no_obs.xml');
# 
# # Load model.
# multisite2_ss_time = 2
# load_model('../Data/multisite2.xml');
# 
# # Check ODE simulation output for maximum length simulation.
# tc_multisite2_ODE = run_time_course(duration = multisite2_ss_time, method='deterministic')
# tc_multisite2_ODE.loc[:, ['Values[Rfree]','Values[Lfree]','Values[A1P]']].plot()
# plt.savefig('../Plots/Trajectories/COPASI/multisite2_ode.png')
# plt.savefig('../Plots/Trajectories/COPASI/multisite2_ode.pdf')
# plt.close()
# 
# # Check Gillespie simulation output.
# tc_multisite2_Gillespie = run_time_course(duration = multisite2_ss_time, method='directMethod')
# tc_multisite2_Gillespie.loc[:, ['Values[Rfree]','Values[Lfree]','Values[A1P]']].plot()
# plt.savefig('../Plots/Trajectories/COPASI/multisite2_ssa.png')
# plt.savefig('../Plots/Trajectories/COPASI/multisite2_ssa.pdf')
# plt.close()
# 
# # Load model.
# egfr_net_ss_time = 10
# load_model('../Data/egfr_net.xml');
# 
# # Check ODE simulation output.
# tc_egfr_net_ODE = run_time_course(duration = egfr_net_ss_time, method='deterministic')
# tc_egfr_net_ODE.loc[:, ['Values[Dimers]','Values[Sos_act]','Values[Y1068]','Values[Y1148]','Values[Shc_Grb]','Values[Shc_Grb_Sos]','Values[R_Grb2]','Values[R_Shc]','Values[R_ShcP]','Values[ShcP]','Values[R_G_S]','Values[R_S_G_S]','Values[Efgr_tot]']].plot()
# plt.savefig('../Plots/Trajectories/COPASI/egfr_net_ode.png')
# plt.savefig('../Plots/Trajectories/COPASI/egfr_net_ode.pdf')
# plt.close()
# 
# # Check Gillespie simulation output.
# tc_egfr_net_Gillespie = run_time_course(duration = egfr_net_ss_time, method='directMethod')
# tc_egfr_net_Gillespie.loc[:, ['Values[Dimers]','Values[Sos_act]','Values[Y1068]','Values[Y1148]','Values[Shc_Grb]','Values[Shc_Grb_Sos]','Values[R_Grb2]','Values[R_Shc]','Values[R_ShcP]','Values[ShcP]','Values[R_G_S]','Values[R_S_G_S]','Values[Efgr_tot]']].plot()
# plt.savefig('../Plots/Trajectories/COPASI/egfr_net_ssa.png')
# plt.savefig('../Plots/Trajectories/COPASI/egfr_net_ssa.pdf')
# plt.close()

# Load model.
# bcr_ss_time = 20000
bcr_ssa_time = 15996
load_model('../Data/BCR.xml');

# Check ODE simulation output.
# tc_BCR_ODE = run_time_course(duration = bcr_ss_time, method='deterministic', intervals=500)
# tc_BCR_ODE.loc[:, ['Values[Activated_Syk]','Values[Ig_alpha_P]','Values[Ig_alpha_PP]','Values[Ig_beta_PP]','Values[Activated_Lyn]','Values[Autoinhibited_Lyn]','Values[Activated_Fyn]','Values[Autoinhibited_Fyn]','Values[PAG1_Csk]']].plot()
# plt.savefig('../Plots/Trajectories/COPASI/BCR_ode.png')
# plt.savefig('../Plots/Trajectories/COPASI/BCR_ode.pdf')
# plt.close()

# Check Gillespie simulation output (not run due to long SSA simulation times for COPASI of the BCR model).
tc_BCR_Gillespie = run_time_course(duration = bcr_ssa_time, method='directMethod', intervals=500, max_steps=1000000000)
tc_BCR_Gillespie.loc[:, ['Values[Activated_Syk]','Values[Ig_alpha_P]','Values[Ig_alpha_PP]','Values[Ig_beta_PP]','Values[Activated_Lyn]','Values[Autoinhibited_Lyn]','Values[Activated_Fyn]','Values[Autoinhibited_Fyn]','Values[PAG1_Csk]']].plot()
plt.savefig('../Plots/Trajectories/COPASI/BCR_ssa.png')
plt.savefig('../Plots/Trajectories/COPASI/BCR_ssa.pdf')

# Load model (without observables).
# load_model('../Data/BCR_no_obs.xml');

# # Load model.
# fceri_gamma2_ss_time = 150
# load_model('../Data/fceri_gamma2.xml');
# 
# # Check ODE simulation output.
# tc_fceri_gamma2_ODE = run_time_course(duration = fceri_gamma2_ss_time, method='deterministic')
# tc_fceri_gamma2_ODE.loc[:, ['Values[LynFree]','Values[RecMon]','Values[RecPbeta]','Values[RecPgamma]','Values[RecSyk]','Values[RecSykPS]']].plot()
# plt.savefig('../Plots/Trajectories/COPASI/fceri_gamma2_ode.png')
# plt.savefig('../Plots/Trajectories/COPASI/fceri_gamma2_ode.pdf')
# plt.close()
# 
# # Check Gillespie simulation output.
# tc_fceri_gamma2_Gillespie = run_time_course(duration = fceri_gamma2_ss_time, method='directMethod')
# tc_fceri_gamma2_Gillespie.loc[:, ['Values[LynFree]','Values[RecMon]','Values[RecPbeta]','Values[RecPgamma]','Values[RecSyk]','Values[RecSykPS]']].plot()
# plt.savefig('../Plots/Trajectories/COPASI/fceri_gamma2_ssa.png')
# plt.savefig('../Plots/Trajectories/COPASI/fceri_gamma2_ssa.pdf')
# plt.close()
# 























