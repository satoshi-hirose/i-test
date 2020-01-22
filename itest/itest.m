function [H, prob, stat] = itest(SD,PD,g_0,i,alpha,identical)
% N: Number of participant (>2)
%
% Inputs
% SD: Sample Decoding Accuracies from experiment (N x 1 matrix)
% PD: (see below for detail): null distribution
% g_0:  Prevalence threshold, gamma0 (Real number between 0 and 1 default:0.5)
% i:    Index of order statistics (Positve Integer, default: 1)
% alpha: statistical threshold (Real number between 0 and 1 default:0.05)
% identical: (boolean) 1 if you assume the identical distribution of 
%                      decoding accuracy distribution among participants 
%                    If not specified, format of PD is reffered (see below)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% H: 1 if Prob < alpha, 0 otherwise
% Prob: Probability 
% stat: (structure)
%       .prob_min minimum probability. should be smaller than alpha.
%       .param          predetermined parameters (g_0,i,alpha) 
%       .order_stat     i-th order statistic of SD (real number)
%       .P_0            
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input PD: 
% the decoding accuracy distribution
% under the null hypothesis "there is no label information in the brain".
% This is empirically estimated by e.g. permutation test,
% or assumed by a statistical model, e.g. binomial distribution.
% The required format depends on 
% whether identical distribution among people is assumed or not.
% In both cases, the distribution can be specified with
% results of empirical estimation (list of empirical estimation) or
% histogram style (similar to output of MATLAB function "hist").
% 
% Therefore, there is 2x2=4 input formats.
%
% 1) results of the empirical estimation procedure.
% 1-1) identical distribution among subjects is assumed.
% 1 x [Number of repetition] matrix
% Example: After permutation test with 1,000 repetition for each of 10 participants,
%          PD is 1 x 10,000 (10*1,000) vector.
% -----------------------------------------------------
% 1-2) identical distribution among subjects is not assumed
% N x [Number of repetition] matrix
% Example: After permutation test with 1,000 repetition for each of 10 participants,
% PD is 10 x 1,000 matrix.
% -----------------------------------------------------
% 2) Histogram style.
% 2-1) identical distribution among subjects is assumed.
% 2 x [number of possible decoding accuracies] matrix,
% Example: If 2 trials for each participants for binary decoding (chance = 50%),
%          And assume that decoding accuracy follows binomial distribution,
%          PD    =  [0       50      100
%                    0.25    0.5     0.25]    
%
% 2-2) identical distribution among subjects is not assumed.
% N x 1 cell, each cell contains 2 x [number of possible decoding accuracies]
% Example: If there is a subject with 2 trials and another with 4 trials, 
%          And assume that decoding accuracy follows binomial distribution,
%          PD{1}    =  [0       50      100
%                       0.25    0.5     0.25]    
%          PD{2}    =  [0       25      50      75     100
%                       0.0625  0.25    0.375   0.25   0.0625]    
%         
%
% Developed by SH 2019/8/10
% Edited by SH 2020/1/21 
% * Renamed from iPIPI to i-test

%% initialize
% initial parameters
if nargin < 2; error('Two inputs (SD and PD) are required'); end
if nargin < 3 || isempty(g_0); g_0 = 0.5; end
if nargin < 5 || isempty(alpha); alpha = 0.05; end

N = size(SD,1);

% identify format of PD
if iscell(PD);          usePMF = 1;identical_PD = 0;
elseif size(PD,1) == 1; usePMF = 0;identical_PD = 1;
elseif size(PD,1) == 2; usePMF = 1;identical_PD = 1;
elseif size(PD,1) == N; usePMF = 0;identical_PD = 0;
else; error('the style of PD is wrong. type "help itest"')
end


if nargin < 6 || isempty(identical); identical = identical_PD;
elseif identical_PD == 0 && identical == 1
    warning('PD is converted to one common distribution'); 
    if usePMF;  PD = cell2mat(PD(:)');
    else;       PD = PD(:)';
    end
elseif identical_PD == 1 && identical == 0
    error('one PD is defined, but identical = 0'); 
end

% reformat PD
if identical
    if usePMF;  PD = PD;
    else;       PD = [PD(:)';ones(1,numel(PD))/numel(PD)];
    end
else
    if usePMF;  PD = PD;
    else;       PD_old = PD;clear PD;
                for n = 1:N
                    PD{n} = [PD_old(n,:);ones(1,size(PD_old,2))/size(PD_old,2)];
                end
    end
end

% error if sum of probability is not 1
numerical_error_tolerance = 10^(-10); 
if identical && abs(sum(PD(2,:))-1)>numerical_error_tolerance; error('sum of PMF should be 1');
elseif ~identical
    for n = 1:N
        if abs(sum(PD{n}(2,:))-1)>numerical_error_tolerance;error('sum of PMF should be 1');
        end
    end
end

% find maximum available i, if i is not specifyed
% find prob_min
if nargin < 4 || isempty(i)
    [i,prob_min] = check_imax(N,g_0,alpha);
else
    prob_min =  binocdf(i-1,N,(1-g_0));
end

% error if i=1 do not satisfy the constraint 
if isnan(i) 
    error('Inappropriate predetermined parameters (alpha,g_0) for this small number of subject. Try larger alpha or smaller g_0')
end

% error if parameters are inappropriate
if prob_min>alpha
    error('Inappropriate predetermined parameters (alpha,g_0,i) for this number of subject. Try smaller i')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main Calculation from here %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% find i-th order statistic of SD
temp = sort(SD);
order_stat = temp(i);

if identical
%%  decpdomg accuracy distribution is IDENTICAL among participants
    % find probability of PD >= order_stat
    P_0 = sum(PD(2,PD(1,:)<order_stat)); 
    % Find Q and L
    Q = (1-g_0)*P_0;
    L = binocdf(i-1,N,Q);
    
else
%%  DA distribution is DIFFERENT among participants
    % find probability of PD >= order_stat for each participant
    for n = 1:N
        P_0(n,1) = sum(PD{n}(2,PD{n}(1,:)<order_stat));
    end
    % Find Q
    Q = (1-g_0)*P_0;
    % Find L
    L = 0;
    for ii = 0:i-1 % number of subjects P(a_n)<a(i)
        ind_0 = combnk(1:N,ii); % subject index of D-Acc < order_stat
        for jj = 1:size(ind_0,1)
            sub_info = ones(N,1);
            sub_info(ind_0(jj,:)) = 0;
            this_PA = prod((1-Q).^sub_info.*Q.^(1-sub_info));
            L = L+this_PA;
        end
    end
end

%% evaluation, make output
H =(L<alpha);
prob = L;

stat.prob_min = prob_min;
stat.param = struct('g_0',g_0,'i',i,'alpha',alpha);
stat.order_stat = order_stat;
%% 
stat.P_0 = P_0;
%% 

