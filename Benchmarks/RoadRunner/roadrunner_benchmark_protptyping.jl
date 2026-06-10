### Preparations ###

# Do something with Pkg...
import Pkg
Pkg.activate(".")
Pkg.DEFAULT_IO[] = stdout;

# Fetch packages
using RoadRunner
using Plots

# Sets plotting defaults
default(framestyle=:box,grid=false,lw=4,la=0.8,guidefontsize=11,legend=:topleft)

### Helper Functions ###

# Loads a sbml model with roadrunner.
function rr_load_model(filename)
    opened_file = open(filename)
    sbml_str = read(filename,String)
    close(opened_file)
    rr_model = RoadRunner.createRRInstance()
    RoadRunner.loadSBML(rr_model, sbml_str)
    return rr_model
end

# Checks a model using roadrunner.
function check_model(filename, tspan, observables; tstops=500, ssa_tspan=tspan)
    filename = "../Data/$(filename)"
    modelname = split(filename, ".")[1]

    # ODE simulation
    @time model = rr_load_model(filename)
    RoadRunner.setTimeCourseSelectionList(model, "Time,$(join(observables,","))")

    @time ode_sol = RoadRunner.simulateEx(model, tspan..., tstops);
    ode_plot = plot(ode_sol[:, 1], ode_sol[:, 2:end]; labels = observables, title=modelname)
    savefig(ode_plot, "../Plots/Trajectories/RoadRunner/$(modelname)_ode.png")

    # Gillespie simulation
    model = rr_load_model(filename)
    RoadRunner.setTimeCourseSelectionList(model, "Time,$(join(observables,","))")

    @time ssa_sol = RoadRunner.gillespieEx(model, ssa_tspan...);
    ssa_plot = plot(ssa_sol[:, 1], ssa_sol[:, 2:end]; labels = observables, title=modelname)
    savefig(ssa_plot, "../Plots/Trajectories/RoadRunner/$(modelname)_ssa.png")

    #returns output plot.
    plot(ode_plot, ssa_plot; size=(800,400))
end

### Run Prototyping ###
check_model("multistate.xml", (0.0, 20.0), ["A_P" "A_unbound_P" "A_bound_P" "RLA_P"])
check_model("multisite2.xml", (0.0, 2.0), ["Rfree" "Lfree" "A1P"])
check_model("egfr_net.xml", (0.0, 10.0), ["Dimers" "Sos_act" "Y1068" "Y1148" "Shc_Grb" "Shc_Grb_Sos" "R_Grb2" "R_Shc" "R_ShcP" "ShcP" "R_G_S" "R_S_G_S" "Efgr_tot"])
check_model("BCR.xml", (0.0, 20000.0), ["Activated_Syk" "Ig_alpha_P" "Ig_alpha_PP" "Ig_beta_PP" "Activated_Lyn" "Autoinhibited_Lyn" "Activated_Fyn" "Autoinhibited_Fyn" "PAG1_Csk"]; ssa_tspan=(0.0, 2000.0))
check_model("fceri_gamma2.xml", (0.0, 150.0), ["LynFree" "RecMon" "RecPbeta" "RecPgamma" "RecSyk" "RecSykPS"])

