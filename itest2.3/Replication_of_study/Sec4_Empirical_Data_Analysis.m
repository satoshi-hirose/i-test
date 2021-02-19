% Codes for empirical data analysis (Section 4 of the paper)
% In the code, I do not use the function of the toolbox.
% Instead, the code include main calculation steps for i-test with MATLAB default function, 
% without minor process such as error handling.
% This may help the understanding of computational process of itest.

load Results/Empirical_Experiment_Results SD
N_trial = 150;
g_0 = 0.5;
alpha = 0.05;
Pcm = 0.5;
precision = 0.01;
N = length(SD);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % perform itest-unif-bino, which maximize the expected statistical power with              %%%%%%%
% % assumpiton of binomial distribution for D-Acc and uniform distribution for Pcp and gamma.%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% itest_unif_bino
fprintf('i-test-unif-bino\n')
%% [i_max,prob_min] = calc_imax(N,g_0,alpha);
% find the maximum available i (i_max)

% lower limit of probability (L) for each i
prob_min_list =  binocdf(0:N,N,(1-g_0));
% largest i with lower limit < alpha
i_max = find(prob_min_list<alpha,1,'last'); 

fprintf('i_max was %u\n',i_max)
%% P_sig = calc_Psig_bino(N,g_0,alpha,1:i_max,gamma,N_trial,Pcm,Pcp,1);
% calculate the probability of significant result for combinations of gamma and Pcp

% define integral space
gamma = (g_0+precision):precision:1;
Pcp   = (Pcm+precision):precision:1;

% define possible values of D-Acc
possible_p = 0:1/N_trial:1;
% estimated PMF of D-Acc without label information
pm_est = binopdf(0:N_trial,N_trial,Pcm);
% possible values of order statistic
possible_order_stat = possible_p;
% Probability that a participant's D-Acc without label information (estimated) is below the order statistic,
% for each possible value of order statistic
Pm_est_below_order_stat = cumsum(pm_est); %
Pm_est_below_order_stat(end) = []; % remove the last element (=1)
Pm_est_below_order_stat = [0 Pm_est_below_order_stat]; % add the first element (=0)

% Q for each possible value of order statistic
Q = (1-g_0)*Pm_est_below_order_stat;

% Calculation of statistical power for each i
for i = 1:i_max
    % find L for each possible value of order statistic
    L = binocdf(i-1,N,Q);
    % Find threshold of order statistic, T.
    % i-test report significant result (i.e. L<alpha) when and only when order_stat>T.
    T = possible_order_stat(find(L>=alpha,1,'last'));
    
    % true PMF of D-Acc without label information
    pm_true = binopdf(0:N_trial,N_trial,Pcm);
    % Probability that a participant's D-Acc without label information is equal to or below T
    Pm_atbelow_T = sum(pm_true(T>=possible_p));
    
    for pp = 1:length(Pcp)
        % true PMF of D-Acc with label information
        pp_true = binopdf(0:N_trial,N_trial,Pcp(pp));
        % Probability that a participant's D-Acc with label information is equal to or below T
        % with fixed Pcp
        Pp_atbelow_T = sum(pp_true(T>=possible_p));
        for gg = 1:length(gamma)
            % Probability that a participant's D-Acc is equal to or below T
            % with fixed Pcp and gamma
            P_atbelow_T = (1-gamma(gg))*Pm_atbelow_T + gamma(gg)*Pp_atbelow_T;
            P_sig(i,gg,pp) = binocdf(i-1,N,P_atbelow_T);
        end
    end
end
    
%% i_opt = calc_i_opt_wsum(P_sig);
% expected statistical power with uniform distribution (mean across gamma and Pcp) 
Power = mean(P_sig,[2 3]);
fprintf('the estiamted statistical power was %.2g for i=1, %.2g for i=2 %.2g for i=3\n', Power)
[~,i_opt] = max(Power);

%% [H, prob, stat] = itest(SD,pm_est,i_opt,g_0,alpha,1);

% find i-th order statistic of SD
temp = sort(SD);
order_stat = temp(i_opt);
fprintf('the %u-th order statistic was %.2g\n', i_opt,order_stat)

% estiamte probability that D-Acc without label information < order_stat
P_0 = sum(pm_est(possible_p<order_stat));
fprintf('the probability of D-Acc below the order statistic without label information was %.2g\n', P_0)

% Calculate Q and L
Q = (1-g_0)*P_0;
L = binocdf(i_opt-1,N,Q);
fprintf('L was %.2g\n', L)

% compare L with alpha and if L<alpha, itest reports significant result (H=1)
H =(L<alpha);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % perform itest-one: i=1  %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n\n\ni-test-one\n')
% find minimum order statistic of SD
order_stat_one = min(SD);
fprintf('the first order statistic was %.2g\n', order_stat_one)

% estiamte probability that D-Acc without label information < order_stat
P_0_one = sum(pm_est(possible_p<order_stat_one));
fprintf('the probability of D-Acc below the order statistic without label information was %.2g\n', P_0_one)

% Calculate Q and L
Q_one = (1-g_0)*P_0_one;
L_one = (1-Q_one)^N;
fprintf('L was %.2g\n', L_one)

% compare L with alpha and if L<alpha, itest reports significant result (H=1)
H_one =(L_one<alpha);


%%
%%%%%%%%%%%%%%%%%%%%%
% % The Others  %%%%%
%%%%%%%%%%%%%%%%%%%%%
%% Values for text
% upper 1% point of the null distribution
up1percentpoint = possible_p(find(binocdf(0:N_trial,N_trial,Pcm)>0.99,1));
%  number of subject with D-Acc>upper 1% poin
N_up = sum(SD>=up1percentpoint);
fprintf('%g participants showed the D-Acc above upper 1 %%\n point of the null distribution (%.2g)\n',N_up,up1percentpoint)

