%% Generate CV D-Acc
% Requires libSVM (https://www.csie.ntu.edu.tw/~cjlin/libsvm/)
% CAUTION: The computation requires >2 days


%% Initialization
run('../Subfunctions/init_for_replication.m')


N=10^5;
N_sess = 5;
N_trial = [10 100 1000];
P = 0.5:0.01:1;
SD = NaN(N,length(N_trial),length(P));
for Ntid = 1:length(N_trial)
    for pid = 1:length(P)
        fprintf('Number of trials: %d P: %g    ', N_trial(Ntid),P(pid));
        SD(:,Ntid,pid) = sim_gen_CV1(N,N_trial(Ntid),N_sess,P(pid));
    end
end

save('../Results/Simulation_CV_firstlevel','SD','N','N_sess','N_trial','P')



