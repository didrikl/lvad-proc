function h_fig = plot_roc_curve_matrix_per_intervention_and_speed(R,...
		F,classifiers,titleStr)
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
	classifier_labels = classifiers(:,2);
	classifiers = classifiers(:,1);

	%classifiers = R.classifiers;
	stateVar = R.stateVar;
	predStates = R.predStates;

	spec = get_specs_for_plot_NHA;
	
	nRows = size(predStates,1);
	nCols = numel(speeds);
	h_fig = figure(spec.fig{:},'Name',titleStr,...
		'Position',[10,10,1700,1050]);
	
	for i=1:nRows
		
		for j=1:nCols
			
			h_ax(i,j) = subplot(nRows,nCols+1,(nCols+1)*(i-1)+j);
			format_axes_in_plot_NHA(h_ax(i,j),spec.rocAx,spec.axTick)
			pbaspect(h_ax(i,j),[1 1 1]);
			set(h_ax(i,j),'XTick',0:0.2:1);
			set(h_ax(i,j),'YTick',0:0.2:1);
			hold on
			if j==1, h_yax(i) = copyobj(h_ax(i,j),gcf); end
			if i==nRows, h_xax(j) = copyobj(h_ax(i,j),gcf); end
						
			% Add annotations
			if i==1 
				h_subTit(j) = title({string(speeds(j))+" RPM",''}); 
			end
			if j==nCols
				subStr = num2str(min(round(unique(...
					F.arealOccl_pst(F.(stateVar)==predStates{i,1})))));
				text(1.10,0.5,{['\bf{',predStates{i,2},'}'],...
					['\rm{',subStr,'% areal occlusion}']},...
					'FontSize',13);
			end
			
			% Plot classifiers overlaid with consistent colors for each panel
			for k=1:numel(classifiers)
				
				X = R.X{i,j,k};
				Y = R.Y{i,j,k};
				
				h_ax(i,j).ColorOrderIndex = k;
				
				h_nha = plot(h_ax(i,j),X(:,1),Y(:,1));
				if contains(classifiers{k},'y')
					set(h_nha,'LineWidth',4);
				elseif contains(classifiers{k},'x')
					set(h_nha,'LineWidth',3,'LineStyle','-.');
				elseif contains(classifiers{k},'z')
					set(h_nha,'LineWidth',3,'LineStyle',':');
				end
				
			end

			% Plot diagonal guide line
			plot([0,1],[0,1],spec.rocDiag{:});
 			
			set(h_ax(i,j),spec.rocAx{:})
			xlim([0,1])
			ylim([0,1])
			
		end
		
	end
	
	% // Add the new axes:
	for i=1:nRows
		h_yax(i).Position = h_ax(i,1).Position;
		h_yax(i).Position(1) = h_yax(i).Position(1)-0.0125;
		h_yax(i).XAxis.Visible = 'off';
		h_yax(i).YLim = h_ax(i,1).YLim;
		h_yax(i).YTick = h_ax(i,1).YTick;
	end
	
	% Add the new axes:
	for j=1:nCols
		h_xax(j).YAxis.Visible = 'off';
		h_xax(j).XLim = h_ax(nRows,j).XLim;
		h_xax(j).XTick = h_ax(nRows,j).XTick;
		h_xax(j).XTickLabel = h_ax(nRows,j).XTickLabel;
		h_xax(j).Position = h_ax(nRows,j).Position;
		h_xax(j).Position(2) = h_xax(j).Position(2)-0.0125;
	end
			
	set(h_yax,'YColor',[0,0,0])
	set(h_xax,'XColor',[0,0,0])
	set([h_xax,h_yax],'Color','none');
	set([h_xax,h_yax],'XGrid','off');
	set([h_xax,h_yax],'YGrid','off');
	set([h_xax,h_yax],'Box','off');
	
	
	h_axleg = subplot(nRows,nCols+1,(nCols+1)*nRows);
	hold on
	for k=1:numel(classifiers)
		h_plt(k) = plot(1,1);
		if contains(classifiers{k},'y')
			set(h_plt(k),...
				'LineWidth',4);
		else
			set(h_plt(k),'LineWidth',3);
			h_plt(k).LineStyle = ':';
		end
	end
	set(h_axleg,spec.rocAx{:},'Visible','off')
% 	h_leg = legend(h_axleg,{'x','y','z'},spec.leg{:}); %'\it{-\DeltaP}\rm_{LVAD}'
% 	h_leg.Title.String = 'Direction';
	%h_leg.Title.String = 'NHA';
	h_leg = legend(h_plt([2,1,3]),classifier_labels([2,1,3]),spec.leg{:}); %'\it{-\DeltaP}\rm_{LVAD}'
	
	% Make panels closer together
	% ---------------------------------------
	for j=2:nCols
		for i=1:nRows
			for J=j:nCols
				h_ax(i,J).Position(1) = h_ax(i,J).Position(1)-0.025;
			end
		end
		for J=j:nCols
			h_xax(J).Position(1) = h_xax(J).Position(1)-0.025;
		end
	end

	for i=2:nRows
		for j=1:nCols
			for I=i:nRows
				h_ax(I,j).Position(2) = h_ax(I,j).Position(2)+0.07;
			end
		end
		for I=i:nRows
			h_yax(I).Position(2) = h_yax(I).Position(2)+0.07;
		end
		for j=1:nCols
			h_xax(j).Position(2) = h_ax(nRows,1).Position(2)-0.021;
		end
	end

	h_xlab = suplabel('1 - Specificity');
	h_ylab = suplabel('Sensitivity','y');
	h_xlab.Position(2) = h_xlab.Position(2)+0.025;
	set(h_xlab,spec.supXLab{:})
	set(h_ylab,spec.supXLab{:})
	h_ylab.Position(1) = h_ylab.Position(1)+0.025;
	
	h_leg.Position(1) = h_xax(end).Position(1)+h_xax(end).Position(3)+0.05;
 	h_leg.Position(2) = h_ylab.Position(2);

	set(h_subTit,spec.subTit{:})
	set(h_ax,'XTickLabel',[],'YTickLabel',[]);
			