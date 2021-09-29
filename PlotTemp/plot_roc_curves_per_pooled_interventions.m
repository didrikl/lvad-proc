function h_figs = plot_roc_curves_per_pooled_interventions(...
		F,classifiers,predStates,titleStr)
	% Plot ROC curves for states of pooled levels (e.g. diameter above a threshold)
	%
	% Panel 1x[no of states] matrix setup:
	% - one row of panels only
	% - one panel (colum) per pooled state
	%
	% Curves overlaid in each panels for:
	% - NHA as classifier, for all speeds
	% - Power as classifier, for all speed
	
	speeds = [2200,2500,2800,3100];
	
	for k=1:numel(classifiers)
		
		figTit = [titleStr,' - ',classifiers{k},' as NHA classifier - ',...
			'Pooled diameters as prediction states'];
		h_figs(k) = figure(...
			'Name',figTit,...
			'Position',[20,20,1400,350] ...
			);
		h = tiledlayout(1,size(predStates,1)+1,...
			'Padding','tight',...
			'TileSpacing','tight'...
			);
		
		xlabel(h,'1 - Specificity')
		ylabel(h,'Sensitivity')
		h_tit = title(h,titleStr,...
			'FontWeight','normal',...
			'VerticalAlignment','bottom');
		
		for j=1:size(predStates,1)
			h_ax(j) = nexttile;
			hold on
			
			for i=1:numel(speeds)
				
				inds = (F.(predStates{j,1}) | F.interventionType=='Control') & ....
					F.pumpSpeed==speeds(i);
				
				[X,Y,~,AUC(i,j)] = perfcurve(F.(predStates{j,1})(inds),...
					F.(classifiers{k})(inds),true);
				h_plt(i) = plot(X,Y,'LineWidth',2);
				h_plt(i).Color = [h_plt(i).Color,0.65];
				
				h_ax(j).ColorOrderIndex = h_ax(j).ColorOrderIndex-1;
				[X,Y] = perfcurve(F.(predStates{j,1})(inds),...
					F.P_LVAD_mean(inds),true);
				h_plt2(i) = plot(X,Y,'LineWidth',1.25,'LineStyle',':','HandleVisibility','off');
				h_plt2(i).Color = [h_plt2(i).Color,0.35];
				
				plot([0,1],[0,1],'k--','HandleVisibility','off','LineWidth',1)
				
			end
			grid on
			h_ax(j).XTick = 0:0.2:1;
			h_ax(j).YTick = 0:0.2:1;
			h_ax(j).YAxis.TickLength = [0,0];
			xlim([-0.02,1])
			ylim([0.0,1.02])
			pbaspect(h_ax(j),[1 1 1]);
			h_ax(j).GridLineStyle = ':';
			h_ax(j).GridAlpha = 0.25;
			title(predStates{j,2},...
				'FontWeight','bold',...
				'Interpreter','none');
			
		end
		
		h_leg = legend([h_plt,h_plt2],[speeds+" RPM / NHA",speeds+" RPM / P_{LVAD}"]);
		h_leg.Title.String = {'Pump Speed / Classifier'};
		h_leg.Box = 'off';
		h_leg.Position(3) = 0.065;
		h_leg.Position(1) = 0.83;
		h_leg.Position(2) = h_ax(4).Position(2);
		
		set(h_ax(2:end),'YTickLabel',{})
		
		
	end
