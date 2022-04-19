
%% Pooled diameter in 4 subplots, 4 speeds in each

F.('diam_4.30mm_or_more') = double(string(F.balloonDiam))>=4.31;
F.('diam_4.73mm_or_more') = double(string(F.balloonDiam))>=4.73;
F.('diam_6.00mm_or_more') = double(string(F.balloonDiam))>=6;
F.('diam_6.60mm_or_more') = double(string(F.balloonDiam))>6.6;
F.('diam_7.30mm_or_more') = double(string(F.balloonDiam))>7.3;
F.('diam_8.52mm_or_more') = double(string(F.balloonDiam))>8.52;
F.('diam_9mm_or_more') = double(string(F.balloonDiam))>=9;
F.('diam_10mm_or_more') = double(string(F.balloonDiam))>=10;
F.('diam_11mm_or_more') = double(string(F.balloonDiam))>=11;
F.('diam_12mm') = double(string(F.balloonDiam))>=12;


clear AUC T h_ax h_figs

classifiers = {
	'accA_x_nf_pow';
	'accA_x_nf_stdev';
	'accA_y_nf_pow';
	'accA_y_nf_stdev';
	%	'P_LVAD_mean'
	};
speeds = {
	'2200'
	'2500'
	'2800'
	'3100'
	};
state_vars = {
	%'diam_4.30mm_or_more', '>= 4.30mm'
	'diam_4.73mm_or_more', '>= 4.73mm'
	%'diam_6.00mm_or_more', '>= 6.0mm'
	'diam_6.60mm_or_more', '>= 6.6mm'
	%'diam_7.30mm_or_more', '>= 7.30mm'
	'diam_8.52mm_or_more', '>= 8.52mm'
	%'diam_9mm_or_more', '>= 9mm'
	%'diam_10mm_or_more', '>= 10mm'
	'diam_11mm_or_more', '>= 11mm'
	%'diam_12mm', '= 12mm'
	};

