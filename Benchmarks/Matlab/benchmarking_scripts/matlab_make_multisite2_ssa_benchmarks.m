%%% Preparations %%%

% Prints number of active threads.
disp("Threads in use: " + maxNumCompThreads)

% Set input.
lengs = logspace(1,4,7);

%Disables warnings (required to run things from an .sh script...).
warning('off')


%%% Benchmarks %%%

%Load model.
model = sbmlimport('../../Data/multisite2_no_obs.xml');
clean_ssa_sbml_model(model)

% Benchmark ODE simulations.
benchmarks = zeros(1,length(lengs));
for i = 1:length(benchmarks)
    f = @() ssa_sim_model(model,lengs(i));
    benchmarks(i) = 1000*timeit(f);
end

% Saves results
output = containers.Map;
output('medians') = benchmarks;
output('lengs') = lengs;

fid = fopen('../../Benchmarking_results/Threads_1/matlab_ssa_multisite2.json','w') ;
encodedJSON = jsonencode(output); 
fprintf(fid, encodedJSON); 
fclose('all'); 