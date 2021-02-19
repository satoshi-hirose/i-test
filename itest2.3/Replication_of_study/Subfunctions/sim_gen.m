function SD = sim_gen(N,N_sim,gamma,pp_true,pm_true)
% Generate simulated results

%  N x N_sim-times Bernoulli trial for random selection of participant.
ID_plus = logical(binornd(1,gamma,N,N_sim)); % 1 if Omega+, 0 if Omega-

%  Random sapmling of D-Acc for each participant
    N_sub_plus = sum(ID_plus(:));
    N_sub_minus = N*N_sim-N_sub_plus;
    SD_plus  = randsample(pp_true(1,:),N_sub_plus,true,pp_true(2,:));
    SD_minus = randsample(pm_true(1,:),N_sub_minus,true,pm_true(2,:));
    SD = NaN(N,N_sim);
    SD(ID_plus) = SD_plus;
    SD(~ID_plus) = SD_minus;

end


