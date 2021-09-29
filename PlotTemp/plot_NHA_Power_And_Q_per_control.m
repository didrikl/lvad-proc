function h_figs = plot_NHA_Power_And_Q_per_control(F,G,R,nhaVars,levelLabels)
	
	Colors_IV2
	Constants
	

	subTitles = {
%		'Q red., 10%' 
		'Q reduced 20%' 
		'Q reduced 40%'
		'Q reduced 60%'
		'Q reduced 80%'
		};
	xVar = 'QRedTarget_pst';
	xLims = [0,100];
	xLab = 'Flow Rate Reduction (%)';
	supTit = 'Increased Afterload by Clamp Control Interventions';
	
	speeds = [2200,2500,2800,3100];
	markers = {'o','diamond','square','hexagram'};%'pentagram'};
	
	backPtsSize = 9;
	backPtsSpec = {backPtsSize,...
		'MarkerEdgeAlpha',0.6,...
		'MarkerFaceAlpha',0.6};
	lineSpec = {...
		'MarkerSize',6,...
		'LineStyle','-',...
		'LineWidth',1.5};
	ax_spec = {...
		'LineWidth',1.5,...
		'FontSize',12,...
		'FontName','Gill Sans Nova',...
		'Color',[.96 .96 .96],...
		'YGrid','on',...
		'XGrid','on',...
		'GridLineStyle','-',...
		'GridColor',[1,1,1],...
		'GridAlpha',1
		};
	
	% Convert from categorical to numerical (for plotting)
	F.QRedTarget_pst = double(string(F.QRedTarget_pst));
	G.arealOccl = double(string(G.QRedTarget_pst));
	
	nLevels = numel(levelLabels);		
	for v=1:size(nhaVars,1)
		
		title_str = ['Median NHA against max D in separate catheter panels'];
		h_figs(v) = figure(...
			'Name',title_str,...
			'Position',[50,0,250*nLevels,1500],...
			'Color',[1,1,1]);
		
		for i=1:nLevels
			
			% Extract inds for overall baseline and for interventions in G and F
			F_inds = ...
				(F.levelLabel=='Nominal' & F.interventionType=='Control') | ...
				(F.levelLabel==levelLabels(i));
			G_inds = ...
				(G.categoryLabel=='Nominal' & G.interventionType=='Control') | ...
				(G.levelLabel==levelLabels(i));
			R_inds = R.levelLabel==levelLabels(i);
			
			% Plot panel row with flow rate data
			% ---------------------------------------------------
			h_ax(1,i) = subplot(3,nLevels,i,'Nextplot','add',...
				'ColorOrder',Colors.Fig.Cats.Speeds4);
			
			[~,h_qPts,h_qLines] = plot_nha_in_catheter_panels(...
				h_ax(1,i),G(G_inds,:),F(F_inds,:),speeds,xVar,xLims,...
				{'Q_mean',[0 8]},backPtsSpec,markers,lineSpec,R(R_inds,:));
			
			title(subTitles{i},'FontWeight','normal')
			
			% Plot panel row with LVAD power data
			% ---------------------------------------------------
			h_ax(2,i) = subplot(3,nLevels,nLevels+i,'Nextplot','add',...
				'ColorOrder',Colors.Fig.Cats.Speeds4);
			
			[~,h_powPts,h_powLines] = plot_nha_in_catheter_panels(...
				h_ax(2,i),G(G_inds,:),F(F_inds,:),speeds,xVar,xLims,...
				{'P_LVAD_mean',[0 8]},backPtsSpec,markers,lineSpec,R(R_inds,:));
			
			% Panel row with NHA data
			% ---------------------------------------------------
			h_ax(3,i) = subplot(3,nLevels,2*nLevels+i,'Nextplot','add',...
				'ColorOrder',Colors.Fig.Cats.Speeds4);
		
			[h_nha,h_nhaPts,h_nhaLines] = plot_nha_in_catheter_panels(...
				h_ax(3,i),G(G_inds,:),F(F_inds,:),speeds,xVar,xLims,...
				nhaVars(v,:),backPtsSpec,markers,lineSpec,R(R_inds,:));
					
			% Toggle visibility of backgorund graphics
			% ---------------------------------------------------
			set([h_powPts,h_qPts,h_nhaPts],'Visible','on')
			set([h_qLines,h_powLines,h_nhaLines],'Visible','on');
 			
		end
		
		% Add annotations
		% ---------------------------------------------------		
		h_leg = legend(h_nha,string(speeds));
		h_leg.Title.String = 'Speed (RPM)';
		h_leg.Title.FontWeight = 'normal';
		h_leg.Location = 'southeastoutside';
		h_leg.FontSize = 12;
		h_leg.Box = 'off';
		
		sgtitle(supTit,...
			'FontName','Gill Sans Nova',...
			'FontSize',16);
		h_suplab = suplabel(xLab,'x');
		h_suplab.FontSize = 12;
		h_suplab.FontName = 'Gill Sans Nova';
		
		h_flow_ylab = ylabel(h_ax(1,1),'Flow\rm (L/min)','Units','normalized');
		h_power_ylab = ylabel(h_ax(2,1),'Power\rm (W)','Units','normalized');
		h_nha_ylab = ylabel(h_ax(3,1),'NHA\rm (g^2/Hz)','Units','normalized');
		h_flow_ylab.Position(1) = -0.15;
		h_power_ylab.Position(1) = -0.15;
		h_nha_ylab.Position(1) = -0.15;
		
		
		% Adjust formatting of lines and text
		% ---------------------------------------------------		
		set(h_ax,ax_spec{:});
		set(h_ax(:,2:end),'YColor',[1,1,1])
		set(h_ax(1:2,:),'XColor',[1,1,1])
		
		h_ax(1,1).YAxis.TickDirection = 'out';
		h_ax(2,1).YAxis.TickDirection = 'out';
		h_ax(3,1).YAxis.TickDirection = 'out';
		h_ax(1,1).YAxis.TickLength = [0.02,0.025];
		h_ax(2,1).YAxis.TickLength = [0.02,0.025];
		h_ax(3,1).YAxis.TickLength = [0.02,0.025];
		
		for i=1:nLevels
			h_ax(3,i).XAxis.TickDirection = 'out';
			h_ax(3,i).XAxis.TickLength = [0.025,0.025];
		end
		
			
		% Adjust positions (after all content is made)
		% ---------------------------------------------------
 		
 		for i=1:nLevels
			xPos = h_ax(1,i).Position(1)-0.075 + (i-1)*0.005;
  			yPos1 = h_ax(1,i).Position(2)-0.08;
  			yPos2 = h_ax(2,i).Position(2)-0.05;
  			yPos3 = h_ax(3,i).Position(2)-0.02;
  			height = 0.24;
  			width = 0.74/nLevels;
  			set(h_ax(1,i),'Position',[xPos,yPos1,width,height]);
  			set(h_ax(2,i),'Position',[xPos,yPos2,width,height]);
 			set(h_ax(3,i),'Position',[xPos,yPos3,width,height]);
 		end
		
		
	end
	
end