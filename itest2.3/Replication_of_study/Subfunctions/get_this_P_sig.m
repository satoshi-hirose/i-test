function P_sig = get_this_P_sig(P_sig,N,Pcp,gamma,N_trial,N_all,Pcp_all,gamma_all,N_trial_all)

Nid=getid(N_all,N);
pcpid=getid(Pcp_all,Pcp);
gid=getid(gamma_all,gamma);
Ntid=getid(N_trial_all,N_trial);

P_sig = cellfun(@(xx) xx(:, gid, pcpid),P_sig(Ntid,Nid),'UniformOutput',false);
if length(P_sig)==1;
    P_sig=P_sig{1};
end

end
function id = getid(all,this)
tol = 10^-10;
for temp = 1:length(this)
id(temp) = find(abs(all - this(temp))<tol);
end
end