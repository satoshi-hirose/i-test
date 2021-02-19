% Simulaion for the calculation of the probability that i-test reports significant
% results, for the following parameters.
% NOTE: the codes are almost identical to "Numerical_Caliculation_Computation.m",

run('../../Subfunctions/init_for_replication.m')

while 1
    %% Initialization for parallel computing
    clear
    
    % Load the number what should be solved
    % "while" and "try" is used for avoiding the error in the case
    % where one slave try to load the "number.mat"
    % while another slave saving the file "number.mat"
    flg = 1;
    while flg
        try
            load(fullfile('Simulation_CV_Computation','number'))
            my_number = my_number+1;
            save(fullfile('Simulation_CV_Computation','number'),'my_number')
            flg = 0;
        catch
            pause(0.5)
        end
    end
    %% parameters
    % parameters for i-test
    g_0 = 0.5;
    alpha = 0.05;
    i='all';
    
    % number of subjects
    N = 5:100;
    % number of trials
    N_trial = [10 100 1000];
    N_sess = 5;
    
    % true mean percent correct given n belongs to Omega-
    Pcm = 0.5;
    
    % true mean percent correct given n belongs to Omega+
    Pcp = 0.51:0.01:1; %
    
    % true gamma
    gamma = 0:0.01:1;
    
    % number of simulation
    N_sim = 1000;
    
    % load saved results
    Res1 = load('../../Results/Simulation_CV_firstlevel');
    
    %% choose the parameterset to be solved
    % (N_trial,N)
    Nid = mod(my_number-1,length(N))+1;
    Ntid = fix((my_number-1)/length(N))+1;
    
    % decide whether the required computation start.
    if Ntid>length(N_trial); fprintf('\n\n\n    ALL MISSIONS COMPLETE!!\n\n\n'); break; end
    fname = fullfile('Simulation_CV_Computation',[int2str(Ntid) '_' int2str(Nid) '.mat']);
    if exist(fname,'file')
        try load(fname); fprintf('\n %s exist!\n',fname); continue;
        catch; fprintf('\n %s exist, but probably broken!\n The file is renamed.\nPlease check',fname);
            movefile(fname,[fname 'broken'])
        end
    end
    
    
    
    this_N_trial=N_trial(Ntid);
    pm_est = 0:1/this_N_trial:1;
    pm_est(2,:) = binopdf(0:this_N_trial,this_N_trial,Pcm);
    
    tic
    this_N = N(Nid);
    fprintf('Number of Trial: %u, Number of Subject: %u',this_N_trial,this_N)
    i_max = calc_imax(this_N,g_0,alpha);
    
    P_sig= calc_Psig_sim_CV(this_N,this_N_trial,g_0,alpha,1:i_max,gamma,Pcp,Pcm,pm_est,N_sim,Res1);
    fprintf(': finished with %.1fsec\n',toc)
    
    
    save(fname,'alpha','g_0','gamma','N','N_sess','N_sim','N_trial','P_sig','Pcm','Pcp')
    
end
