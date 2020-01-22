g_0s   = [0.1 0.3 0.7];
gammas = [0.3 0.5 0.9];
N_max = 50;
for ii = 1:3
    g_0 = g_0s(ii);
    gamma = gammas(ii);
clear P_sig T p_above_T_individual p_above_T_plus I_MAX


% number of trial
N_trial = 1000;

% parameters for i-test
alpha = 0.05;

% true mean percent correct given n belongs to Omega-
P_correct_minus = 0.5;
% true mean percent correct given n belongs to Omega+
P_correct_plus = 0.9;
% maximum number of subjects
N_max = 50;

%% computation N = 1:N_max, i=1:i_max
for N = 1:N_max
    % check i_max for the current number of subject (N)
    [i_max,prob_min] = check_imax(N,g_0,alpha);
    disp([N,i_max])
    if ~isnan(i_max)
        for i = 1:i_max
            [P_sig(N,i),T(N,i),p_above_T_individual(N,i),p_above_T_plus(N,i)]= numeric_binomial(N_trial,N,g_0,alpha,gamma,P_correct_minus,P_correct_plus,i);
        end
    end
    % save i_max
    I_MAX(N) = i_max;
end

%% Figures

% replace zeros in P_sig to NaN
P_sig(P_sig==0)=NaN;

% Figure 2A
for N=1:N_max
    if isnan(I_MAX(N)); P_max(N,1) = NaN;
    else;               P_max(N,1) = P_sig(N,I_MAX(N));
    end
end
figure
plot(P_sig); hold on;axis([0 N_max 0 1])
plot(P_max,'k','LineWidth',3)

% Figure 2B
figure
plot(I_MAX,'.','MarkerSize',10)
end
