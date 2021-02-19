% Code for results reported in Section 3.
% draw Figure 2
% Crease SupplementaryGIF1,2,3,4
% Display values in the text in Section 3.

% initialization
run('Subfunctions/init_for_replication.m')

% load parameters and probability of significant result (P_sig{N_trial,N}(i,gamma,Pcp))
% N: Number of subject, 5:100
% N_trial: Number of trials, [10 100 1000] 
% gamma: true gamma 0:0.01:1
% Pcp: (stands for P correct plus) mean D-Acc with label information 0.51:0.01:1
% Pcm: (stands for P correct minus) mean D-Acc without label information 0.5
% alpha: statistical threshold: 0.05
% g_0: prevalance threshold: 0.5
% Note: subfunction "get_this_P_sig" can extract the contents of P_sig relevant to the analysis

NumRes = load('Results/Numerical_Caliculation_Computation_g0_5');

%% Optimal i for i-test-unif-bino
% with uniform prior of gamma and Pcp and binomial distribution of D-Acc
N = NumRes.N;
N_trial = NumRes.N_trial;
gamma = (NumRes.g_0+0.01):0.01:1;
Pcp     =  (NumRes.Pcm+0.01):0.01:1;

this_P_sig = get_this_P_sig(NumRes.P_sig,N,Pcp,gamma,N_trial,NumRes.N,NumRes.Pcp,NumRes.gamma,NumRes.N_trial);
% find estimated optimal i (i_eopt for i-test-unif-bino) for each combination of Nid and Ntid
for Nid = 1:size(this_P_sig,2)
    for Ntid = 1:size(this_P_sig,1)
        NumRes.i_eopt(Nid,Ntid) = calc_i_opt_wsum(this_P_sig{Ntid,Nid});
    end
end

%% i_max
for Nid = 1:size(this_P_sig,2)
    NumRes.i_max(Nid,1) = size(NumRes.P_sig{1,Nid},1);
end

%% minimum number of subject for i-test with i>=2
Nmin_i2 = NumRes.N(find(NumRes.i_max>1,1,'first'));

%
FIGfilename = 'Figure/Figure2.ps';
close all
h1 = figure(1);clf(h1);ax1 = gca(h1); h1.Position = [950 700 560 480];
h2 = figure(2);clf(h2);ax21=subplot(1,3,1);ax22=subplot(1,3,2);ax23=subplot(1,3,3); h2.Position = [100 100 2200 500]; 

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
this_P_sig = get_this_P_sig(NumRes.P_sig,N,Pcp,gamma,N_trial,NumRes.N,NumRes.Pcp,NumRes.gamma,NumRes.N_trial);

%% Values for text
fprintf('i_max is %d\n',i_max)

