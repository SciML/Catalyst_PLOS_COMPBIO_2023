### ---------- ---------- Preparations ---------- ---------- ###


### Import Packages ###
using JSON
using Plots
using Statistics



### Set Plotting Options ###
gr()
mm = Plots.mm;
default(framestyle=:box,legend=:topleft, gridalpha=0.3, gridlinewidth=2.5,
        xaxis=:log10, yaxis=:log10, legendfontsize=7, titlefontsize=11, yguide="Simulation runtime (ms)", 
        lw=6, la=0.8,
        markersize=6, markeralpha=0.6)

const ticks = 10.0 .^(-10:1:10)

### Declare Solvers Plotting Options ###

# Non DiffEq methods implemented in Julia and run on Catalyst.
methods_ode_catalyst_lsoda_n_CVODE = [
    ("catalyst_lsoda_NoLinSolver",                      "Catalyst (lsoda, NoLinSol)",                       :seagreen1,         :star4),
    ("catalyst_CVODE_BDF_NoLinSolver",                  "Catalyst (CVODE_BDF, NoLinSol)",                   :chartreuse1,       :circle),
    ("catalyst_CVODE_BDF_LapackDense",                  "Catalyst (CVODE_BDF, LapackDense)",                :darkolivegreen3,   :diamond),
    ("catalyst_CVODE_BDF_GMRES",                        "Catalyst (CVODE_BDF, GMRES)",                      :darkgreen,         :rect),
    ("catalyst_CVODE_BDF_sparse_pc_GMRES",              "Catalyst (CVODE_BDF, GMRES, preconditioner)",      :green,             :octagon),
    #("catalyst_CVODE_BDF_jac_LapackDense",              "Catalyst (CVODE_BDF, jac=true, LapackDense)",      :mediumseagreen,    :pentagon),
    ("catalyst_CVODE_BDF_jac_sparse_KLU",               "Catalyst (CVODE_BDF, jac=true, sparse=true, KLU)", :darkseagreen1,     :utriangle)];

# Implicit DiffEq methods implemented in Julia and run on Catalyst (without linnear solver).
methods_ode_catalyst_julia = [
    ("catalyst_TRBDF2_NoLinSolver",                     "Catalyst (TRBDF2, Default LinSol)",            :darkslategray1,    :dtriangle),
    ("catalyst_KenCarp4_NoLinSolver",                   "Catalyst (KenCarp4, Default LinSol)",          :lightskyblue,      :star5),
    ("catalyst_QNDF_NoLinSolver",                       "Catalyst (QNDF, Default LinSol)",              :deepskyblue1,      :hexagon),
    ("catalyst_FBDF_NoLinSolver",                       "Catalyst (FBDF, Default LinSol)",              :dodgerblue2,       :rtriangle),
    ("catalyst_Rodas4_NoLinSolver",                     "Catalyst (Rodas4, Default LinSol)",            :steelblue,         :star7),
    ("catalyst_Rodas5P_NoLinSolver",                    "Catalyst (Rodas5P, Default LinSol)",           :blue,              :heptagon),
    ("catalyst_Rosenbrock23_NoLinSolver",               "Catalyst (Rosenbrock23, Default LinSol)",      :navy,              :ltriangle)]

# Implicit DiffEq methods implemented in Julia and run on Catalyst (GMRES linnear solver).
methods_ode_catalyst_julia_GMRES = [
    ("catalyst_TRBDF2_GMRES",                  "Catalyst (TRBDF2, GMRES)",                     methods_ode_catalyst_julia[1][3:4]...),
    ("catalyst_KenCarp4_GMRES",                "Catalyst (KenCarp4, GMRES)",                   methods_ode_catalyst_julia[2][3:4]...),
    ("catalyst_QNDF_GMRES",                    "Catalyst (QNDF, GMRES)",                       methods_ode_catalyst_julia[3][3:4]...),
    ("catalyst_FBDF_GMRES",                    "Catalyst (FBDF, GMRES)",                       methods_ode_catalyst_julia[4][3:4]...),
    ("catalyst_Rodas4_GMRES",                  "Catalyst (Rodas4, GMRES)",                     methods_ode_catalyst_julia[5][3:4]...),
    ("catalyst_Rodas5P_GMRES",                 "Catalyst (Rodas5P, GMRES)",                    methods_ode_catalyst_julia[6][3:4]...),
    ("catalyst_Rosenbrock23_GMRES",            "Catalyst (Rosenbrock23, GMRES)",               methods_ode_catalyst_julia[7][3:4]...)]

