function [dprime, dprimeNext] =evalDprime(trajData, labels)



classes = unique(labels);
for k=1:length(classes)
    for d = 1:size(trajData,1)
        meanVals(d, :, k) = mean(permute(trajData(d,:,labels==classes(k)),[2 3 1]),2);
        eVals(d, :, k) = mean(std(permute(trajData(d,:,labels==classes(k)),[2 3 1]),0,2),3);
        varVals(d, :, k) = mean(var(permute(trajData(d,:,labels==classes(k)),[2 3 1]),0,2),3);
    end
    %     shadedTraj(meanVals(1:2, :, k),eVals(1:2, :, k),'lineprops',{'-b'});
end


trajData=trajData(:,:,2:end);
labels=labels(1:end-1);
for k=1:length(classes)
    for d = 1:size(trajData,1)
        meanValsNext(d, :, k) = mean(permute(trajData(d,:,labels==classes(k)),[2 3 1]),2);
        varValsNext(d, :, k) = mean(var(permute(trajData(d,:,labels==classes(k)),[2 3 1]),0,2),3);
    end
end

meanValsAll = cat(2,meanVals, meanValsNext);
varValsAll = cat(2,varVals, varValsNext);

dprime = (meanVals(:,:,1)-meanVals(:,:,2))./sqrt(0.5*(varVals(:,:,1)+varVals(:,:,2)));
dprimeNext = (meanValsNext(:,:,1)-meanValsNext(:,:,2))./sqrt(0.5*(varValsNext(:,:,1)+varValsNext(:,:,2)));