mingamma_highpower = gamma(find(any(squeeze(this_P_sig(1,:,:)>0.8)'),1));

fprintf('P_sig>0.8 required gamma >= %g for i-test-one \n',mingamma_highpower)

i_opt = NumRes.i_eopt(NumRes.N==N,NumRes.N_trial==N_trial);
fprintf('i_opt for i-test-unif-bino is %g \n',i_opt)

%% draw Figure 2 A-E & SupplementaryGIF1
GIFfilename = 'Figure/SupplementaryGIF1.gif';
figid=0;
figalphabet = 'ABCDE';
for i = 1:i_max
    % plot statistical power
    plot_Psig(ax1,'Power',squeeze(this_P_sig(i,:,:)))
    title(ax1,sprintf('Statistical power (numerically calculated) with \\sli\\rm=%u\n(\\slN\\rm=%u, \\slN\\rm_{trial}=%u, \\gamma_0=%.1g, \\alpha=0.05)'...
        ,i,N,N_trial,NumRes.g_0),'FontSize',18,'FontName','Times');
    drawnow

    % Save GIF
    [imind,cm] = rgb2ind(frame2im(getframe(h1)),256);
    if i == 1; imwrite(imind,cm,GIFfilename,'gif', 'Loopcount',inf);
    else; imwrite(imind,cm,GIFfilename,'gif','WriteMode','append'); end
        
    % Save Figure
    if any(i==[1 5 10 15 19])
        figid = figid+1;
        title(ax1,sprintf('Figure2%c: i=%g',figalphabet(figid),i),'FontName','Arial')
        print(h1,'-dpsc','-append',FIGfilename);
    end
end

%% Draw Figure 2F: Difference between i-test-unif-bino vs. i-test-one
% plot the difference
plot_Psig(ax1,'Difference',squeeze(this_P_sig(i_opt,:,:)-this_P_sig(1,:,:)))
title(ax1,'Figure2F difference of Power i-test-unif-bino vs. i-test-one','FontName','Arial')
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
        this_P_sig = get_this_P_sig(NumRes.P_sig,this_N,Pcp,gamma,this_N_trial,NumRes.N,NumRes.Pcp,NumRes.gamma,NumRes.N_trial);
        mingamma_highpower(Ntid,Nid) = gamma(find(any(squeeze(this_P_sig(1,:,:)>0.8)'),1));
    end
end
minmingamma_highpower = min(mingamma_highpower,[],'all');
fprintf('P_sig>0.8 required gamma >= %g for i-test-one \n',minmingamma_highpower)

%% draw Figure 2 G-I supplementaryGIF 2,3,4
N = Nmin_i2:100;
N_trial =  NumRes.N_trial;
gamma = (NumRes.g_0+0.01):0.01:1;
Pcp     =  (NumRes.Pcm+0.01):0.01:1;

figalphabet = 'GHI';

cla(ax1,'reset');
for Ntid = 1:3
    GIFfilename = ['Figure/SupplementaryGIF' int2str(Ntid+1) '.gif'];
    this_N_trial = N_trial(Ntid);
    hold(ax1,'on');
    for Nid = 1:length(N)
        this_N = N(Nid);
        % get the results with the number of trials: this_N_trial, the number of participants: this_N
        this_P_sig = get_this_P_sig(NumRes.P_sig,this_N,Pcp,gamma,this_N_trial,NumRes.N,NumRes.Pcp,NumRes.gamma,NumRes.N_trial);
        i_eopt = NumRes.i_eopt(NumRes.N==this_N,NumRes.N_trial==this_N_trial);
        this_i_test_unif_bino = squeeze(this_P_sig(i_eopt,:,:));
        this_i_test_one = squeeze(this_P_sig(1,:,:));
        
        % power of i-test-unif-bino
        plot_Psig(ax21,'Power',this_i_test_unif_bino)
        title(ax21,sprintf('\\sli-test-unif-bino\\rm (\\sli\\rm=%u)',i_eopt),'FontSize',18,'FontName','Times')
        
        % power of i-test-one
        plot_Psig(ax22,'Power',this_i_test_one)
    title(ax22,sprintf('Statistical Power (numerically calculated) with \\slN\\rm=%u (\\slN\\rm_{trial}=%u, \\gamma_0=%.1g, \\alpha=0.05)\n\\sli-test-one\\rm (\\sli\\rm=1)'...
        ,N(Nid),N_trial(Ntid),NumRes.g_0),'FontSize',18,'FontName','Times');
        
        % difference
         plot_Psig(ax23,'Difference',this_i_test_unif_bino-this_i_test_one)
         title('Difference between \sli-test-unif-bino\rm and \sli-test-one\rm','FontSize',18,'FontName','Times')
            
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
        title(ax1,sprintf('Figure2%c: N_{trial}=%g',figalphabet(Ntid),N_trial(Ntid)),'FontName','Arial')
    print(h1,'-dpsc','-append',FIGfilename);
    cla(ax1,'reset')
    
end

%%
% Get values for text. False alarm
%
% Also, we confirmed that the false positive ratio ($P_{sig}$ for $\gamma<\gamma_0$;
% FPR) was below the statistical threshold $\alpha$ for all tested situation

N = NumRes.N;
N_trial = NumRes.N_trial;
gamma = 0:0.01:NumRes.g_0;
Pcp     =  (NumRes.Pcm+0.01):0.01:1;

this_P_sig = get_this_P_sig(NumRes.P_sig,N,Pcp,gamma,N_trial,NumRes.N,NumRes.Pcp,NumRes.gamma,NumRes.N_trial);

% Should be empty
if isempty(find(cell2mat(this_P_sig(:))>=NumRes.alpha, 1))
    fprintf('FA rate was always below alpha.\n')
end


