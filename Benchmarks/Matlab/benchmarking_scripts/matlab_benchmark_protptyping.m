%%% Multistate %%%
multistate_ss_time = 20;
model_multistate = sbmlimport('../../Data/multistate.xml');
model_multistate_no_obs = sbmlimport('../../Data/multistate_no_obs.xml');

% ODE %

% Check ODE simulation outputs.
[t_ode_multistate, x_ode_multistate, names_multistate] = ode_sim_model(model_multistate,multistate_ss_time);
plot(t_ode_multistate, x_ode_multistate(:,end-3:end))
xlabel('Time')
ylabel('States')
plot_ode_multistate = legend(names_multistate(end-3:end))
saveas(plot_ode_multistate,'../../Plots/Trajectories/Matlab/ode_multistate.png')
saveas(plot_ode_multistate,'../../Plots/Trajectories/Matlab/ode_multistate.pdf')

% Check ODE simulation times.
tic
   ode_sim_model(model_multistate_no_obs,multistate_ss_time);
toc

% SSA %

% Check SSA simulation outputs (display of observables currently not working - error files with Matworks and no response yet).
clean_ssa_sbml_model(model_multistate)
[t_ssa_multistate, x_ssa_multistate, names_multistate] = ssa_sim_model(model_multistate,10.0);
% plot(t_ssa_multistate, x_ssa_multistate(:,end-3:end))
% xlabel('Time')
% ylabel('States')
% plot_ssa_multistate = legend(names_multistate(end-3:end))
% saveas(plot_ssa_multistate,'../../Plots/Trajectories/Matlab/ssa_multistate.png')
% saveas(plot_ssa_multistate,'../../Plots/Trajectories/Matlab/ssa_multistate.pdf')

% Check SSA simulation times.
clean_ssa_sbml_model(model_multistate_no_obs)
tic
   ode_sim_model(model_multistate_no_obs,multistate_ss_time);
toc



%%% Multisite2 %%%
multisite2_ss_time = 2;
model_multisite2 = sbmlimport('../../Data/multisite2.xml');
model_multisite2_no_obs = sbmlimport('../../Data/multisite2_no_obs.xml');

% ODE %

% Check ODE simulation outputs.
[t_ode_multisite2, x_ode_multisite2, names_multisite2] = ode_sim_model(model_multisite2,multisite2_ss_time);
plot(t_ode_multisite2, x_ode_multisite2(:,end-2:end))
xlabel('Time')
ylabel('States')
plot_ode_multisite2 = legend(names_multisite2(end-2:end))
saveas(plot_ode_multisite2,'../../Plots/Trajectories/Matlab/ode_multisite2png')
saveas(plot_ode_multisite2,'../../Plots/Trajectories/Matlab/ode_multisite2.pdf')

% Check ODE simulation times.
tic
   ode_sim_model(model_multisite2_no_obs,multisite2_ss_time);
toc

% SSA %

% Check SSA simulation outputs (display of observables currently not working - error files with Matworks and no response yet).
% clean_ssa_sbml_model(model_multisite2)
% [t_ssa_multisite2, x_ssa_multisite2, names_multisite2] = ssa_sim_model(model_multisite2,multisite2_ss_time);
% plot(t_ssa_multisite2, x_ssa_multisite2(:,end-2:end))
% xlabel('Time')
% ylabel('States')
% plot_ssa_multisite2 = legend(names_multisite2(end-2:end))
% saveas(plot_ssa_multisite2,'../../Plots/Trajectories/Matlab/ssa_multisite2.png')
% saveas(plot_ssa_multisite2,'../../Plots/Trajectories/Matlab/ssa_multisite2.pdf')

% Check SSA simulation times.
clean_ssa_sbml_model(model_multisite2_no_obs)
tic
   ode_sim_model(model_multisite2_no_obs,multisite2_ss_time);
toc


%%% Egfr_net %%%
egfr_net_ss_time = 10;
model_egfr_net = sbmlimport('../../Data/egfr_net.xml');
model_egfr_net_no_obs = sbmlimport('../../Data/egfr_net_no_obs.xml');

% ODE %

% Check ODE simulation outputs.
[t_ode_egfr_net, x_ode_egfr_net, names_egfr_net] = ode_sim_model(model_egfr_net,egfr_net_ss_time);
plot(t_ode_egfr_net, x_ode_egfr_net(:,end-12:end))
xlabel('Time')
ylabel('States')
plot_ode_egfr_net = legend(names_egfr_net(end-12:end))
saveas(plot_ode_egfr_net,'../../Plots/Trajectories/Matlab/ode_egfr_net.png')
saveas(plot_ode_egfr_net,'../../Plots/Trajectories/Matlab/ode_egfr_net.pdf')

