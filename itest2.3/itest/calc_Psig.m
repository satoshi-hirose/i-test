function [P_sig,param] = calc_Psig(N,g_0,alpha,i,gamma,pp_true,pm_true,pm_est,skip_preparation)
% Numerical calculation of the i-test's statistical power (or False alerm ratio).
% The probability that i-test provide significant results is calcualted from below input parameters.
% Each participants belongs to Omega+ with probability of gamma.
% If so, the D-Acc follows the distribution pp_true.
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
%                   (1+[Number of possible PMF with label information] x [number of possible decoding accuracies])
%   pm_true: True distribution of D-Acc without label information. see below[[Possible value of D-Acc]; p_minus];
%                   (2 x [number of possible decoding accuracies])
%   pm_est: Distribution of estimated value of p_correct_minus. If not specified, true distribution is used. 
%                   (2 x [number of possible decoding accuracies])
%   skip_preparation: skip variable format check, reformat, default value insert etc.
%                   for call as subfunction
%
% pp_true, pm_true, and pm_est takes histogram style.
%  pp_true
%   first row : possible value of D-Acc
%   second row- : Probability mass functions with label information
%   Example: For 2 trials for each participants,
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
% specify pm_est with the same format, when pm_est is differnt from pm_true. 
%
% Note: For the continuous distribution, please discretize with sufficient precision
% Example:Approximation of the above example (though it does not make sense)
% 	N_trial = 2;
%   precision = 10^-5;
%   bin =0:precision:1;
%   mu_minus = 0.5; sigma_minus = sqrt(N_trial*mu_minus*(1-mu_minus));
%   mu_plus1  = 0.8; sigma_plus1= sqrt(N_trial*mu_plus1 *(1-mu_plus1));
%   mu_plus2  = 0.9; sigma_plus2= sqrt(N_trial*mu_plus2 *(1-mu_plus2));
%   pp_true = [bin;normpdf(bin,mu_plus1 ,sigma_plus1);normpdf(bin,mu_plus2 ,sigma_plus2)];
%   pm_true = [bin;normpdf(bin,mu_minus,sigma_minus)];
%   pm_est  = pm_true;
%
% Output:
% P_sig: Probability that i-test reports significant resuts. ([Number of i] x [Number of g] x [Number of pp_true])
% param: parameters(structure)

% 2021/1/25 Modified by SH; Matrix computation, instead of for loop. About 10times faster


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
    
    if ~exist('pm_est','var') || isempty(pm_est); pm_est = pm_true;
    elseif ~isp(pm_est) ; error('pm_est should satisfy specified format. type ''help isp'''); end
    
    % find largest i & define i if 'all'
    i_max = calc_imax(N,g_0,alpha);
    if strcmp(i,'all')
        i=1:i_max;
    elseif any(i>i_max)
        warning('i > %d are ignored',i_max);
        i = i(i <= i_max);
    end
    
    % Return NaNs if i-test cannot perform with specified parameter set.
    if isnan(i) || isempty(i)
        P_sig = NaN;param = NaN;
        if isnan(i)
            warning('Inappropriate predetermined parameters (alpha,g_0) for this small number of subject. Try larger alpha or smaller g_0')
        elseif isempty(i)
            warning('Any specified i is not available. Try smaller i')
        end
        return;
    end
end
% count the number of i, gamma, p_plus
N_i = length(i);
N_g = length(gamma);
N_p = size(pp_true,1)-1;

%%%%%%%%%%%%%%%%%%%%%%
%% Main calculation %%
%%%%%%%%%%%%%%%%%%%%%%



% Find Q, under each possible value of order statistic
order_stat = pm_est(1,:); % possible value of order statistic (a_(i))
Pm_est_below_order_stat = cumsum(pm_est(2,:)); %
Pm_est_below_order_stat(end) = []; % remove the last element (=1)
Pm_est_below_order_stat = [0 Pm_est_below_order_stat]; % add the first element (=0)
Q = (1-g_0)*Pm_est_below_order_stat;

% [N_i x size(pm_est,2)] matrix
Q_mat = repmat(Q(:)',[N_i,1]);
i_mat = repmat(i(:),[1,size(pm_est,2)]);
L_mat = binocdf(i_mat-1,N,Q_mat);

for ii = 1:N_i
    T(ii,1) = order_stat(find(L_mat(ii,:)>=alpha,1,'last'));
end

% [N_i x size(pm_true,2)] matrix
    pm_true_below_T_mat = repmat(T,[1,size(pm_true,2)]) >= repmat(pm_true(1,:),[N_i,1]); % equal to or below
    % binary [N_i x size(pm_true,2)] matrix whether each possible value of pm_true are higher than T for each i
    pm_true_prob_mat = repmat(pm_true(2,:),[N_i,1]);

% [N_i x 1] matrix
% probability that D-Acc without label information are at or below T for each i
Pm_atbelow_T = sum(pm_true_prob_mat.*pm_true_below_T_mat,2);

% [N_i x N_p x size(pp_true,2)] matrix (mat3)
    pp_true_below_T_mat = repmat(permute(repmat(T,[1,size(pp_true,2)]) >= repmat(pp_true(1,:),[N_i,1]),[1,3,2]),[1,N_p,1]);
    % binary [N_i x N_p x size(pp_true,2)] matrix whether each possible value of pp_true are higher than T for each i
    pp_true_prob_mat = repmat(permute(pp_true(2:end,:),[3,1,2]),[N_i,1,1]);

% [N_i x Np] matrix
% probability that D-Acc with label information are at or below T for each i, for each pp_true distribution
Pp_atbelow_T = sum(pp_true_prob_mat.*pp_true_below_T_mat,3); 

% [N_i x  N_g x N_p] matrix (mat3)
gamma_mat3 = repmat(permute(gamma(:),[2 1 3]),[N_i,1,N_p]);
Pm_atbelow_T_mat3 = repmat(Pm_atbelow_T,[1,N_g,N_p]);
Pp_atbelow_T_mat3 = repmat(permute(Pp_atbelow_T,[1 3 2]),[1,N_g,1]);
i_mat3 = repmat(i(:),[1,N_g,N_p]);

P_atbelow_T_mat3 = (1-gamma_mat3).*Pm_atbelow_T_mat3 + gamma_mat3.*Pp_atbelow_T_mat3;
P_atbelow_T_mat3(P_atbelow_T_mat3>1)=1;
P_sig = binocdf(i_mat3-1,N,P_atbelow_T_mat3);



%% save parametes
param=struct('N',N,'g_0',g_0,'alpha',alpha,'i',i,'gamma',gamma,'pp_true',pp_true,'pm_true',pm_true,'pm_est',pm_est);

end % end of function
