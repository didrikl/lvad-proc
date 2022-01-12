function h_fig = plot_roc_curve_matrix_per_intervention_and_speed(R,...
		F,classifiers_to_use,titleStr)
	% Specific/max inflations by speeds in subplots
	% Plot ROC curves for states of specific or pooled intervention levels.
	%
	% Panel [no of states]x4 matrix setup:
	% - one panel row for each speed
	% - one panel colum for each state
	%
	% Curves overlaid in each panels for:
	% - NHA as classifier, component-wise

	speeds = [2200,2500,2800,3100];
	classifier_labels = classifiers_to_use(:,2);
	classifier_inds = find(ismember(R.classifiers,classifiers_to_use(:,1)));
	classifiers = R.classifiers(classifier_inds);
	
	%classifiers = R.classifiers;
	stateVar = R.stateVar;
	predStates = R.predStates;

	spec = get_plot_specs;
	figHeight = 900; %955
	figWidth = 1180;
	panelLength = 155;
	
	% Offsets for common axes
	mainAxGap = 0.01;
	
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
				X = R.X{i,j,classifier_inds(k)};
				Y = R.Y{i,j,classifier_inds(k)};

				h_ax(i,j).ColorOrderIndex = k;

				h_nha(k) = plot(h_ax(i,j),X(:,1),Y(:,1));
				if contains(classifiers{k},'y')
					set(h_nha(k),'LineWidth',4);
				elseif contains(classifiers{k},'x')
					set(h_nha(k),'LineWidth',3,'LineStyle',':');
				elseif contains(classifiers{k},'z')
					set(h_nha(k),'LineWidth',3,'LineStyle',':');
				end

			end

			% Plot diagonal guide line
			plot([0,1],[0,1],spec.rocDiag{:});

		end

		occl = num2str(min(round(unique(...
			F.arealOccl_pst(F.(stateVar)==predStates{i,1})))));
		text(1.10,0.5,{['\bf',occl,'%'],'\rmareal occl.'},spec.text{:});

	end

	set([h_ax(:);h_xax(:);h_yax(:)],'XTick',0:0.2:1);
	set([h_ax(:);h_xax(:);h_yax(:)],'YTick',0:0.2:1);
	
	format_axes_in_plot_NHA(h_ax,spec);
	format_axes_in_plot_NHA([h_xax,h_yax],spec);
	set(h_ax,spec.rocAx{:})
			
	[gap, h_ax] = position_roc_panels(panelLength, h_ax);

	% Make main axes offset
	offset_main_ax(h_ax,h_xax,h_yax,mainAxGap,mainAxGap);

	add_shaded_boxes_and_titles(h_ax,cellstr(string(speeds)+" RPM"),...
		panelLength,panelLength,gap,spec);
			
	format_tick_labels(h_xax, h_yax);


	h_xlab = suplabel('1 - Specificity');
	h_ylab = suplabel('Sensitivity','y');
	set(h_xlab,spec.supXLab{:})
	set(h_ylab,spec.supXLab{:})
	h_ylab.Position(1) = h_ylab.Position(1)+0.035;
	h_xlab.Position(2) = h_xlab.Position(2)+0.025;
	
	h_leg = legend(h_nha,classifier_labels,spec.leg{:},'Units','points');
	h_leg.Position(1) = h_leg.Position(1) + 125;%figWidth-20;% h_ax(end,end).Position(1)+h_ax(end,end).Position(3)+12;
	h_leg.Position(2) = 10;
  		
			