# Implicit DiffEq methods implemented in Julia and run on Catalyst (GMRES linnear solver with pre conditioner).
methods_ode_catalyst_julia_GMRES_pc = [
    ("catalyst_TRBDF2_sparse_pc_GMRES",        "Catalyst (TRBDF2, GMRES, iLU pre-c)",          methods_ode_catalyst_julia[1][3:4]...),
    ("catalyst_KenCarp4_sparse_pc_GMRES",      "Catalyst (KenCarp4, GMRES, iLU pre-c)",        methods_ode_catalyst_julia[2][3:4]...),
    ("catalyst_QNDF_sparse_pc_GMRES",          "Catalyst (QNDF, GMRES, iLU pre-c)",            methods_ode_catalyst_julia[3][3:4]...),
    ("catalyst_FBDF_sparse_pc_GMRES",          "Catalyst (FBDF, GMRES, iLU pre-c)",            methods_ode_catalyst_julia[4][3:4]...),
    ("catalyst_Rodas4_sparse_pc_GMRES",        "Catalyst (Rodas4, GMRES, iLU pre-c)",          methods_ode_catalyst_julia[5][3:4]...),
    ("catalyst_Rodas5P_sparse_pc_GMRES",       "Catalyst (Rodas5P, GMRES, iLU pre-c)",         methods_ode_catalyst_julia[6][3:4]...),
    ("catalyst_Rosenbrock23_sparse_pc_GMRES",  "Catalyst (Rosenbrock23, GMRES, iLU pre-c)",    methods_ode_catalyst_julia[7][3:4]...)]

# Implicit DiffEq methods implemented in Julia and run on Catalyst (KLU linnear solver and sparse jacobian).
methods_ode_catalyst_julia_KLU = [
    ("catalyst_TRBDF2_jac_sparse_KLU",                  "Catalyst (TRBDF2, KLU, sparse jac)",                     methods_ode_catalyst_julia[1][3:4]...),
    ("catalyst_KenCarp4_jac_sparse_KLU",                "Catalyst (KenCarp4, KLU, sparse jac)",                   methods_ode_catalyst_julia[2][3:4]...),
    ("catalyst_QNDF_jac_sparse_KLU",                    "Catalyst (QNDF, KLU, sparse jac)",                       methods_ode_catalyst_julia[3][3:4]...),
    ("catalyst_FBDF_jac_sparse_KLU",                    "Catalyst (FBDF, KLU, sparse jac)",                       methods_ode_catalyst_julia[4][3:4]...),
    ("catalyst_Rodas4_jac_sparse_KLU",                  "Catalyst (Rodas4, KLU, sparse jac)",                     methods_ode_catalyst_julia[5][3:4]...),
    ("catalyst_Rodas5P_jac_sparse_KLU",                 "Catalyst (Rodas5P, KLU, sparse jac)",                    methods_ode_catalyst_julia[6][3:4]...),
    ("catalyst_Rosenbrock23_jac_sparse_KLU",            "Catalyst (Rosenbrock23, KLU, sparse jac)",               methods_ode_catalyst_julia[7][3:4]...)]

