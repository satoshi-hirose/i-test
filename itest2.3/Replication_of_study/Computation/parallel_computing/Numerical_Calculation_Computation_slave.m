% Numerical calculation of the probability that i-test reports significant
% results, for the following parameters.



run('../../Subfunctions/init_for_replication.m')

while 1
    %% Initialization for parallel computing
    clear
    
    % Load the number what should be solved
    % "while" and "try" is used for avoiding the error in the case
    % where one slave try to load the "number.mat"
    % while one slave saving the file "number.mat"
    flg = 1;
    while flg
        try
            load(fullfile('Numerical_Calculation_Computation','number'))
            my_number = my_number+1;
            save(fullfile('Numerical_Calculation_Computation','number'),'my_number')
            flg = 0;
        catch
            pause(0.5)
        end
    end
    
    
    %% parameters
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
    
    %% choose the parameterset to be solved
    % (g_0)
    g0ind = my_number;
    if g0ind>length(g_0_all)  fprintf('\n\n\n    ALL MISSIONS COMPLETE!!\n\n\n'); break; end
    g_0 = g_0_all(g0ind);
    fname =   ['Numerical_Calculation_Computation/Numerical_Caliculation_Computation_g0_' int2str(g_0*10), '.mat'];
    if exist(fname,'file')
        try load(fname); fprintf('\n %s exist!\n',fname); continue;
        catch; fprintf('\n %s exist, but probably broken!\n The file is renamed.',fname);
        end
    end
    
    %% Main calculation
    
    N = n_min(g0ind):n_max;
    P_sig=cell(length(N_trial),length(N));
    if exist(fname,'file'); continue; end
    for Ntid = 1:length(N_trial)
        this_N_trial=N_trial(Ntid);
        for Nid = 1:length(N)
            this_N = N(Nid);
            fprintf('g_0: %g, Number of Trial: %u, Number of Subject: %u\n',g_0,this_N_trial,this_N)
            i_max = calc_imax(this_N,g_0,alpha);
            P_sig{Ntid,Nid} = calc_Psig_bino(this_N,g_0,alpha,1:i_max,gamma,this_N_trial,Pcm,Pcp,1);
        end
    end
    
    save(fname, 'P_sig','N_trial','gamma', 'N','Pcm','Pcp','alpha','g_0')
end