function plot_nha_versus_flow_scatter_1panel(var, F, F_rel, F_del)

	figHeight = 265;
	figWidth = 340;
	pWidth = 120;
	pHeight = 200;
	gap = 58;
	ptSize = 21;

	spec = get_plot_specs;
	hFig2 = figure(...
		'Name','Flow (at corresponding baseline) versus NHA elevation',...
		'Position',[300,300,figWidth,figHeight],...
		'PaperUnits','centimeters',...
		'PaperSize',[9,9*(figHeight/figWidth)+0.1]...
		);

	hSub(1) = subplot(1,2,1, spec.subPlt{:}, 'FontSize',9, 'LineWidth',1);
	hSub(2) = subplot(1,2,2, spec.subPlt{:}, 'FontSize',9, 'LineWidth',1);

	set(hSub(1:2), ...
		'Units','pixels',...
		...'YLim',[-1,10.8], ...
		'XLim',[1.15,4.15], ...
		'XLim',[2.05,4.25], ...
		'FontSize',9, ...
		'LineWidth',1, ...
		'XTick',1:0.5:4, ...
		'YTick',-2:2:11, ...
		'XTickLabelRotation',0, ...
		'YTickLabelRotation',0, ...
		'GridColor',[0 0 0], ...
		'GridAlpha',0.22, ...
		'GridLineStyle',':', ...
		'XGrid','on', ...
		'YGrid','on', ...
		'TickDir','out',...
		'TickLength',[0.025,0] ...
		);
	yStart = 50;
	xStart = 38;
	hSub(1).Position = [xStart, yStart, pWidth, pHeight];
	hSub(2).Position = [xStart + pWidth + gap, yStart, pWidth, pHeight];

	inds = ismember(F.balLev_xRay_mean,[0]) & F.interventionType~='Reversal';
	inds = contains(string(F.idLabel),'Nom') & F.interventionType~='Reversal';
	F2 = F;
	F2 = F2(inds,:);
	F2( F2.(var) == max(F2.(var)),:) = [];
	x = F2.Q_mean;
	y = F2.(var);
	x = x(not(isnan(y)));
	y = y(not(isnan(y)));
	t = table(x,y);
	t = sortrows(t,'x');
	scatter(hSub(1), t.x, t.y, ptSize,'filled', 'MarkerFaceAlpha',0.35);
	hold on

	[R,p,uB,lB] = corrcoef(t.x, t.y);
	pol = polyfit(t.x, t.y, 1);
	t.f = polyval(pol, t.x);
	hSub(1).ColorOrderIndex = hSub(1).ColorOrderIndex-1;
	plot(hSub(1), t.x, t.f, 'HandleVisibility','off', 'LineWidth',2);
	title(hSub(1), 'Baseline', 'FontWeight','normal');
	hTxt(1) = text(hSub(1),2.3, 7, {['\itr\rm = ',num2str(R(1,2),'%2.2f')]});
	fprintf('Correlation, baseline: %2.2f (p=%1.4f)\n',R(1,2),p(1,2))

	inds = ismember(F.balLev_xRay_mean,[2,3,4]) & F.interventionType~='Reversal';
	x = F.Q_mean(inds)-F_del.Q_mean(inds); % in view of corresponding BL flow
	y = F_rel.(var)(inds);
	x = x(not(isnan(y)));
	y = y(not(isnan(y)));
	t = table(x,y);
	t = sortrows(t,'x');
	scatter(hSub(2), t.x, t.y, ptSize,'filled', 'MarkerFaceAlpha',0.35);
	hold on
	[R,p,uB,lB] = corrcoef(t.x, t.y);
	pol = polyfit(t.x, t.y, 1);
	t.f = polyval(pol, t.x);
	hSub(2).ColorOrderIndex = hSub(2).ColorOrderIndex-1;
	plot(t.x, t.f, 'HandleVisibility','off', 'LineWidth',2);
	title(hSub(2), 'Level 2-4', 'FontWeight','normal');
	hTxt(1) = text(hSub(2),2.2, 7, {['\itr\rm = ',num2str(R(1,2),'%2.2f')]});

	ylim(hSub(1),[0,6]);
	ylim(hSub(2),[-1,11]);

	fprintf('Correlation, level 2-4: %2.2f (p=%1.4f)\n',R(1,2),p(1,2))

	%hXLab = suplabel('baseline flow rate (L min^{-1})','x');
	xlabel(hSub(1),'flow (L min^{-1})');
	xlabel(hSub(2),'flow (L min^{-1})');
	hYLab(1) = ylabel(hSub(1),'NHA','Units','pixels');
	hYLab(2) = ylabel(hSub(2),'relative NHA elevation','Units','pixels');
	%hYLab.Position(1) = hYLab.Position(1)-6;
	hXLab.Units = 'pixels';
	%hXLab.Position(2) = hXLab.Position(2)+4;