# Explicit DiffEq methods implemented in Julia and run on Catalyst.
methods_ode_catalyst_julia_explicit = [
    ("catalyst_Tsit5_NoLinSolver",                      "Catalyst (Tsit5)",                             :orchid2,           :ltriangle),
    ("catalyst_BS5_NoLinSolver",                        "Catalyst (BS5)",                               :thistle2,          :star8),
    ("catalyst_VCABM_NoLinSolver",                      "Catalyst (VCABM)",                             :lightsteelblue2,   :heptagon),
    ("catalyst_Vern6_NoLinSolver",                      "Catalyst (Vern6)",                             :lightslateblue,    :rtriangle),
    ("catalyst_Vern7_NoLinSolver",                      "Catalyst (Vern7)",                             :mediumpurple1,     :star6),
    ("catalyst_Vern8_NoLinSolver",                      "Catalyst (Vern8)",                             :mediumpurple3,     :hexagon),
    ("catalyst_Vern9_NoLinSolver",                      "Catalyst (Vern9)",                             :blueviolet,        :dtriangle),
    ("catalyst_ROCK2_NoLinSolver",                      "Catalyst (ROCK2)",                             :darkmagenta,       :star5),
    ("catalyst_ROCK4_NoLinSolver",                      "Catalyst (ROCK4)",                             :purple4,           :square)]

# Non-Catalyst tools.
methods_ode_other = [
    ("bionetgen_ode",                                   "Bionetgen (CVODE)",                            :orange1,           :diamond),
    ("bionetgen_sparse_ode",                            "Bionetgen (CVODE, GMRES)",                     :darkorange3,       :rect), 
    ("copasi_deterministic",                            "Copasi (LSODA)",                               :lightcoral,        :octagon),
    ("gillespy2_lsoda",                                 "Gillespy2 (LSODA)",                            :firebrick1,        :pentagon),
    ("gillespy2_csolver",                               "Gillespy2 (CSolver default)",                  :red3,              :hexagon),
    ("matlab_ode",                                      "MATLAB SimBiology (CVODE)",                    :firebrick4,        :utriangle)]

# Catalyst and non-Catalyst tools' ssa solvers.
methods_ssa = [
    ("catalyst_Direct",                                 "Catalyst (Direct)",                            :darkseagreen1,     :star4),
    ("catalyst_SortingDirect",                          "Catalyst (SortingDirect)",                     :turquoise1,        :circle),
    ("catalyst_RSSA",                                   "Catalyst (RSSA)",                              :aquamarine3,       :star8),
    ("catalyst_RSSACR",                                 "Catalyst (RSSACR)",                            :teal,              :diamond),
    ("bionetgen_ssa",                                   "Bionetgen (SortingDirect)",                    :orange1,           :diamond),
    ("copasi_directMethod",                             "Copasi (Direct)",                              :lightcoral,        :octagon),
    ("gillespy2_ssa",                                   "Gillespy2 (Direct)",                           :firebrick1,        :pentagon),
    #("gillespy2_numpyssa",                              "Gillespy2 (Numpy SSA)",                        :red3,              :hexagon),
    ("matlab_ssa",                                      "MATLAB SimBiology (Direct)",                   :firebrick4,        :utriangle)];



### Group ODE Methods ###

# All ODE methods in one set of vectors. Also includes titles.
methods_ode_all =  [methods_ode_catalyst_lsoda_n_CVODE,
                    methods_ode_catalyst_julia,
                    methods_ode_catalyst_julia_GMRES,
                    methods_ode_catalyst_julia_GMRES_pc,
                    methods_ode_catalyst_julia_KLU,
                    methods_ode_catalyst_julia_explicit,
                    methods_ode_other]
methods_ode_all_titles =  [ "Catalyst, Lsoda and CVODE",
                            "Catalyst, Implicit methods",
                            "Catalyst, Implicit methods (GMRES linsolver)",
                            "Catalyst, Implicit methoods (GMRES with pre-conditioner)",
                            "Catalyst, Implicit methods (KLU linsolver, sparse jac)",
                            "Catalyst, Explicit methods",
                            "Non-Catalyst tools"]

# Non-Catalyst tools separated in BioNetGen and others (used in some benchmarking plots).
methods_ode_BioNetGen = methods_ode_other[1:2]
methods_ode_COPASI = methods_ode_other[3:3]
methods_ode_GillesPy2 = methods_ode_other[4:5]
methods_ode_Matlab = methods_ode_other[6:6]

