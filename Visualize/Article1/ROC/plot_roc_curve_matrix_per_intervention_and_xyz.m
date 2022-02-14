function h_fig = plot_roc_curve_matrix_per_intervention_and_xyz(R,...
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
		{'\bf27%\rm areal occlussion'}
		{'\bf45%\rm areal occlussion'}
		{'\bf75%\rm areal occlussion'}
		};
	speeds = [2200,2500,2800,3100];
	classifier_labels = classifiers_to_use(:,2);
	classifier_inds = find(ismember(R.classifiers,classifiers_to_use(:,1)));
	classifiers = R.classifiers(classifier_inds);
	predStates = R.predStates;

	spec = get_plot_specs;
	figHeight = 855;%900; %955
	figWidth = 1180;
	panelLength = 155;
	gap_x = 35;
	gap_y = 25;
	
	% Offsets for common axes
	mainAxGap = 10;
	
	nRows = size(predStates,1);
	nCols = numel(classifiers);
	h_fig = figure(spec.fig{:},...
		'Name',titleStr,...
		'Position',[10,40,figWidth,figHeight]);
	
	for i=1:nRows

		for k=1:nCols

			h_ax(i,k) = subplot(nRows,nCols,(i-1)*nCols+k,spec.subPlt{:});
			if k==1, h_yax(i) = copyobj(h_ax(i,k),gcf); end
			if i==nRows, h_xax(k) = copyobj(h_ax(i,k),gcf); end

			% Plot classifiers overlaid with consistent colors for each panel
			for j=1:numel(speeds)
				X = R.X{i,j,classifier_inds(k)};
				Y = R.Y{i,j,classifier_inds(k)};

				h_ax(i,k).ColorOrderIndex = j;

				h_nha(k) = plot(h_ax(i,k),X(:,1),Y(:,1),...
					'LineWidth',1.5,...
					'LineStyle','-');
				set(h_nha(k),'Color',[h_nha(k).Color,0.7])
				
			end

			% Plot diagonal guide line
			plot([0,1],[0,1],spec.rocDiag{:});

		end

		text(1.10,0.5,rowLabels{i},spec.text{:});

	end

	
	% Format axes
	format_axes_in_plot_NHA(h_ax,spec);
	format_axes_in_plot_NHA([h_xax,h_yax],spec);
	%set(h_ax,spec.rocAx{:})
	%h_ax = position_panels(panelLength, h_ax, gap_x,gap_y);
	offset_main_ax(h_ax,h_xax,h_yax,mainAxGap,mainAxGap);			
	format_tick_labels(h_ax,h_xax, h_yax);
	
	add_subtitles(h_ax,classifier_labels,panelLength,gap_y,spec);

	h_xlab = suplabel('1 - Specificity');
	h_ylab = suplabel('Sensitivity','y');
	set(h_xlab,spec.supXLab{:})
	set(h_ylab,spec.supXLab{:})
	h_ylab.Position(1) = h_ylab.Position(1)+0.035;
	h_xlab.Position(2) = h_xlab.Position(2)+0.025;
	
	h_leg = legend(h_ax(end),string(speeds),spec.leg{:});
 	h_leg.Position(1) = h_leg.Position(1) + 140;%figWidth-20;% h_ax(end,end).Position(1)+h_ax(end,end).Position(3)+12;
 	h_leg.Position(2) = 10;		
			