function hFig = plot_roc_per_balloon_level(ROC, ROC_Pooled, classifiersToUse, classifiersToUsePooled)
	% Plot ROC curves for states of specific intervention levels.
	% - One panel for each balloon level state

	spec = get_plot_specs;
	
	figHeight = 422;
	figWidth = 710;
	pLength = 82.5;
	gap = 12;
	
	[hFig, hSub] = init_panels(spec, figWidth, figHeight);
	
	adjust_panel_positions(hSub(1:3), pLength, gap, 1);
	adjust_panel_positions(hSub(4:6), pLength, gap, 2);
	
	[hXAx1, hYAx1] = make_ax_offset(hSub(1:3), hFig);
	[hXAx2, hYAx2] = make_ax_offset(hSub(4:6), hFig);

	make_plots(hXAx1, hYAx1, classifiersToUse, ROC, hSub(1:3), spec);
	make_plots(hXAx2, hYAx2, classifiersToUsePooled, ROC_Pooled, hSub(4:6), spec);
	
	annotation('line',[.5 .5],[0 1 ], 'LineWidth',.7, 'Color',[.15 .15 .15]);
	text(hSub(1), -.55, 1, 'A', 'FontSize',13, 'FontName','Arial','VerticalAlignment','middle')
	text(hSub(4), -.55, 1, 'B', 'FontSize',13, 'FontName','Arial','VerticalAlignment','middle')
%  	text(hSub(1), 0, 1.1, {'2400 RPM'}, 'FontSize',9.5, 'FontName','Arial','FontWeight','normal','VerticalAlignment','bottom','HorizontalAlignment','center');
%  	text(hSub(4), 0, 1.1, {'Pooled for all RPM'}, 'FontSize',9.5, 'FontName','Arial','FontWeight','normal','VerticalAlignment','bottom','HorizontalAlignment','center');

