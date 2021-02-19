function P_sig= calc_Psig_sim_CV(N,N_trial,g_0,alpha,i,gamma,Pcp_true,Pcm_true,pm_est,N_sim,varargin)
% Simulation for calculation of the i-test's statistical power (or False alerm ratio).
% with cross-validated decoding accuracy

% if isinteger(varargin{1})
%     shortcutmode = false;
%     N_sess = varargin{1};
% elseif isstruct(varargin{1})
%     shortcutmode = true;
%     sim_CV_res_1st = varargin{1};
% end

% count the number of i, gamma, p_plus
N_i = length(i);
N_g = length(gamma);
N_p = length(Pcp_true);


% prepare output
P_sig = zeros(N_i,N_g,N_p);


%%%%%%%%%%%%%%%%%%%%%%
%% Main calculation %%
%%%%%%%%%%%%%%%%%%%%%%
% Calculation of P_sig for each combination of gamma, p_plus and i
    for gg = 1:N_g
        for pp = 1:N_p
                SD(:,:,pp,gg) = sim_gen_CV2(N,N_sim,gamma(gg),Pcp_true(pp),Pcm_true,N_trial,varargin{1});
        end
    end
for ii = 1:N_i
          Sig = itest_multi(SD,pm_est,i(ii),g_0,alpha);
            P_sig(ii,:,:) = permute(mean(Sig,2),[1 4 3 2]);
end
end % end of function

