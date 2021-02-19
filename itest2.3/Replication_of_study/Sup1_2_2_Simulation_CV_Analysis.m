% Code for results reported in Supplementary Material 1.

% initialization
run('Subfunctions/init_for_replication.m')

% load parameters and probability of significant result
% (P_sig{N_trial,N}(i,gamma,P_correct_plus))
%
% N: Number of subject
% N_trial: Number of trials
% gamma: true gamma
% Pcp: (stands for P correct plus) mean D-Acc with label information
%
% subfunction "get_this_P_sig" can extract the contents of Pcp relevant to
% the analysis, see below
SimCV=load('Results/Simulation_CV_Computation');
NumRes = load('Results/Numerical_Caliculation_Computation_g0_5');

%% Optimal i for i-test-unif-bino
N = NumRes.N;
N_trial = NumRes.N_trial;
gamma = (NumRes.g_0+0.01):0.01:1;
Pcp     =  (NumRes.Pcm+0.01):0.01:1;

this_P_sig = get_this_P_sig(NumRes.P_sig,N,Pcp,gamma,N_trial,NumRes.N,NumRes.Pcp,NumRes.gamma,NumRes.N_trial);
% find estimated optimal i (i_eopt) for each combination of Nid and Ntid
for Nid = 1:size(this_P_sig,2)
    for Ntid = 1:size(this_P_sig,1)
        NumRes.i_eopt(Ntid,Nid) = calc_i_opt_wsum(this_P_sig{Ntid,Nid});
    end
end

%% i_max
for Nid = 1:size(this_P_sig,2)
    NumRes.i_max(Nid,1) = size(NumRes.P_sig{1,Nid},1);
end

%% minimum number of subject for i-test with i>=2
Nmin_i2 = NumRes.N(find(NumRes.i_max>1,1,'first'));
%
close all
h1 = figure(1);ax1 = gca(h1); h1.Position = [950 700 560 480];
h2 = figure(2);ax21=subplot(1,3,1);ax22=subplot(1,3,2);ax23=subplot(1,3,3); h2.Position = [100 100 2200 500]; 
h3 = figure(3);ax3 = gca(h3); h3.Position = [1600 700 560 480];

%% Figure S1.2.2 Comparison with numerical analysis
difference = cat(1,SimCV.P_sig{:}) - cat(1,NumRes.P_sig{:}) ;
histogram(ax1,difference(:),-1:.05:1,'Normalization','probability');
xlabel(ax1,'\slDifference of Power','FontSize',18,'FontName','Times')
ylabel(ax1,'\slFrequency','FontSize',18,'FontName','Times')
title(ax1,'Figure S1.2.2')

% print(h1,'-dpsc','-append','Figure/FigureS1.2.2.ps');
 print(h1,'-dpdf','Figure/FigureS1.2.2.pdf');
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


%% Figure S1.2.3 Identical format with Figure 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% example case N=50, N_trial = 100 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%% example case N=50, N_trial = 100 %%')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

N = 50;
N_trial = 100;
gamma = (NumRes.g_0+0.01):0.01:1;
Pcp =  (NumRes.Pcm+0.01):0.01:1;
i_max =  NumRes.i_max(NumRes.N==N);
this_P_sig = get_this_P_sig(SimCV.P_sig,N,Pcp,gamma,N_trial,SimCV.N,SimCV.Pcp,SimCV.gamma,SimCV.N_trial);