# Lsoda and CVODE methods separated.
method_lsoda = methods_ode_catalyst_lsoda_n_CVODE[1]
methods_ode_catalyst_CVODE = methods_ode_catalyst_lsoda_n_CVODE[2:end]

# Julia solvers by solver.
methods_ode_catalyst_TRBDF2 = getindex.([methods_ode_catalyst_julia,methods_ode_catalyst_julia_GMRES,methods_ode_catalyst_julia_GMRES_pc],1)
methods_ode_catalyst_KenCarp4 = getindex.([methods_ode_catalyst_julia,methods_ode_catalyst_julia_GMRES,methods_ode_catalyst_julia_GMRES_pc],2)
methods_ode_catalyst_QNDF = getindex.([methods_ode_catalyst_julia,methods_ode_catalyst_julia_GMRES,methods_ode_catalyst_julia_GMRES_pc],3)
methods_ode_catalyst_FBDF = getindex.([methods_ode_catalyst_julia,methods_ode_catalyst_julia_GMRES,methods_ode_catalyst_julia_GMRES_pc],4)
methods_ode_catalyst_Rodas4 = getindex.([methods_ode_catalyst_julia,methods_ode_catalyst_julia_GMRES,methods_ode_catalyst_julia_GMRES_pc],5)
methods_ode_catalyst_Rodas5P = getindex.([methods_ode_catalyst_julia,methods_ode_catalyst_julia_GMRES,methods_ode_catalyst_julia_GMRES_pc],6)
methods_ode_catalyst_Rosenbrock23 = getindex.([methods_ode_catalyst_julia,methods_ode_catalyst_julia_GMRES,methods_ode_catalyst_julia_GMRES_pc],7)

methods_ode_catalyst_Tsit5 = methods_ode_catalyst_julia_explicit[1:1]
methods_ode_catalyst_BS5 = methods_ode_catalyst_julia_explicit[2:2]
methods_ode_catalyst_VCABM = methods_ode_catalyst_julia_explicit[3:3]
methods_ode_catalyst_Vern6 = methods_ode_catalyst_julia_explicit[4:4]
methods_ode_catalyst_Vern7 = methods_ode_catalyst_julia_explicit[5:5]
methods_ode_catalyst_Vern8 = methods_ode_catalyst_julia_explicit[6:6]
methods_ode_catalyst_Vern9 = methods_ode_catalyst_julia_explicit[7:7]

all_julia_solver_grouped = [methods_ode_catalyst_TRBDF2,methods_ode_catalyst_KenCarp4,methods_ode_catalyst_QNDF,methods_ode_catalyst_FBDF,methods_ode_catalyst_Rodas4,methods_ode_catalyst_Rodas5P,methods_ode_catalyst_Rosenbrock23,
                            methods_ode_catalyst_Tsit5,methods_ode_catalyst_BS5,methods_ode_catalyst_VCABM,methods_ode_catalyst_Vern6,methods_ode_catalyst_Vern7,methods_ode_catalyst_Vern8,methods_ode_catalyst_Vern9]



### Method Benchmark Sturcture & Utility ###

# Gathers the information of a single benchmark in a single structure.
struct MetodBenchmark
    is_ss::Bool
    lengs::Vector{Float64}
    vals::Vector{Float64}
    label::String
    color::Symbol
    markershape::Symbol
    completed::Bool

    function MetodBenchmark(method::Tuple{String, String, Symbol, Symbol}, model::String, is_ss::Bool; print_missing=true, nbr_of_threads=1)
        filename = "../Benchmarking_results/Threads_$nbr_of_threads/$(method[1][1:findfirst('_',method[1])]*(is_ss ? "ss_sim_" : "")*method[1][findfirst('_',method[1])+1:end])_$(model).json"
        if !isfile(filename) 
            print_missing && println("Missing benchmark: $(method[2])")
            return new(is_ss,Float64[],Float64[],method[2:4]...,false)
        end
        bm = JSON.parsefile(filename)
        (bm["lengs"] isa Number) && return new(is_ss,Float64.([bm["lengs"]]),[bm["medians"]],method[2:4]...,true)
        return new(is_ss,Float64.(bm["lengs"]),bm["medians"],method[2:4]...,true)
    end
