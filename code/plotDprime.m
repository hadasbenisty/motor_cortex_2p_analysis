function f = plotDprime(t, dprime, dprimeNext, labelsFontSz, xlimmin, toneTime)



m = (min(0.9*min(sum(dprime.^2)), 0.9*min(sum(dprimeNext.^2))));
M = (max(1.1*max(sum(dprime.^2)), 1.1*max(sum(dprimeNext.^2))));


f(1)=figure;plot(t, sum(dprime.^2), 'k');xlabel('Time [sec]', 'FontSize', labelsFontSz);
ylabel('Sensitivity Index', 'FontSize', labelsFontSz);
axis tight;
set(gca, 'Box','off');
% % grid on;

a=get(gcf,'Children');
yticks = get(a, 'YTick');
M = yticks(end)+yticks(2)-yticks(1);
ylim([m M]);
% set(a, 'YTick', yticks);
set(gca,'XLim',[xlimmin t(end)]);

line([0 0], get(gca, 'YLim'), 'Color','k','LineWidth',2, 'LineStyle', ':');

xlabel('Time [sec]','FontSize',labelsFontSz);
ylabel('Sensitivity Index','FontSize',labelsFontSz);
