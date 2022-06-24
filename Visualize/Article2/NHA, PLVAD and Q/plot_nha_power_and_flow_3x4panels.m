function hFig = plot_nha_power_and_flow_3x4panels(F, G, R, var3, yLims)
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

	yTicks1 = -0.75:0.25:0.2;
	yTicks2 = yTicks1+0.25;
	yTicks3 = 0:1:5.5;
	
	spec = get_plot_specs;
	
	figWidth = 710;
	figHeight =  715;
	pHeight = 110;
	pHeigh3 = 180;
	xGap = 9;
	yGap = 7;
	
	%R_inds = contains(string(R.levelLabel),levelLabels(j,1));
	G_ctrl = G(G.categoryLabel=='Clamp' & G.interventionType~='Reversal',:);
	G_bal = G(G.categoryLabel=='Balloon' & G.interventionType~='Reversal',:);
	F_ctrl = F(F.categoryLabel=='Clamp' & F.interventionType~='Reversal',:);
	F_bal = F(F.categoryLabel=='Balloon' & F.interventionType~='Reversal',:);
	
	hFig = figure(spec.fig{:},...
		'Name',sprintf('NHA, PLVAD and Q curves - %s as NHA',var3),...
		'Position',[150,150,figWidth,figHeight],...
		'PaperUnits','centimeters',...
		'PaperSize',[19,30]...
		);

	hAx = init_axes(spec);
	adjust_panel_positions(hAx, pHeight, pHeigh3, yGap, xGap);
	hAx = adjust_axes(hAx, yLims, yTicks1, yTicks2, yTicks3);
	[hXAx,~] = make_offset_axes(hAx, xGap, yGap);
	
	xVar = 'QRedTarget_pst';
	plot_panel_colum(hAx(:,1), G_ctrl, F_ctrl, [2400], xVar, var3, spec);

  	xVar = 'balLev_xRay_mean';
  	plot_panel_colum(hAx(:,2), G_bal, F_bal, [2400], xVar, var3, spec);
	plot_panel_colum(hAx(:,3), G_bal, F_bal, [2200], xVar, var3, spec);
	hPlt = plot_panel_colum(hAx(:,4), G_bal, F_bal, [2600], xVar, var3, spec);
		
	add_legend(hPlt, spec);
	add_annotation(hAx, hXAx);

function hPlt = plot_panel_colum(hAx, G, F, speeds, xVar, var, spec)
	flowColor = [0.17,0.47,0.59];%[0.03,0.26,0.34];
	plvadColor = [0.87,0.50,0.13];%[0.9961,0.4961,0];%[0.84,0.61,0.39];%Colors.Fig.Cats.Speeds4(2,:);
	varColor = [0.76,0.0,0.2];
	
	plot_individual_data(hAx(1), F, speeds, xVar, 'Q_mean', spec);
	hPlt(1) = plot_group_statistic(hAx(1), G, speeds, xVar, 'Q_mean', flowColor, 'diamond');
	plot_individual_data(hAx(2), F, speeds, xVar, 'P_LVAD_mean', spec);
	hPlt(2) = plot_group_statistic(hAx(2), G, speeds, xVar, 'P_LVAD_mean', plvadColor, 'square');
	plot_individual_data(hAx(3), F, speeds, xVar, var, spec);
	hPlt(3) = plot_group_statistic(hAx(3), G, speeds, xVar, var, varColor, 'o');
	
function hPlt = plot_group_statistic(hAx, G, speeds, xVar, var, color, marker)
	
	G = sortrows(G, xVar);
	hPlt = gobjects(numel(speeds),1);
	for j=1:numel(speeds)
		G_rpm_inds = G.pumpSpeed==speeds(j);
		if all(not(G_rpm_inds)), continue; end
		
		% Plot aggregated values in heavy lines
		x = G.(xVar)(G_rpm_inds);
		y = G.(var)(G_rpm_inds);
		
		hPlt(j) = plot(hAx, x, y, ...
			'Color',color, ...
			'Marker',marker, ...
			'MarkerSize',5, ...
			'LineWidth',2 ...
			...,'LineStyle','none'
			); 	
 		hPlt(j).MarkerFaceColor = color;
 		
