function hFig = plot_nha_power_and_flow(F, G, R, var3, yLims3)
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

	yLims1 = [-0.85 0.2];
	%yLims2 = [-0.45 0.15];
	yLims2 = yLims1+0.25;
	yTicks1 = -0.75:0.25:0;
	%yTicks2 = -0.4:0.1:0.1;
	yTicks2 = yTicks1+0.25;
	yTicks3 = 0:1:5.5;

	spec = get_plot_specs;

	figWidth = 710;
	figHeight =  710;
	pHeight = 145;
	xGap = 8;
	yGap = 8;

	%R_inds = contains(string(R.levelLabel),levelLabels(j,1));
	G_ctrl = G(G.categoryLabel=='Clamp' & G.interventionType~='Reversal',:);
	G_bal = G(G.categoryLabel=='Balloon' & G.interventionType~='Reversal',:);
	F_ctrl = F(F.categoryLabel=='Clamp' & F.interventionType~='Reversal',:);
	F_bal = F(F.categoryLabel=='Balloon' & F.interventionType~='Reversal',:);
	speeds = unique(G_bal.pumpSpeed);

	hFig = figure(spec.fig{:},...
		'Name',sprintf('NHA, PLVAD and Q curves - %s as NHA',var3),...
		'Position',[150,150,figWidth,figHeight],...
		'PaperUnits','centimeters',...
		'PaperSize',[19,30]...
		);

	hAx = init_axes(spec);
	adjust_panel_positions(hAx, pHeight, yGap);
	hAx = adjust_axes(hAx, yLims1, yLims2, yLims3, G_ctrl, yTicks1, yTicks2, yTicks3);
	[hXAx,~] = make_offset_axes(hAx, xGap, yGap);


	% Extract inds for overall baseline and for interventions in G and F
	% ---------------------------------------------------

	xVar = 'QRedTarget_pst';
	plot_panel_colum(hAx(:,1), G_ctrl, F_ctrl, speeds, xVar, var3, spec);

	xVar = 'arealObstr_xRay_pst_mean';
	xVar = 'balLev_xRay_mean';
	plot_panel_colum(hAx(:,2), G_bal, F_bal, speeds, xVar, var3, spec);

	add_legend(G, hAx, spec);
	add_annotation(hAx, hXAx);

function plot_panel_colum(hAx, G, F, speeds, xVar, var, spec)

	plot_individual_data(hAx(1), F, speeds, xVar, 'Q_mean', spec);
	plot_group_statistic(hAx(1), G, speeds, xVar, 'Q_mean', spec, []);
	plot_group_statistic(hAx(2), G, speeds, xVar, 'P_LVAD_mean', spec, []);
	plot_individual_data(hAx(2), F, speeds, xVar, 'P_LVAD_mean', spec);
	plot_group_statistic(hAx(3), G, speeds, xVar, var, spec, []);
	plot_individual_data(hAx(3), F, speeds, xVar, var, spec);

function hPlt = plot_group_statistic(hAx, G, speeds, xVar, var, spec, R)

	G = sortrows(G, xVar);
	hPlt = gobjects(numel(speeds),1);
	for j=1:numel(speeds)

		% Plot background points
		hAx.ColorOrderIndex=j;

		G_rpm_inds = G.pumpSpeed==speeds(j);
		if all(not(G_rpm_inds)), continue; end

		% Plot aggregated values in heavy lines
		x = G.(xVar)(G_rpm_inds);
		y = G.(var)(G_rpm_inds);

		hPlt(j) = plot(hAx, x, y, ...
			'Marker', spec.speedMarkers{j},...
			'LineWidth',1 ...
			...,'LineStyle','none'
			);
		%hPlt(j).MarkerFaceColor = hPlt(j).Color;

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

