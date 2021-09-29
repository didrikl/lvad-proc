function h_figs = plot_acc_against_max_areal_occl_per_catheter(F,G,Q1,Q3,vars,type)
	
	Constants
% 	catheters = unique(F.catheter);
% 	catheters = catheters(not(catheters=='-'));
	levelLabels = {
		%'Inflated, 4.73 mm'
		'Inflated, 6.60 mm'
		'Inflated, 8.52 mm'
		%'Inflated, 9 mm'
		%'Inflated, 10 mm'
		'Inflated, 11 mm'
		};
	subTitles = {
		%'PCI 1'
		'PCI 2'
		'PCI 3'
		%'RHC_1'
		%'RHC_2'
		'RHC'
		};
	markers = {'o','diamond','square','pentagram'};
	speeds = {'2200','2500','2800','3100'};
	backgroundPointSize = 9;
	backgroundPointAlpha = 0.6;
	
	if strcmpi(type,'relative')
		F{F.categoryLabel=='Nominal',vars(:,1)} = 0;
		G{G.categoryLabel=='Nominal',vars(:,1)} = 0;
	end
	
	nLevels = numel(levelLabels);
	for v=1:size(vars,1)
		var = vars{v,1};
		title_str = ['Plot 6: ',type,' change in acc against max D, at all speeds, per catheter'];
		
		h_figs(v) = figure(...
			'Name',title_str,...
			'Position',[150,250,300*nLevels,450],...
			'Color',[1,1,1]);
		
		for i=1:nLevels
			
			% New panel per catheter
			h_ax(i) = subplot(1,nLevels,i);
			hold on
				
			% Extract inds for overall baseline and for interventions in G and F
			F_inds = ...
				(F.levelLabel=='Nominal' & F.interventionType=='Control') | ...
				(F.levelLabel==levelLabels(i));
			G_inds = ...
				(G.categoryLabel=='Nominal' & G.interventionType=='Control') | ...
				(G.levelLabel==levelLabels(i));
			
			for j=1:numel(speeds)
				F_rpm_inds = F.pumpSpeed==speeds{j};
				G_rpm_inds = G.pumpSpeed==double(string(speeds{j}));
				
				F_x = double(string(F.balloonDiam(F_inds & F_rpm_inds)))+mod(j,2)*0.2-0.15;
				F_y = F.(var)(F_inds & F_rpm_inds);
				G_y = G.(var)(G_inds & G_rpm_inds);
				G_x = double(string(G.balloonDiam(G_inds & G_rpm_inds)))+mod(j,2)*0.2-0.15;
				G_x(isnan(G_x)) = 0;
				F_x(isnan(F_x)) = 0;
				
				% Plot background points
				h_ax(i).ColorOrderIndex=j;
				h_s = scatter(F_x,F_y,backgroundPointSize,'filled',...
					'Marker',markers{j},...
					'MarkerEdgeColor','none',...
					'MarkerFaceAlpha',backgroundPointAlpha);
				h_s.Visible = 'on';
				
				% Plot background lines
				seqs = unique(F.seq);
				for k=1:numel(seqs)
					h_ax(i).ColorOrderIndex=j;
					F_x = double(string(F.balloonDiam(F_inds & F_rpm_inds & F.seq==seqs(k))));%+j*0.10-0.20;
					F_y = F.(var)(F_inds & F_rpm_inds & F.seq==seqs(k));
					G_x(isnan(G_x)) = 0;
					F_x(isnan(F_x)) = 0;
					max_x_ind = F_x==max(F_x);
					min_x_ind = F_x==min(F_x);
					h_p3(j) = plot(F_x(min_x_ind|max_x_ind),F_y(min_x_ind|max_x_ind));
					h_p3(j).Color = [h_p3(j).Color,0.25];				

					% Toggle visibility of backgorund lines
 					set(h_p3(j),'Visible','off');				
				end
					
			end
			
			% Plot aggregated values in heavy lines
			for j=1:numel(speeds)
				
				F_rpm_inds = F.pumpSpeed==speeds{j};
				G_rpm_inds = G.pumpSpeed==double(string(speeds{j}));
				
				F_x = double(string(F.balloonDiam(F_inds & F_rpm_inds)));%+j*0.05-0.10;
				F_y = F.accA_y_nf_stdev(F_inds & F_rpm_inds);
				G_y = G.(var)(G_inds & G_rpm_inds);
				G_x = double(string(G.balloonDiam(G_inds & G_rpm_inds)));%+j*0.05-0.10;
				G_x(isnan(G_x)) = 0;
				F_x(isnan(F_x)) = 0;
				h_p(j) = plot(G_x([1,end]),double(G_y([1,end])),...
					'Marker',markers{j},...
					'MarkerSize',6,...
					'LineStyle','-',...
					'LineWidth',1.5, ...
					'Color',h_p3(j).Color ...
					);
				h_p(j).MarkerFaceColor = h_p(j).Color;
				%text(G_x(end)+0.5,G_y(end),'p=','Clipping','off');
			
			end
			
			%{
			% Plot error bars
			h_ax(i).ColorOrderIndex=h_ax(i).ColorOrderIndex-1;
			for j=1:numel(speeds)
				Q1_rpm_inds = Q1.pumpSpeed==double(string(speeds{j}));
				G_rpm_inds = G.pumpSpeed==double(string(speeds{j}));
				q1_y = Q1.(var)(G_inds & Q1_rpm_inds);
				q3_y = Q3.(var)(G_inds & Q1_rpm_inds);
				G_y = G.(var)(G_inds & G_rpm_inds);
				G_x = double(string(G.balloonDiam(G_inds & G_rpm_inds)));%+j*0.05-0.10;
				G_x(isnan(G_x)) = 0;
				h_err(j) = errorbar(G_x(end),G_y(end),q1_y(end),q3_y(end),...
					'LineWidth',1,...
					'LineStyleMode','manual',...
					'CapSize',10,...
					'LineStyle','none',...
					'Color',[h_p3(j).Color,0.25],...
					'Marker',markers{j});
				%h_err(j).Color = [h_p3(j).Color,0.25];
			end
			%}
			
			% Add annotations
			if i==1 
				h_ylab = ylabel('Acc_y NHA (..)','Units','normalized');
				h_ylab.Position(1) = -0.15;
			end
			if i==nLevels
				h_leg = legend(h_p,speeds);
				h_leg.Title.String = 'Speed (RPM)';
				%h_leg.Title.FontWeight = 'normal';
				h_leg.Location = 'southeastoutside';
				h_leg.FontSize = 12;
				h_leg.Box = 'off';
			end
			title(subTitles{i},'FontWeight','normal')
			
			% Adjust axis limits; y only if specified by user
			if not(isempty(vars{v,2})), ylim(vars{v,2}); end
			xlim([-0,12.7])
			
			maxBalTick = G_x(end);
			xticklabels({'0',['\bf{',num2str(maxBalTick),'}'],num2str(diamLVAD)});
			xticks([0,maxBalTick,diamLVAD]);
			if i>1,	h_ax(i).YAxis.TickLabel = []; end
			h_ax(i).FontSize = 11;
			h_ax(i).YAxis.TickDirection = 'out';
			h_ax(i).XAxis.TickDirection = 'out';
			h_ax(i).XAxis.TickLength = [0.02,0.025];
			h_ax(i).YAxis.TickLength = [0.02,0.025];
			
			h_ax(i).YGrid = 'on';
			h_ax(i).GridLineStyle = '-';
			h_ax(i).GridAlpha = 1;
			h_ax(i).GridColor = [1,1,1];
			h_ax(i).LineWidth = 1.5;
			h_ax(i).Color = [.96 .96 .96];
			if i>1, h_ax(i).YColor = [1,1,1]; end
			
			h_ax(i).FontSize = 12;
			h_ax(i).FontName = 'Gill Sans Nova';
			
			h_ax(i).Position(3) = 0.74/nLevels;%0.185;
			h_ax(i).Position(4) = 0.68;
			h_ax(i).Position(1) = h_ax(i).Position(1)-0.075 + (i-1)*0.005;
			h_ax(i).Position(2) = h_ax(i).Position(2)+0.05;	
			
		end
		
		sgtitle('Simulated Pre-PT and Speed Influence on NHA');
		h_suplab = suplabel('Balloon diameter (mm)','x');
		h_suplab.FontSize = 12;
		h_suplab.FontName = 'Gill Sans Nova';
		
	end