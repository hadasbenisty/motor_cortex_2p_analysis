function svmAccuracyAnalysis(X, labels)


foldsnum = 10;
islin = true;
duration = 12;
slidingWinLen = 1;
slidingWinHop = 0.5;

[winstSec, winendSec] = getFixedWinsFine(duration, slidingWinLen, slidingWinHop);

[chanceLevel, tmid, accSVM] = slidingWinAcc(X, ...
    labels, winstSec, winendSec, foldsnum, islin, duration);

        
   
% visualize
labelsFontSz = 14;
toneTime = 4;
duration = 12;

t=linspace(0,duration, size(X,2))-toneTime;

figure;
stdplusmean = accSVM.mean+accSVM.std;
stdplusmean=min(stdplusmean,1);
shadedErrorBar(tmid-toneTime,accSVM.mean,stdplusmean-accSVM.mean,'lineprops',{'-k'});

ylabel('Accuracy', 'FontSize',labelsFontSz);axis tight;
hold all;

plot(tmid-toneTime, ones(size(tmid))*chanceLevel, '--k');

ylim([min(chanceLevel*.9, min(get(gca,'YLim'))), max(1,  max(get(gca,'YLim')))]);
xlim([-2.5 7.5]);
line([0 0], get(gca, 'YLim'), 'Color','k','LineWidth',2, 'LineStyle', ':');

set(gca, 'Box','off');




end

function [winstSec, winendSec] = getFixedWinsFine(tendTrial, D, d)

st = 0:d:tendTrial;
en = st+D;
inds = find(en <= tendTrial);
winstSec=st(inds);
winendSec=en(inds);
end