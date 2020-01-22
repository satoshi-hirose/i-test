% number of trial
N_trial = 1000;

% parameters for i-test
g_0 = 0.5;
alpha = 0.05;
i=1;
% true information prevalence
gamma = 0.8;
% true mean percent correct given n belongs to Omega-
P_correct_minus = 0.5;
% true mean percent correct given n belongs to Omega+
P_correct_plus = 0.9;
% maximum number of subjects
N=50;

[P_sig,T,p_below_T_individual,p_below_T_plus,p_below_T_minus,L] = ...
    numeric_binomial(N_trial,N,g_0,alpha,gamma,P_correct_minus,P_correct_plus,i)
P_individual = gamma*binopdf(0:N_trial,N_trial,P_correct_plus)+(1-gamma)*binopdf(0:N_trial,N_trial,P_correct_minus);

%% Figures
% Supplementary Figure 6A

% Relation between a_hat_(i) and L: Derive T
figure; hold on
plot(0:(1/N_trial):1,L,'ko-','LineWidth',1,'MarkerSize',5)
plot([0 1],[alpha alpha],'r--')
xlabel('$$ \hat{a}_{(i)} $$','Interpreter','latex')
ylabel('$$ L $$','Interpreter','latex')
title('$$ Relation\ between\ \hat{a}_{(i)}\ and\ L:\ Derive\ T $$','Interpreter','latex')

% Supplementary Figure 6B (zoomup version)
a=gca;
f = figure;
copyobj(a,f)
axis([0.46 0.51 0 0.1])