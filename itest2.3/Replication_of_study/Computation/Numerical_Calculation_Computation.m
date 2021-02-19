% Numerical calculation of the probability that i-test reports significant
% results, for the following parameters.
% CAUTION: The computation takes >1 hours and requires ~50GB system memory


run('../Subfunctions/init_for_replication.m')


g_0_all = [0.1 0.3 0.5 0.7];

% parameters for i-test
alpha = 0.05;
i='all';

% number of subjects
n_min = [2 3 5 9];
n_max = 100;
% number of trials
N_trial = 10.^(1:3);

% true mean percent correct given n belongs to Omega-
Pcm = 0.5;

% true mean percent correct given n belongs to Omega+
Pcp = 0.51:0.01:1;

% true gamma
gamma = 0:0.01:1;

for g0ind = 1:length(g_0_all)
    g_0 = g_0_all(g0ind);
    N = n_min(g0ind):n_max;
    P_sig=cell(length(N_trial),length(N));
    for Ntid = 1:length(N_trial)
        this_N_trial=N_trial(Ntid);
        for Nid = 1:length(N)
            this_N = N(Nid);
            fprintf('g_0: %g, Number of Trial: %u, Number of Subject: %u\n',g_0,this_N_trial,this_N)
            i_max = calc_imax(this_N,g_0,alpha);
            P_sig{Ntid,Nid} = calc_Psig_bino(this_N,g_0,alpha,1:i_max,gamma,this_N_trial,Pcm,Pcp,1);
        end
    end
    
    save(['../Results/Numerical_Caliculation_Computation_g0_' int2str(g_0*10)], 'P_sig','N_trial','gamma', 'N','Pcm','Pcp','alpha','g_0')
end
