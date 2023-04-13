function [t, x, names] = ode_sim_model(model,leng)
    cs = getconfigset(model);
    cs.SolverType = 'sundials';           % Should be either cvode or lsoda.
    cs.StopTime = leng;
    cs.SolverOptions.AbsoluteTolerance = 1e-9;
    cs.SolverOptions.RelativeTolerance = 1e-6;

    cs.RuntimeOptions.StatesToLog = {};
    
    [t, x, names] = sbiosimulate(model);
end