% 		% Add p value label at line endpoints
% 		if not(isempty(R))
% 			p = R.(var)(ismember(R.pumpSpeed,speeds(j)));
% 			%text(G_x(end)+0.055*diff(xLims),G_y(end),'p='+extractAfter(p,'p='),'FontSize',9);
% 			if double(extractBetween(p,' (',')'))<=0.05
% 				text(G_x(end)+0.05*diff(xLims),G_y(end),'*',...
% 					spec.asterix{:});
% 			end
% 		end
% 
	end

function plot_individual_data(hAx, F, speeds, xVar, var, spec)
 
	seqs = unique(F.seq);
	F = sortrows(F,xVar);
	
	for j=1:numel(speeds)

		% Plot background points
		hAx.ColorOrderIndex=j;

		F_rpm_inds = F.pumpSpeed==speeds(j);

		F_y = F.(var)(F_rpm_inds);
		F_x = F.(xVar)(F_rpm_inds);
		F_x(isnan(F_x)) = 0;
		scatter(hAx, F_x, F_y, 10, ...'filled',...spec.backPts{:},...
			'Marker',spec.speedMarkers{j},...
			'MarkerEdgeColor',[0 0 0],...
			'MarkerEdgeAlpha',0.2,...
			...'MarkerFaceColor',[0 0 0],...
			...'MarkerFaceAlpha',0.1,...
			...'MarkerFaceAlpha',0.1,...
			'HandleVisibility','off');

		% Plot background lines
		for k=1:numel(seqs)
			hAx.ColorOrderIndex=j;
			F_x = F.(xVar)(F_rpm_inds & F.seq==seqs(k));
			F_y = F.(var)(F_rpm_inds & F.seq==seqs(k));
			F_x(isnan(F_x)) = 0;
			if isempty(F_y), continue; end
			hLines = plot(hAx, F_x, F_y, spec.backLines{:});
			hLines.Color = [0,0,0,0.2];
		end
	end

function [hXAx, hYAx] = make_offset_axes(hAx, xGap, yGap)
	% Make main axes offset and "actual data axes" invisible

	% Make extra axes to offset
	for i=1:size(hAx,1)
		hYAx(i) = copyobj(hAx(i,1), gcf); 
	end
	for j=1:size(hAx,2)
		hXAx(j) = copyobj(hAx(end,j), gcf); 
	end

 	offset_main_ax(hAx, hXAx, hYAx, xGap, yGap);
 	%make_xy_halfframe(hAx)

function hAx = adjust_panel_positions(hAx, pHeight, pHeight3,yGap, xGap)
	
	pStartX = 37;
	pStartY = 92;
	xGapClaBal = 18;
	pWidth1 = 83;
	pWidth2 = pWidth1*1.5;

    nRows = size(hAx,1);
	nCols = size(hAx,2);
	
	for i=1:nRows-1
		hAx(i,1).Position([3,4]) = [pWidth1,pHeight];
		hAx(i,2).Position([3,4]) = [pWidth2,pHeight];
		hAx(i,3).Position([3,4]) = [pWidth2,pHeight];
		hAx(i,4).Position([3,4]) = [pWidth2,pHeight];
	end
	hAx(end,1).Position([3,4]) = [pWidth1,pHeight3];
	hAx(end,2).Position([3,4]) = [pWidth2,pHeight3];
	hAx(end,3).Position([3,4]) = [pWidth2,pHeight3];
	hAx(end,4).Position([3,4]) = [pWidth2,pHeight3];

	for i=1:nRows
		hAx(i,1).Position(1) = pStartX;
		hAx(i,2).Position(1) = pStartX + pWidth1 + xGapClaBal;
		hAx(i,3).Position(1) = pStartX + pWidth1 + pWidth2 + xGapClaBal + xGap;
		hAx(i,4).Position(1) = pStartX + pWidth1 + 2*pWidth2 + xGapClaBal + 2*xGap;
	end

	for j=1:nCols
		hAx(3,j).Position(2) = pStartY;
		hAx(2,j).Position(2) = pStartY + pHeight3 + yGap;
		hAx(1,j).Position(2) = pStartY + pHeight + yGap + pHeight3 + yGap;
	end	
	