end

# Finds the maximum/minimum x/y values (rounded to power of 10) across several benchmarks.
function find_x_limits(bms::Vector{MetodBenchmark}) 
    (maximum(vcat(getfield.(bms, :lengs)...)) == 10^5.01) && (return (0.8,1.0/0.8) .* (log10_floor(minimum(vcat(getfield.(bms, :lengs)...))), log10_ceil(maximum(10.0^4.99)))) # Exception for the SSA BCR model plot.
    return (0.8,1.0/0.8) .* (log10_floor(minimum(vcat(getfield.(bms, :lengs)...))), log10_ceil(maximum(vcat(getfield.(bms, :lengs)...))))
end
find_y_limits(bms::Vector{MetodBenchmark}) = (0.8,1.0/0.8) .* (log10_floor(minimum(vcat(getfield.(bms, :vals)...))), log10_ceil(maximum(vcat(getfield.(bms, :vals)...))))
find_y_limits(bmss::Vector{Vector{MetodBenchmark}}) = (minimum(first.(find_y_limits.(bmss))), maximum(last.(find_y_limits.(bmss))))

# Gets the largest/smallest factor of 10 lower/higher than a number.
log10_floor(x) = 10^floor(log10(x))
log10_ceil(x) = 10^ceil(log10(x))



### Base Plotting Functions ###

# Plots a several sets of benchmarks where the system is simualted until the steady state.
function plot_transient_benchmarks(model, methodss::Vector{Vector{Tuple{String, String, Symbol, Symbol}}}; ylimit=nothing,title="", kwargs...)
    bmss = filter(x->!isempty(x), map(methods -> filter(bm->bm.completed, MetodBenchmark.(methods, model, true)), methodss))
    valss = map(bms -> first.(getfield.(bms, :vals)), bmss)
    labelss = get_field_vals(bmss, :label)
    colorss = get_field_vals(bmss, :color)
    markershapess = get_field_vals(bmss, :markershape)
    isnothing(ylimit) && (ylimit = find_y_limits(bmss))
    isempty(bmss) && (return (plot(yguide="",xguide="",titles=title)))
    grouped_bar_plot(valss; ylimit=ylimit, labelss=labelss, colorss=colorss, yticks=ticks, markershapess=markershapess, title=title, kwargs...)
end
# Plots a single set of benchmarks where the system is simualted until the steady state.
plot_transient_benchmarks(model, methods::Vector{Tuple{String, String, Symbol, Symbol}}; kwargs...) = plot_transient_benchmarks(model, [methods]; kwargs...)
# Collects a single field as a vector, from a vector of vectors of benchmarks.
get_field_vals(bmss::Vector{Vector{MetodBenchmark}}, field::Symbol) = vcat(map(bms -> getfield.(bms, field), bmss)...)

# Plots several groups of bar plots in a single diagram.
function grouped_bar_plot(valss; width=1.0, space=1, ylimit=(-Inf,Inf), markersize=12, markerstrokewidth=4, labelss=[""], colorss=1:sum(length.(methodss)), markershapess=[:circle] , kwargs...)
    poss_pre = map(d -> collect(1:width:(width*length(d))), valss)
    poss = poss_pre[1]
    foreach(p -> append!(poss,p .+ space*width .+ poss[end]), poss_pre[2:end])
    vals = vcat(valss...)
    bar(poss, vals; xaxis=:identity, labels="", ylimit=ylimit, fillrange=ylimit[1], bar_width=width, color=vcat(colorss...), kwargs...)
    scatter!(poss', vals'; markersize=markersize, markerstrokewidth=markerstrokewidth, markerstrokecolor=:grey25, xticks=[], label=hcat(vcat(labelss...)...), color=hcat(vcat(colorss...)...), markershape=hcat(vcat(markershapess...)...), kwargs...)
end;

