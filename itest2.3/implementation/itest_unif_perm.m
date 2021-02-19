function [H, prob, stat] = itest_unif_perm(SD,PD,N_trial,Pcm,g_0,alpha,precision,skip_preparation)
% perform i-test with assumption of 
% 1) uniform prior distribution of gamma and Pcm.
% 2) binomial distribution of true D-Acc distribution with label information (pp_true)
% 3) cross-validated estimation for true D-Acc distribution with label information (pm_true)
% 4) cross-validated estimation for estimated D-Acc distribution (pm_est)
%
% [H, prob, stat] = itest_unif_perm(SD,PD,N_trial,Pcm,g_0,alpha,precision,skip_preparation)
%
% parameter i is optimized to maximize expected statistical power with the assumptions
%
% Inputs
% SD: Sample Decoding Accuracies from experiment (N x 1 matrix)
% PD: Cross-validated Decoding Accuracies from experiment (N x M matrix)
%    (N: Number of participants)
%    (M: Number of cross-validation tirals for each participant)
% N_trial: number of trials
% Pcm: chance level, e.g. 0.5 for binary
% g_0:  Prevalence threshold, gamma0 (Real number between 0 and 1 default:0.5)
% alpha: statistical threshold (Real number between 0 and 1 default:0.05)
% precision:  Precision parameter of Pcp and gamma for deciding i
% skip_preparation: if 1, skip variable format check, reformat, default value insert etc.
%                   for call as subfunction (default:0)
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% H: 1 if Prob < alpha, 0 otherwise
% Prob: Probability
% stat: (structure)
%       .prob_min minimum probability. should be smaller than alpha.
%       .param          predetermined parameters (g_0,i,alpha)
%       .order_stat     i-th order statistic of SD (probability)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2020/11/10 Developed by SH
% 2021/1/25 Modified by SH

%%%%%%%%%%%%%%%%%
%% Preparation %%
%%%%%%%%%%%%%%%%%
% number of subjects
N = size(SD,1);

if ~exist('skip_preparation','var') || ~skip_preparation
    % initial parameters
    if nargin < 3; error('SD, PD, and N_trial is required'); end
    if ~exist('Pcm','var') || isempty(Pcm); Pcm = 0.5;
        warning('Pcm is not specified; Assume binary classification, i.e. Pcm=0.5'); end
    if  ~exist('g_0','var') || isempty(g_0); g_0 = 0.5; end
    if  ~exist('alpha','var') || isempty(alpha); alpha = 0.05; end
    if  ~exist('precision','var') || isempty(precision); precision = 10^-2; end
    
    if ~iscolumn(SD); error('SD should be a N x 1 vector'); end
    if ~all(arrayfun(@isprob,SD)); error('each element of SD should be probability'); end
    if ~all(arrayfun(@isprob,PD)); error('each element of PD should be probability'); end
    if ~isposint(N_trial); error('N_trial should be a positive integer'); end
    if ~isprob(Pcm); error('Pcm should be a probability'); end
    if ~isprob(g_0); error('g_0 should be a probability'); end
    if ~isprob(alpha); error('alpha should be a probability'); end
end

%%%%%%%%%%%%%%%%%
%% Calculation %%
%%%%%%%%%%%%%%%%%
% find i_max and prob_min
i_max = calc_imax(N,g_0,alpha);

% error if i=1 do not satisfy the constraint 
if isnan(i_max) 
    error('Inappropriate predetermined parameters (alpha,g_0) for this small number of subject. Try larger alpha or smaller g_0')
end

% find i_opt
gamma = (g_0+precision):precision:1;
Pcp   = (Pcm+precision):precision:1;
N_p = length(Pcp);

% D-Acc with label information
pp_true = 0:1/N_trial:1;
for pp = 1:N_p
    pp_true(pp+1,:) = binopdf(0:N_trial,N_trial,Pcp(pp));
end

% D-Acc without label information (from cross validaiton)
[possible_p,~,tempind] = unique(PD(:));
freq = accumarray(tempind,1);

pm_true=[possible_p';freq'/sum(freq)];
pm_est = pm_true;

P_sig = calc_Psig(N,g_0,alpha,1:i_max,gamma,pp_true,pm_true,pm_est,1);
i_opt = calc_i_opt_wsum(P_sig);

[H, prob, stat] = itest(SD,pm_est,i_opt,g_0,alpha,1);

end % end of function
