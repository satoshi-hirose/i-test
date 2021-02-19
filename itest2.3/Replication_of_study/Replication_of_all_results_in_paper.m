% Replication of all the results reported in the paper.
% Complete the 5 computation in the Computation directory,
% so that there're files listed below in the Results directory.
% Numerical_Caliculation_Computation_g0_1.mat
% Numerical_Caliculation_Computation_g0_3.mat
% Numerical_Caliculation_Computation_g0_5.mat
% Numerical_Caliculation_Computation_g0_7.mat
% Simulation_Binomial_Computation.mat
% Simulation_CV_Computation.mat
% Simulation_CV_firstlevel.mat
% Benchmark_Test.mat

run('Subfunctions/init_for_replication.m')
mkdir Figure
diary Figure/Values_in_text.txt
%% Section 3 Numerical calculation
disp('#########################################')
disp('## Sec3_Numerical_Calculation_Analysis ##')
disp('#########################################')
% see the comment in the m-file
Sec3_Numerical_Calculation_Analysis


%% Section 4 Empirical analysis
disp('##################################')
disp('## Sec4_Empirical_Data_Analysis ##')
disp('##################################')
% in Empirical_Data_Analysis.m, 
% I did not use the function of the i-test toolbox.
% Instead, the code include main calculation steps for itest explicitly, 
% without minor process such as error handling, with comment for each lines.
% This may help the understanding of computational process of itest.
Sec4_Empirical_Data_Analysis

%% Appendix A Calculation of the statistical power
disp('############################')
disp('## AppA_P_sig_calculation ##')
disp('############################')
AppA_P_sig_calculation

%% Supplementary Marterial S.1.1
disp('#########################################')
disp('## Sup1_1_Simulation_Binomial_Analysis ##')
disp('#########################################')
% Simulation with binomial distribution to see whether the numerical analysis reported in Section 3
% can be replicated by Simultion with the same parameters.
Sup1_1_Simulation_Binomial_Analysis

%% Supplementary Marterial S.1.2
% Simulation with cross validated decoding accuracy.
disp('################################################')
disp('## Sup1_2_1_Simulation_CV_firstlevel_Analysis ##')
disp('################################################')
Sup1_2_1_Simulation_CV_firstlevel_Analysis
disp('#####################################')
disp('## Sup1_2_2_Simulation_CV_Analysis ##')
disp('#####################################')
Sup1_2_2_Simulation_CV_Analysis


%% Supplementary Materials S.2
disp('#############################################')
disp('## Sup2_Numerical_Calculation_different_g0 ##')
disp('#############################################')
% Simulation for the evaluation of empirical procedure for the selection of i.
Sup2_Numerical_Calculation_different_g0

%% Supplementary Materials S.5
disp('####################')
disp('## Benchmark_Test ##')
disp('####################')
load Results/Benchmark_Test.mat
meantime = mean(T_all,3);
%plot(meantime)
fprintf('The computational time for N_trial <= 1000 and N <= 100 is less than %u\n', ceil(max(meantime(:))))

diary off