# Plots a set single of benchmarks where the system is simualted until and during the steady state.
function plot_asymptotic_benchmarks(model, methods; title="",ylimit=nothing,kwargs...)
    bms = filter(bm->bm.completed, MetodBenchmark.(methods, model, false))
    plot()
    for bm in bms
        plot!(bm.lengs,bm.vals,label="",color=bm.color,linestyle=(bm.label=="Bionetgen (SortingDirect)" ? :dash : :solid))
        plot!(bm.lengs,bm.vals,seriestype=:scatter,label=bm.label,color=bm.color,markershape=bm.markershape)
    end
    isempty(bms) && (return (plot(yguide="",xguide="",title=title)))
    isnothing(ylimit) && (ylimit = find_y_limits(bms))
    plot!(;xguide="Model (physical) final time (s)", xlimit=find_x_limits(bms), xticks=ticks, yticks=ticks, ylimit=ylimit, title=title, kwargs...)
end



### Plot Combination of Benchmarks ###

# For a single model, plot all the asymptotic ode benchamrks as 5 subplots.
function plot_full_aymptotic_ode_bms(model; size=(3500,450))
    ylimit = find_y_limits(filter(x->!isempty(x), map(methods -> filter(bm->bm.completed, MetodBenchmark.(methods, model, false; print_missing=false)), methods_ode_all)))
    plots = map((method,title) -> plot_asymptotic_benchmarks(model,method;title=title,yguide="",ylimit=ylimit), methods_ode_all, methods_ode_all_titles)
    plots[1] = plot!(plots[1];yguide="Simulation runtime (ms)", left_margin=20mm)
    plot(plots..., bottom_margin=15mm, top_margin=5mm, size=size, layout=(1,length(plots)))
end

# For a single model, plot all the transient ode benchamrks as 5 subplots.
function plot_full_transient_ode_bms(model; size=(3500,450))
    ylimit = find_y_limits(filter(x->!isempty(x), map(methods -> filter(bm->bm.completed, MetodBenchmark.(methods, model, true; print_missing=false)), methods_ode_all)))
    plots = map((method,title) -> plot_transient_benchmarks(model,method;title=title,yguide="",ylimit=ylimit), methods_ode_all, methods_ode_all_titles)    
    plots[1] = plot!(plots[1];yguide="Simulation runtime (ms)", left_margin=20mm)
    plot(plots..., bottom_margin=5mm, top_margin=5mm, size=size, layout=(1,length(plots)))
end

# For a single model, plot a selection of transient benchmarks as a singe plot.
function plot_selected_transient_ode_bms(model)
    lsodacvode_bms = [method_lsoda, (get_best_result(methods_ode_catalyst_CVODE, model)[1:2]...,methods_ode_catalyst_CVODE[1][3:4]...)]
    julia_bms = sort(get_best_result.(all_julia_solver_grouped, model), by=method->get_ss_method_weigth(method, model))[1:3]
    BioNetGen_bm = [get_best_result(methods_ode_BioNetGen, model)]; BioNetGen_bm = [(BioNetGen_bm[1][1:2]..., methods_ode_BioNetGen[1][3:4]...)];
    COPASI_bm = [get_best_result(methods_ode_COPASI, model)]
    GillesPy2_bm = [get_best_result(methods_ode_GillesPy2, model)]; GillesPy2_bm = [(GillesPy2_bm[1][1:2]..., methods_ode_GillesPy2[1][3:4]...)];
    Matlab_bm = [get_best_result(methods_ode_Matlab, model)]
    selected_benchmarks = [julia_bms, lsodacvode_bms, BioNetGen_bm, COPASI_bm, GillesPy2_bm, Matlab_bm]
    foreach(method -> print_bm_summary(method,model), vcat(selected_benchmarks...)) 
    plot_transient_benchmarks(model, selected_benchmarks)
end
# For a set of (astymptotic) benchmarks, find the most performant one.
get_best_result(methods, model) = sort(methods, by=method->get_ss_method_weigth(method, model))[1]
# For an (astymptotic) method, find its performance (returning Inf if benchmarking was not done for the specific method).
function get_ss_method_weigth(method, model)
    bm = MetodBenchmark(method, model, true; print_missing=false)
    bm.completed ? bm.vals[1] : Inf
