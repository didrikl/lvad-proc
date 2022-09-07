function plot_nha_versus_flow_scatter_3panels(var, F, F_rel, F_del)

	if nargin<4, F_del = []; end

	figHeight = 241;
	figWidth = 340;
	pWidth = 90;
	pHeight = 180;
	gap = 8;
	levs = [2,3,4];
	ptSize = 21;

	spec = get_plot_specs;
	nhaColor = [0.07,0.39,0.50];
	nhaColor = [0.76,0.0,0.2];
	
	hFig = figure(...
		'Name','Flow (actual) versus NHA elevation',...
		'Position',[300,300,figWidth,figHeight],...
		'PaperUnits','centimeters',...
		'PaperSize',[9,9*(figHeight/figWidth)]...
		);

	hSub(1) = subplot(1,4,1, spec.subPlt{:}, 'FontSize',8.5, 'LineWidth',1);
	hSub(2) = subplot(1,4,2, spec.subPlt{:}, 'FontSize',8.5, 'LineWidth',1);
	hSub(3) = subplot(1,4,3, spec.subPlt{:}, 'FontSize',8.5, 'LineWidth',1);

	set(hSub, ...
		'Units','pixels',...
		'YLim',[-1,10.65], ...
		'XLim',[1.15,4.15], ...
		'XLim',[2.10,4.25], ...
		'FontSize',9, ...
		'LineWidth',1, ...
		'XTick',1:0.5:4, ...
		'YTick',-2:2:10, ...
		'XTickLabelRotation',0, ...
		'YTickLabelRotation',0, ...
		'Color',[.96 .96 .96], ...
		'GridColor',[0 0 0], ...
		'GridAlpha',0.22, ...
		'GridColor',[1 1 1], ...
		'GridAlpha',1, ...
		'GridLineStyle',':', ...
		'GridLineStyle','-', ...
		'XGrid','on', ...
		'YGrid','on', ...
		'TickDir','out',...
		'TickLength',[0.025,0] ...
		);
	if isempty(F_del)
	   xlim(hSub(1),[1.9,4.2]);
	   xlim(hSub(2),[1.6,3.8]);
	   xlim(hSub(3),[0.9,3.2]);
	end
	
	adjust_panel_positions(hSub, pWidth, pHeight, gap)
	hSub(2).YAxis.Visible = 'off';
	hSub(3).YAxis.Visible = 'off';
	yTickLabels = 100*yticks(hSub(1))+"%";
	yticklabels(hSub(1),yTickLabels)
	hYAx = make_ax_offset(hSub, hFig);

	fprintf('\n')
	for i=1:numel(levs)
		inds = F.balLev_xRay_mean==levs(i) & F.interventionType~='Reversal';
		if isempty(F_del)
			x = F.Q_mean(inds); % in view of actual flow
		else
			x = F.Q_mean(inds)+abs(F_del.Q_mean(inds)); % in view of corresponding BL flow
		end
		y = F_rel.(var)(inds);
		x = x(not(isnan(y)));
		y = y(not(isnan(y)));
		t = table(x,y);
		t = sortrows(t,'x');
		scatter(hSub(i),t.x,t.y,ptSize,'filled',...
			'MarkerFaceColor',[0 0 0],...[0.76,0.00,0.20],...[0.07,0.39,0.50], ...
			'MarkerFaceAlpha',0.4);
		hold on
		[rho,pVal] = corr(t.x, t.y, 'Type','Spearman');
		pol = polyfit(t.x, t.y, 1);
		t.f = polyval(pol, t.x);
		fprintf('Correlation, level %d: %2.2f (p=%1.3f)\n',levs(i), rho, pVal)

		plot(hSub(i),t.x,t.f,'HandleVisibility','off',...
			'LineWidth',2, ...
			'Color',nhaColor);%[0 0 0 ]);%[0.76,0.00,0.20]);%...[0.07,0.39,0.50]);
		xLims = xlim(hSub(i));
		hTxt(i) = text(hSub(i), xLims(1)+0.25, 9.5, {['\rho\rm = ',num2str(rho,'%2.2f')]},...
			'FontName','Arial',...
			'FontSize',9.5);
		hTit = title(hSub(i), ['level ',num2str(levs(i))],'FontWeight','normal','FontSize',9,'FontName','Arial');
		hTit.Position(2) = hTit.Position(2)+0.25;
	end

	hXLab = suplabel('flow rate (L min^{-1})','x');
	hXLab.Position(2) = hXLab.Position(2)+0.01;
	hXLab.FontSize = 9;
	hXLab.FontName = 'Arial';
	adjust_corr_text_position(F_del, hTxt);

function hYAx = make_ax_offset(hSub, hFig)
	hYAx = copyobj(hSub(1), hFig);
	hSub(1).YAxis.Color = 'none';
	set(hYAx, 'box','off', 'Color','none', 'YGrid','off', 'XGrid','off', 'Units','pixels')
	hYAx.Position(1) = hYAx.Position(1)-8;
	set(hYAx(1).XAxis, 'Color','none')

function adjust_panel_positions(hSub, pWidth, pHeight, gap)
	set(hSub,'Units','pixels');
	yStart = 45;
	xStart = 54;
	hSub(1).Position = [xStart, yStart, pWidth, pHeight];
	hSub(2).Position = [xStart + pWidth + gap, yStart, pWidth, pHeight];
	hSub(3).Position = [xStart + 2*pWidth + 2*gap, yStart, pWidth, pHeight];

function adjust_corr_text_position(F_del, hTxt)
	if isempty(F_del)
  		hTxt(1).Position = [2.1,1.85,0];
   		hTxt(2).Position = [1.7,3.15,0];
   		hTxt(3).Position = [1.15,4.95,0];
	else
 		hTxt(1).Position = [2.316054421768706,1.642972600853641,0];
 		hTxt(2).Position = [2.086,2.94,0];
 		hTxt(3).Position = [2.172470823191661,4.335068153655516,0];
	end
	