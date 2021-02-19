% Code for results reported in Supplementary Material 1.2.1.

% load parameters and cross validated D-Acc (SD) for individual participant
% calculated with simualtion (SimCV1)
% N: Number of repetition (subject): 100000
% N_sess: Number of sessions: 5
% N_trial: Number of trials, [10 100 1000]
% P: probability of correct decoding for each trial: 0.5:0.01:1, 0.5 = chance (Pcm)
SimCV1 = load('Results/Simulation_CV_firstlevel');

FIGfilename = 'Figure/FigureS1.2.1.ps';
h1 = figure(1);clf(h1);ax1 = gca(h1); h1.Position = [950 700 560 480];

%% Mean
bino_mean = repmat(0.5:0.01:1,3,1)';
cv_mean   = squeeze(mean(SimCV1.SD,1))';
plot(ax1,0.5:0.01:1,bino_mean,'r--')
hold(ax1,'on')
plot(ax1,0.5:0.01:1,cv_mean,'b')

% Visualization setting
axis(ax1,[0.5 1 0.5 1])
set(ax1,'YTick',0.5:0.1:1,'XTick',0.5:0.1:1)
xlabel(ax1,'\slP_{\rmcorrect}','FontSize',18,'FontName','Times');
ylabel(ax1,'\slMean D-Acc','FontSize',18,'FontName','Times');
title(ax1,'Figure S1.2.1A: Mean D-Acc')

% save figure
print(h1,'-dpsc','-append',FIGfilename);
cla(ax1,'reset')

%% Difference of Mean
plot(ax1,0.5:0.01:1,cv_mean - bino_mean)

% Visualization setting
axis(ax1,[0.5 1 -0.06 0])
xlabel(ax1,'\slP_{\rmcorrect}','FontSize',18,'FontName','Times');
ylabel(ax1,'\slDifference of Mean D-Acc','FontSize',18,'FontName','Times');
title(ax1,'Figure S1.2.1C: Difference of Mean D-Acc')

% save figure
print(h1,'-dpsc','-append',FIGfilename);
cla(ax1,'reset')

%% SD
[nmesh,pmesh] = meshgrid([10 100 1000],0.5:0.01:1);
bino_sd = sqrt(nmesh.*pmesh.*(1-pmesh))./nmesh;
cv_sd   = squeeze(std(SimCV1.SD))';

plot(ax1,0.5:0.01:1,bino_sd,'r--')
hold(ax1,'on')
plot(ax1,0.5:0.01:1,cv_sd,'b')

% Visualization setting
axis(ax1,[0.5 1 0 0.2])
xlabel(ax1,'\slP_{\rmcorrect}','FontSize',18,'FontName','Times');
ylabel(ax1,'\slSD of D-Acc','FontSize',18,'FontName','Times');
title(ax1,'Figure S1.2.1B: SD of D-Acc')

% save figure
print(h1,'-dpsc','-append',FIGfilename);
cla(ax1,'reset')

%% Difference of SD
plot(ax1,0.5:0.01:1,cv_sd - bino_sd)

% Visualization setting
axis(ax1,[0.5 1 0 0.05])
xlabel(ax1,'\slP_{\rmcorrect}','FontSize',18,'FontName','Times');
ylabel(ax1,'\slDifference of SD of D-Acc','FontSize',18,'FontName','Times');
title(ax1,'Figure S1.2.1D: Difference of SD of D-Acc')

% save figure
print(h1,'-dpsc','-append',FIGfilename);
cla(ax1,'reset')

%% Example distribution
N_trial = 10;
P = 0.61;
h = histogram(SimCV1.SD(:,SimCV1.N_trial==N_trial,SimCV1.P==P),(-1/N_trial/2):(1/N_trial):(1+1/N_trial/2),'Normalization','probability');
plot(ax1,0:(1/N_trial):1,h.Values,'k')
hold(ax1,'on')
plot(ax1,0:(1/N_trial):1,binopdf(0:N_trial,N_trial,P),'r')

title(ax1,'Figure S1.2.1E: Comparison at P=0.61, N_{trial} = 10')

print(h1,'-dpsc','-append',FIGfilename);
cla(ax1,'reset')
%% Pcm
P = 0.5;
figalphabet = 'FGH';
figid = 0;
for N_trial = [10 100 1000]
    figid = figid+1;
    h = histogram(SimCV1.SD(:,SimCV1.N_trial==N_trial,SimCV1.P==P),(-1/N_trial/2):(1/N_trial):(1+1/N_trial/2),'Normalization','probability');
    plot(ax1,0:(1/N_trial):1,h.Values,'k')
    hold(ax1,'on')
    plot(ax1,0:(1/N_trial):1,binopdf(0:N_trial,N_trial,P),'r')
    
    title(ax1,sprintf('Figure S1.2.1%c: Comparison at P=0.5 N_{trial} = %u',figalphabet(figid),N_trial))
    
    print(h1,'-dpsc','-append',FIGfilename);
    cla(ax1,'reset')
end
