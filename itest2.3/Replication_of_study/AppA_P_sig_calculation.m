%% Draw figure A1

alpha = 0.05;
g0=0.5;
N=50;
i=1;
N_trial=1000;
Pcp=0.9;
Pcm = 0.5;
gamma=0.8;
FIGfilename = 'Figure/FigureA1.ps';

% possible order statistic and the probability cumularive distribution
% function of D-Acc with (pp_cdf) and without (pm_cdf, pm_less) label
% information
possible_order_stat = 0:(1/N_trial):1;
pm_cdf = binocdf(0:N_trial,N_trial,Pcm);
pm_less = [0 pm_cdf(1:end-1)];
pp_cdf = binocdf(0:N_trial,N_trial,Pcp);

% Calculate the threshold T
Q= (1-g0)*pm_less; % Q for each possible order statistic
L=binocdf(i-1,N,Q); % L for each possible order statistic
Tid=find(L>=alpha,1,'last');
T = possible_order_stat(Tid);

% draw figure
figure
plot(possible_order_stat,L,'o-k','MarkerFaceColor','k','MarkerSize',4)
hold on
plot([0 1],alpha*[1 1],'r--')
set(gca,'YTick',0:0.2:1,'XTick',0:0.2:1)
xlabel('\sla\rm_{(\sli\rm)}','FontSize',18,'FontName','Times');
ylabel('\slL','FontSize',18,'FontName','Times');   
title('FigureA1A')
print('-dpsc','-append',FIGfilename);

% draw zoomup figure
ax = gca;
h = figure;
copyobj(ax,h)
plot(T*[1 1],[0 L(Tid)],'r')
axis([0.46 0.51 0 0.1])
set(gca,'YTick',[0.05 0.1],'XTick',0.46:0.01:0.51)
xlabel('\sla\rm_{(\sli\rm)}','FontSize',18,'FontName','Times');
ylabel('\slL','FontSize',18,'FontName','Times');   
title('FigureA1B')
print('-dpsc','-append',FIGfilename);

%% Get values for text.
pp_at_below_T = pp_cdf(Tid);
pm_at_below_T = pm_cdf(Tid);
p_at_below_T = gamma*pp_at_below_T+(1-gamma)*pm_at_below_T;
P_sig = binocdf(i-1,N,p_at_below_T);

fprintf('i=1 case:\n T is  %g\np_at_below_T is %.3g\nP_sig is %.3g\n\n',T,p_at_below_T,P_sig)

i=19;
L=binocdf(i-1,N,Q);
Tid=find(L>=alpha,1,'last');
T = possible_order_stat(Tid);
pp_at_below_T = pp_cdf(Tid);
pm_at_below_T = pm_cdf(Tid);
p_at_below_T = gamma*pp_at_below_T+(1-gamma)*pm_at_below_T;
P_sig = binocdf(i-1,N,p_at_below_T);
fprintf('i=19 case:\n T is  %g\np_at_below_T is %.3g\nP_sig is %.3g\n',T,p_at_below_T,P_sig)
