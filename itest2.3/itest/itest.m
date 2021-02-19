function [H, prob, stat] = itest(SD,pm_est,i,g_0,alpha,skip_preparation)
% perform i-test.
% [H, prob, stat] = itest(SD,PD,g_0,alpha,i,identical)
% Inputs
% SD: Sample Decoding Accuracies from experiment (N x 1 matrix)
% pm_est: (see below for detail): estimated distribution of D-Acc without label information
% g_0:  Prevalence threshold, gamma0 (Real number between 0 and 1 default:0.5)
% alpha: statistical threshold (Real number between 0 and 1 default:0.05)
% i:    Index of order statistics (Positve Integer)
% skip_preparation: skip variable format check, reformat, default value insert etc.
%                   for call as subfunction
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% H: 1 if prob < alpha, 0 otherwise
% Prob: Probability
% stat: (structure)
%       .prob_min minimum probability. should be smaller than alpha.
%       .param          predetermined parameters (g_0,i,alpha)
%       .order_stat     i-th order statistic of SD (probability)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input pm_est:
% the decoding accuracy distribution
% under the null hypothesis "there is no label information in the brain".
% This is assumed by a statistical model, e.g. binomial distribution
% or empirically estimated by e.g. permutation test.
% The distribution can be specified with results of empirical estimation (list of empirical estimation) or
% assumption of distribution with histogram style (similar to output of MATLAB function "hist").
% -----------------------------------------------------
% 1) Histogram style.
% 2 x [number of possible decoding accuracies] matrix,
% Example: If there's 2 trials of binary decoding (chance = 50%) for each participants,
%          And assume that decoding accuracy follows binomial distribution,
%          pm_est    =  [0       50      100
%                         0.25    0.5     0.25]
% -----------------------------------------------------
% 2) results of the empirical estimation procedure.
% 1 x [Number of repetition] matrix
% Example: After permutation test with 1,000 repetition for each of 10 participants,
%          pm_est is 1 x 10,000 (10*1,000) vector.
%

%
% SH 2019/8/10 Developed
% SH 2020/1/21 Edited * Renamed from iPIPI to itest
% SH 2020/7/14 Edited * change the order of input function
% SH 2020/10/1 Bug fixed
%     added PD(2,:) = PD(2,:)/sum(PD(2,:)); to avoid error when PD format 2-2) is converted to PD format 2-1)
% SH 2020/11/9 remane PD to pm_est, make i_max NOT default
%               Added skip_preparation for subfunction use
%               separate "woid"
%%%%%%%%%%%%%%%%%
%% Preparation %%
%%%%%%%%%%%%%%%%%

N = size(SD,1);% number of subjects
prob_min =  binocdf(i-1,N,(1-g_0));

if ~exist('skip_preparation','var') || ~skip_preparation
    %% initial parameters
    if nargin < 3; error('Three inputs (SD, pm_est and i) are required'); end
    if ~exist('g_0','var'); g_0 = 0.5; end
    if ~exist('alpha','var'); alpha = 0.05; end
    
    % find prob_min and error if parameters are inappropriate

    if prob_min>alpha
        error('Inappropriate predetermined parameters (alpha,g_0,i) for this number of subject. Try smaller i')
    end
    
    % check input format
    if ~isprob(g_0); error('g_0 should be probability'); end
    if ~isprob(alpha); error('alpha should be probability'); end
    if ~isposint(i); error('i should be positive integer'); end
    

% identify format of pm_est and reformat
if     size(pm_est,1) == 1; pm_est = [pm_est(:)';ones(1,numel(pm_est))/numel(pm_est)];
elseif size(pm_est,1) == 2; if ~ispmf(pm_est(2,:)); error('sum of PMF should be 1'); end
else; error('the style of PD is wrong. type "help itest"')
end
end

%%%%%%%%%%%%%%%%%%%%%%
%% Main calculation %%
%%%%%%%%%%%%%%%%%%%%%%

% find i-th order statistic of SD
temp = sort(SD);
order_stat = temp(i);

% find probability of PD < order_stat
P_0 = sum(pm_est(2,pm_est(1,:)<order_stat));

% Find Q and L
Q = (1-g_0)*P_0;
L = binocdf(i-1,N,Q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% evaluation, make output %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H =(L<alpha);
prob = L;

stat.prob_min = prob_min;
stat.param = struct('g_0',g_0,'i',i,'alpha',alpha);
stat.order_stat = order_stat;

end % end of function

