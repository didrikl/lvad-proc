function h_figs = plot_acc_against_max_diameter_per_catheter(F,G,R,Q1,Q3,yVars,yVarType)
	
	Constants
	levelLabels = {
		'Inflated, 4.73 mm'
		'Inflated, 6.60 mm'
		'Inflated, 8.52 mm'
		'Inflated, 9 mm'
		%'Inflated, 10 mm'
		'Inflated, 11 mm'
		};
	subTitles = {
		'PCI Catheter 1'
		'PCI Catheter 2'
		'PCI Catheter 3'
		'RHC Catheter'
		%'RHC Catheter'
		'RHC Catheter'
		};
	
	%xVar = 'balloonDiam';
 	%xLims = [0,diamLVAD];
	%xLab = 'Balloon diameter (mm)';
	xVar = 'arealOccl';
 	xLims = [0,100];
	xLab = 'Areal occlusion (%)';
	supTit = 'Inlet Occlusion and Speed Influence on Non-Harmonic Amplitudes and LVAD Power';
	
	markers = {'o','diamond','square','pentagram'};
	speeds = {'2200','2500','2800','3100'};
	backgroundPointSize = 9;
	backgroundPointAlpha = 0.6;
	
	% Mutual changes of speed changes are stored as relative change
	if strcmpi(yVarType,'relative')
		F{F.categoryLabel=='Nominal',yVars(:,1)} = 0;
		G{G.categoryLabel=='Nominal',yVars(:,1)} = 0;
	end
	
	% Add info about areal occlusion
	% TODO: Move to init function
	F.arealOccl = 100*double(string(F.balloonDiam)).^2./(diamLVAD.^2);
 	G.arealOccl = 100*double(string(G.balloonDiam)).^2./(diamLVAD.^2);
 	
	nLevels = numel(levelLabels);
	for v=1:size(yVars,1)
		
		var = yVars{v,1};
		
		title_str = ['Plot 5: ',yVarType,'Median NHA against max D in separate catheter panels'];
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
				
				% Plot background points
				h_ax(i).ColorOrderIndex=j;
				F_rpm_inds = F.pumpSpeed==speeds{j};
				F_y = F.(var)(F_inds & F_rpm_inds);
 				
				F_x = round(double(string(F.(xVar)(F_inds & F_rpm_inds)))+j*0.005*diff(xLims)-0.01*diff(xLims),0);
				F_x(isnan(F_x)) = 0;
				h_s = scatter(F_x,F_y,backgroundPointSize,...'filled',...
					'Marker',markers{j},...
					...'MarkerEdgeColor','none',...
					'MarkerEdgeAlpha',backgroundPointAlpha,...
					'MarkerFaceAlpha',backgroundPointAlpha);
				h_s.Visible = 'on';
				
				% Plot background lines
				seqs = unique(F.seq);
				for k=1:numel(seqs)
					h_ax(i).ColorOrderIndex=j;
					F_x = double(string(F.(xVar)(F_inds & F_rpm_inds & F.seq==seqs(k))));%+j*0.10-0.20;
					F_y = F.(var)(F_inds & F_rpm_inds & F.seq==seqs(k));
					F_x(isnan(F_x)) = 0;
					max_x_ind = F_x==max(F_x);
					min_x_ind = F_x==min(F_x);
					h_p3(j) = plot(F_x(min_x_ind|max_x_ind),F_y(min_x_ind|max_x_ind));
					h_p3(j).Color = [h_p3(j).Color,0.25];				

					% Toggle visibility of backgorund lines
 					set(h_p3(j),'Visible','off');				
				end
						
				% Plot aggregated values in heavy lines
				G_rpm_inds = G.pumpSpeed==double(string(speeds{j}));
				G_y = G.(var)(G_inds & G_rpm_inds);
				G_x = round(double(string(G.(xVar)(G_inds & G_rpm_inds))),0)%+j*0.05-0.10;
				G_x(isnan(G_x)) = 0;
				h_p(j) = plot(G_x([1,end]),double(G_y([1,end])),...
					'Marker',markers{j},...
					'MarkerSize',6,...
					'LineStyle','-',...
					'LineWidth',1.5, ...
					'Color',h_p3(j).Color ...
					);
				h_p(j).MarkerFaceColor = h_p(j).Color;
				
				% Add p value label at line endpoints
% 				p = R.(var)(R.levelLabel==levelLabels(i) & ismember(string(R.pumpSpeed),speeds{j}));
% 				text(G_x(end)+0.055*diff(xLims),G_y(end),'p='+extractAfter(p,'p='),'FontSize',9);
				
			end
			
			% Plot error bars (and make use of Q1 and Q3 input)
			%{
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
				h_leg.Title.FontWeight = 'normal';
				h_leg.Location = 'southeastoutside';
				h_leg.FontSize = 12;
				h_leg.Box = 'off';
			end
			title(subTitles{i},'FontWeight','normal')
			
			% Adjust axis limits; y only if specified by user
			if not(isempty(yVars{v,2})), ylim(yVars{v,2}); end
			xlim(xLims)
			
			maxBalTick = G_x(end);
			xticklabels({'0',['\bf{',num2str(maxBalTick),'}'],num2str(xLims(2))});
			xticks([0,maxBalTick,xLims(2)]);
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
		
		sgtitle(supTit,...
			'FontName','Gill Sans Nova',...
			'FontSize',16);
		h_suplab = suplabel(xLab,'x');
		h_suplab.FontSize = 12;
		h_suplab.FontName = 'Gill Sans Nova';
		
	end