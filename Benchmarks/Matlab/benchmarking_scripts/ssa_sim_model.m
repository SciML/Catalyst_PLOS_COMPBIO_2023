function [t, x, names] = ssa_sim_model(model,leng)
    cs = getconfigset(model);
    cs.SolverType = 'ssa';         
    cs.StopTime = leng;

    cs.RuntimeOptions.StatesToLog = {};
    
    [t, x, names] = sbiosimulate(model);
end