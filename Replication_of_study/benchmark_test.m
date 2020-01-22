clear all

alpha = 0.05;
g_0 = 0.5;

%% idleing
N=5; S=100;
SD = rand(N,1);
PD = rand(N,S);
[H, prob0, stat] = itest(SD,PD,g_0,[],alpha,1);

%% original i-test: Supplementary Figure S6B
N_max = 1000;
Time= NaN(N_max,1);
for N=5:N_max

SD = rand(N,1);
PD = [rand(1,S); ones(1,S)/S];

tic
[H, prob0, stat] = itest(SD,PD,g_0,[],alpha,1);
Time(N) = toc;
disp([N Time(N)])
end

figure; plot(Time)

%%  i-test without i.d. assumption: Supplementary Figure S6A
N_max = 50;
Time2= NaN(N_max,1);
for N=5:N_max

SD = rand(N,1);
PD = rand(N,S);

tic
[H, prob0, stat] = itest(SD,PD,g_0,[],alpha,0);
Time2(N) = toc;
disp([N Time2(N)])
end

figure; plot(log10([Time2 Time]))