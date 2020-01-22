% parameters for i-test
g_0 = 0.5;
alpha = 0.05;

% true mean percent correct given n belongs to Omega-
P_correct_minus = 0.5;
% true mean percent correct given n belongs to Omega+0.45:0.01:0.60

% number of subjects
N = 50;
% true gamma
gamma = 0.8;

i_max = check_imax(N,g_0,alpha);




%% Small effect size

N_trial = 1000;
P_correct_plus = 0.53;

[P_sig,T,p_below_T_individual] ...
 = decide_i(N,N_trial,g_0,alpha,P_correct_minus,gamma,P_correct_plus);

axis([0 i_max+1 0 1]) 
title('Statistical Power 1: FigureA1A')

%% few trial
N_trial = 10;
P_correct_plus = 0.9;

i_max = check_imax(N,g_0,alpha);

[P_sig,T,p_below_T_individual,p_below_T_plus,p_below_T_minus,L] ...
    = decide_i(N,N_trial,g_0,alpha,P_correct_minus,gamma,P_correct_plus);


axis([0 i_max+1 0 1]) 
title('Statistical Power 2: Figure A1B')


return

