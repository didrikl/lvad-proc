function h_fig = plot_roc_curve_matrix_G1(ROC, classifiersToUse, titleStr)
	% Specific/max inflations by speeds in subplots
	% Plot ROC curves for states of specific or pooled intervention levels.
	%
	% Panel [no of states]x4 matrix setup:
	% - one panel row for each speed
	% - one panel colum for each state
	%
	% Curves overlaid in each panels for:
	% - NHA as classifier, component-wise

	classifierLabels = classifiersToUse(:,2);
	classifier_inds = find(ismember(ROC.classifiers,classifiersToUse(:,1)));
	classifiers = ROC.classifiers(classifier_inds);
	
	spec = get_plot_specs;
		
	nRows = size(ROC.predStates,1);
	nCols = size(ROC.X,2);
	figHeight = 1050;%900; %955
	figWidth = (750/3)*nCols+430;
	panelLength = 150;
	gap = 20;
	mainAxGap = 15;
	h_fig = figure(spec.fig{:},...
		'Name',titleStr,...
		'Position',[10,40,figWidth,figHeight]);
	
	for i=1:nRows

		for j=1:nCols

			h_ax(i,j) = subplot(nRows,nCols,(i-1)*nCols+j,spec.subPlt{:});
			if j==1, h_yax(i) = copyobj(h_ax(i,j),gcf); end
			if i==nRows, h_xax(j) = copyobj(h_ax(i,j),gcf); end

			% Plot classifiers overlaid with consistent colors for each panel
			for k=1:numel(classifiers)
				X = ROC.X{i,j,classifier_inds(k)};
				Y = ROC.Y{i,j,classifier_inds(k)};
				AUC = ROC.AUC{i,j,classifier_inds(k)};

				h_ax(i,j).ColorOrderIndex = k;
				h_nha(k) = plot(h_ax(i,j),X(:,1),Y(:,1));

				if contains(classifiers{k},'sum')
					set(h_nha(k),'LineWidth',4);
   					area(X(:,1),Y(:,1),'FaceColor',h_nha(k).Color,...
						'EdgeColor','none', 'FaceAlpha',0.06,'HandleVisibility','Off')
% 					plot_shaded(X(:,1),Y(:,1),'LineWidth',0.1,'Color',h_nha(k).Color);
  					text(0.625,0.3,[num2str(AUC(1),'%1.2f')],spec.rocText{:})
				elseif contains(classifiers{k},'norm')
					set(h_nha(k),'LineWidth',2.25,'LineStyle',':','Color',min(1.1*h_nha(k).Color,[1 1 1]));
				elseif contains(classifiers{k},'best')
					set(h_nha(k),'LineWidth',2.25,'LineStyle',':','Color',min(1.1*h_nha(k).Color,[1 1 1]));
				elseif contains(classifiers{k},'P_LVAD')
					if i<nRows, set(h_nha(k),'Visible','on'); end
					set(h_nha(k),'LineWidth',1.5,'LineStyle',':',...
						'Color',[h_nha(k).Color,0.9]);
				end


			end

			% Plot diagonal guide line
			plot([0,1],[0,1],spec.rocDiag{:});

		end

		text(1.15,0.5, ROC.predStates{i,2}, spec.rocText{:});

	end
	
	hXLab = suplabel('1 - specificity','x');
	hYLab = suplabel('Sensitivity','y');
	
	% Format axes
	format_axes_in_plot_NHA(h_ax,spec);
	format_axes_in_plot_NHA([h_xax,h_yax],spec);
	set(h_ax,spec.rocAx{:})
	h_ax = position_panels(panelLength,h_ax,gap);
	offset_main_ax(h_ax,h_xax,h_yax,mainAxGap,mainAxGap);			
  	format_tick_labels(h_ax, h_xax, h_yax);
	set(h_ax,'YTickLabel',{},'XTickLabel',{},'GridLineStyle','-','GridColor',[.9 .9 .9]);
	set(h_ax,'LineWidth',1,'XTick',0:0.2:1,'YTick',0:0.2:1);
	
	h_leg = legend(h_ax(end), classifierLabels, spec.leg{:});
	if ROC.pooledSpeed
		add_subtitles(h_ax,"\bf{All}\rm RPM",panelLength,gap,spec);
	else
		add_subtitles(h_ax,cellstr("\bf"+string(ROC.speeds)+"\rm RPM"),panelLength,gap,spec);
	end	
	set([hXLab,hYLab],spec.supXLab{:})
	hYLab.Position(1) = 60;
    hXLab.Position(1) = 0;%(10/3)*nCols;
	h_leg.Position(1) = h_leg.Position(1) + 275;

	h_leg.Position(2) = 0;%hXLab.Position(2);

function h_ax = position_panels(panelLength,h_ax,gap_x,gap_y)
	
	if nargin==3, gap_y = gap_x; end

	rowStart = 80;
	colStart = 80;
	[nRows,nCols] = size(h_ax);
	for i=1:nRows
		rowPos = (nRows-i)*(panelLength+gap_y)+rowStart;
		for j=1:nCols
			colPos = (j-1)*(panelLength+gap_x)+colStart;
			h_ax(i,j).Position = [colPos,rowPos,panelLength,panelLength];
		end
	end
