%%% Preparations %%%

% Prints number of active threads.
disp("Threads in use: " + maxNumCompThreads)

% Set input.
lengs = logspace(2.176,2.176,1);


%%% Benchmarks %%%

%Load model.
model = sbmlimport('../../Data/fceri_gamma2_no_obs.xml');


% Benchmark ODE simulations.
benchmarks = zeros(1,length(lengs));
for i = 1:length(benchmarks)
    f = @() ode_sim_model(model,lengs(i));
    benchmarks(i) = 1000*timeit(f);
end

% Saves results
output = containers.Map;
output('medians') = benchmarks;
output('lengs') = lengs;

fid = fopen('../../Benchmarking_results/Threads_1/matlab_ss_sim_ode_fceri_gamma2.json','w') ;
encodedJSON = jsonencode(output); 
fprintf(fid, encodedJSON); 
fclose('all'); 