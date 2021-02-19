function [H, prob, stat] = itest_woid(SD,pm_est,i,g_0,alpha,skip_perser)
% perform i-test WithOut the assumption of Identical Distribution among participants.
%
% [H, prob, stat] = itest_woid(SD,PD,g_0,alpha,i,skip_perser)
%
% Inputs
% SD: Sample Decoding Accuracies from experiment (N x 1 matrix)
% pm_est: (see below for detail): estimated distribution of D-Acc without label information
% g_0:  Prevalence threshold, gamma0 (Real number between 0 and 1 default:0.5)
% alpha: statistical threshold (Real number between 0 and 1 default:0.05)
% i:    Index of order statistics (Positve Integer)
% skip_perser: skip variable format check, reformat, default value insert etc. for call as subfunction
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% H: 1 if prob < alpha, 0 otherwise
% Prob: Probability (L)
% stat: (structure)
%       .prob_min minimum probability. should be smaller than alpha to perform i-test.
%       .param          predetermined parameters (g_0,i,alpha)
%       .order_stat     i-th order statistic of SD (probability)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input pm_est:
% the decoding accuracy distribution
% under the null hypothesis "there is no label information in the brain".
% This is assumed by a statistical model, e.g. binomial distribution
% or empirically estimated by e.g. permutation test.
% The distribution can be specified with
% results of empirical estimation (list of empirical estimation) or
% histogram style (similar to output of MATLAB function "hist").
%
% -----------------------------------------------------
% 1) Histogram style.
% N x 1 cell, each cell contains 2 x [number of possible decoding accuracies]
% Example: If there is a subject with 2 trials of binary decoding and another with 4 trials,
%          And assume that decoding accuracy follows binomial distribution,
%          pm_est{1,1}    =  [0       0.5      1
%                              0.25    0.5     0.25]
%          pm_est{2,1}    =  [0       0.25      0.5      0.75     1
%                              0.0625  0.25    0.375   0.25   0.0625]
%
% -----------------------------------------------------
% 2) results of the empirical estimation procedure.
% N x [Number of repetition] matrix
% Example: After permutation test with 1,000 repetition for each of 10 participants,
% pm_est is 10 x 1,000 matrix.

% SH 2020/11/9 separate from "itest.m"
% SH 2020/11/10 Added a warning that N should be <15 (nchoosek)



%%%%%%%%%%%%%%%%%
%% Preparation %%
%%%%%%%%%%%%%%%%%
N = size(SD,1);% number of subjects
if N>=15
    warning('i-test-woid cannot apply when N>=15.')
    warning('The results can be inaccurate and/or huge computational cost is required')
    warning('see https://jp.mathworks.com/help/matlab/ref/nchoosek.html')
end
% find prob_min
prob_min =  binocdf(i-1,N,(1-g_0));

%%%%%%%%%%%%%%%%%%
%% input perser %%
%%%%%%%%%%%%%%%%%%

if ~exist('skip_perser','var') || ~skip_perser
    %% initial parameters
    if nargin < 3; error('Three inputs (SD, pm_est and i) are required'); end
    if ~exist('g_0','var'); g_0 = 0.5; end
    if ~exist('alpha','var'); alpha = 0.05; end
    
    % find prob_min and error if parameters are inappropriate
    if prob_min>alpha
        error('Inappropriate predetermined parameters (alpha,g_0,i) for this number of subject. Try smaller i')
    end
    
    
    % check input format
    if ~isprobvec(SD); error('SD should be probability vector'); end
    if isnumeric(pm_est) && all(arrayfun(@isp,pm_est),'all') && size(pm_est,1)==N 
    elseif iscell(pm_est) && all(cellfun(@(xx) size(xx,1)==2,pm_est)) && all(cellfun(@isp,pm_est)) && size(pm_est,1)==N
    else; error('the style of PD is wrong. type "help itest_woid"');
    end
    if ~isposint(i); error('i should be positive integer'); end
    if ~isprob(g_0); error('g_0 should be probability'); end
    if ~isprob(alpha); error('alpha should be probability'); end
    
end

%%%%%%%%%%%%%%%%%
%% Preparation %%
%%%%%%%%%%%%%%%%%

% reformat PD if style 2) for resutls of empirical estimation procedure
if isnumeric(pm_est)
    pm_est_old = pm_est;clear pm_est;
    for n = 1:N
        pm_est{n} = [pm_est_old(n,:);ones(1,size(pm_est_old,2))/size(pm_est_old,2)];
    end
end

%%%%%%%%%%%%%%%%%%%%%%
%% Main calculation %%
%%%%%%%%%%%%%%%%%%%%%%

% find i-th order statistic of SD
temp = sort(SD);
order_stat = temp(i);

% find probability of PD >= order_stat for each participant
for n = 1:N
    P_0(n,1) = sum(pm_est{n}(2,pm_est{n}(1,:)<order_stat));
end
% Find Q
Q = (1-g_0)*P_0;
% Find L
L = 0;
for ii = 0:i-1 % number of subjects P(a_n)<a(i)
    ind_0 = nchoosek(1:N,ii); % subject index of D-Acc < order_stat
    for jj = 1:size(ind_0,1)
        sub_info = ones(N,1);
        sub_info(ind_0(jj,:)) = 0;
        this_PA = prod((1-Q).^sub_info.*Q.^(1-sub_info));
        L = L+this_PA;
    end
end

%% evaluation, make output
H =(L<alpha);
prob = L;

stat.prob_min = prob_min;
stat.param = struct('g_0',g_0,'i',i,'alpha',alpha);
stat.order_stat = order_stat;

end % end of function

