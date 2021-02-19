%% Generate CV D-Acc
% Requires libSVM (https://www.csie.ntu.edu.tw/~cjlin/libsvm/)


%% Initialization
run('../../Subfunctions/init_for_replication.m')
% fill your libSVM MATLAB directory path
% addpath('your libSVM MATLAB directory path')
addpath /project/doraemon/hirose/matlab_toolbox/libsvm-3.21/matlab/

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
            load(fullfile('Simulation_CV_firstlevel','number'))
            my_number = my_number+1;
            save(fullfile('Simulation_CV_firstlevel','number'),'my_number')
            flg = 0;
        catch
            pause(0.5)
        end
    end
    
    
    %% parameters
    N=10^5;
    N_sess = 5;
    N_trial = [10 100 1000];
    P = 0.5:0.01:1;
    SD = NaN(N,length(N_trial),length(P));
    
    %% choose the parameterset to be solved
    % (N_trial,P)
    pid = mod(my_number-1,length(P))+1;
    Ntid = fix((my_number-1)/length(P))+1;
    
    % decide whether the required computation start.
    if Ntid>length(N_trial); fprintf('\n\n\n    ALL MISSIONS COMPLETE!!\n\n\n'); break; end
    fname = fullfile('Simulation_CV_firstlevel',[int2str(Ntid) '_' int2str(pid) '.mat']);
    if exist(fname,'file')
        try load(fname); fprintf('\n %s exist!\n',fname); continue;
        catch; fprintf('\n %s exist, but probably broken!\n The file is renamed.\nPlease check',fname);
            movefile(fname,[fname 'broken'])
        end
    end
    %% Main calculation
    fprintf('Number of trials: %d P: %g    ', N_trial(Ntid),P(pid));
    SD = sim_gen_CV1(N,N_trial(Ntid),N_sess,P(pid));
    
    save(fname,'SD','N','N_sess','N_trial','P')
    
    
    
end
