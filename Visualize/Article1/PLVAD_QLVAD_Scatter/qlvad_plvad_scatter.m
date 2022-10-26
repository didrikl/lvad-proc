close all
clampInd = contains(string(F.levelLabel),'load') & F.interventionType=='Control';
balloonInd = contains(string(F.balLev),{'1','3'});

% subplot(1,2,1)
% hold on
% scatter(F.Q_LVAD_mean(F.pumpSpeed==2200 & clampInd),F.P_LVAD_mean(F.pumpSpeed==2200 & clampInd))
% scatter(F.Q_LVAD_mean(F.pumpSpeed==2500 & clampInd),F.P_LVAD_mean(F.pumpSpeed==2500 & clampInd))
% scatter(F.Q_LVAD_mean(F.pumpSpeed==2800 & clampInd),F.P_LVAD_mean(F.pumpSpeed==2800 & clampInd))
% scatter(F.Q_LVAD_mean(F.pumpSpeed==3100 & clampInd),F.P_LVAD_mean(F.pumpSpeed==3100 & clampInd))
% ylim([1.5,6.5])
% xlim([0,6.5])
% 
% subplot(1,2,2)
% hold on
% scatter(F.Q_LVAD_mean(F.pumpSpeed==2200 & balloonInd),F.P_LVAD_mean(F.pumpSpeed==2200 & balloonInd))
% scatter(F.Q_LVAD_mean(F.pumpSpeed==2500 & balloonInd),F.P_LVAD_mean(F.pumpSpeed==2500 & balloonInd))
% scatter(F.Q_LVAD_mean(F.pumpSpeed==2800 & balloonInd),F.P_LVAD_mean(F.pumpSpeed==2800 & balloonInd))
% scatter(F.Q_LVAD_mean(F.pumpSpeed==3100 & balloonInd),F.P_LVAD_mean(F.pumpSpeed==3100 & balloonInd))
% ylim([1.5,6.5])
% xlim([0,6.5])

figure('Position',[50,50,600,600])
h = axes(...
	'Color',[.95 .95 .95], ...
	'GridColor',[1 1 1], ...
	'Color',[1 1 1], ...
	'LineWidth',2, ...
	'XGrid','on', ...
	'YGrid','on', ...
	'TickDir','out', ...
	'FontName','Arial', ...
	'FontSize',9.5 ...
	);
hold on
ylim([0.75,6.5])
xlim([-.25,6.5])
ptSize = 20;

inds = clampInd;
scatter(F.Q_LVAD_mean(F.pumpSpeed==2200 & inds),F.P_LVAD_mean(F.pumpSpeed==2200 & inds), ptSize, 'MarkerFaceAlpha',0.3, 'MarkerEdgeColor','flat')
scatter(F.Q_LVAD_mean(F.pumpSpeed==2500 & inds),F.P_LVAD_mean(F.pumpSpeed==2500 & inds), ptSize, 'MarkerFaceAlpha',0.3, 'MarkerEdgeColor','flat')
scatter(F.Q_LVAD_mean(F.pumpSpeed==2800 & inds),F.P_LVAD_mean(F.pumpSpeed==2800 & inds), ptSize, 'MarkerFaceAlpha',0.3, 'MarkerEdgeColor','flat')
scatter(F.Q_LVAD_mean(F.pumpSpeed==3100 & inds),F.P_LVAD_mean(F.pumpSpeed==3100 & inds), ptSize, 'MarkerFaceAlpha',0.3, 'MarkerEdgeColor','flat')
 
h.ColorOrderIndex=1;
inds = balloonInd;

x = F.Q_LVAD_mean(F.pumpSpeed==2200 & inds);
y = F.P_LVAD_mean(F.pumpSpeed==2200 & inds);
scatter(x, y, ptSize, 'filled','MarkerFaceAlpha',0.35,'MarkerEdgeColor','flat')
% [rho,pVal] = corr(x, y, 'Type','Spearman');
% pol = polyfit(x, y, 1);
% f = polyval(pol, x);
% h.ColorOrderIndex = h.ColorOrderIndex-1;
% plot(x,f,'HandleVisibility','off',...
% 	'LineWidth',1.5 ...
% 	);

scatter(F.Q_LVAD_mean(F.pumpSpeed==2500 & inds),F.P_LVAD_mean(F.pumpSpeed==2500 & inds), ptSize, 'filled','MarkerFaceAlpha',0.35,'MarkerEdgeColor','flat')
scatter(F.Q_LVAD_mean(F.pumpSpeed==2800 & inds),F.P_LVAD_mean(F.pumpSpeed==2800 & inds), ptSize, 'filled','MarkerFaceAlpha',0.35,'MarkerEdgeColor','flat')
scatter(F.Q_LVAD_mean(F.pumpSpeed==3100 & inds),F.P_LVAD_mean(F.pumpSpeed==3100 & inds), ptSize, 'filled','MarkerFaceAlpha',0.35,'MarkerEdgeColor','flat')

xlabel('\itQ\rm_{LVAD} (L min^{-1})')
ylabel('\itP\rm_{LVAD} (W)')
hLeg = legend({'2200 RPM, clamp','2500 RPM, clamp','2800 RPM, clamp','3100 RPM, clamp','2200 RPM, balloon','2500 RPM, balloon','2800 RPM, balloon','3100 RPM, balloon'},...
	'box','off',...
	'Location','southeast',...
	'NumColumns',1);
%hLeg.Title.String = '\rmpump speed, intervention type';