%% Values for text
mingamma_highpower = gamma(find(any(squeeze(this_P_sig(1,:,:)>0.8)'),1));
fprintf('P_sig>0.8 required gamma >= %g for i-test-one \n',mingamma_highpower)

i_opt = NumRes.i_eopt(NumRes.N_trial==N_trial,NumRes.N==N);
fprintf('i_opt for i-test-unif-bino is %g \n',i_opt)

%% draw Figure S1.2.3 A-E & SupplementaryGIF5
GIFfilename = 'Figure/SupplementaryGIF5.gif';
FIGfilename = 'Figure/FigureS1.2.3.ps';
figid=0;
figalphabet = 'ABCDE';

for i = 1:i_max
    % plot statistical power
    plot_Psig(ax1,'Power',squeeze(this_P_sig(i,:,:)))
    title(ax1,sprintf('Statistical power (CV-Simulation) with \\sli\\rm=%u\n(\\slN\\rm=%u, \\slN\\rm_{trial}=%u, \\gamma_0=%.1g, \\alpha=0.05)'...
        ,i,N,N_trial,NumRes.g_0),'FontSize',18,'FontName','Times');
    drawnow
    
    % Save GIF
    [imind,cm] = rgb2ind(frame2im(getframe(h1)),256);
    if i == 1; imwrite(imind,cm,GIFfilename,'gif', 'Loopcount',inf);
    else; imwrite(imind,cm,GIFfilename,'gif','WriteMode','append'); end
        
    % Save Figure
    if any(i==[1 5 10 15 19])
        figid = figid+1;
        title(ax1,sprintf('FigureS1.2.3%c: i=%g',figalphabet(figid),i),'FontName','Arial')
        print(h1,'-dpsc','-append',FIGfilename);
    end
end

%% draw FigureS1.2.3F
plot_Psig(ax1,'Difference',squeeze(this_P_sig(i_opt,:,:)-this_P_sig(1,:,:)))
title(ax1,'FigureS1.2.3F difference of Power i-test-unif-bino vs. i-test-one','FontName','Arial')
print(h1,'-dpsc','-append',FIGfilename);

%%%%%%%%%%%%%%%
%% All cases %%
%%%%%%%%%%%%%%%
disp('%%%%%%%%%%%%%%%')
disp('%% All cases %%')
disp('%%%%%%%%%%%%%%%')

%% Get values for text.
N = NumRes.N;
N_trial = NumRes.N_trial;
gamma = (NumRes.g_0+0.01):0.01:1;
Pcp     =  (NumRes.Pcm+0.01):0.01:1;

for Ntid = 1:3
    this_N_trial = N_trial(Ntid);
    for Nid = 1:length(N)
        this_N = N(Nid);
        this_P_sig = get_this_P_sig(SimCV.P_sig,this_N,Pcp,gamma,this_N_trial,SimCV.N,SimCV.Pcp,SimCV.gamma,SimCV.N_trial);                                    
        mingamma_highpower(Ntid,Nid) = gamma(find(any(squeeze(this_P_sig(1,:,:)>0.8)'),1));
    end
end
minmingamma_highpower = min(mingamma_highpower,[],'all');
fprintf('P_sig>0.8 required gamma >= %g for i-test-one \n',minmingamma_highpower)

%% draw Figure S1.2.3GHI  supplementaryGIF6,7,8
N = Nmin_i2:100;
N_trial =  NumRes.N_trial;
gamma = (NumRes.g_0+0.01):0.01:1;
Pcp     =  (NumRes.Pcm+0.01):0.01:1;

figalphabet = 'GHI';
cla(ax1,'reset')

for Ntid = 1:3
    GIFfilename = ['Figure/SupplementaryGIF' int2str(Ntid+5) '.gif'];
    this_N_trial = N_trial(Ntid);
    hold(ax1,'on');
    for Nid = 1:length(N)
        this_N = N(Nid);
        % get the results with the number of trials: this_N_trial, the number of participants: this_N
        this_P_sig = get_this_P_sig(SimCV.P_sig,this_N,Pcp,gamma,this_N_trial,SimCV.N,SimCV.Pcp,SimCV.gamma,SimCV.N_trial);
        i_eopt = NumRes.i_eopt(NumRes.N_trial==this_N_trial,NumRes.N==this_N);
        this_i_test_unif_bino = squeeze(this_P_sig(i_eopt,:,:));
        this_i_test_one = squeeze(this_P_sig(1,:,:));
        
        % power of i-test-unif-bino
        plot_Psig(ax21,'Power',this_i_test_unif_bino)
        title(ax21,sprintf('\\sli-test-unif-bino\\rm (\\sli\\rm=%u)',i_eopt),'FontSize',18,'FontName','Times')
        
        % power of i-test-one
        plot_Psig(ax22,'Power',this_i_test_one)
        title(ax22,sprintf('Statistical Power (CV-Simulation) with \\slN\\rm=%u (\\slN\\rm_{trial}=%u, \\gamma_0=%.1g, \\alpha=0.05)\n\\sli-test-one\\rm (\\sli\\rm=1)'...
            ,N(Nid),N_trial(Ntid),NumRes.g_0),'FontSize',18,'FontName','Times');
        
        % difference
        plot_Psig(ax23,'Difference',this_i_test_unif_bino-this_i_test_one)
        title(ax23,'Difference between \sli-test-unif-bino\rm and \sli-test-one\rm','FontSize',18,'FontName','Times')

       % draw contour figure (Figure 2 G,H,I)
        if mod(N(Nid),20)==0;
            my_contour(ax1,this_i_test_unif_bino,0.8,[1,1-(N(Nid)+20)/120,1-(N(Nid)+20)/120],1); 
            my_contour(ax1,this_i_test_one,0.8,[1-(N(Nid)+20)/120,1-(N(Nid)+20)/120,1],1);
        end
        
        % Save GIF
        [imind,cm] = rgb2ind(frame2im(getframe(h2)),256);
        if Nid == 1; imwrite(imind,cm,GIFfilename,'gif', 'Loopcount',inf);
        else; imwrite(imind,cm,GIFfilename,'gif','WriteMode','append'); end
    end
    % save contour figure (Figure 2 G,H,I)
    % Visualization setting    
        set(ax1,'YDir','Normal','YTick',10:10:((1-NumRes.g_0)*100),'YTickLabel',(NumRes.g_0+0.1):0.1:1,'XTick',10:10:50,'XTickLabel',0.6:0.1:1);
        xlabel(ax1,'\slP\rm_{correct+}','FontSize',14,'FontName','Times')
        ylabel(ax1,'\sl\gamma','FontSize',18,'FontName','Times')
        axis(ax1,[0.5 50.5 0.5 (1-NumRes.g_0)*100+.5])
        title(ax1,sprintf('FigureS1.2.3%c: N_{trial}=%g',figalphabet(Ntid),N_trial(Ntid)),'FontName','Arial')
        print(h1,'-dpsc','-append',FIGfilename);
        cla(ax1,'reset')
end

%%%%%%%%%%%%%%%%%
%% FA analysis %%
%%%%%%%%%%%%%%%%%
disp('%%%%%%%%%%%%%%%%%')
disp('%% FA analysis %%')
disp('%%%%%%%%%%%%%%%%%')

%% Get values for text.
N = NumRes.N;
N_trial = NumRes.N_trial;
gamma = 0:0.01:NumRes.g_0;
Pcp     =  (NumRes.Pcm+0.01):0.01:1;

for Ntid = 1:3
    this_N_trial = N_trial(Ntid);
    for Nid = 1:length(N)
        this_N = N(Nid);
        i_eopt = NumRes.i_eopt(NumRes.N_trial==this_N_trial,NumRes.N==this_N);
        
        this_P_sig = get_this_P_sig(SimCV.P_sig,this_N,Pcp,gamma,this_N_trial,SimCV.N,SimCV.Pcp,SimCV.gamma,SimCV.N_trial);
        this_mingamma_FA=gamma(find(any(squeeze(this_P_sig(i_eopt,:,:)>0.05)'),1));
        if isempty(this_mingamma_FA);mingamma_FA(Ntid,Nid)=0.51;
        else; mingamma_FA(Ntid,Nid) = this_mingamma_FA;
        end
    end
end
minmingamma_FA = min(mingamma_FA,[],2);
fprintf('P_sig >0.05 observed when gamma >= %g,%g and %g for N_trial = 10,100 and 1000, respectively \n',minmingamma_FA)

%% Figure S1.2.4 false alarm rate
N = NumRes.N;
gamma = 0:0.01:NumRes.g_0;
N_trial = [10 100 1000];
Pcp =  0.51:0.01:1;

for Ntid = 1:3
    GIFfilename = ['Figure/SupplementaryGIF' int2str(Ntid+8) '.gif'];
    this_N_trial = N_trial(Ntid);
    hold(ax3,'on');
    for Nid = 1:length(N)
        this_N = N(Nid);
        this_P_sig = get_this_P_sig(SimCV.P_sig,this_N,Pcp,gamma,this_N_trial,SimCV.N,SimCV.Pcp,SimCV.gamma,SimCV.N_trial);
        i_eopt = NumRes.i_eopt(NumRes.N_trial==this_N_trial,NumRes.N==this_N);
        this_i_test_unif_bino = squeeze(this_P_sig(i_eopt,:,:));

        % FA of i-test-unif-bino
        plot_Psig(ax1,'FA',this_i_test_unif_bino)
        title(ax1,sprintf('False Alarm Rate (CV-Simulation) of \\sli-test-unif-bino\\rm (\\sli\\rm=%u)\n \\slN\\rm=%u (\\slN\\rm_{trial}=%u, \\gamma_0=%.1g, \\alpha=0.05)'...
           ,i_eopt ,N(Nid),N_trial(Ntid),NumRes.g_0),'FontSize',18,'FontName','Times');

        % draw contour figure (Figure 2 G,H,I)
        if mod(N(Nid),20)==0;
            my_contour(ax3,this_i_test_unif_bino,0.05,[1,1-(N(Nid)+20)/120,1-(N(Nid)+20)/120],1); 
        end
        % Save GIF
        [imind,cm] = rgb2ind(frame2im(getframe(h1)),256);
        if Nid == 1; imwrite(imind,cm,GIFfilename,'gif', 'Loopcount',inf);
        else; imwrite(imind,cm,GIFfilename,'gif','WriteMode','append'); end
    end
    % save contour figure (Figure 2 G,H,I)
    % Visualization setting    
        set(ax3,'YDir','Normal','YTick',10:10:(NumRes.g_0*100),'YTickLabel',0.1:0.1:NumRes.g_0,'XTick',10:10:50,'XTickLabel',0.6:0.1:1);
        xlabel(ax3,'\slP\rm_{correct+}','FontSize',14,'FontName','Times')
        ylabel(ax3,'\sl\gamma','FontSize',18,'FontName','Times')
        axis(ax3,[0.5 50.5 0.5 NumRes.g_0*100+.5])
        title(ax3,sprintf('FigureS1.2.4%c\n N_{trial}=%g',figalphabet(Ntid),N_trial(Ntid)))
        print(h3,'-dpsc','-append',FIGfilename);
        cla(ax3,'reset')
    
    
end







