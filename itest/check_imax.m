function [i_max,prob_min] = check_imax(N,g_0,alpha)
% [i_max,prob_min] = check_imax(N,g_0,alpha)
% This function calculates the maximum possible i 
% from the number of subjects (N) and the predetermined threshold parameters (g_0 and alpha)
% Input
% N: Number of participant (integer)
% g_0: Prevalence threshold,  (Real number between 0 and 1 default:0.5)
% alpha: statistical threshold,  (Real number between 0 and 1 default:0.05)
% 
% Output
% i_max: The maximum available 
% prob_min: Theoretical lower bound of Prob computed from predetermined parameters (g_0 and i) and number of participants.
%
% 2020/1/22 Developed by SH
%% find largest i
prob_min_list =  binocdf(0:N,N,(1-g_0));
i_max = find(prob_min_list<alpha,1,'last');
if isempty(i_max); i_max = NaN; prob_min=NaN;
else; prob_min = prob_min_list(i_max); end