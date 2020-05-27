function meansTrajs = plotTrajMeanRBstartMove(labelsLUT, clrs, trajData, labels, ...
    mvStartInd, toneTime, afterToneInd, viewparams, labelsFontSz)

classes = unique(labels);
for ci = 1:length(classes)
    meansTrajs(:, :, ci) = mean(trajData(:,:,labels==classes(ci)),3);
    plot3(meansTrajs(1,:, ci), meansTrajs(2,:, ci), meansTrajs(3,:, ci),'Color', clrs(ci, :), 'LineWidth',5);
    hold all;
end
placeTimePointsOnTraj(clrs, meansTrajs, mvStartInd, toneTime, afterToneInd);
for ci = 1:length(classes)
    plot3(meansTrajs(1,:, ci), meansTrajs(2,:, ci), meansTrajs(3,:, ci),'Color', clrs(ci, :), 'LineWidth',5);
    hold all;
end
if ~all(viewparams==0)
    view(viewparams);
end
a=get(gcf,'Children');
xlabel('\psi_1', 'FontSize',labelsFontSz);ylabel('\psi_2', 'FontSize',labelsFontSz);
zlabel('\psi_3', 'FontSize',labelsFontSz);

axis tight
grid on;
% if length(classes) == length(labelsLUT)
    labels = labelsLUT;
% else
% labels = labelsLUT(classes);
% end
l=legend(cat(2,labels ,{'Start','Tone'}),'Location','northeastoutside');
set(l, 'FontSize',labelsFontSz);
end

function placeTimePointsOnTraj(clrs, meansTrajs, mvStartInd, toneTime, afterToneInd)
for ci = 1:size(meansTrajs, 3)
    if ~isempty(mvStartInd)
        plot3(meansTrajs(1,mvStartInd, ci), meansTrajs(2,mvStartInd, ci), meansTrajs(3,mvStartInd, ci),'Marker', 's', 'MarkerFaceColor','w','MarkerSize',10,...
            'MarkerEdgeColor',clrs(ci,:))
    end
    if ~isempty(toneTime)
        plot3(meansTrajs(1,toneTime, ci), meansTrajs(2,toneTime, ci),meansTrajs(3,toneTime, ci),'ko','MarkerSize',10,...
            'MarkerFaceColor','w',...
            'MarkerEdgeColor',clrs(ci,:))
    end
    
    if ~isempty(afterToneInd)
        plot3(meansTrajs(1,afterToneInd, ci), meansTrajs(2,afterToneInd, ci),meansTrajs(3,afterToneInd, ci),'k^','MarkerSize',10,...
            'MarkerFaceColor','w',...
            'MarkerEdgeColor',clrs(ci,:))
    end
end
end
