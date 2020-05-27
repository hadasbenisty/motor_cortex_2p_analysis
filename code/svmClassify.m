function acc = svmClassify(X, Y, foldsNum, islin, tonorm)
if ~exist('islin', 'var')
    islin = false;
end

X=X.';
if size(X,2) ~= length(Y)
    error('Dims are inconsistent');
end
if foldsNum >= length(Y)
    INDICES = 1:length(Y);
else
    INDICES = crossvalind('Kfold',length(Y),foldsNum);
end
if tonorm
    Xnorm = (X - min(X(:)))/(max(X(:))-min(X(:)));
else
    Xnorm=X;
end
log2c = -6:10;log2g = -6:4;
classes = unique(Y);
wstr=' ';
for w_i=1:length(classes)
    w = sum(Y==classes(w_i))/length(Y);
    wstr=[wstr ' -w' num2str(classes(w_i)) ' ' num2str(w)];
end
for fold_i = 1:length(unique(INDICES))
    testinds = find(INDICES == fold_i);
    cvinds = setdiff(1:length(Y), testinds);
    if islin
        bestc(fold_i) = cvsvmclassification(Xnorm(:,cvinds).', Y(cvinds), 2.^log2c, [], foldsNum);
        SVMModel(fold_i) = svmtrain(Y(cvinds), Xnorm(:,cvinds)', ['-t 0 -q  -c ', num2str(bestc(fold_i)) ' ' wstr] );
    else
        [bestc(fold_i), bestg(fold_i)] = cvsvmclassification(Xnorm(:,cvinds).', Y(cvinds), 2.^log2c, 2.^log2g, foldsNum);
        SVMModel(fold_i) = svmtrain(Y(cvinds), Xnorm(:,cvinds)', ['-t 2 -q  -c ', num2str(bestc(fold_i)) ' -g ' num2str(bestg(fold_i)) wstr] );
        
    end
    [predictions, ~, score] = svmpredict(Y(testinds), sparse(Xnorm(:,testinds))', SVMModel(fold_i));
    acc_v(fold_i) = sum(predictions==Y(testinds))/length(testinds);
    
    
    
end
acc.acc_v = acc_v;
acc.mean = mean(acc_v(~isnan(acc_v)));
acc.std  = std(acc_v(~isnan(acc_v)));

end


