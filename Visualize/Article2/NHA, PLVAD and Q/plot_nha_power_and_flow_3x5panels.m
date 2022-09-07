function hFig = plot_nha_power_and_flow_3x5panels(F, G, R, var3, yLims)
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
	
	figWidth = 715;
	figHeight =  462;
	pHeight = 64;
	pHeigh3 = 125;
	xGap = 11.5;
	xGapExtra = 4.5;
	yGap = 5;
	
	%R_inds = contains(string(R.levelLabel),levelLabels(j,1));
	G_rpm = G(G.categoryLabel=='RPM' & G.interventionType~='Reversal',:);
	G_cla = G(G.categoryLabel=='Clamp' & G.interventionType~='Reversal',:);
	G_bal = G(G.categoryLabel=='Balloon' & G.interventionType~='Reversal',:);
	F_rpm = F(F.categoryLabel=='RPM' & F.interventionType~='Reversal',:);
	F_cla = F(F.categoryLabel=='Clamp' & F.interventionType~='Reversal',:);
	F_bal = F(F.categoryLabel=='Balloon' & F.interventionType~='Reversal',:);
	
	hFig = figure(spec.fig{:},...
		'Name',sprintf('NHA, PLVAD and Q curves - %s as NHA',var3),...
		'Position',[150,150,figWidth,figHeight],...
		'PaperUnits','centimeters',...
		'PaperSize',[19,19*(figHeight/figWidth)]...
		);

	hAx = init_axes(spec);
	adjust_panel_positions(hAx, pHeight, pHeigh3, yGap, xGap, xGapExtra);
	hAx = adjust_axes(hAx, yLims, yTicks1, yTicks2, yTicks3);
	[hXAx,~] = make_offset_axes(hAx, yGap, xGap);
	
	xVar = 'pumpSpeed';
	plot_panel_colum(hAx(:,1), G_rpm, F_rpm, [nan], xVar, var3, spec);

	xVar = 'QRedTarget_pst';
	plot_panel_colum(hAx(:,2), G_cla, F_cla, 2400, xVar, var3, spec);

  	xVar = 'balLev_xRay_mean';
  	plot_panel_colum(hAx(:,3), G_bal, F_bal, 2200, xVar, var3, spec);
	plot_panel_colum(hAx(:,4), G_bal, F_bal, 2400, xVar, var3, spec);
	hPlt = plot_panel_colum(hAx(:,5), G_bal, F_bal, 2600, xVar, var3, spec);
		
	add_legend([hPlt{:}], spec);
	add_annotation(hAx, hXAx);

function hPlt = plot_panel_colum(hAx, G, F, speeds, xVar, var, spec)
	
	%flowColor = [0.44,0.58,0.32];
	flowColor = [0.07,0.39,0.50];
	plvadColor = [0.87,0.50,0.13];
	nhaColor = [0.76,0.0,0.2];
	%nhaColor = [0.07,0.39,0.50];
	
	plot_individual_data(hAx(1), F, speeds, xVar, 'Q_mean', spec);
	hPlt{1} = plot_group_statistic(hAx(1), G, speeds, xVar, 'Q_mean', flowColor, 'diamond');
	plot_individual_data(hAx(2), F, speeds, xVar, 'P_LVAD_mean', spec);
	hPlt{2} = plot_group_statistic(hAx(2), G, speeds, xVar, 'P_LVAD_mean', plvadColor, 'square');
	plot_individual_data(hAx(3), F, speeds, xVar, var, spec);
	hPlt{3} = plot_group_statistic(hAx(3), G, speeds, xVar, var, nhaColor, 'o');
	
function hPlt = plot_group_statistic(hAx, G, speeds, xVar, var, color, marker)
	
	G = sortrows(G, xVar);
	G = make_bl_deviation_zero(G, var);
	
		
	for j=1:numel(speeds)
		
		G_inds = get_speed_inds(speeds(j), G);
		if all(not(G_inds)), continue; end
		
		% Plot aggregated values in heavy lines
		x = G.(xVar)(G_inds);
		y = G.(var)(G_inds);
		
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
	F = make_bl_deviation_zero(F, var);
	
	for j=1:numel(speeds)

		F_inds = get_speed_inds(speeds(j), F);
		if all(not(F_inds)), continue; end

		F_y = F.(var)(F_inds);
		F_x = F.(xVar)(F_inds);
		F_x(isnan(F_x)) = 0;
		scatter(hAx, F_x, F_y, 10, ...'filled',...spec.backPts{:},...
			'Marker',spec.speedMarkers{j},...
			'MarkerEdgeColor',[0 0 0],...
			'MarkerEdgeAlpha',0.2,...
			...'MarkerFaceColor',[0 0 0],...
			...'MarkerFaceAlpha',0.1,...
			'HandleVisibility','off');

		% Plot background lines
		for k=1:numel(seqs)
			hAx.ColorOrderIndex=j;
			F_x = F.(xVar)(F_inds & F.seq==seqs(k));
			F_y = F.(var)(F_inds & F.seq==seqs(k));
			F_x(isnan(F_x)) = 0;
			if isempty(F_y), continue; end
			hLines = plot(hAx, F_x, F_y, spec.backLines{:},'LineWidth',1.0);
			hLines.Color = [0,0,0,0.25];
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
 	
