function h_figs = plot_nha_power_and_flow_per_intervention_G1(...
		F,G,R,nhaVar,levelLabels,xVar,xLims,xLab,supTit,intervention)
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
	% - panel and axis format specified in the get_plot_specs function
	% - object positions is adjusted in this function
	% - Visibility of background points and lines is here toggled on/off.
	
	yVar_row1 = {'Q_mean',[-0.75 8]};
	yVar_row2 = {'P_LVAD_mean',[-0.75 8]};
	yLabels = {
		{'\itQ\rm'}
		{'\itP_{\rmLVAD}\rm'}
		{'NHA_{\ity}\rm'}
		};
	legTit = {'RPM'};
	speeds = [2200,2400,2600];
	
	spec = get_plot_specs;
	figWidth = 1180;
	figHeight =  890; %955
    panelHeight = 185; %200
	yStart = 74;
	yGap = 7;

	switch intervention
		case 'control'
			xGap = 60;
			panelWidth = 300;
			xStart = 105;
		case 'effect'
			xGap = 22;
			xStart = 68;
			panelWidth = 500;
	end
	
	% Offsets for common axes
	mainXAxGap = 0.01;
	mainYAxGap = mainXAxGap*(figHeight/figWidth);
	
	nFigs = size(nhaVar,1);
	nCols = size(levelLabels(:,1),2);
	nRows = 3;	
	h_figs = gobjects(nFigs,1);

	% Use g^2/kHz as unit instead
% 	G{:,nhaVar(:,1)} = 1000*G{:,nhaVar(:,1)};
% 	F{:,nhaVar(:,1)} = 1000*F{:,nhaVar(:,1)};

	for v=1:nFigs
		
		h_figs(v) = figure(spec.fig{:},...
			'Name',sprintf('%s - %s as NHA',supTit,nhaVar{v,1}),...
			'Position',[10,40,figWidth,figHeight]);
		
		h_ax = gobjects(nRows,nCols);
		for j=1:nCols

			% Extract inds for overall baseline and for interventions in G and F
			% ---------------------------------------------------
			F_inds = ...
				(contains(string(F.levelLabel),levelLabels(j,1)) & contains(string(F.idLabel),'Lev0') & F.interventionType=='Control') | ...
				(contains(string(F.levelLabel),levelLabels(j,1)) & F.interventionType=='Effect');
			G_inds = ...
				(contains(string(G.levelLabel),levelLabels(j,1)) & contains(string(G.idLabel),'Lev0') & G.interventionType=='Control') | ...
				(contains(string(G.levelLabel),levelLabels(j,1)) & G.interventionType=='Effect');
			%R_inds = contains(string(R.levelLabel),levelLabels(j,1));
			
			% Plot panel row 1 with flow rate data
			% ---------------------------------------------------
			h_ax(1,j) = subplot(nRows,nCols,j,spec.subPlt{:});
			if j==1, h_yax(1) = copyobj(h_ax(1,j),gcf); end
			
			plot_group_and_individual_data(h_ax(1,j),G(G_inds,:),F(F_inds,:),...
				speeds,xVar,xLims,yVar_row1,spec,[]);
			
			% Plot panel row 2 with LVAD power data
			% ---------------------------------------------------
			h_ax(2,j) = subplot(nRows,nCols,nCols+j,spec.subPlt{:});
			if j==1, h_yax(2) = copyobj(h_ax(2,j),gcf); end
			
			plot_group_and_individual_data(h_ax(2,j),G(G_inds,:),F(F_inds,:),...
				speeds,xVar,xLims,yVar_row2,spec,[]);
			
			% Panel row with 3 NHA data
			% ---------------------------------------------------
			h_ax(3,j) = subplot(nRows,nCols,2*nCols+j,spec.subPlt{:});
			if j==1, h_yax(3) = copyobj(h_ax(3,j),gcf); end
			h_xax(j) = copyobj(h_ax(3,j),gcf);
			
			h_nha = plot_group_and_individual_data(h_ax(3,j),G(G_inds,:),...
				F(F_inds,:),speeds,xVar,xLims,nhaVar(v,:),spec,[]);
					
		end
		
		format_axes_in_plot_NHA(h_ax,spec);
		format_axes_in_plot_NHA([h_xax,h_yax],spec);
 				
		% Adjust axes positions (after all content is made)
		% ---------------------------------------------------
		
		adjust_panel_positions(h_ax,xGap,yGap,yStart,xStart,...
			panelWidth,panelHeight);
	    
		% Add annotations 
		% ------------------
		
		h_ax = add_shaded_boxes_and_subtitles(h_ax,levelLabels(:,2),...
			panelHeight,panelWidth,yGap,spec);
		
		h_leg = add_legend_to_plot_NHA(h_nha,speeds,spec,legTit);
		h_leg.Position(1) = h_ax(end,end).Position(1)+h_ax(end,end).Position(3)+15;
		h_leg.Position(2) = 65;		
  		
		% Add row y-labels
		h_yLab = add_subYLabels_to_plot_NHA(h_yax,yLabels,spec);
		
		% Add common x label, must be done after other repositioning
		h_supLab = add_supLabel(xLab,spec,'x');

		h_ax = make_intervention_ticks_bold(h_ax);
		adjust_axis_label_positions(h_yLab,h_supLab);

		% Make main axes offset and "actual data axes" invisible
		offset_main_ax(h_ax,h_xax,h_yax,mainXAxGap,mainYAxGap);
  		%make_xy_halfframe(h_ax)

		fix_overlapping_labels(intervention,h_xax,h_yax);
		
	end

function h_ax = adjust_panel_positions(h_ax,xGap,yGap,rowStart,colStart,width,height)
	nRows = size(h_ax,1);
	nCols = size(h_ax,2);
	for i=1:nRows
		rowPos = (nRows-i)*(height+yGap)+rowStart;
		for j=1:nCols
			colPos = (j-1)*(width+xGap)+colStart;
			h_ax(i,j).Position = [colPos,rowPos,width,height];
		end
	end

function h_yLab = adjust_axis_label_positions(h_yLab,h_supLab)
	for i=1:numel(h_yLab)
		h_yLab(i).Position(2) = h_yLab(i).Position(2)+22;
	end

	h_yLab(1).Position(1) = -37;
	h_yLab(2).Position(1) = -31;
	h_yLab(3).Position(1) = -29;
	
	h_supLab.Position(2) = h_supLab.Position(2)+12;

function [h_xax,h_yax] = fix_overlapping_labels(intervention,h_xax,h_yax)
	nCols = numel(h_xax);
	nRows = numel(h_yax);
	if strcmp(intervention,'effect')
		for j=1:nCols-1, h_xax(j).XTickLabel{end} = '100  ';end
		for j=2:nCols, h_xax(j).XTickLabel{1} = ' 0';end
	end

	for i=1:nRows
		h_yax(i).YTick(end) = '';
	end