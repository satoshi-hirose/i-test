function [i_opt,P_sig_w_sum] = calc_i_opt_wsum(P_sig,w)
% find the optimal i from P_sig, which maximize the weighted sum of P_sig. 
% INPUT
% P_sig:probability of significant results
%    [length of i] x [length of gamma] Å~ [length of P_correct_plus]
% w: Weight for each combination of gamma and P_correct_plus
%                    [length of gamma] Å~ [length of P_correct_plus]
%    If w is not specified, uniform distribution is used
% 
% OUTPUT
% i_opt: id of the optimal i (Positive Integer)
% P_sig_w_sum: weighted sum of P_sig

% 2021/1/25 Modified by SH

% if w is not specified, use uniform distribution
if ~exist('w','var'); w = ones(size(P_sig,2),size(P_sig,3)); end

% normalize w so that sum(w,'all') = 1
w = w/sum(w(:));

P_sig_w = P_sig.*repmat(permute(w,[3 1 2]),[size(P_sig,1),1,1]);
P_sig_w_sum = nansum(P_sig_w,[2 3]);
[~,i_opt] = max(P_sig_w_sum);

end % end of function