function adjust_panel_positions(hAx, pHeight, pHeight3, yGap, xGap, xGapExtra)
	
	pStartX = 40;
	pStartY = 68;
	pWidth1 = 44;
	pWidth2 = 60;
	pWidth3 = 90;

    nRows = size(hAx,1);
	nCols = size(hAx,2);
	
	for i=1:nRows-1
		hAx(i,1).Position([3,4]) = [pWidth1,pHeight];
		hAx(i,2).Position([3,4]) = [pWidth2,pHeight];
		hAx(i,3).Position([3,4]) = [pWidth3,pHeight];
		hAx(i,4).Position([3,4]) = [pWidth3,pHeight];
		hAx(i,5).Position([3,4]) = [pWidth3,pHeight];
	end
	hAx(end,1).Position([3,4]) = [pWidth1,pHeight3];
	hAx(end,2).Position([3,4]) = [pWidth2,pHeight3];
	hAx(end,3).Position([3,4]) = [pWidth3,pHeight3];
	hAx(end,4).Position([3,4]) = [pWidth3,pHeight3];
	hAx(end,5).Position([3,4]) = [pWidth3,pHeight3];
	
	for i=1:nRows
		hAx(i,1).Position(1) = pStartX;
		hAx(i,2).Position(1) = pStartX + pWidth1 + xGap;
		hAx(i,3).Position(1) = pStartX + pWidth1 + pWidth2 + 2*xGap + 2*xGapExtra;
		hAx(i,4).Position(1) = pStartX + pWidth1 + pWidth2 + pWidth3 + 3*xGap + 2*xGapExtra;
		hAx(i,5).Position(1) = pStartX + pWidth1 + pWidth2 + 2*pWidth3 + 4*xGap + 2*xGapExtra;
	end

	for j=1:nCols
		hAx(3,j).Position(2) = pStartY;
		hAx(2,j).Position(2) = pStartY + pHeight3 + yGap;
		hAx(1,j).Position(2) = pStartY + pHeight + yGap + pHeight3 + yGap;
	end	
	
function hAx = init_axes(spec)
	nCols = 5;
	nRows = 3;
	for i=1:nRows
		for j=1:nCols
			hAx(i,j) = subplot(nRows,nCols,nCols*(i-1)+j,...
				spec.subPlt{:},...
				'FontSize',9,...
				'FontName','Arial',...
				'Color',[.96 .96 .96],...
				'TickDir','out',...
				'TickLength',[0.015, 0.015],...
			    'XColor',[1 1 1],...
			    'YColor',[1 1 1],...
				'GridColor',[1 1 1],...
				'XGrid','on',...
				'YGrid','on',...
				'LineWidth',1.5,...
				'GridAlpha',1 ...
				);
				
		end
	end
	
function add_legend(hPlt, spec)
	leg = {'\itQ\rm','\itP\rm_{LVAD}','NHA'};
	hLeg = legend(hPlt, leg, spec.leg{:}, 'FontSize',9);
	hLeg.Position(1) = hLeg.Position(1)+75;
	hLeg.Position(2) = 0;
	
