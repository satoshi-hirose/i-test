
run('../Subfunctions/init_for_replication.m')

% benchmark test
N =5:50;
N_trial=[10 100 1000];
Pcm = 0.5;
g_0 = 0.5;
alpha =0.05;
Niter = 100;
precision = 0.01;
skip_preparation=0;
n_perm = 100;
for Nid = 1:length(N)
    for Ntid = 1:length(N_trial)
        disp([Nid,Ntid])
        for ite = 1:Niter
            SD = binornd(N_trial(Ntid),0.6,N(Nid),1)/N_trial(Ntid);
            tic;
            [H, prob, stat] = itest_unif_bino(SD,N_trial(Ntid),Pcm,g_0,alpha,precision,skip_preparation);
            time = toc;
            T_all(Nid,Ntid,ite)=time;
        end
    end
end

save ../Results/Benchmark_Test T_all

