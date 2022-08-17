function hFig = plot_roc_per_balloon_level(ROC, classifiersToUse)
	% Plot ROC curves for states of specific intervention levels.
	% - One panel for each balloon level state

	classifierLabels = classifiersToUse(:,2);
	classifier_inds = find(ismember(ROC.classifiers,classifiersToUse(:,1)));
	classifiers = ROC.classifiers(classifier_inds);
	
	spec = get_plot_specs;
		
	figHeight = 422;%900; %955
	figWidth = 340;
	pLength = 82.5;
	gap = 13;
	
	[hFig, hSub] = init_panels(spec, figWidth, figHeight);
	adjust_panel_positions(hSub, pLength, gap)
	[hXAx, hYAx] = make_ax_offset(hSub, hFig);
	
	levels = 2:4;

	for i=1:numel(levels)

		% Plot classifiers overlaid with consistent colors for each panel
		for k=1:numel(classifiers)
		
			% Plot diagonal guide line
			plot(hSub(i), [0,1], [0,1], spec.rocDiag{:},'LineWidth',0.8,'LineStyle','-','Color',[.6 .6 .6]);

			lev = levels(i);
			X = ROC.X{lev,1,classifier_inds(k)};
			Y = ROC.Y{lev,1,classifier_inds(k)};
			
			hSub(i).ColorOrderIndex = k;
			hPlt(k) = plot(hSub(i), X(:,1), Y(:,1));

			if contains(classifiers{k},'norm')
				
				set(hPlt(k), ...
					'LineWidth',1.5, ...
					'Color',[0.07,0.39,0.50]);%[0 0 0]);% [0.76,0.0,0.2]);
     			area(hSub(i), X(:,1), Y(:,1), ...
					'FaceColor',[0.07,0.39,0.50], ...[0 0 0], ... [0.40,0.0,0.2],...
     				'EdgeColor','none', ...
					'FaceAlpha',0.028, ...
					'HandleVisibility','Off')
				nhaAUC(i,:) = ROC.AUC{lev,1,classifier_inds(k)};
			
			elseif contains(classifiers{k},'P_LVAD')
				
				set(hPlt(k), 'LineWidth',1.5, 'LineStyle','-.', 'Color',[0.857,0.50,0.13]);
  				area(hSub(i), X(:,1), Y(:,1), 'FaceColor',[0.65,0.50,0.13],...
					'EdgeColor','none', 'FaceAlpha',0.04, 'HandleVisibility','Off')
				plvadAUC(i,:) = ROC.AUC{lev,1,classifier_inds(k)};
			
			end


		end

		
	end
	
	add_annotations(hSub, hXAx, hYAx, classifierLabels, nhaAUC, plvadAUC, spec);
	%	set(hSub,'Color',[.965,.965,.965],'GridColor',[1 1 1],'GridLineStyle','-','GridAlpha',1)
	

function [hFig, hSub] = init_panels(spec, figWidth, figHeight)
	
	hFig = figure(spec.fig{:},...
		'Name','ROC curves per balloon level',...
	    'Position',[300,300,figWidth,figHeight],...
		'PaperUnits','centimeters',...
		'PaperSize',[9,9*(figHeight/figWidth)+0.1]...
		);
	
	hSub(1) = subplot(3,1,1, spec.subPlt{:}, 'FontSize',9, 'LineWidth',1);
	hSub(2) = subplot(3,1,2, spec.subPlt{:}, 'FontSize',9, 'LineWidth',1);
	hSub(3) = subplot(3,1,3, spec.subPlt{:}, 'FontSize',9, 'LineWidth',1);
	
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

function adjust_panel_positions(hSub, pLength, gap)
	
	yStart = 40;
	xStart = 36;
	hSub(3).Position = [xStart, yStart, pLength, pLength];
	hSub(2).Position = [xStart, yStart + gap + pLength, pLength, pLength];
	hSub(1).Position = [xStart, yStart + 2*gap + 2*pLength, pLength, pLength];

function add_annotations(hSub, hXAx, hYAx, classifierLabels,nhaAUC, plvadAUC, spec)
	
	text(hSub(1), 1.2, 0.5, {...
		'\bfLevel 2\rm',...
		'50%-65% obstrution',...
		'','AUC:'...
		['    ',sprintf('%1.2f [%1.2f, %1.2f]',nhaAUC(1,1),nhaAUC(1,2),nhaAUC(1,3))], ...
		['    ',sprintf('%1.2f [%1.2f, %1.2f]',plvadAUC(1,1),plvadAUC(1,2),plvadAUC(1,3))]}, ...
		"FontSize", 9, "FontName",'Arial', 'VerticalAlignment','middle');
	text(hSub(2), 1.2, 0.5, {...
		'\bfLevel 3\rm',...
		'65%-75% obstruction',...
		'','AUC:'...
		['    ',sprintf('%1.2f [%1.2f, %1.2f]',nhaAUC(2,1),nhaAUC(2,2),nhaAUC(2,3))], ...
		['    ',sprintf('%1.2f [%1.2f, %1.2f]',plvadAUC(2,1),plvadAUC(2,2),plvadAUC(2,3))]}, ...
		"FontSize", 9, "FontName",'Arial', 'VerticalAlignment','middle');
	text(hSub(3), 1.2, 0.45, {...
		'\bfLevel 4\rm',...
		'75%-83% obstruction',...
		'','AUC:'...
		['    ',sprintf('%1.2f [%1.2f, %1.2f]',nhaAUC(3,1),nhaAUC(3,2),nhaAUC(3,3))], ...
		['    ',sprintf('%1.2f [%1.2f, %1.2f]',plvadAUC(3,1),plvadAUC(3,2),plvadAUC(3,3))]}, ...
		"FontSize", 9, "FontName",'Arial', 'VerticalAlignment','middle');
	
	hXLab = xlabel(hXAx, '1 - specificity', 'FontSize',10, 'FontName','Arial', 'Units', 'pixels');
	hYLab = ylabel(hYAx(2), 'Sensitivity', 'FontSize',10, 'FontName','Arial', 'Units', 'pixels');
	hXLab.Position(2) = hXLab.Position(2)-5;
	hYLab.Position(1) = -29;
	hLeg = legend(hSub(end), classifierLabels, spec.leg{:}, "FontSize", 10, 'Units','pixels');
 	hLeg.Position(1) = 255;
	hLeg.Position(2) = 0;

function [hXAx,hYAx] = make_ax_offset(hSub, hFig)
	
	hYAx = copyobj(hSub, hFig);
	hXAx = copyobj(hSub(3), hFig);
	
	for i=1:3
		hSub(i).XAxis.Color = 'none';
		hSub(i).YAxis.Color = 'none';
		set(hSub, 'XTick',.2:.2:.8, 'YTick',.2:.2:.8);
	end

	set([hXAx;hYAx], 'LineWidth',1.5, 'box','off', 'Color','none', ...
		'YGrid','off', 'XGrid','off')
	
	hXAx.Position(2) = hXAx.Position(2)-3;
	set(hXAx.YAxis, 'Color','none')

	for i=1:numel(hYAx)
		hYAx(i).Position(1) = hYAx(i).Position(1)-3;
		set(hYAx(i).XAxis, 'Color','none')
	end

