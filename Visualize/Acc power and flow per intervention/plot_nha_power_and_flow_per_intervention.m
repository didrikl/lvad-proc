function h_figs = plot_nha_power_and_flow_per_intervention(...
		F,G,R,nhaVars,levelLabels,xVar,xLims,xLab,supTit,figWidth)
	% Plot NHA for each catheter type
	%
	% Panel 3x[no of levels] matrix setup: 
	% - one panel row for Q
	% - one panel row for Power
	% - one row with NHA at the bottom	
	% - one panel colum per levelLabel
	%
	% Each panel is plotted with the plot_group_and_individual_data function
	% - Group static data points (as given in input G)
	% - Individual points (as given in F) in the background
	% - Individual points connection line in the background
	% 
	% Hardcoding and adjusmtents made in this function:
	% - annotations
	% - panel and axis format specified in the get_specs_for_plot_NHA function
	% - object positions is adjusted in this function
	% - Visibility of background points and lines is here toggled on/off.
	
	yVar_row1 = {'Q_mean',[0 8]};
	yVar_row2 = {'P_LVAD_mean',[0 8]};
	yLabels = {
		{'\itQ\rm (L/min)'}
		{'\itP_{LVAD}\rm (W)'}
		{'NHA (g^2/Hz)'}
		};
	% Alternative yLabels 
	%{
	yLabels = {
		{'\bfFlow rate\rm','\itQ\rm (L/min)'}
		{'\bfPower consumption\rm','\itP_{LVAD}\rm (W)'}
		{'\bfNHA\rm','BP(\ita_y\rm) (g^2/Hz)'}
		};
	%}
	
	legTit = {'RPM'};
	speeds = [2200,2500,2800,3100];
	spec = get_specs_for_plot_NHA;
	
	figHeight = 1200;
	mainXAxGap = 0.01;
	mainYAxGap = mainXAxGap*(figHeight/figWidth);
	nFigs = size(nhaVars,1);
	nCols = numel(levelLabels(:,1));
	nRows = 3;
	h_figs = gobjects(nFigs,1);
	for v=1:nFigs
		
		h_figs(v) = figure(spec.fig{:},...
			'Name',sprintf('%s - %s as NHA',supTit,nhaVars{v,1}),...
			'Position',[0,0,figWidth,figHeight]);
		
		h_ax = gobjects(nRows,nCols);
		for j=1:nCols
			
			% Extract inds for overall baseline and for interventions in G and F
			% ---------------------------------------------------
			F_inds = ...
				(F.levelLabel=='Nominal' & F.interventionType=='Control') | ...
				(contains(string(F.levelLabel),levelLabels(j,1)));
			G_inds = ...
				(G.categoryLabel=='Nominal' & G.interventionType=='Control') | ...
				(contains(string(G.levelLabel),levelLabels(j,1)));
			R_inds = R.levelLabel==levelLabels(j,1);
			
			% Plot panel row 1 with flow rate data
			% ---------------------------------------------------
			h_ax(1,j) = subplot(nRows,nCols,j,'Nextplot','add',spec.subPlt{:});
			if j==1, h_yax(1) = copyobj(h_ax(1,j),gcf); end
			
			[~,h_qPts,h_qLines] = plot_group_and_individual_data(h_ax(1,j),...
				G(G_inds,:),F(F_inds,:),speeds,xVar,xLims,yVar_row1,...
				spec.backPts,spec.speedMarkers,spec.line,R(R_inds,:));
			
			h_tit(j) = title(levelLabels{j,2},spec.subTit{:});
			
			% Plot panel row 2 with LVAD power data
			% ---------------------------------------------------
			h_ax(2,j) = subplot(nRows,nCols,nCols+j,'Nextplot','add',spec.subPlt{:});
			if j==1, h_yax(2) = copyobj(h_ax(2,j),gcf); end
			
			[~,h_powPts,h_powLines] = plot_group_and_individual_data(h_ax(2,j),...
				G(G_inds,:),F(F_inds,:),speeds,xVar,xLims,yVar_row2,...
				spec.backPts,spec.speedMarkers,spec.line,R(R_inds,:));
			
			% Panel row with 3 NHA data
			% ---------------------------------------------------
			h_ax(3,j) = subplot(nRows,nCols,2*nCols+j,'Nextplot','add',spec.subPlt{:});
			if j==1, h_yax(3) = copyobj(h_ax(3,j),gcf); end
			h_xax(j) = copyobj(h_ax(3,j),gcf);
			
			[h_nha,h_nhaPts,h_nhaLines] = plot_group_and_individual_data(h_ax(3,j),...
				G(G_inds,:),F(F_inds,:),speeds,xVar,xLims,nhaVars(v,:),...
				spec.backPts,spec.speedMarkers,spec.line,R(R_inds,:));
					
			% Toggle visibility of backgorund graphics
			% ---------------------------------------------------
			set([h_powPts,h_qPts,h_nhaPts],'Visible','on')
			set([h_qLines,h_powLines,h_nhaLines],'Visible','on');
 			
		end
		
		h_leg = add_legend_to_plot_NHA(h_nha,speeds,spec.leg,spec.legTit,legTit);
		h_leg.Position(1) = h_leg.Position(1)+0.1; 
		h_leg.Position(2) = h_leg.Position(2)-mainYAxGap; 
		
		format_axes_in_plot_NHA(h_ax,spec.ax,spec.axTick)
		
		
		% Adjust object positions (after all content is made)
		% ---------------------------------------------------
		for i=1:nRows
			h_yLab(i).Position(1) = -0.15;
		end
		for j=1:nCols
 			xPos = h_ax(1,j).Position(1)-0.06 + (j-1)*(nCols/500-0.004);
  			yPos1 = h_ax(1,j).Position(2)-0.02;
  			yPos2 = h_ax(2,j).Position(2)+0.01;
  			yPos3 = h_ax(3,j).Position(2)+0.04;
  			height = 0.25;
  			width = 0.74/nCols;
  			set(h_ax(1,j),'Position',[xPos,yPos1,width,height]);
  			set(h_ax(2,j),'Position',[xPos,yPos2,width,height]);
 			set(h_ax(3,j),'Position',[xPos,yPos3,width,height]);
			h_tit(j).Position(2) = h_tit(j).Position(2)+0.35;
		end
		
		% Add annotations and formatting of lines, text and ticks
		% ---------------------------------------------------
		%sgtitle(supTit,spec.supTit{:});
		h_yLab = add_subYLabels_to_plot_NHA(h_yax,yLabels);
		h_supLab = add_supLabel(xLab,spec.supXLab,'x');
		h_supLab.Position(2) = h_supLab.Position(2)+0.05;
		
		format_axes_in_plot_NHA([h_xax,h_yax],spec.ax,spec.axTick)
 		set([h_xax,h_yax],'box','off')
		set([h_xax,h_yax],'Color','none');
		set([h_xax,h_yax],'YGrid','off');
		set([h_xax,h_yax],'XGrid','off');
		set(h_yax,'YColor',[0,0,0])
		set(h_xax,'XColor',[0,0,0])
		set(h_yax,'YColor',[0,0,0])
		
		% Make main axes offset
		for i=1:3
			h_yax(i).Position = h_ax(i,1).Position;
			h_yax(i).Position(1) = h_yax(i).Position(1)-mainYAxGap;
			h_yax(i).XAxis.Visible = 'off';
			h_yax(i).YLim = h_ax(i,1).YLim;
		end
		for j=1:numel(h_xax)
			h_xax(j).YAxis.Visible = 'off';
 			h_xax(j).XLim = h_ax(3,j).XLim;
 			h_xax(j).XTick = h_ax(3,j).XTick;
 			h_xax(j).XTickLabel = h_ax(3,j).XTickLabel;
 			h_xax(1,j).Position = h_ax(3,j).Position;
 			h_xax(1,j).Position(2) = h_xax(1,j).Position(2)-mainXAxGap;
		end
		h_xax(end).Position(3) = h_ax(end,end).Position(3);

  		%make_xy_halfframe(h_ax)


		
	end
	
end

function make_xy_halfframe(h_ax)
	set(h_ax,'box','off')
	set(h_ax,'XColor',[0.95,0.95,0.95])
	set(h_ax,'YColor',[0.95,0.95,0.95])
	set(h_ax,'XTickLabel',{})
	set(h_ax,'YTickLabel',{})
	set(h_ax,'TickLength',[0,0])
end