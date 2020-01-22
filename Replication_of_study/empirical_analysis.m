% codes for empirical data analysis
%% Decide i (Figure S4 A and B)
N = 12;
N_trial = 150;
g_0 = 0.5;
alpha = 0.05;
P_correct_minus = 0.5;
gamma = g_0:0.01:1;
i=1:3;
P_correct_plus = P_correct_minus:0.01:1;
P_sig = decide_i(N,N_trial,g_0,alpha,P_correct_minus,gamma,P_correct_plus,i);

% change color for visualization
h = findobj('FaceColor',[0.5 0 0.5]);
set(h,'FaceColor',[1 1 0])

%% Decide i with specified effect size (Figure S4C)
N = 12;
N_trial = 150;
g_0 = 0.5;
alpha = 0.05;
P_correct_minus = 0.5;
gamma = g_0:0.01:1;
i=1:3;
P_correct_plus =0.7;
P_sig = decide_i(N,N_trial,g_0,alpha,P_correct_minus,gamma,P_correct_plus,i);



%% Decide i with specified gamma (Figure S4D)
N = 12;
N_trial = 150;
g_0 = 0.5;
alpha = 0.05;
P_correct_minus = 0.5;
gamma = 0.7;
i=1:3;
P_correct_plus =P_correct_minus:0.01:1;
P_sig = decide_i(N,N_trial,g_0,alpha,P_correct_minus,gamma,P_correct_plus,i);


%% permutation test resutls (Figure 3) 

load Empirical_Experiment_Results.mat

figure
hist(PD(:),0.5:1:99.5)
axis([0 100 0 1000])
hold on

SSD = sort(SD);
for i = 1:12
    if i == 3||i == 1; linelength = 200; else linelength= 75; end
    plot([SSD(i),SSD(i)],[0 linelength],'r','LineWidth',2)
end

%% estimation of P(a_n<a_hat(i)|Omega-)
sum(PD(:)<SSD(3))
sum(PD(:)<SSD(1))


%% i-test (Values in Text of Section 4)
identical = 1;
alpha = 0.05;
g_0 = 0.5;

i = 3;
n_permute_lower_than_ai = sum(PD(:)<SSD(i))
P_an_smaller_than_a_hat_omega_minus = n_permute_lower_than_ai/numel(PD)
[H, L, stat] = itest(SD,PD,g_0,i,alpha,identical)

i = 1;
n_permute_lower_than_ai = sum(PD(:)<SSD(i))
P_an_smaller_than_a_hat_omega_minus = n_permute_lower_than_ai/numel(PD)
[H, L, stat] = itest(SD,PD,g_0,i,alpha,identical)

%% extended i-test (Values in Text of Appendix A)
identical = 0;
i = 3;
n_permute_lower_than_ai = sum(PD'<SSD(i));
P_an_smaller_than_a_hat_omega_minus = n_permute_lower_than_ai/size(PD,2);
[max(P_an_smaller_than_a_hat_omega_minus) min(P_an_smaller_than_a_hat_omega_minus)]
[H, L, stat] = itest(SD,PD,g_0,i,alpha,identical)

% comparison of L
L_nid = L;
identical = 1;
[H, L_id, stat] = itest(SD,PD,g_0,i,alpha,identical);
L_nid-L_id