end
function print_bm_summary(method, model)
    bm = MetodBenchmark(method, model, true; print_missing=false)
    bm.completed && println(method[2],":\t\t\t",Statistics.median(bm.vals))
end



### Plot Saving Functions ###

# Saves a fugure with various options.
function save_fig(fig, filename; path="")
    savefig(fig, path*filename*".png")
    savefig(fig, path*filename*".svg")
    savefig(fig, path*filename*".pdf")
    decluttered_fig = plot!(deepcopy(fig),legend=:none,xguide="",yguide="")
    savefig(decluttered_fig, path*filename*"_clean.png")
    savefig(decluttered_fig, path*filename*"_clean.svg")
    savefig(decluttered_fig, path*filename*"_clean.pdf")
end



### ---------- ---------- Plot Model Benchmarks ---------- ---------- ###


### Multistate Model ###

# Plot asymptotic ODE benchmarks.
multistate_full_transient_bms_plot = plot_full_transient_ode_bms("multistate")
multistate_full_asymptotic_bms_plot = plot_full_aymptotic_ode_bms("multistate")
multistate_selected_transient_bms_plot = plot_selected_transient_ode_bms("multistate")
multistate_ssa_bms_plot = plot_asymptotic_benchmarks("multistate",methods_ssa)

save_fig(multistate_full_transient_bms_plot, "full_transient_bms"; path="Benchmark_results/Multistate/")
save_fig(multistate_full_asymptotic_bms_plot, "full_asymptotic_bms"; path="Benchmark_results/Multistate/")
save_fig(multistate_selected_transient_bms_plot, "selected_transient_bms"; path="Benchmark_results/Multistate/")
save_fig(multistate_ssa_bms_plot, "ssa_bms"; path="Benchmark_results/Multistate/")


### Multisite2 Model ###
multisite2_full_transient_bms_plot = plot_full_transient_ode_bms("multisite2")
multisite2_full_asymptotic_bms_plot = plot_full_aymptotic_ode_bms("multisite2")
multisite2_selected_transient_bms_plot = plot_selected_transient_ode_bms("multisite2")
multisite2_ssa_bms_plot = plot_asymptotic_benchmarks("multisite2",methods_ssa)

save_fig(multisite2_full_transient_bms_plot, "full_transient_bms"; path="Benchmark_results/Multisite2/")
save_fig(multisite2_full_asymptotic_bms_plot, "full_asymptotic_bms"; path="Benchmark_results/Multisite2/")
save_fig(multisite2_selected_transient_bms_plot, "selected_transient_bms"; path="Benchmark_results/Multisite2/")
save_fig(multisite2_ssa_bms_plot, "ssa_bms"; path="Benchmark_results/Multisite2/")


### Egfr_net Model ###
egfr_net_full_transient_bms_plot = plot_full_transient_ode_bms("egfr_net")
egfr_net_full_asymptotic_bms_plot = plot_full_aymptotic_ode_bms("egfr_net")
egfr_net_selected_transient_bms_plot = plot_selected_transient_ode_bms("egfr_net")
egfr_net_ssa_bms_plot = plot_asymptotic_benchmarks("egfr_net",methods_ssa)

save_fig(egfr_net_full_transient_bms_plot, "full_transient_bms"; path="Benchmark_results/Egfr_net/")
save_fig(egfr_net_full_asymptotic_bms_plot, "full_asymptotic_bms"; path="Benchmark_results/Egfr_net/")
save_fig(egfr_net_selected_transient_bms_plot, "selected_transient_bms"; path="Benchmark_results/Egfr_net/")
save_fig(egfr_net_ssa_bms_plot, "ssa_bms"; path="Benchmark_results/Egfr_net/")


### BCR Model ###
BCR_full_transient_bms_plot = plot_full_transient_ode_bms("BCR")
BCR_full_asymptotic_bms_plot = plot_full_aymptotic_ode_bms("BCR")
BCR_selected_transient_bms_plot = plot_selected_transient_ode_bms("BCR")
BCR_ssa_bms_plot = plot_asymptotic_benchmarks("BCR",methods_ssa)

