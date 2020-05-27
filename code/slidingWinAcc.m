function  [chanceLevel, tmid, accSVM] = slidingWinAcc(X, ...
    labels, winstSec, winendSec, foldsnum, islin, tendTrial)

t = linspace(0,tendTrial, size(X,2));

tmid = (winendSec + winstSec)/2;
rng('default');
randinds = randperm(length(labels));

b=hist(labels,unique(labels));
chanceLevel=max(b./sum(b));
%% wins

accSVM.mean=[];



for win_i = 1:length(winstSec)
    
    Xwin = X(:,t >= winstSec(win_i) & t <= winendSec(win_i),:);
    rawX=squeeze(mean(Xwin,2))';
    ACC = svmClassify(rawX, labels, foldsnum, islin, false);
    accSVM.mean(win_i) = ACC.mean;
    accSVM.std(win_i) = ACC.std;
    accSVM.accv(:, win_i) = ACC.acc_v;
    
end

end



function [accSVM, accRandSVM] = setStats(ACC, ACCrand, win_i, accSVM, accRandSVM)
accSVM.mean(win_i) = ACC.mean;
accSVM.std(win_i) = ACC.std;
accSVM.accv(:, win_i) = ACC.acc_v;
% raw rand
accRandSVM.mean(win_i) = ACCrand.mean;
accRandSVM.std(win_i) = ACCrand.std;
accRandSVM.accv(:, win_i) = ACCrand.acc_v;
end

