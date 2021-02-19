function [H, prob, stat] = itest_ml_bino(SD,N_trial,Pcm,g_0,alpha,precision,skip_preparation)
% perform i-test with assumption of 
% 1) Data-driven Maximum likelihood estimation of gamma and Pcm is used as prior.
% 2) binomial distribution of true D-Acc distribution with label information (pp_true)
% 3) binomial distribution of true D-Acc distribution with label information (pm_true)
% 4) binomial distribution of estimated D-Acc distribution (pm_est)
%
% [H, prob, stat] = itest_ml_bino(SD,N_trial,Pcm,g_0,alpha,precision,skip_preparation)
%
% parameter i is optimized to maximize expected statistical power with the assumptions
%
% Inputs
% SD: Sample Decoding Accuracies from experiment (N x 1 matrix)
%                 (N: Number of participants)
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
    if nargin < 2; error('SD and N_trial is required'); end
    if ~exist('Pcm','var') || isempty(Pcm); Pcm = 0.5;
        warning('Pcm is not specified; Assume binary classification, i.e. Pcm=0.5'); end
    if  ~exist('g_0','var') || isempty(g_0); g_0 = 0.5; end
    if  ~exist('alpha','var') || isempty(alpha); alpha = 0.05; end
    if  ~exist('precision','var') || isempty(precision); precision = 0.01; end
    
    if ~iscolumn(SD); error('SD should be a N x 1 vector'); end
    if ~all(arrayfun(@isprob,SD)); error('each element of SD should be probability'); end
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
[Likelihood,g_mat,Pcp_mat] = calc_likelihood(SD,N_trial,Pcm,g_0,precision);
[~,ML_index] = max(Likelihood(:));
Pcp   = Pcp_mat(ML_index);
gamma = g_mat(ML_index);

P_sig = calc_Psig_bino(N,g_0,alpha,1:i_max,gamma,N_trial,Pcm,Pcp,1);
[~,i_opt] = max(P_sig);

pm_est = [(0:N_trial)/N_trial; binopdf(0:N_trial,N_trial,Pcm)];
[H, prob, stat] = itest(SD,pm_est,i_opt,g_0,alpha,1);

end % end of function
