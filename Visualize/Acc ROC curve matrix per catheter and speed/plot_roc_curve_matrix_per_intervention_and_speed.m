function h_fig = plot_roc_curve_matrix_per_intervention_and_speed(...
		F,classifiers,stateVar,predStates,titleStr,pooled)
	% Specific/max inflations by speeds in subplots
	% Plot ROC curves for states of specific intervention levels.
	%
	% Panel [no of states]x4 matrix setup:
	% - one panel row for each speed
	% - one panel colum for each pooled state
	%
	% Curves overlaid in each panels for:
	% - NHA as classifier
	% - Power as classifier
	
	speeds = [2200,2500,2800,3100];
	
	spec = get_specs_for_plot_NHA;
	
	k=1;
	nRows = size(predStates,1);
	nCols = numel(speeds);
	h_fig = figure(spec.fig{:},...
		'Name',[titleStr,' - ',classifiers{k},' as NHA classifier'],...
		'Position',[10,10,1200,800] ...
		);
	
	
	for i=1:size(predStates,1)
		
		if pooled
			state_inds = F.(stateVar)>=predStates{i,1};
		else
			state_inds = F.(stateVar)==predStates{i,1};
		end
		
		
		for j=1:nCols
			
			h_ax(i,j) = subplot(nRows,nCols+1,(nCols+1)*(i-1)+j);
			format_axes_in_plot_NHA(h_ax(i,j),spec.ax,spec.axTick)
			pbaspect(h_ax(i,j),[1 1 1]);
			set(h_ax(i,j),'XTick',0:0.2:1);
			set(h_ax(i,j),'YTick',0:0.2:1);
			hold on
			if j==1, h_yax(i) = copyobj(h_ax(i,j),gcf); end
			if i==nRows, h_xax(j) = copyobj(h_ax(i,j),gcf); end
			if i==1,h_subTit(i,j) = title({string(speeds(j))+" RPM",''}); end
			
			inds = (state_inds | F.interventionType=='Control' )...
				& F.pumpSpeed==speeds(j);
			
			
			% Add annotations
			% -----------------------------
			if i==1,
				h_subTit(i,j) = title({string(speeds(j))+" RPM",''},...
					spec.subTit{:});
			end
			if j==nCols
				subStr = num2str(min(round(unique(...
					F.arealOccl_pst(F.(stateVar)==predStates{i,1})))));
				text(1.10,0.5,{['\bf{',predStates{i,2},'}'],...
					['\rm{',subStr,'% areal occl.}']},...
					'FontSize',11);
			end
			
			for k=1:numel(classifiers)
				h_ax(i,j).ColorOrderIndex = k;
				
				
				[X,Y,~,AUC_boot] = perfcurve(F.(stateVar)(inds),...
					F.(classifiers{k})(inds),predStates{i,1},"NBoot",1);
				
				h_nha(k) = plot(h_ax(i,j),X(:,1),Y(:,1), ...
					'LineWidth',3 ...
					...'Color', [37,52,148]/256 ... dark blue
					...'Color', [44,127,184]/256 ... medium blue
					);
				if k>1
					set(h_nha(k),'LineWidth',2);
					%	h_nha(k).Color = [h_nha(k).Color, .6];
					h_nha(k).LineStyle = ':';
				end
				
			end
			
			% 			plot([0,1],[0,1],'-',...
			% 				'Color',[0.8906,0.1016,0.1094,0.25],...
			% 				'LineWidth',1.5);
			
			set(h_ax(i,j),spec.ax{:})
			%pbaspect(h_ax(i,j),[1 1 1]);
			xlim([0,1])
			ylim([0,1])
			
		end
		
	end
	
	h_ylab = ylabel(h_yax(2),'Sensitivity',spec.supXLab{:});
	h_xlab = xlabel(h_xax(3),'1 - Specificity',spec.supXLab{:});
		
	% // Add the new axes:
	for i=1:nRows
		h_yax(i).Position = h_ax(i,1).Position;
		h_yax(i).Position(1) = h_yax(i).Position(1)-0.015;
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
		h_xax(1,j).Position = h_ax(nRows,j).Position;
		h_xax(1,j).Position(2) = h_xax(1,j).Position(2)-0.025;
	end
			
	set(h_yax,'YColor',[0,0,0])
	set(h_xax,'XColor',[0,0,0])
	set([h_xax,h_yax],'Color','none');
	set([h_xax,h_yax],'XGrid','off');
	set([h_xax,h_yax],'YGrid','off');
	
	
	h_axleg = subplot(nRows,nCols+1,(nCols+1)*nRows);
	hold on
	h_plt(1) = plot(1,1,'LineWidth',3); 
	h_plt(2) = plot(1,1,':','LineWidth',2);
	h_plt(3) = plot(1,1,':','LineWidth',2);
	set(h_axleg,spec.ax{:},'Visible','off')
	h_leg = legend(h_axleg,{'x','y','z'},spec.leg{:}); %'\it{-\DeltaP}\rm_{LVAD}'
	h_leg.Title.String = 'Direction';
	
 	h_leg.Position(3) = 0.065;
 	h_leg.Position(1) = 0.8;
 	h_leg.Position(2) = 0.1;%h_ax(end,end).Position(2);
			
	
