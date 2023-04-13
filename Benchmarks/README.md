# Benchamrks of CRN modelling tools

Tools covered:

1. Catalyst (Run from Julia)
2. Gillespy2 (Run from Python)
3. BioNetGen (run from Python using https://pypi.org/project/bionetgen/)
4. Copasi (Run from Python using basico, https://github.com/copasi/basico)
5. Matlab's Systems Biology Toolbox (Run from Matlab)

Aim is to benchmark:
1. ODE Simulations using LSODA and CVODE.
2. Gillespie-type SSA Simulation simulations for various methods.

### Repository structure

- The folder "Data" contains the model files. This includes 5 models (multistate, multisite2, egfr_net, BCR, and fceri_gamma2). Each model i presented as a .bngl file (read by BioNetGen), a .net file (read by Catalyst via ReactionNetworkImporters), and a .xml file (SBML format, reag by Copasi, Gillespy2, and Matlab). The .net and .xml files are generated from the .bngl file via BioNetGen. There also exists a "_no_obs" version of every file, where the observables are removed (these slows down some solvers). The "_no_obs" versions are used for all benchmarks.
- The folder "Benchmark_results" contain the benchmarking output (saved in json format).
- Five folders, one for each tool (BioNetGen, Catalyst, Copasi, Gillespy2, and Matlab) contain the files for benchmarking this tools. This includes:
  * A "TOOL_benchmark_protptyping" file (typically a jupyter notebook) for testing the code and benchamrks.
  * A "TOOL_make_benchmarks" file, which runs the benchmark for the tool. This is a .jl file for Catalyst, a .py file for BioNetGen, Copasi, and Gillespy2. Matlab instead got 10 separate .m files (located in a "benchmarking_scripts subfolder), each benchmarking a specific model and solver.
  * A run_benchmarks_TOOL.sh file, which runs the benchmarks for that specific tool.
- A "plot_benchmark_results.ipynb" file, which loads the benchmarks and plots them.


### Models

We test the following models:

Multistate
- 9 Species
- 18 Reactions

Multisite2
- 66 Species
- 288 Reactions

egfr_net
- 356 Species
- 3749 Reactions

BCR
- 1122 Species
- 24388 Reactions

fceri_gamma2
- 3744 Species
- 58276 Reactions