% Check ODE simulation times.
tic
   ode_sim_model(model_egfr_net_no_obs,egfr_net_ss_time);
toc

% SSA %
% Gillespie simulations not performed using Matlab for the egfr_net model (Matlab crashes - error files with Matworks and no response yet). %

% Check SSA simulation outputs (display of observables currently not working - error files with Matworks and no response yet).
% clean_ssa_sbml_model(model_egfr_net)
% [t_ode_egfr_net, x_ode_egfr_net, names_egfr_net] = ssa_sim_model(model_egfr_net,egfr_net_ss_time);
% plot(t_ode_egfr_net, x_ode_egfr_net(:,end-12:end))
% xlabel('Time')
% ylabel('States')
% legend(names_egfr_net(end-12:end))

% Check SSA simulation times.
% clean_ssa_sbml_model(model_egfr_net_no_obs)
% tic
%    ode_sim_model(model_egfr_net_no_obs,egfr_net_ss_time);
% toc


%%% BCR %%%
bcr_ss_time = 20000;
model_BCR = sbmlimport('../../Data/BCR.xml');
model_BCR_no_obs = sbmlimport('../../Data/BCR_no_obs.xml');

% ODE %

% Check ODE simulation outputs.
[t_ode_BCR, x_ode_BCR, names_BCR] = ode_sim_model(model_BCR,bcr_ss_time);
plot(t_ode_BCR, x_ode_BCR(:,end-8:end))
xlabel('Time')
ylabel('States')
plot_ode_BCR = legend(names_BCR(end-8:end))
saveas(plot_ode_BCR,'../../Plots/Trajectories/Matlab/ode_BCR.png')
saveas(plot_ode_BCR,'../../Plots/Trajectories/Matlab/ode_BCR.pdf')

% Check ODE simulation times.
tic
   ode_sim_model(model_BCR_no_obs,bcr_ss_time);
toc

% SSA %
% Gillespie simulations not performed using Matlab for the BCR model (Matlab crashes - error files with Matworks and no response yet). %

% Check SSA simulation outputs (display of observables currently not working - error files with Matworks and no response yet).
% clean_ssa_sbml_model(model_BCR)
% [t_ssa_BCR, x_ssa_BCR, names_BCR] = ssa_sim_model(model_BCR,bcr_ss_time);
% plot(t_ssa_BCR, x_ssa_BCR(:,end-8:end))
% xlabel('Time')
% ylabel('States')
% legend(names_BCR(end-8:end))

% Check SSA simulation times.
% clean_ssa_sbml_model(model_BCR_no_obs)
% tic
%    ode_sim_model(model_BCR_no_obs,bcr_ss_time);
% toc


%%% Fceri_gamma2 %%%
fceri_gamma2_ss_time = 150;
model_fceri_gamma2 = sbmlimport('../../Data/fceri_gamma2.xml');
model_fceri_gamma2_no_obs = sbmlimport('../../Data/fceri_gamma2_no_obs.xml');

% ODE %

% Check ODE simulation outputs.
[t_ssa_fceri_gamma2, x_ssa_fceri_gamma2, names_fceri_gamma2] = ode_sim_model(model_fceri_gamma2,fceri_gamma2_ss_time);
plot(t_ssa_fceri_gamma2, x_ssa_fceri_gamma2(:,end-5:end))
xlabel('Time')
ylabel('States')
plot_ode_fceri_gamma2 = legend(names_fceri_gamma2(end-5:end))
saveas(plot_ode_fceri_gamma2,'../../Plots/Trajectories/Matlab/ode_fceri_gamma2.png')
saveas(plot_ode_fceri_gamma2,'../../Plots/Trajectories/Matlab/ode_fceri_gamma2.pdf')

% Check ODE simulation times.
tic
   ode_sim_model(model_fceri_gamma2_no_obs,fceri_gamma2_ss_time);
toc

% SSA %
% Gillespie simulations not performed using Matlab for the fceri_gamma2 model (Matlab crashes - error files with Matworks and no response yet). %

% Check SSA simulation outputs (display of observables currently not working - error files with Matworks and no response yet).
% clean_ssa_sbml_model(model_fceri_gamma2)
% [t_ssa_fceri_gamma2, x_ssa_fceri_gamma2, names_fceri_gamma2] = ssa_sim_model(model_fceri_gamma2,fceri_gamma2_ss_time);
% plot(t_ssa_fceri_gamma2, x_ssa_fceri_gamma2(:,end-5:end))
% xlabel('Time')
% ylabel('States')
% legend(names_fceri_gamma2(end-5:end))

% Check SSA simulation times.
% clean_ssa_sbml_model(model_fceri_gamma2_no_obs)
% tic
%    ode_sim_model(model_fceri_gamma2_no_obs,fceri_gamma2_ss_time);
% toc