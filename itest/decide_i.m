function [P_sig,T,p_below_T_individual,p_below_T_plus,p_below_T_minus,L]= decide_i(N,N_trial,g_0,alpha,P_correct_minus,gamma,P_correct_plus,i_all)
% This script estimates the probability of significant result of i-test (P_sig),
% under the assumption that decoding accuracies follows binomial distribution.
% INPUT
% N: Number of subjects (positive integer)
% N_trial: Number of trials (positive integer)
% g_0: Prevalence threshold, (Real number between 0 and 1 default:0.5)
% alpha: statistical threshold,  (Real number between 0 and 1 default:0.05)
% P_correct_minus: chance level decoding accuracy, e.g. 0.5 for binary classification. (Real number between 0 and 1)
% gamma: true information prevalence: i.e. true proportion of people in population with higher-than-chance decoding accuracy. (Real number between 0 and 1 or vector)
% P_correct_plus: true expectation of decoding accuracy of people with higher-than-chance decoding accuracy (Real number between 0 and 1 or vector)
% i_all: candidate values of  (positive integer or vector)
% OUTPUT
% P_sig: probability of achieving significant result of i-test. 3-dimensional matrix with size of [length of gamma] Å~ [length of P_correct_plus] Å~ [length of i]
% The other outputs are values appear during the calculation of P_sig. Please see the original paper.
%
% OUTPUT FIGURE: plot of P_sig against gamma, P_correct_plus or both. 
%
% 2020/1/22 Developed by SH



if nargin<4
    error('Required inputs: Number of subject, Number of trials, g_0, alpha')
end

if nargin<5 || isempty(P_correct_minus)
    P_correct_minus = 0.5
    disp('Binary classification')
end

if nargin<6 || isempty(gamma)
    gamma = g_0:0.01:1;
end

if nargin<7 || isempty(P_correct_plus)
    P_correct_plus = P_correct_minus:0.01:1;
end

i_max = check_imax(N,g_0,alpha);% find i_max
if nargin<8 || isempty(i_all)
    i_all = 1:i_max;
else
    i_all = i_all(:)';
    if any(abs(round(i_all)-i_all)) > eps('double') || any(i_all)<=0
        error('i should be positive integer') 
    elseif any(i_all(i_all>i_max))
        warning('i > %d are ignored',i_max);
        i_all = i_all(i_all <= i_max);
    end
end



%% check input format
if length(N)~=1 || (abs(round(N)-N)) > eps('double') || N<=0
        error('N should be positive integer') 
end

if length(N_trial)~=1 || (abs(round(N_trial)-N_trial)) > eps('double') || N_trial<=0
        error('N_trial should be positive integer') 
end

if length(g_0)~=1 || g_0>=1 || g_0<=0
        error('0<g_0<1') 
end

if length(alpha)~=1 || alpha>=1 || alpha<=0
        error('0<alpha<1') 
end

if isvector(gamma) && all(gamma <=1 & gamma >=0) 
    gamma = gamma(:)';
else error('gamma should be vector or number, 0<=gamma<=1')
end

if isvector(P_correct_plus)  && all(P_correct_plus <=1 & P_correct_plus >=0) 
    P_correct_plus=P_correct_plus(:)'; 
else error('P_correct_plus should be vector or number, 0<=P_correct_plus<=1')
end



%% Main calculation of P_sig for each combination of gamma, P_correct_plus and i

tmp_p=0;
for pcp = P_correct_plus
    tmp_p=tmp_p+1;

    tmp_g = 0;
    for g = gamma
        tmp_g = tmp_g+1;
        tmp_i = 0;
        for i = i_all
            tmp_i=tmp_i+1;
[P_sig(tmp_p,tmp_g,tmp_i),T(tmp_p,tmp_g,tmp_i),p_below_T_individual(tmp_p,tmp_g,tmp_i),...
    p_below_T_plus(tmp_p,tmp_g,tmp_i),p_below_T_minus(tmp_p,tmp_g,tmp_i),L{tmp_p,tmp_g,tmp_i}]...
                = numeric_binomial(N_trial,N,g_0,alpha,g,P_correct_minus,pcp,i);
        end
    end
end

%% Make Figure
P_sig(P_sig==0) = NaN;
    for i_ind = 1:length(i_all)
    lg{i_ind} = ['i = ' int2str(i_all(i_ind))];
    end
figure; hold on   
title('Statistical Power')
if size(P_sig,1)==1 && size(P_sig,2)==1
    plot(squeeze(P_sig),'o-')
    xlabel('i')
    ylabel('P_s_i_g')
elseif size(P_sig,1)==1
    plot(gamma,squeeze(P_sig),'o-')
    xlabel('true gamma')
    ylabel('P_s_i_g')
    legend(lg);
elseif size(P_sig,2)==1
    plot(P_correct_plus,squeeze(P_sig),'o-')
    xlabel('true P correct plus')
    ylabel('P_s_i_g')
    legend(lg);
else
for i_ind = 1:length(i_all)
surf(gamma,P_correct_plus,P_sig(:,:,i_ind),'FaceColor',[1-(i_ind-1)/(length(i_all)-1) 0 (i_ind-1)/(length(i_all)-1)])
end
legend(lg);
xlabel('Gamma')
ylabel('P correct plus')
zlabel('P_s_i_g')

end


