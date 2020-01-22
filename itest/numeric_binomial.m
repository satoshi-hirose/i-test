function [P_sig,T,p_below_T_individual,p_below_T_plus,p_below_T_minus,L] = numeric_binomial(N_trial,N,g_0,alpha,gamma,P_correct_minus,P_correct_plus,i)
% Numerical calculation of the i-test's statistical power (or False alerm ratio).
% The probability that i-test provide significant results is calcualted
% from below input parameters.
% Each participants belongs to Omega+ with probability of gamma.
% If so, the decoder can predict the correct label 
% in each trial with probability of "P_correct_plus";
% If not, he belongs to Omega- and the decoder can predict the correct label 
% with probability of "P_correct_minus", i.e. P_correct_minus = 0.5 if
% binary.

%
% Input: 
%   N_trial: Number of trials for each subject
%   N: Number of subjects
%   
%   g_0: Prevalence threshold, gannma0 (Real number between 0 and 1)
%   alpha: statistical threshold (Real number between 0 and 1)
%   i: the parameter for order statistic
%
%   gamma: see above
%   P_correct_minus: see above 
%   P_correct_plus: see above
%
% Output:
% P_sig: Probability that i-test provide significant resuts.
% T: Threshold of the order statistic;
%     i-test provides significant results when and only when T<order_stat.
% p_below_T_individual: Probability that a participant provide below T D-Acc
% p_below_T_plus: Probability that a participant provide below T D-Acc,
%                                               given he belongs to Omega+
% p_below_T_minus: Probability that a participant provide below T D-Acc,
%                                               given he belongs to Omega-
% L: L of i-test
%
% 2020/1/22 Developed by SH

%% find largest i
i_max = check_imax(N,g_0,alpha);
if strcmp(i,'max'); i=i_max; end

%% Return NaNs if i-test cannot perform with specified parameter set.
if i > i_max | i ==0; warning('too large i and/or too small samples'); 
    P_sig = NaN; T=NaN;p_below_T_individual = NaN;
    p_below_T_plus = NaN;p_below_T_minus = NaN; L = NaN;
return;
end


%% Find Test statistic L, under each value of order statistic (order_stat = 0:N_trial)
order_stat = 0:N_trial;
P_an_below_order_stat_minus = binocdf(order_stat-1,N_trial,P_correct_minus);
Q_n = (1-g_0)*P_an_below_order_stat_minus;
L = binocdf(i-1,N,Q_n);
%% Find threshold of order statistic, T.
T = find(L>=alpha,1,'last')-1; 

if isempty(T);
    disp('No chance to get significant result'); 
    P_sig = NaN; T=NaN;p_below_T_individual = NaN;
    p_below_T_plus = NaN;p_below_T_minus = NaN; L = NaN;
return; end

%% Calculate probability that the order statistic is above T.
p_below_T_plus = binocdf(T,N_trial,P_correct_plus);
p_below_T_minus = binocdf(T,N_trial,P_correct_minus);
p_below_T_individual = p_below_T_minus*(1-gamma) + p_below_T_plus*gamma;
P_sig = binocdf(i-1,N,p_below_T_individual);

% Convert T to Probability
T= T/N_trial;


