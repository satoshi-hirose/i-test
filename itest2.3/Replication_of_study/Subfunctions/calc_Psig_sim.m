function P_sig= calc_Psig_sim(N,g_0,alpha,i,gamma,pp_true,pm_true,pm_est,N_sim,skip_preparation)
% Simulation for calculation of the i-test's statistical power (or False alerm ratio).
% The probability that i-test provide significant results is calcualted from below input parameters.
% Each participants belongs to Omega+ with probability of gamma.
% If so, the D-Acc follows the distribution pcp_true.
% If not, he/she belongs to Omega- and
% the D-Acc follows the distribution pm_true.
%
% Input:
%   N: Number of subjects (Positive Integer)
%   g_0: Prevalence threshold, gamma0 (Real number between 0 and 1)
%   alpha: statistical threshold (Real number between 0 and 1)
%   i: parameter for order statistic (vector of positive integer. Or 'all' for all possible values, 1:i_max)
%   gamma: see above (Vector of real number between 0 and 1)
%   pp_true: True distribution of D-Acc with label information. see below[[Possible value of D-Acc]; p_plus];
%                   (1+[Number of possible PMF with label information]) x [number of possible decoding accuracies]
%   pm_true: True distribution of D-Acc without label information. see below[[Possible value of D-Acc]; p_minus];
%                   (2 x [number of possible decoding accuracies])
%   pm_est: Estimated value of p_correct_minus. If not specified, true distribution is used.
%                   (2 x [number of possible decoding accuracies])
%   skip_preparation: skip variable format check, reformat, default value insert etc.
%                   for call as subfunction
%
%   N_sim: Number of simulation (only used when numeric=0; default: 500)
%
% pp_true, pm_true, and pm_est takes histogram style.
%  pp_true
%   first row : possible value of D-Acc
%   second row- : Probability mass functions with label information
%   Example: For 2 trials for each participants for binary decoding (chance = 50%),
%            and assume that decoding accuracy follows binomial distribution,
%            and the probability of the correct decoding for each trials
%            for Omega+ is 80% or 90%
%    pp_true     =  [0       0.5      1    % 0:1/2:1
%                    0.04    0.32    0.64 %binopdf(0:2,2,0.8)
%                    0.01    0.18    0.81] %binopdf(0:2,2,0.9)
%
% pm_true and pm_est (2 x [number of possible decoding accuracies] )
%   Example: For 2 trials for each participants for binary decoding (chance = 50%),
%            and assume that decoding accuracy follows binomial distribution,
%    pm_true     =  [0       0.5      1    % 0:1/2:1
%                    0.25    0.0.5    0.25] %binopdf(0:2,2,0.5)
% specify pm_est with the same format If pm_est is differnt from pm_true.
%
% Note: For the continuous distribution, please discretize with sufficient precision
% Example:Approximation of the above example (though it does not make sense)
% 	N_trial = 2;
%   precision = 10^-6;
%   bin =0:precision:1;
%   mu_minus = 0.5; sigma_minus = sqrt(N_trial*mu_minus*(1-mu_minus));
%   mu_plus1  = 0.8; sigma_plus1= sqrt(N_trial*mu_plus1 *(1-mu_plus1));
%   mu_plus2  = 0.9; sigma_plus2= sqrt(N_trial*mu_plus2 *(1-mu_plus2));
%   pp_true = [bin;normpdf(bin,mu_plus1 ,sigma_plus1);normpdf(bin,mu_plus2 ,sigma_plus2)];
%   pm_true = [bin;normpdf(bin,mu_minus,sigma_minus)];
%   pm_est  = pm_true;
%
% OUTPUT
% P_sig: Probability that i-test reports significant resuts. ([Number of i] x [Number of g] x [Number of pp_true])
% param: parameters(structure)

% 2020/7/13 Developed by SH (generalized version of decide_i_binomial.m)
% 2020/7/14 Modified by SH (simulation can be selected)
% 2020/7/15 Modified by SH (make input p cell, output parameters)
% 2020/11/9 Edited by SH
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
    if ~isp(pp_true); error('pp_true should satisfy specified format. type ''help isp'''); end
    if ~isp(pm_true) && size(pm_true,1)==2; error('pm_true should satisfy specified format. type ''help isp'''); end
    if ~isposint(N_sim); error('N_sim should be positive integer'); end
    
    if ~exist('pm_est','var'); pm_est = pm_true;
    else; ~isp(pm_est) && size(pm_est,1)==2; error('pm_est should satisfy specified format. type ''help isp'''); end
end

% find largest i & define i if 'all'
i_max = calc_imax(N,g_0,alpha);
if strcmp(i,'all')
    i=1:i_max;
elseif any(i>i_max)
    warning('i > %d are ignored',i_max);
    i = i(i <= i_max);
end

% Return NaNs if i-test cannot perform with specified parameter set.
if any(isnan(i)) || any(isempty(i))
    P_sig = NaN;
    if isnan(i)
        warning('Inappropriate predetermined parameters (alpha,g_0) for this small number of subject. Try larger alpha or smaller g_0')
    elseif isempty(i)
        warning('Any specified i is available. Try smaller i')
    end
    return;
end
% count the number of i, gamma, p_plus
N_i = length(i);
N_g = length(gamma);
N_p = size(pp_true,1)-1;


% prepare output
P_sig = zeros(N_i,N_g,N_p);


%%%%%%%%%%%%%%%%%%%%%%
%% Main calculation %%
%%%%%%%%%%%%%%%%%%%%%%
% Calculation of P_sig for each combination of gamma, p_plus and i
for gg = 1:N_g
    for pp = 1:N_p
        SD(:,:,pp,gg) = sim_gen(N,N_sim,gamma(gg),pp_true([1 1+pp],:),pm_true);
    end
end
for ii = 1:N_i
    Sig = itest_multi(SD,pm_est,i(ii),g_0,alpha);
    P_sig(ii,:,:) = permute(mean(Sig,2),[1 4 3 2]);
end
end % end of function