function [hPts,hLines] = plot_individual_data(hAx, F, speeds, xVar, var, spec)

	seqs = unique(F.seq);
	%F.(xVar) = double(string((F.(xVar))));
	F = sortrows(F,xVar);

	for j=1:numel(speeds)

		% Plot background points
		hAx.ColorOrderIndex=j;

		F_rpm_inds = F.pumpSpeed==speeds(j);

		F_y = F.(var)(F_rpm_inds);
		F_x = F.(xVar)(F_rpm_inds);
		F_x(isnan(F_x)) = 0;
		hPts(j) = scatter(hAx, F_x, F_y, spec.backPts{:},...
			'Marker',spec.speedMarkers{j},...
			'MarkerEdgeAlpha',0.8,...
			'HandleVisibility','off');

		% 		% Plot background lines
		% 		for k=1:numel(seqs)
		% 			hAx.ColorOrderIndex=j;
		% 			F_x = F.(xVar)(F_rpm_inds & F.seq==seqs(k));
		% 			F_y = F.(var)(F_rpm_inds & F.seq==seqs(k));
		% 			F_x(isnan(F_x)) = 0;
		% 			if isempty(F_y), continue; end
		% 			hLines(j,k) = plot(hAx, F_x, F_y, spec.backLines{:},'HandleVisibility','off');
		% 			hLines(j,k).Color = [hLines(j).Color,0.5];
		% 		end
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

function hAx = adjust_panel_positions(hAx, pHeight, yGap)

	pStartX = 70;
	pStartY = 50;
	xGap = 25;
	pWidth1 = 125;
	pWidth2 = pWidth1*1.8;

	nRows = size(hAx,1);
	nCols = size(hAx,2);

	for i=1:nRows
		hAx(i,1).Position([3,4]) = [pWidth1,pHeight];
		hAx(i,2).Position([3,4]) = [pWidth2,pHeight];
	end

	for i=1:nRows
		hAx(i,1).Position(1) = pStartX;
		hAx(i,2).Position(1) = pStartX + pWidth1 + xGap;
	end

	for j=1:nCols
		hAx(3,j).Position(2) = pStartY;
		hAx(2,j).Position(2) = pStartY + pHeight + yGap;
		hAx(1,j).Position(2) = pStartY + pHeight + yGap + pHeight + yGap;
	end

function hAx = init_axes(spec)
	nCols = 2;
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

function add_legend(G, hAx, spec)
	leg = string(unique(G.pumpSpeed));%{'2200','2400','2600'};
	hLeg = legend(hAx(end,end), leg, spec.leg{:}, 'FontSize',10);
	hLeg.Title.String = 'speed (RPM)';
	set(hLeg.Title, spec.legTit{:}, 'FontSize',10, 'FontWeight','normal')
	hLeg.Position(1) = hLeg.Position(1)+95;
	hLeg.Position(2) = 0;

function add_annotation(hAx, hXAx)

	hYLab = suplabel('deviation from baseline','y');
	hYLab.FontSize = 10.5;
	hYLab.FontName = 'Arial';

	xLab1 = 'afterload levels';
	xLab2 = 'inflow obstruction levels';
	hXLab(1) = xlabel(hXAx(1), xLab1, "FontSize",10.5, 'Units','points');
	hXLab(2) = xlabel(hXAx(2), xLab2, "FontSize",10.5, 'Units','points');
	hXLab(1).Position(2) = -27;
	hXLab(2).Position(2) = -27;

	y = hAx(1,2).YLim(1)+0.5*diff(hAx(1,2).YLim);
	text(hAx(1,2), 5.9, y, '\itQ\rm','FontSize',10.5);
	y = hAx(2,2).YLim(1)+0.5*diff(hAx(2,2).YLim);
	text(hAx(2,2), 5.9, y,'\itP\rm_{LVAD}','FontSize',10.5);
	y = hAx(3,2).YLim(1)+0.5*diff(hAx(3,2).YLim);
	text(hAx(3,2), 5.9, y, 'NHA', 'FontSize',10.5);
	text(hAx(1,1), hAx(1,1).YLim(1), .30, 'A', 'FontSize',15, 'FontName','Arial');
	text(hAx(1,2), 0, .30, 'B', 'FontSize',15, 'FontName','Arial');

