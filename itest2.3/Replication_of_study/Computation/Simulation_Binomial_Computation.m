% Simulaion for the calculation of the probability that i-test reports significant
% results, for the following parameters.
% CAUTION: The computation requires >1 week
% NOTE: the codes are almost identical to "Numerical_Caliculation_Computation.m",

run('../Subfunctions/init_for_replication.m')

% parameters for i-test
g_0 = 0.5;
alpha = 0.05;
i='all';

% number of subjects
N = 5:100;

% number of trials
N_trial = 10.^(1:3);

% true mean percent correct given n belongs to Omega-
Pcm = 0.5;

% true mean percent correct given n belongs to Omega+
Pcp = 0.51:0.01:1; % 

% true gamma
gamma = 0:0.01:1;

% number of simulation
N_sim = 1000;

P_sig=cell(length(N_trial),length(N));
for Ntid = 1:length(N_trial)
    this_N_trial=N_trial(Ntid);
    % generate binomial distribution
    pm = 0:1/this_N_trial:1;
    pm(2,:) = binopdf(0:this_N_trial,this_N_trial,Pcm);
    pp = 0:1/this_N_trial:1;
    [Ntmesh,Pcpmesh] = meshgrid(0:this_N_trial,Pcp);
    pp = [pp;binopdf(Ntmesh,this_N_trial,Pcpmesh)];
    for Nid = 1:length(N)
        tic
        this_N = N(Nid);
        fprintf('Number of Trial: %u, Number of Subject: %u',this_N_trial,this_N)
        i_max = calc_imax(this_N,g_0,alpha);
        P_sig{Ntid,Nid}= calc_Psig_sim(this_N,g_0,alpha,1:i_max,gamma,pp,pm,pm,N_sim,1);
        fprintf(': finished with %.1fsec\n',toc)
        
    end
end

save(['../Results/Simulation_Binomial_Computation'],'P_sig','N_trial','gamma','N','Pcp','Pcm','alpha','g_0','N_sim')


