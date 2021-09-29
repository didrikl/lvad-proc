function h_figs = plot_NHA_Power_And_Q_for_afterload_and_preload(...
		F,G,R,nhaVars)
	% Plot NHA for each control type (afterload and preload)
	%
	% Panel 3x2 matrix setup: 
	% - one panel row for Q
	% - one panel row for Power
	% - one row with NHA at the bottom	
	% - two panel colums, one for afterload and one for preload
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
	
	categoryLabels = {
 		'Afterload increase' 
 		'Preload decrease'
		};
	subTitles = {
		'Afterload Clamp' 
		'Preload Clamp' 
		};
	
	xVar = 'QRedTarget_pst';
	xLims = [0,100];
	yVar_row1 = {'Q_mean',[0 8]};
	yVar_row2 = {'P_LVAD_mean',[0 8]};
	
	titleStr = 'Control Interventions';
	xLab = 'Flow Rate Reduction (%)';
	yLabels = {
		'Flow\rm (L/min)'
		'Power\rm (W)'
		'NHA\rm (g^2/Hz)'
		};
	
	Constants
	speeds = [2200,2500,2800,3100];
	spec = get_specs_for_plot_NHA;
	nFigs = size(nhaVars,1);
	nCols = 2;
	nRows = 3;
	h_figs = gobjects(nFigs,1);
	
	for v=1:nFigs
		
		h_figs(v) = figure(spec.fig{:},...
			'Name',sprintf('%s - %s as NHA',titleStr,nhaVars{v,1}),...
			'Position',[50,00,450*nCols,1500]);
		
		h_ax = gobjects(nRows,nCols);
		for j=1:nCols
	
			
			% Extract inds for overall baseline and for interventions in G and F
			F_inds = ...
				(F.levelLabel=='Nominal' & F.interventionType=='Control') | ...
				(F.categoryLabel==categoryLabels(j));
			G_inds = ...
				(G.categoryLabel=='Nominal' & G.interventionType=='Control') | ...
				(G.categoryLabel==categoryLabels(j));
			R_inds = R.categoryLabel==categoryLabels(j);	
		
			
			% Plot panel row 1 with flow rate data
			% ---------------------------------------------------
			h_ax(1,j) = subplot(nRows,nCols,j,'Nextplot','add',spec.subPlt{:});
			
			[~,h_qPts,h_qLines] = plot_group_and_individual_data(h_ax(1,j),...
				G(G_inds,:),F(F_inds,:),speeds,xVar,xLims,yVar_row1,...
				spec.backPts,spec.speedMarkers,spec.line,R(R_inds,:));
			
			title(subTitles{j},'FontWeight','normal')
			
			% Plot panel row 2 with LVAD power data
			% ---------------------------------------------------
			h_ax(2,j) = subplot(nRows,nCols,nCols+j,'Nextplot','add',spec.subPlt{:});
			
			[~,h_powPts,h_powLines] = plot_group_and_individual_data(h_ax(2,j),...
				G(G_inds,:),F(F_inds,:),speeds,xVar,xLims,yVar_row2,...
				spec.backPts,spec.speedMarkers,spec.line,R(R_inds,:));
			
			% Panel row 3 with NHA data
			% ---------------------------------------------------
			h_ax(3,j) = subplot(nRows,nCols,2*nCols+j,'Nextplot','add',spec.subPlt{:});
		
			[h_nha,h_nhaPts,h_nhaLines] = plot_group_and_individual_data(h_ax(3,j),...
				G(G_inds,:),F(F_inds,:),speeds,xVar,xLims,nhaVars(v,:),...
				spec.backPts,spec.speedMarkers,spec.line,R(R_inds,:));
					
			% Toggle visibility of backgorund graphics
			% ---------------------------------------------------
			set([h_powPts,h_qPts,h_nhaPts],'Visible','on')
			set([h_qLines,h_powLines,h_nhaLines],'Visible','on');
 			
		end
		
		% Add annotations and formatting of lines, text and ticks
		% ---------------------------------------------------
		sgtitle(titleStr,spec.supTit{:});
		add_supLabel(xLab,spec.supXLab,'x');
		add_legend_to_plot_NHA(h_nha,speeds,spec.leg,spec.legTit);
		h_yLab = add_subYLabels_to_plot_NHA(h_ax,yLabels);
		
			
		% Adjust positions (after all content is made)
		% ---------------------------------------------------
 		for i=1:nRows
			h_yLab(i).Position(1) = -0.095;
		end
		for i=1:nCols
 			xPos = h_ax(1,i).Position(1)-0.05 - (i-1)*0.024;
  			yPos1 = h_ax(1,i).Position(2)-0.06;
  			yPos2 = h_ax(2,i).Position(2)-0.03;
  			yPos3 = h_ax(3,i).Position(2)-0.00;
  			height = 0.2425;
  			width = 0.74/nCols;
  			set(h_ax(1,i),'Position',[xPos,yPos1,width,height]);
  			set(h_ax(2,i),'Position',[xPos,yPos2,width,height]);
 			set(h_ax(3,i),'Position',[xPos,yPos3,width,height]);
 		end
		
		format_axes_in_plot_NHA(h_ax,spec.ax,spec.axTick)
		
	end
	
end