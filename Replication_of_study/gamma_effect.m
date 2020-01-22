% number of trial
N_trial = 1000;

% parameters for i-test
g_0 = 0.5;
alpha = 0.05;

% true mean percent correct given n belongs to Omega-
P_correct_minus = 0.5;
% true mean percent correct given n belongs to Omega+
P_correct_plus = 0.9;

% number of subjects
N_all = 1:50;
% true gamma
gamma_all = 0:0.01:1;

%% computation N = N_all, gamma = gamma_all, i=[1 i_max]
tmp_n=0;
for N = N_all
    tmp_n=tmp_n+1;
    
    [i_max,prob_min] = check_imax(N,g_0,alpha);
    disp([N,i_max])
    tmp_g = 0;
    for gamma = gamma_all
        tmp_g = tmp_g+1;
        tmp_i = 0;
        for i = [1 i_max]
            tmp_i=tmp_i+1;
            [P_sig{tmp_n}(tmp_g,tmp_i),T{tmp_n}(tmp_g,tmp_i),p_above_T_individual{tmp_n}(tmp_g,tmp_i),p_above_T_plus{tmp_n}(tmp_g,tmp_i)]...
                = numeric_binomial(N_trial,N,g_0,alpha,gamma,P_correct_minus,P_correct_plus,i);
        end
    end
end

%% Figure 2C: representative results
for sub =10:10:50
figure; hold on
plot(P_sig{sub})
plot([1 size(P_sig{1},1)],[ alpha alpha],'--')
plot([find(gamma_all == g_0) find(gamma_all == g_0)],[ 0  1],'--')
set(gca,'xtick',1:10:101,'xticklabel',0:0.1:1)
axis([1 size(P_sig{1},1) 0 1])
title(int2str(sub))
end

temp = 0;
for N = 10:10:50
    temp = temp+1;
    I_Max(temp)=check_imax(N,g_0,alpha);
end
disp(I_Max)

%% confirm that they are empty
for sub =1:length(N_all)
difference(sub,:) = (P_sig{sub}(:,2)-P_sig{sub}(:,1))';
end


% When gamma is at or lower than g_0-0.05, 
% there's no cases that (P_sig with iMax) >  (P_sig with i=1)  
find(difference(:,(gamma_all<=(g_0-0.04)))>0)
% When gamma is higher than g_0, 
% there's no cases that (P_sig with iMax) <  (P_sig with i=1)  
find(difference(:,(gamma_all>g_0+0.01))<0)
return

%% logscale of figure 2C
for sub =10:10:50
    figure; hold on
plot(log(P_sig{sub}))
axis([1 size(P_sig{1},1) -10 0])
plot([1 size(P_sig{1},1)],[ log(alpha) log(alpha)],'--')
plot([(1+size(P_sig{1},1))/2 (1+size(P_sig{1},1))/2],[-10  0],'--')
set(gca,'xtick',1:10:101,'xticklabel',0:0.1:1)
title(int2str(sub))
end