function hAx = adjust_axes(hAx, yLims1, yLims2, yLims3, G_ctrl, yTicks1, yTicks2, yTicks3)
	xlim(hAx(:,1),[-5,80]);
	xlim(hAx(:,2),[-0.2,5.2]);
	ylim(hAx(1,:),yLims1);
	ylim(hAx(2,:),yLims2);
	ylim(hAx(3,:),yLims3);
	xticks(hAx(end,1), unique(G_ctrl.QRedTarget_pst));
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

function [h_lines,h_backPts,h_backLines] = plot_group_and_individual_data(...
		h_ax,G,F,speeds,xVar,xLims,nhaVars,spec,R)

	seqs = unique(F.seq);
	yVar = nhaVars{1};
	yLims = nhaVars{2};
	G.(xVar) = double(string((G.(xVar))));
	F.(xVar) = double(string((F.(xVar))));
	F = sortrows(F,xVar);

	for j=1:numel(speeds)

		% Plot background points
		h_ax.ColorOrderIndex=j;

		F_rpm_inds = F.pumpSpeed==speeds(j);
		F_y = F.(yVar)(F_rpm_inds);
		F_x = F.(xVar)(F_rpm_inds);%round(double(string(F.(xVar)(F_rpm_inds)))+mod(j,2)*0.003*diff(xLims));
		F_x(isnan(F_x)) = 0;
		h_backPts(j) = scatter(F_x,F_y,spec.backPts{:},...
			'Marker',spec.speedMarkers{j});

		% Plot background lines
		for k=1:numel(seqs)
			h_ax.ColorOrderIndex=j;
			F_x = F.(xVar)(F_rpm_inds & F.seq==seqs(k));%double(string(F.(xVar)(F_rpm_inds & F.seq==seqs(k))));%+j*0.10-0.20;
			F_y = F.(yVar)(F_rpm_inds & F.seq==seqs(k));
			F_x(isnan(F_x)) = 0;
			max_x_ind = F_x==max(F_x);
			min_x_ind = F_x==min(F_x);
			F_y = [F_y;nan];
			F_x = [F_x;nan];
			h_backLines(j,k) = plot(F_x,F_y,spec.backLines{:});
			h_backLines(j,k).Color = [h_backLines(j).Color,0.5];
		end
	end

	for j=1:numel(speeds)

		% Plot background points
		h_ax.ColorOrderIndex=j;

		% Plot aggregated values in heavy lines
		G.(xVar)(isnan(G.(xVar))) = 0;
		G = sortrows(G,xVar);
		G_rpm_inds = G.pumpSpeed==speeds(j);
		G_y = G.(yVar)(G_rpm_inds);
		G_x = round(G.(xVar)(G_rpm_inds),0);%+j*0.05-0.10;
		if isempty(G_y), G_y = nan; G_x = nan; end
		h_lines(j) = plot(G_x,double(G_y),spec.line{:},...
			'Marker',spec.speedMarkers{j},...
			'Color',h_backLines(j).Color);
		h_lines(j).MarkerFaceColor = h_lines(j).Color;
		
		% Add p value label at line endpoints
		if not(isempty(R))
			p = R.(yVar)(ismember(R.pumpSpeed,speeds(j)));
			%text(G_x(end)+0.055*diff(xLims),G_y(end),'p='+extractAfter(p,'p='),'FontSize',9);
			if double(extractBetween(p,' (',')'))<=0.05
				text(G_x(end)+0.05*diff(xLims),G_y(end),'*',...
					spec.asterix{:});
			end
		end

		interventionTicks = G_x(2:end)';
		xticks(unique([0,interventionTicks,xLims(2)]));

		% Adjust axis limits; y only if specified by user
		if not(isempty(yLims)), ylim(yLims); end
		xlim(xLims)

	end