function hAx = init_axes(spec)
	nCols = 4;
	nRows = 3;
	for i=1:nRows
		for j=1:nCols
			hAx(i,j) = subplot(nRows,nCols,nCols*(i-1)+j,...
				spec.subPlt{:},...
				'FontSize',9.25,...
				'FontName','Arial',...
				'Color',[.96 .96 .96],...
				...'Color',[1 1 1],...
				'TickDir','out',...
				'TickLength',[0.015, 0.015],...
			    'XColor',[1 1 1],...
			    'YColor',[1 1 1],...
				'GridColor',[1 1 1],...
				...'GridColor',[0 0 0],...
				'XGrid','on',...
				'YGrid','on',...
				'LineWidth',1.5,...
				'GridAlpha',1 ...
				...'GridAlpha',0.075...
				);
				
		end
	end
	
function add_legend(hPlt, spec)
	leg = {'\itQ\rm','\itP\rm_{LVAD}','NHA'};
	hLeg = legend(hPlt, leg, spec.leg{:}, 'FontSize',11);
	hLeg.Position(1) = hLeg.Position(1)+10;
	hLeg.Position(2) = 0;

function add_annotation(hAx, hXAx)
	
% 	hYLab = suplabel('deviation from baseline','y');
% 	hYLab.FontSize = 10.5;
% 	hYLab.FontName = 'Arial';
	
	xLab1 = 'afterload levels';
	xLab2 = 'inflow balloon obstruction levels';
	hXLab(1) = xlabel(hXAx(1), xLab1, "FontSize",11, 'Units','points');
	hXLab(2) = xlabel(hXAx(3), xLab2, "FontSize",11, 'Units','points');
	hXLab(1).Position(2) = -27;
	hXLab(2).Position(2) = -27;
	
% 	y = hAx(1,2).YLim(1)+0.5*diff(hAx(1,2).YLim);
% 	text(hAx(1,2), 5.9, y, '\itQ\rm','FontSize',10.5);
% 	y = hAx(2,2).YLim(1)+0.5*diff(hAx(2,2).YLim);
% 	text(hAx(2,2), 5.9, y,'\itP\rm_{LVAD}','FontSize',10.5);
% 	y = hAx(3,2).YLim(1)+0.5*diff(hAx(3,2).YLim);
% 	text(hAx(3,2), 5.9, y, 'NHA', 'FontSize',10.5);
	
	text(hAx(1,1), hAx(1,1).XLim(1), .4, {'A'}, 'FontSize',15, 'FontName','Arial','VerticalAlignment','bottom');
	text(hAx(1,2), hAx(1,2).XLim(1), .4, {'B'}, 'FontSize',15, 'FontName','Arial','VerticalAlignment','bottom');
	text(hAx(1,3), hAx(1,3).XLim(1), .4, {'C'}, 'FontSize',15, 'FontName','Arial','VerticalAlignment','bottom');
	text(hAx(1,4), hAx(1,4).XLim(1), .4, {'D'}, 'FontSize',15, 'FontName','Arial','VerticalAlignment','bottom');
	
	text(hAx(1,1), 0.5*diff(hAx(1,1).XLim), .35, {'clamp','2400 RPM'}, 'FontSize',11, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
	text(hAx(1,2), 0.5*diff(hAx(1,2).XLim), .35, {'balloon','2400 RPM'}, 'FontSize',11, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
	text(hAx(1,3), 0.5*diff(hAx(1,3).XLim), .35, {'balloon','2200 RPM'}, 'FontSize',11, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
	text(hAx(1,4), 0.5*diff(hAx(1,4).XLim), .35, {'balloon','2600 RPM'}, 'FontSize',11, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
	
function hAx = adjust_axes(hAx, yLims, yTicks1, yTicks2, yTicks3)
	xlim(hAx(:,1),[-5,80]);
	xlim(hAx(:,2:end),[-0.2,5.2]);
	ylim(hAx(1,:),yLims{1});
	ylim(hAx(2,:),yLims{2});
	ylim(hAx(3,:),yLims{3});
	xticks(hAx(end,1), [0, 25, 50, 75]);	
	xticks(hAx(:,2:end), 0:5);	
	yticks(hAx(1,:),yTicks1)
	yticks(hAx(2,:),yTicks2)
	yticks(hAx(3,:),yTicks3)
	for i=1:size(hAx,1)
		yTickLabels = 100*yticks(hAx(i,1))+"%";
		%yTickLabels(2:2:end) = "";
		yticklabels(hAx(i,1),yTickLabels)
	end
	hAx(end,1).XTickLabel = {'BL','1','2','3'};
	hAx(end,2).XTickLabel{1} = 'BL';
	hAx(end,3).XTickLabel{1} = 'BL';
	hAx(end,4).XTickLabel{1} = 'BL';
