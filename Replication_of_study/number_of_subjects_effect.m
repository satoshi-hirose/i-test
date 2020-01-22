% number of trial
N_trial = 1000;

% parameters for i-test
g_0 = 0.5;
alpha = 0.05;

% true information prevalence
gamma = 0.8;
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

return
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% Below are not in the Paper %%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

%% Plot T for i=1 and i_max
figure; subplot('Position',[0.1 0.1 0.8 0.8])
T(T==0) = NaN;
for N=1:N_max
  if isnan(I_MAX(N));T_max(N,1) = NaN;
  else T_max(N,1) = T(N,I_MAX(N));
  end
end
plot(T(:,1),'LineWidth',3); hold on
plot(T_max,'k','LineWidth',3)
axis([0 N_max 0 1])

subplot('Position',[0.9 0.1 0.1 0.8])
plot(flip(binopdf(0:N_trial,N_trial,P_correct_minus)*(1-gamma)+binopdf(0:N_trial,N_trial,P_correct_plus)*gamma));
axis_tmp = axis; set(gca,'xtick','','ytick','')
axis([0 1000 axis_tmp(3:4)])
view(90,90)

figure; hold on
p_above_T_individual(P_sig==0)=NaN;
for N=1:N_max
    if isnan(I_MAX(N));p_above_T_individual_max(N,1) = NaN;
    else p_above_T_individual_max(N,1) = p_above_T_individual(N,I_MAX(N));
    end
end
p_above_T_individual(p_above_T_individual==0)=NaN;
plot(p_above_T_individual(:,1),'LineWidth',3)
plot(p_above_T_individual_max(:,1),'k','LineWidth',3)
axis([0 N_max 0 1])

return

%% p_above_T_individual
figure
for N_sub=1:N_sub_max
    if I_MAX(N_sub)==0;T_max(N_sub,1) = NaN;
    else T_max(N_sub,1) = T(N_sub,I_MAX(N_sub));
    end
end
T2 = T/N_trial;
T2(T2==0)=NaN;
plot(T2); hold on
plot(T_max/N_trial,'k','LineWidth',3)



figure
p_above_T_individual(p_above_T_individual==0)=NaN;
plot(p_above_T_individual)