function [Likelihood,g_mat,Pcp_mat] = calc_likelihood(SD,N_trial,Pcm,g_0,precision)
% [Likelihood,g_mat,Pcp_mat] = calc_likelihood(SD,N_trial,Pcm,g_0,precision)
% calculate likelihood of gamma and Pcp, i.e. p(gamma,Pcp|SD)
% under the assumption of binomial distribution of true D-Acc
%
% Inputs
%    SD: Sample Decoding accuracy (vector of probability)
%    N_trial: Number of trials (integer)
%    Pcm: Proabbility of correct decoding for Omega- (chance level)
%    g_0:  Prevalence threshold, gamma0 (Real number between 0 and 1)
%    precison: precision parameter for estimation of likeliihood (see below)
%    
% Output
%    Likelihood: Likelihood of the Pcp (Proabbility of correct decoding for
%    Omega+) and gamma. (row corresponds Pcp, column correcponds to gamma)
%    g_mat: matrix of gamma
%    Pcp_mat: matrix of Pcp
%
% Likelihood(a,b) is likelihood of g_mat(a,b) and Pcp_mat(a,b).

% Developed by SH 2020/11/12
% Modified by SH 2021/1/25

% Number of correct decoding for each participant
N_correct = round(SD*N_trial);

% possible gamma and Pcp (length(gamma), length(Pcp) is precision)
gamma = (g_0+precision):precision:1;
Pcp   = (Pcm+precision):precision:1;

% Number of Subject
N   = length(SD);

% Number of gamma and Pcp
Ng = length(gamma);
Np = length(Pcp);

% make [Np x Ng x N] matrix for Pcp and gamma and N_correct
% 1st dim: Pcp, 2nd dim: gamma, 3rd dim: subject
Pcp_mat = repmat(Pcp(:),[1,Ng,N]);
g_mat   = repmat(gamma(:)',[Np,1,N]);
Nc_mat  = repmat(reshape(N_correct,[1,1,N]),[Np,Ng,1]);

% make [precision x precision x N] matrix for likelihood given that each participant belongs to Omega-
P_minus_mat = repmat(reshape(binopdf(N_correct,N_trial,Pcm),[1,1,N]),[Np,Ng,1]);

% Calculate likelihood
Likelihood = prod(g_mat.*binopdf(Nc_mat,N_trial,Pcp_mat) + (1-g_mat).* P_minus_mat,3);

% save g_mat and Pcp_mat
g_mat = g_mat(:,:,1);
Pcp_mat = Pcp_mat(:,:,1);

end % end of function

 