%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Numerical_Calculation_Computation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% takes < two hours without parallel computing

%% before the calcualtion of slaves
mkdir Numerical_Calculation_Computation
my_number = 0;
save Numerical_Calculation_Computation/number my_number

%% after the calcualtion of slaves
mkdir ../../Results
copyfile Numerical_Calculation_Computation/Numerical_Caliculation_Computation_g0_* ../../Results/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation_CV_firstlevel %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% takes < two days without parallel computing

%% before the calcualtion of slaves
mkdir Simulation_CV_firstlevel
my_number = 0;
save Simulation_CV_firstlevel/number my_number

%% after the calcualtion of slaves
N=10^5;
N_sess = 5;
N_trial = [10 100 1000];
P = 0.5:0.01:1;
SD = NaN(N,length(N_trial),length(P));
for Ntid = 1:length(N_trial)
    for pid = 1:length(P)
        Res = load(fullfile('Simulation_CV_firstlevel',[int2str(Ntid) '_' int2str(pid)]));
        SD(:,Ntid,pid) = Res.SD;
    end
end
save('../../Results/Simulation_CV_firstlevel','SD','N','N_sess','N_trial','P')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation_CV_Computation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% takes < two weeks without parallel computing

%% before the calcualtion of slaves
mkdir Simulation_CV_Computation
my_number = 0;
save Simulation_CV_Computation/number my_number

%% after the calcualtion of slaves
g_0 = 0.5;
alpha = 0.05;
N = 5:100;
N_trial = [10 100 1000];
N_sess = 5;
Pcm = 0.5;
Pcp = 0.51:0.01:1; 
gamma = 0:0.01:1;
N_sim = 1000;

for Ntid = 1:length(N_trial)
    for Nid = 1:length(N)
        Res = load(fullfile('Simulation_CV_Computation',[int2str(Ntid) '_' int2str(Nid)]));
        P_sig{Ntid,Nid}= Res.P_sig;

    end
end
save(['../../Results/Simulation_CV_Computation'],'alpha','g_0','gamma','N','N_sess','N_sim','N_trial','P_sig','Pcm','Pcp') 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation_Binomial_Computation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% takes < two weeks without parallel computing

%% before the calcualtion of slaves
mkdir Simulation_Binomial_Computation
my_number = 0;
save Simulation_Binomial_Computation/number my_number

%% after the calcualtion of slaves
g_0 = 0.5;
alpha = 0.05;
N = 5:100;
N_trial = 10.^(1:3);
Pcm = 0.5;
Pcp = 0.51:0.01:1; % 
gamma = 0:0.01:1;
N_sim = 1000;

for Ntid = 1:length(N_trial)
    for Nid = 1:length(N)
 Res = load(fullfile('Simulation_Binomial_Computation',[int2str(Ntid) '_' int2str(Nid)]));
        P_sig{Ntid,Nid}= Res.P_sig;        
    end
end

save(['../../Results/Simulation_Binomial_Computation'],'P_sig','N_trial','gamma','N','Pcp','Pcm','alpha','g_0','N_sim')





