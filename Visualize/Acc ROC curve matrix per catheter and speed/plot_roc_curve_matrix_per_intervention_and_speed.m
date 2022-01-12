function h_fig = plot_roc_curve_matrix_per_intervention_and_speed(ROC,...
		classifiers_to_use,titleStr)
	% Specific/max inflations by speeds in subplots
	% Plot ROC curves for states of specific or pooled intervention levels.
	%
	% Panel [no of states]x4 matrix setup:
	% - one panel row for each speed
	% - one panel colum for each state
	%
	% Curves overlaid in each panels for:
	% - NHA as classifier, component-wise

	rowLabels = {
		{'\bfCatheter 2\rm','27% areal obstruction'}
		{'\bfCatheter 3\rm','45% areal obstruction'}
		{'\bfCatheter 4\rm','75% areal obstruction'}
		};
	rowLabels = {
		{'\bf27%\rm','obstruction'}
		{'\bf45%\rm','obstruction'}
		{'\bf75%\rm','obstruction'}
		};
% 	rowLabels = {
% 		{'\bf27%\rm AO'}
% 		{'\bf45%\rm AO'}
% 		{'\bf75%\rm AO'}
% 		};
	speeds = [2200,2500,2800,3100];
	classifier_labels = classifiers_to_use(:,2);
	classifier_inds = find(ismember(ROC.classifiers,classifiers_to_use(:,1)));
	classifiers = ROC.classifiers(classifier_inds);
	predStates = ROC.predStates;

	spec = get_plot_specs;
	figHeight = 850;%900; %955
	figWidth = 1180;
	panelLength = 152;
	gap = 25;
	
	% Offsets for common axes
	mainAxGap = 17;
	
	nRows = size(predStates,1);
	nCols = numel(speeds);
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
				if contains(classifiers{k},'y')
					set(h_nha(k),'LineWidth',4);
%  					area(X(:,1),Y(:,1),'FaceColor',h_nha(k).Color,...
%  						'EdgeColor','none', 'FaceAlpha',0.07)
% 					plot_shaded(X(:,1),Y(:,1),'LineWidth',0.1,'Color',h_nha(k).Color);
% 					text(0.625,0.3,[num2str(AUC(1),'%1.2f')],spec.text{:})
				elseif contains(classifiers{k},'x')
					set(h_nha(k),'LineWidth',2.25,'LineStyle',':','Color',min(1.1*h_nha(k).Color,[1 1 1]));
				elseif contains(classifiers{k},'z')
					set(h_nha(k),'LineWidth',2.25,'LineStyle',':','Color',min(1.1*h_nha(k).Color,[1 1 1]));
				elseif contains(classifiers{k},'P_LVAD')
					if i<nRows, set(h_nha(k),'Visible','off'); end
					set(h_nha(k),'LineWidth',1.5,'LineStyle',':',...
						'Color',[h_nha(k).Color,0.9]);
				end

			end

			% Plot diagonal guide line
			plot([0,1],[0,1],spec.rocDiag{:});

		end

		text(1.10,0.5,rowLabels{i},spec.text{:});

	end
	
	% Format axes
	format_axes_in_plot_NHA(h_ax,spec);
	format_axes_in_plot_NHA([h_xax,h_yax],spec);
	set(h_ax,spec.rocAx{:})
	h_ax = position_panels(panelLength,h_ax,gap);
	offset_main_ax(h_ax,h_xax,h_yax,mainAxGap,mainAxGap);			
	format_tick_labels(h_ax,h_xax, h_yax);
	
	add_subtitles(h_ax,cellstr("\bf"+string(speeds)+"\rm RPM"),panelLength,gap,spec);

	h_xlab = suplabel('1 - Specificity');
	h_ylab = suplabel('Sensitivity','y');
	set(h_xlab,spec.supXLab{:})
	set(h_ylab,spec.supXLab{:})
	h_ylab.Position(1) = h_ylab.Position(1)+0.032;
	h_xlab.Position(2) = h_xlab.Position(2)+0.025;
	
	h_leg = legend(h_nha,classifier_labels,spec.leg{:},'Units','points');
	h_leg.Position(1) = h_leg.Position(1) + 114;%132;%figWidth-20;% h_ax(end,end).Position(1)+h_ax(end,end).Position(3)+12;
	h_leg.Position(2) = 0;
  		
			