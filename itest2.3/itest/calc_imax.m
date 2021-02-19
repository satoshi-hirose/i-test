function [i_max,prob_min] = calc_imax(N,g_0,alpha)
% [i_max,prob_min] = calc_imax(N,g_0,alpha)
% This function calculates the maximum possible i 
% from the number of subjects (N) and the predetermined threshold parameters (g_0 and alpha)
% Input
% N: Number of participant (positive integer)
% g_0: Prevalence threshold,  (Real number between 0 and 1)
% alpha: statistical threshold,  (Real number between 0 and 1)
% 
% Output
% i_max: The maximum available i
% prob_min: Theoretical lower bound of L
%
% 2020/1/22 Developed by SH

% check input format
if ~isposint(N); error('N should be positive integer'); end
if ~isprob(g_0); error('g_0 should be probability'); end
if ~isprob(alpha); error('alpha should be probability'); end

% find largest i
prob_min_list =  binocdf(0:N,N,(1-g_0));
i_max = find(prob_min_list<alpha,1,'last');
if isempty(i_max); i_max = NaN; prob_min=NaN;
else; prob_min = prob_min_list(i_max); end