function [hFig, hSub] = init_panels(spec, figWidth, figHeight)
	
	hFig = figure(spec.fig{:},...
		'Name','ROC curves per balloon level',...
	    'Position',[300,300,figWidth,figHeight],...
		'PaperUnits','centimeters',...
		'PaperSize',[19,19*(figHeight/figWidth)]...
		);
	
	for i=1:3
		hSub(i) = subplot(3,2,i, spec.subPlt{:});
		hSub(i+3) = subplot(3,2,i+3, spec.subPlt{:});
	end
	
	set(hSub, spec.subPlt{:}, ...
		'FontSize',9, ...
	     'LineWidth',1, ...
		 'XTick',0:0.2:1, ...
		 'YTick',0:0.2:1, ...
		 'XTickLabel',{'0','.2','.4','.6','.8','1'},...
		 'YTickLabel',{'0','.2','.4','.6','.8','1'},...
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
	linkaxes(hSub)

function adjust_panel_positions(hSub, pLength, gap, colNo)
	
	if colNo==1, xStart = 50; end
	if colNo==2, xStart = 40 + 285; end
	
	yStart = 40;
	hSub(3).Position = [xStart, yStart, pLength, pLength];
	hSub(2).Position = [xStart, yStart + gap + pLength, pLength, pLength];
	hSub(1).Position = [xStart, yStart + 2*gap + 2*pLength, pLength, pLength];

function add_annotations(hSub, hPlt, hXAx, hYAx, levels, classifierLabels,nhaAUC, plvadAUC, spec)
	
	for i=1:numel(levels)
		if all(isnan(plvadAUC))
			aucStr = {'','AUC:'...
				['    ',sprintf('%1.2f [%1.2f, %1.2f]',nhaAUC(i,1),nhaAUC(i,2),nhaAUC(i,3))]};
		else
			aucStr = {'','AUC:'...
				['    ',sprintf('%1.2f [%1.2f, %1.2f]',nhaAUC(i,1),nhaAUC(i,2),nhaAUC(i,3))], ...
				['    ',sprintf('%1.2f [%1.2f, %1.2f]',plvadAUC(i,1),plvadAUC(i,2),plvadAUC(i,3))]};
		end
	text(hSub(i), 1.2, 0.5, [{['\bflevel ',num2str(levels(i)),'\rm']}, aucStr],...
		"FontSize", 9, "FontName",'Arial', 'VerticalAlignment','middle');
	end
	
	hXLab = xlabel(hXAx(end), '1 - specificity', 'FontSize',10, 'FontName','Arial', 'Units', 'pixels');
	hYLab = ylabel(hYAx(2), 'sensitivity', 'FontSize',10, 'FontName','Arial', 'Units', 'pixels');
	hXLab.Position(2) = hXLab.Position(2)-5;
	hYLab.Position(1) = -29;
	
	hLeg = legend(hPlt, classifierLabels, spec.leg{:}, ...
		"FontSize", 9, 'Units','pixels');
  	hLeg.Position(1) = hLeg.Position(1)+179;
	hLeg.Position(2) = 0;

function [hXAx,hYAx] = make_ax_offset(hSub, hFig)
	
	hYAx = copyobj(hSub, hFig);
	hXAx = copyobj(hSub(end), hFig);
	
	for i=1:3
		hSub(i).XAxis.Color = 'none';
		hSub(i).YAxis.Color = 'none';
		set(hSub, 'XTick',.2:.2:.8, 'YTick',.2:.2:.8);
	
	end

	hXAx(end).Position(2) = hXAx(end).Position(2)-5;
	set([hXAx;hYAx], 'LineWidth',1, 'box','off', 'Color','none', ...
		'YGrid','off', 'XGrid','off')
	set(hXAx(end).YAxis, 'Color','none')
	
	for i=1:numel(hYAx)
		hYAx(i).Position(1) = hYAx(i).Position(1)-4;
		set(hYAx(i).XAxis, 'Color','none')
	end

function make_plots(hXAx, hYAx, classifiersToUse, ROC, hSub, spec)
	
	nhaColor = [0.76,0.0,0.2];
	nhaShadeColor = [0.5,0.5,0.5];
	plvadColor = [0.857,0.50,0.13];
	
	classifierLabels = classifiersToUse(:,2);
	classifier_inds = find(ismember(ROC.classifiers,classifiersToUse(:,1)));
	classifiers = ROC.classifiers(classifier_inds);
	
	levels = 2:4;
	nhaAUC = nan(numel(levels),3);
	lvadAUC = nan(numel(levels),3);
	for i=1:numel(levels)
		
		% Plot classifiers overlaid with consistent colors for each panel
		for k=1:numel(classifiers)
			
			% Plot diagonal guide line
			plot(hSub(i), [0,1], [0,1], spec.rocDiag{:},'LineWidth',0.8,'LineStyle','-','Color',[.6 .6 .6]);
			hSub(i).ColorOrderIndex = k;
			
			lev = levels(i);
			X = ROC.X{lev,1,classifier_inds(k)};
			Y = ROC.Y{lev,1,classifier_inds(k)};
			pt = ROC.Optimal_Point{lev,1,classifier_inds(k)};
			ptInd = find(Y>=0.8, 1, 'first');
			hPlt(k) = plot(hSub(i), X(:,1), Y(:,1));
			
			%if contains(classifiers{k},'norm')
			if contains(classifiers{k},'P_LVAD')
				
				set(hPlt(k), 'LineWidth',1.5, 'LineStyle','-.', 'Color',plvadColor);
				area(hSub(i), X(:,1), Y(:,1), ...
					'FaceColor',[.5 .5 .5],...[0.857,0.50,0.13],...plvadColor,...
					'EdgeColor','none', ...
					'FaceAlpha',0.07, ...
					'HandleVisibility','Off');
				lvadAUC(i,:) = ROC.AUC{lev,1,classifier_inds(k)};
				
			else

				set(hPlt(k), ...
					'LineWidth',1.5, ...
					'Color',nhaColor);
				area(hSub(i), X(:,1), Y(:,1), ...
					'FaceColor',nhaShadeColor,...
					'EdgeColor','none', ...
					'FaceAlpha',0.07, ...
					'HandleVisibility','Off'),
				nhaAUC(i,:) = ROC.AUC{lev,1,classifier_inds(k)};
			
			end
			
		end
		
		
	end
	
	add_annotations(hSub, hPlt, hXAx, hYAx, levels, classifierLabels, nhaAUC, lvadAUC, spec);
	%	set(hSub,'Color',[.965,.965,.965],'GridColor',[1 1 1],'GridLineStyle','-','GridAlpha',1)
