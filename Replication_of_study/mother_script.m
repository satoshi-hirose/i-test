% Figure 2A,B
clear all
number_of_subjects_effect
% Figure 2C
clear all
gamma_effect

% Supplementary Figure S1, S2, S3
clear all
number_of_subjects_effect_g0
clear all
gamma_effect_g0


% Figure 3, Supplementary Figure S4 
clear all
empirical_analysis

% benchmark test: Supplementary Figure S5
clear all
benchmark_test

% Supplementary Figure S6
clear all
find_T

% Appendix Figure A1
clear all
i_effect

% values in the Appendix B text
clear all
N_trial = 1000;
N = 50;
g_0 = 0.5;
alpha = 0.05;
gamma = 0.8;
P_correct_minus = 0.5;
P_correct_plus = 0.9;

i=1;
[P_sig,T,p_below_T_individual,p_below_T_plus,p_below_T_minus,L] = ...
    numeric_binomial(N_trial,N,g_0,alpha,gamma,P_correct_minus,P_correct_plus,i)

i=19;
[P_sig,T,p_below_T_individual,p_below_T_plus,p_below_T_minus,L] = ...
    numeric_binomial(N_trial,N,g_0,alpha,gamma,P_correct_minus,P_correct_plus,i)

% A GUI program to help understanding 
% the difference of behavior between i-test and conventional t-test
Demo_Comparison

