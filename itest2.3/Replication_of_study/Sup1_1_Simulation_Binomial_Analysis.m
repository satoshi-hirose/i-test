% Code for results reported in Supplementary Material 1.1.

% load parameters and probability of significant result (P_sig{N_trial,N}(i,gamma,Pcp))
% calculated with numerical analysis (NumRes) and simualtion (SimRes)
% N: Number of subject, 5:100
% N_trial: Number of trials, [10 100 1000] 
% gamma: true gamma 0:0.01:1
% Pcp: (stands for P correct plus) mean D-Acc with label information 0.51:0.01:1
% Pcm: (stands for P correct minus) mean D-Acc without label information 0.5
% alpha: statistical threshold: 0.05
% g_0: prevalance threshold: 0.5
% N_sim: Number of simulation: 1000
% Note: subfunction "get_this_P_sig" can extract the contents of P_sig relevant to the analysis

SimRes = load('Results/Simulation_Binomial_Computation');
NumRes = load('Results/Numerical_Caliculation_Computation_g0_5.mat');
h1 = figure(1);clf(h1);ax1 = gca(h1); h1.Position = [950 700 560 480];
%% Comparison between SimRes and NumRes

difference = cat(1,SimRes.P_sig{:}) - cat(1,NumRes.P_sig{:}) ;
histogram(ax1,difference(:),-0.08:.001:0.08,'Normalization','probability');

xlabel(ax1,'\slDifference of Power','FontSize',18,'FontName','Times')
ylabel(ax1,'\slFrequency','FontSize',18,'FontName','Times')
title(ax1,'Figure S1.1')

% print(h1,'-dpsc','-append','Figure/TESTFigureS1.1.ps');
print(h1,'-dpdf','Figure/FigureS1.1.pdf'); 
% Developer's memo: 
% I do not know why MATLAB outputs non-vector postscript graphics with '-dpsc'
% with histogram figure (FigureS1.1 and S1.2.2)
% I use 'dpdf' (PDF format) instead.

%% Values for text
maximum = max(difference,[],'all');
minimum = min(difference,[],'all');
absolutemean = mean(abs(difference),'all');
average = mean(difference,'all');
fprintf('max: %g, min: %g, mean: %d, absolute mean:%g\n', maximum,minimum,average, absolutemean) 