save_fig(BCR_full_transient_bms_plot, "full_transient_bms"; path="Benchmark_results/BCR/")
save_fig(BCR_full_asymptotic_bms_plot, "full_asymptotic_bms"; path="Benchmark_results/BCR/")
save_fig(BCR_selected_transient_bms_plot, "selected_transient_bms"; path="Benchmark_results/BCR/")
save_fig(BCR_ssa_bms_plot, "ssa_bms"; path="Benchmark_results/BCR/")


### Fceri_gamma Model ###
fceri_gamma2_full_transient_bms_plot = plot_full_transient_ode_bms("fceri_gamma2")
fceri_gamma2_full_asymptotic_bms_plot = plot_full_aymptotic_ode_bms("fceri_gamma2")
fceri_gamma2_selected_transient_bms_plot = plot_selected_transient_ode_bms("fceri_gamma2")
fceri_gamma2_ssa_bms_plot = plot_asymptotic_benchmarks("fceri_gamma2",methods_ssa)

save_fig(fceri_gamma2_full_transient_bms_plot, "full_transient_bms"; path="Benchmark_results/Fceri_gamma2/")
save_fig(fceri_gamma2_full_asymptotic_bms_plot, "full_asymptotic_bms"; path="Benchmark_results/Fceri_gamma2/")
save_fig(fceri_gamma2_selected_transient_bms_plot, "selected_transient_bms"; path="Benchmark_results/Fceri_gamma2/")
save_fig(fceri_gamma2_ssa_bms_plot, "ssa_bms"; path="Benchmark_results/Fceri_gamma2/")


### Summary Figures ###

p_ode = plot(multistate_selected_transient_bms_plot,multisite2_selected_transient_bms_plot,egfr_net_selected_transient_bms_plot,BCR_selected_transient_bms_plot,fceri_gamma2_selected_transient_bms_plot,layout=(1,5),size=(5500,1000),
             legendfontsize=18, tickfontsize=18,xguidefontsize=18,yguidefontsize=18,gridlinewidth=7.0,markersize=20,markerstrokewidth=2)
p_ssa = plot(multistate_ssa_bms_plot,multisite2_ssa_bms_plot,egfr_net_ssa_bms_plot,BCR_ssa_bms_plot,fceri_gamma2_ssa_bms_plot,layout=(1,5),size=(5500,1000),
             lw=20,la=0.7,legendfontsize=18, tickfontsize=18,xguidefontsize=18,yguidefontsize=18,gridlinewidth=7.0,markersize=20,markerstrokewidth=3,legend=:bottomright)
main_benchmarks_plot = plot(p_ode,p_ssa,layout=(2,1),size=(5500,2000),bottom_margin=30mm,left_margin=5mm)

save_fig(main_benchmarks_plot, "benchmarks"; path="Benchmark_results/")

p_ode_all_transient = plot(multistate_full_transient_bms_plot,multisite2_full_transient_bms_plot,egfr_net_full_transient_bms_plot,BCR_full_transient_bms_plot,fceri_gamma2_full_transient_bms_plot,layout=(5,1),size=(5000,3000),
            legendfontsize=18, tickfontsize=18,xguidefontsize=18,yguidefontsize=18,gridlinewidth=7.0,markersize=20,markerstrokewidth=2,markerstrokealpha=0.8)
p_ode_all_asymptotic = plot(multistate_full_asymptotic_bms_plot,multisite2_full_asymptotic_bms_plot,egfr_net_full_asymptotic_bms_plot,BCR_full_asymptotic_bms_plot,fceri_gamma2_full_asymptotic_bms_plot,layout=(5,1),size=(5000,3000),
            lw=16,la=0.5,legendfontsize=18, tickfontsize=18,xguidefontsize=18,yguidefontsize=18,gridlinewidth=7.0,markersize=10,markerstrokewidth=1)

save_fig(p_ode_all_transient, "benchmarks_transient_all"; path="Benchmark_results/")
save_fig(p_ode_all_asymptotic, "benchmarks_asymptotic_all"; path="Benchmark_results/")
