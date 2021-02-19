function [P_sig,param] = calc_Psig_bino(N,g_0,alpha,i,gamma,N_trial,Pcm,Pcp,skip_preparation)
% Numerical calculation of the i-test's statistical power (or False alerm ratio)
% with Binomial distribution assumption.
% The probability that i-test provide significant results is calcualted from below input parameters.
% Each participants belongs to Omega+ with probability of gamma.
% If so, the D-Acc follows the binomial distribution with parameters of N_trial and Pcp.
% If not, he/she belongs to Omega- and D-Acc follows the binomial distribution with parameters of N_trial and Pcm(=chance level),
% e.g. Pcm = 0.5 if binary.
% 
% INPUT
%   N: Number of subjects (positive integer)
%   g_0: Prevalence threshold, gamma0 (Real number between 0 and 1)
%   alpha: statistical threshold (Real number between 0 and 1)
%   i: candidate values of i ('all' (1:i_max) or positive integer or vector)
%   gamma: see above (Vector of Real number between 0 and 1).
%   N_trial: see above (positive integer)
%   Pcm: see above (Real number between 0 and 1)
%   Pcp: see above (Vector of real number between 0 and 1)
%
% OUTPUT
%   P_sig: probability of reportind significant result of i-test. 3-dimensional matrix 
%   with size of [length of i] x [length of gamma] ~ [length of P_correct_plus].
% param: parameters (structure)

% 2020/1/22 Developed by SH modified from Binomial_decide_i, remove output figure, remove simulation etc.

%%%%%%%%%%%%%%%%%
%% Preparation %%
%%%%%%%%%%%%%%%%%
if ~exist('skip_preparation','var') || ~skip_preparation
    % check input format
    if ~isposint(N); error('N should be positive integer'); end
    if ~isprob(g_0); error('g_0 should be probability'); end
    if ~isprob(alpha); error('alpha should be probability'); end
    if ~((isvector(i) && all(arrayfun(@isposint,i))) || strcmp(i,'all')); error('i should be vector of positive integer or ''all'''); end
    if ~(isvector(gamma) && all(arrayfun(@isprob,gamma))); error('gamma should be vector of probability'); end
    if ~isposint(N_trial); error('N_trial should be positive integer'); end
    if ~isprob(Pcm); error('P_correct_minus should be probability'); end
    if ~(isvector(Pcp) && all(arrayfun(@isprob,Pcp))); error('Pcp should be vector of probability'); end
    
    % find largest i & define i if 'all'
i_max = calc_imax(N,g_0,alpha);
if strcmp(i,'all')
    i=1:i_max;
elseif any(i>i_max)
    warning('i > %d are ignored',i_max);
    i = i(i <= i_max);
end
    
end

%%%%%%%%%%%%%%%%%%%%%%
%% Main calculation %%
%%%%%%%%%%%%%%%%%%%%%%
% make the probability of D-Acc 
possible_p = 0:1/N_trial:1;
pm_true = [possible_p; binopdf(0:N_trial,N_trial,Pcm)];
pm_est = pm_true;
N_p = length(Pcp);
pp_true = possible_p;
for pp = 1:N_p
    pp_true(pp+1,:) = binopdf(0:N_trial,N_trial,Pcp(pp));
end

% run decide_i
[P_sig,param] = calc_Psig(N,g_0,alpha,i,gamma,pp_true,pm_true,pm_est,1);

%%%%%%%%%%%%%%%%%%%%%
%% Save Parameters %%
%%%%%%%%%%%%%%%%%%%%%

    param = rmfield(param,{'pp_true','pm_true','pm_est'});
    param.Pcm = Pcm;
    param.Pcp = Pcp;
    param.N_trial = N_trial;
    
end % end of function
