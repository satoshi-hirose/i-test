function SD = sim_gen_CV2(N,N_sim,gamma,Pcp,Pcm,N_trial,varargin)
% Direct mode: simulate the CV-D-Acc for each participant in each
% simulation experiment: requires libSVM (https://www.csie.ntu.edu.tw/~cjlin/libsvm/)
% SD = sim_gen_CV2(N,N_sim,gamma,Pcp,Pcm,N_trial,N_sess)
% 
% Shortcut mode: the CV-D-Acc for each participant is chosen from results of 
% the first level simulation
% SD = sim_gen_CV2(N,N_sim,gamma,Pcp,Pcm,N_trial,sim_CV_res_1st)

if isinteger(varargin{1})
    shortcutmode = false;
    N_sess = varargin{1};
elseif isstruct(varargin{1})
    shortcutmode = true;
    sim_CV_res_1st = varargin{1};
end

%  N x N_sim-times Bernoulli trial for random selection of participant.
ID_plus = logical(binornd(1,gamma,N,N_sim)); % 1 if Omega+, 0 if Omega-

%  Random sapmling of D-Acc for each participant
    N_sub_plus = sum(ID_plus(:));
    N_sub_minus = N*N_sim-N_sub_plus;
    if shortcutmode
    SD_plus   = randsample(sim_CV_res_1st.SD(:,abs(sim_CV_res_1st.N_trial-N_trial)<eps,abs(sim_CV_res_1st.P-Pcp)<eps),N_sub_plus,true);
    SD_minus   = randsample(sim_CV_res_1st.SD(:,abs(sim_CV_res_1st.N_trial-N_trial)<eps,abs(sim_CV_res_1st.P-Pcm)<eps),N_sub_minus,true);
    else
    SD_plus   = sim_gen_CV1(N_sub_plus,N_trial,N_sess,Pcp);
    SD_minus   = sim_gen_CV1(N_sub_minus,N_trial,N_sess,Pcm);
    end        
    SD = NaN(N,N_sim);
    SD(ID_plus) = SD_plus;
    SD(~ID_plus) = SD_minus;
end % End of function
