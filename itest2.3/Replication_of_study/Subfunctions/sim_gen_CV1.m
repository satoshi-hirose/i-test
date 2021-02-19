function [SD,PD] = sim_gen_CV1(N,N_trial,N_sess,P,Nperm)
% Generata cross-validated simulation results for individual subjects(first level).
% Permutation results are also generated, if two outputs are required 
% Requires libSVM (https://www.csie.ntu.edu.tw/~cjlin/libsvm/)

if nargout <= 1
    permuflag = 0;
elseif nargout == 2
    permuflag = 1;
end


% signal
S = norminv(P,0,1);

% label for one session
label = [ones(N_trial/N_sess/2,1);-ones(N_trial/N_sess/2,1)];

% label for training
labeltrain =repmat(label,N_sess-1,1);
% label for test
labeltest =label;
SD = zeros(N,1);

nword = 0;
tic;
for sub = 1:N
    if mod(sub,N/1000)==0
        fprintf(repmat('\b', 1, nword));
        nword = fprintf('%.1f%% with %.1fsec', round(sub/N*1000)/10,toc);
    end
    % voxel signal
    for sess = 1:N_sess
        if S==0
            x{sess,1} = randn(N_trial/N_sess,1);
        else
            x{sess,1} = randn(N_trial/N_sess,1)/S+label;
        end
    end
    
    % Cross validation
    for sess = 1:N_sess
        strain = 1:N_sess;
        strain(sess) = [];
        svmmodel = svmtrain(labeltrain, cell2mat(x(strain)),'-s 0 -t 0 -c 1 -q');
        labelpred = svmpredict(labeltest, x{sess}, svmmodel,'-q');
        acc(sess,1)  =sum(labelpred == labeltest);
    end
    SD(sub,1) = sum(acc)/N_trial;
    
    %% Permutation test
    if permuflag
    for permid = 1:Nperm
        for sess = 1:N_sess
            plabel(:,sess) = labeltest(randperm(length(labeltest)));
        end
        
        for sess = 1:N_sess
            strain = 1:N_sess;
            strain(sess) = [];
            plabeltrain = plabel(:,strain);
            plabeltrain = plabeltrain(:);
            plabeltest = plabel(:,sess);
            svmmodel = svmtrain(plabeltrain, cell2mat(x(strain)),'-s 0 -t 0 -c 1 -q');
            plabelpred = svmpredict(plabeltest, x{sess}, svmmodel,'-q');
            acc(sess,1)  =sum(plabelpred == plabeltest);
        end
        PD(sub,permid) = sum(acc)/N_trial;
        
    end
    end
end
fprintf('\n')
end % end of function