close all
for k=1:numel(classifiers)
	
	title_str = ['NHA in ',classifiers{k},' - Pooled diameters'];
	h_figs(k) = figure(...
		'Name',title_str,...
		'Position',[10,100,1400,350] ...
		);
	h = tiledlayout(1,size(state_vars,1)+1,...
		'Padding','tight',...
		'TileSpacing','tight'...
		);
	xlabel(h,'Specificity')
	ylabel(h,'Sensitivity')
	h_tit = title(h,title_str,...
		'FontWeight','normal',...
		'Interpreter','none',...
		'VerticalAlignment','bottom');
	
	for j=1:size(state_vars,1)
		h_ax(j) = nexttile;
		hold on
		
		for i=1:numel(speeds)
			
			inds = (F.(state_vars{j,1}) | F.interventionType=='Control') & ....
				F.pumpSpeed==speeds(i);
			
			[X,Y,~,AUC(i,j)] = perfcurve(F.(state_vars{j,1})(inds),...
				F.(classifiers{k})(inds),true);
			h_plt(i) = plot(X,Y,'LineWidth',2);
			h_plt(i).Color = [h_plt(i).Color,0.65];
			
			h_ax(j).ColorOrderIndex = h_ax(j).ColorOrderIndex-1;
			[X,Y] = perfcurve(F.(state_vars{j,1})(inds),...
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
		title(state_vars{j,2},...
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

save_analysis_plots(h_figs,analysis_path,classifiers)

%% Max inflations by speeds in subplots 

clear AUC T h_ax opt_opr_pt X Y h_plt h_plt2
classifiers = {
	'accA_x_nf_pow';
%  	'accA_x_nf_stdev';
%  	'accA_y_nf_pow';
%  	'accA_y_nf_stdev';
	};
speeds = {
	'2200'
	'2500'
	'2800'
	'3100'
	};
state_vals = {
	%'4.31', 'PCI1'
   %'4.73', 'PCI1'
	%'6', 'PCI2'
	'6.6', 'PCI2'
	%'7.3', 'PCI3'
	'8.52', 'PCI3'
	%'9', 'RHC'
	'10', 'RHC'
	'11', 'RHC'
	%'12', 'RHC'
	};

%close all
for k=1:numel(classifiers)
	title_str = ['NHA in ',classifiers{k},' - Max inflation diameters'];
	h_figs(k) = figure(...
		'Name',title_str,...
		'Position',[10,100,1080,700] ...
		);
	h = tiledlayout(size(state_vals,1),size(speeds,1)+1,...
		'Padding','tight',...
		'TileIndexing','columnmajor',...
		'TileSpacing','tight'...
		);
	xlabel(h,'Specificity')
	ylabel(h,'Sensitivity')
	h_tit = title(h,title_str,...
		'FontWeight','normal',...
		'Interpreter','none',...
		'VerticalAlignment','bottom');
	
	for j=1:numel(speeds)
		
		for i=1:size(state_vals,1)
			
			h_ax(i,j) = nexttile;
			hold on
 		
			inds = (F.balloonDiam==state_vals(i,1) | F.interventionType=='Control' )...
				& F.pumpSpeed==speeds(j);
			
			[X,Y,~,AUC_boot] = perfcurve(F.balloonDiam(inds),...
				F.(classifiers{k})(inds),state_vals(i,1),"NBoot",1000);
			AUC(i,j) = AUC_boot(1);
			
			h_plt(i) = plot(X(:,1),Y(:,1),...
				'LineWidth',2,...
				'Color',[0.02,0.34,0.55,0.75]);
			
			[X,Y,~,AUC_boot2] = perfcurve(F.balloonDiam(inds),...
 				F.P_LVAD_mean(inds),state_vals(i,1),"NBoot",1);
			AUC2(i,j) = AUC_boot2(1);
			
			h_plt2(i) = plot(X(:,1),Y(:,1),...
				'LineWidth',1.25,...
				'Color',[.3 .3 .3 .75],...
				'LineStyle',':'...
				);
 			
			pbaspect(h_ax(i,j),[1 1 1]);
			if i==1
				title(speeds{j},...
					'FontWeight','bold',...
					'Interpreter','none');
			end
			grid on
			xlim([-0.02,1])
			ylim([0.0,1.02])
			
			if j==numel(speeds)
				text(1.08,0.8,...
					{['\bf{',state_vals{i,2},'}'],...
					['\rm{',state_vals{i,1},' mm}']});
			end
			
			text(0.3,0.15,...
				sprintf("AUC=%2.2f (%2.2f, %2.2f)",...
				AUC_boot(1),AUC_boot(2),AUC_boot(3)),...
				'FontSize',9);
				
		end
		        
	end
	
	set(h_ax,'XTick',0:0.2:1);
	set(h_ax,'YTick',0:0.2:1);
	set(h_ax,'GridLineStyle',':');
	set(h_ax,'GridAlpha',0.25);
		
	h_leg = legend(h_ax(end,end),{'NHA','P_{LVAD}'},...
		'Location','southeast',...
		'Box','off');
	h_leg.Title.String = 'Classifier';
	
 	h_leg.Position(3) = 0.065;
 	h_leg.Position(1) = 0.83;
 	h_leg.Position(2) = h_ax(end,end).Position(2);
	
	set(h_ax(:,2:end),'YTickLabel',{})
	set(h_ax(1:end-1,:),'XTickLabel',{})
end

save_analysis_plots(h_figs,analysis_path,classifiers)

%% All interventions pooled

clear AUC T h_ax opt_opr_pt X Y
classifiers = {
	'accA_x_nf_pow';
 	'accA_x_nf_stdev';
 	'accA_y_nf_pow';
 	'accA_y_nf_stdev';
	};

close all

for k=1:numel(classifiers)
	
	title_str = ['Classifier ',classifiers{k},...
		' - All interventions pooled'];
	h_figs(k) = figure(...
		'Name',title_str,...
		'Position',[10,100,500,500] ...
		);
	
	plot([0,1],[0,1],'k--','HandleVisibility','off')
	hold on
	h_ax=gca;
	h_ax.ColorOrderIndex = 1;
		
		
	inds = (F.interventionType=='Effect' | F.interventionType=='Control' );
	
	[X,Y,T,AUC_boot] = perfcurve(F.interventionType(inds),...
		F.(classifiers{k})(inds),'Effect',"NBoot",1000);
	
	h_plt = plot(X(:,1),Y(:,1),'LineWidth',2);
	h_plt.Color = [h_plt.Color,0.7];
	
	h_ax.ColorOrderIndex = h_ax.ColorOrderIndex-1;
	
	[X,Y,~,AUC_boot2] = perfcurve(F.interventionType(inds),...
		F.P_LVAD_mean(inds),'Effect',"NBoot",1000);
	h_plt2 = plot(X(:,1),Y(:,1),...
		'LineWidth',1.25,...
		'LineStyle',':',...
		'Color',[.4 .4 .4 .75]);
	
	grid on
	h_ax.XTick = 0:0.2:1;
	h_ax.YTick = 0:0.2:1;
	xlim([-0.02,1])
	ylim([0.0,1.02])
	pbaspect(h_ax,[1 1 1]);
	h_ax.GridLineStyle = ':';
	h_ax.GridAlpha = 0.25;
	
	
	xlabel('Specificity')
	ylabel('Sensitivity')
	
	h_leg = legend(h_ax,...
		{sprintf('NHA   (AUC=%2.2f)',AUC_boot(1)),...
		sprintf('P_{LVAD} (AUC=%2.2f)',AUC_boot2(1))},...
		'Location','southeast','Box','off');
	title(title_str,...
		'FontWeight','normal',...
		'Interpreter','none',...
		'VerticalAlignment','bottom');
	
	set(h_ax(2:end),'YTickLabel',{})
end

save_analysis_plots(h_figs,analysis_path,classifiers)