function add_annotation(hAx, hXAx)
	
	% 	hYLab = suplabel('deviation from baseline','y');
	% 	hYLab.FontSize = 10.5;
	% 	hYLab.FontName = 'Arial';

	xLab1 = {'speed (RPM)'};
	xLab2 = {'\itQ\rm reduction'};
	xLab3 = {'','level'};
	hXLab(1) = xlabel(hXAx(1), xLab1, "FontSize",9, 'Units','points');
	hXLab(2) = xlabel(hXAx(2), xLab2, "FontSize",9, 'Units','points');
	hXLab(3) = xlabel(hXAx(3), {'level'}, "FontSize",9, 'Units','points');
	hXLab(4) = xlabel(hXAx(4), {'level'}, "FontSize",9, 'Units','points');
	hXLab(5) = xlabel(hXAx(5), {'level'}, "FontSize",9, 'Units','points');
	hXLab(1).Position(2) = -29;
	hXLab(2).Position(2) = -29;
  	hXLab(3).Position(2) = -16;
  	hXLab(4).Position(2) = -16;
  	hXLab(5).Position(2) = -16;
	text(hAx(3,3), mean(hAx(3,3).XLim), -3.15, {'2200 RPM'}, 'FontSize',9, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
	text(hAx(3,4), mean(hAx(3,4).XLim), -3.15, {'2400 RPM'}, 'FontSize',9, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
	text(hAx(3,5), mean(hAx(3,5).XLim), -3.15, {'2600 RPM'}, 'FontSize',9, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
		
	text(hAx(1,1), hAx(1,1).XLim(1), .335, {' A'}, 'FontSize',13, 'FontName','Arial','VerticalAlignment','bottom');
	text(hAx(1,2), hAx(1,2).XLim(1), .335, {' B'}, 'FontSize',13, 'FontName','Arial','VerticalAlignment','bottom');
	text(hAx(1,3), hAx(1,3).XLim(1), .335, {' C'}, 'FontSize',13, 'FontName','Arial','VerticalAlignment','bottom');
	text(hAx(1,4), hAx(1,4).XLim(1), .335, {' D'}, 'FontSize',13, 'FontName','Arial','VerticalAlignment','bottom');
	text(hAx(1,5), hAx(1,5).XLim(1), .335, {' E'}, 'FontSize',13, 'FontName','Arial','VerticalAlignment','bottom');
% 	text(hAx(1,1), 2150+0.5*diff(hAx(1,1).XLim), .35, {'pump','speed'}, 'FontSize',11, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
% 	text(hAx(1,2), 0.5*diff(hAx(1,2).XLim), .35, {'clamp','2400 RPM'}, 'FontSize',11, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
%  	text(hAx(1,3), 0.5*diff(hAx(1,3).XLim), .35, {'2200 RPM'}, 'FontSize',11, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
%  	text(hAx(1,4), 0.5*diff(hAx(1,4).XLim), .35, {'2400 RPM'}, 'FontSize',11, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
%  	text(hAx(1,5), 0.5*diff(hAx(1,5).XLim), .35, {'2600 RPM'}, 'FontSize',11, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
	
annotation(gcf,'textbox',...
		[0.0577 0.0 0.24095 0.05],...
		'VerticalAlignment','bottom',...
		'FontName','Arial',...
		'FontWeight','bold',...
		'FontSize',9.5,...
		'String',{'control interventions'},...
		'Margin',1,...
		'LineStyle','none',...
		'HorizontalAlignment','center');
annotation(gcf,'textbox',...
		[0.341559440559441 0 0.537461538461539 0.0553191489361702],...
		'VerticalAlignment','bottom',...
		'FontName','Arial',...
		'FontWeight','bold',...
		'FontSize',9.5,...
		'String',{'balloon inflow obstructions'},...
		'Margin',1,...
		'LineStyle','none',...
		'HorizontalAlignment','center');

annotation(gcf,'line',[0.3104 0.3104],[0 0.955], ...
	'Color',[0.15 0.15 0.15], 'LineWidth',0.7);

function hAx = adjust_axes(hAx, yLims, yTicks1, yTicks2, yTicks3)
	
	ylim(hAx(1,:),yLims{1});
	ylim(hAx(2,:),yLims{2});
	ylim(hAx(3,:),yLims{3});
	
	yticks(hAx(1,:),yTicks1)
	yticks(hAx(2,:),yTicks2)
	yticks(hAx(3,:),yTicks3)
	for i=1:size(hAx,1)
		yTickLabels = 100*yticks(hAx(i,1))+"%";
		%yTickLabels(2:2:end) = "";
		yticklabels(hAx(i,1),yTickLabels)
	end
	
	xlim(hAx(:,1),[2150 2650]);
	xlim(hAx(:,2),[-5,80]);
	xlim(hAx(:,3:end),[-0.2,5.2]);
	
	xticks(hAx(end,1), [2200 2400 2600]);	
	xticks(hAx(end,2), [0, 25, 50, 75]);	
	xticks(hAx(:,3:end), 0:5);	
	hAx(end,1).XTickLabel = {'2200','2400','2600'};
	%hAx(end,2).XTickLabel = {'BL','1','2','3'};
	hAx(end,2).XTickLabel = {'BL','25%','50%','75%'};
	set(hAx(end,3:end),'XTickLabel',{'BL','1','2','3','4','5'});
	set(hAx(end,1),'XTickLabelRotation',45);
	set(hAx(end,2),'XTickLabelRotation',45);
	set(hAx(end,3:end),'XTickLabelRotation',0);

function G = make_bl_deviation_zero(G, var)
	bl_inds = ismember(G.idLabel,{
		'Bal_2200_Nom_Rep1'
		'Bal_2400_Nom_Rep1'
		'Bal_2600_Nom_Rep1'
		'RPM_2400_Nom_Rep1'
		'Cla_2400_Nom_Rep1'
		});
	G{bl_inds,var} = 0;

function G_inds = get_speed_inds(speed, G)
	if not(isnan(speed)) 
		G_inds = G.pumpSpeed==speed; 
	else
		G_inds = true(height(G),1);
	end
