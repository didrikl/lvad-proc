function hFig = make_part_figure_2panels_with_nha(T1, T2, map1, map2, Notes, ...
		var, partSpec, fs, yLims1, yLims2, yTicks2, widthFactor)
	
	Colors_IV2
	cMapName = 'batlowW';
	cMap = scientificColormaps.(cMapName);
	cMapScale = [-64, -38];
	spec = get_plot_specs;
	
	figWidth = 710;
	figHeight =  445;
	pHeight1 = 150;
	pHeight2 = 200;

	%   If clipping of transitional segments in between
	% 	[map1.map,map1.order,~,map1.mapTime] = make_rpm_order_map(T1, var, fs, 'pumpSpeed', res, overlapPst);
	% 	[map2.map,map2.order,~,map2.mapTime] = make_rpm_order_map(T2, var, fs, 'pumpSpeed', res, overlapPst);
	[T1, segs1] = make_dur_and_seg_info(T1, Notes, fs);
	[T2, segs2] = make_dur_and_seg_info(T2, Notes, fs);
	
	[hFig, hSub] = init_panels(spec, figWidth, figHeight);
	make_panels_colum(hSub(:,1), T1, var, map1, fs, segs1, cMapScale, cMap, yLims1, yLims2, yTicks2);
	make_panels_colum(hSub(:,2), T2, var, map2, fs, segs2, cMapScale, cMap, yLims1, yLims2, yTicks2);
	
 	rpms = unique(T2.pumpSpeed(segs2.all.startInd),'stable');
%  	hYYLab = add_linked_map_hz_yyaxis(hSub(1,2), '', rpms);
%  	hYYLab.FontSize = 9;

 	adjust_panel_positions(T1, T2, hSub, widthFactor, pHeight1, pHeight2);
	add_annotations(hSub, yLims1, segs1, segs2);

	hSub(1,2).YAxis(1).Visible = 'off';
	hSub(2,2).YAxis(1).Visible = 'off';

	seqID = get_seq_id(Notes.Properties.UserData.Experiment_Info.ExperimentID);
	hFig.Name = make_figure_title(rpms, seqID, partSpec, var, cMapScale, ...
		cMapName, '2 panels, with NHA');

function hLeg = add_legend_and_colorbar(hSub)
	
	hLeg(1) = colorbar(hSub(1,2),...
		'Units','pixels',...
		'Box','off');
	hLeg(1).Label.String = '(dB)';
	
	legStr2 = {
		'\itQ\rm'
		'NHA'
		'\itP\rm_{LVAD}'
		};
	hLeg(2) = legend(hSub(end,2),legStr2,...
		"AutoUpdate","off",...
		"Box","off",...
		'Units','pixels');
	
function adjust_panel_positions(T1, T2, hSub, widthFactor, pHeight1, pHeight2)
	
	pWidth1 = min(920*T1.dur(end)/widthFactor,1200);
	pWidth2 = min(920*T2.dur(end)/widthFactor,1200);
	
	pStartX = 53;
	pStartY = 43;
	yGap = 8;
	xGap = 30;
	set(hSub,'Units','pixels');
	
	hSub(1,1).Position(4) = pHeight1;
	hSub(2,1).Position(4) = pHeight2;
	hSub(1,2).Position(4) = pHeight1;
	hSub(2,2).Position(4) = pHeight2;
	hSub(1,1).Position(3) = pWidth1;
	hSub(2,1).Position(3) = pWidth1;
	hSub(2,2).Position(3) = pWidth2;
	hSub(1,2).Position(3) = pWidth2;
	hSub(1,1).Position(1) = pStartX;
	hSub(2,1).Position(1) = pStartX;
 	hSub(1,2).Position(1) = hSub(1,1).Position(1) + hSub(1,1).Position(3) + xGap;
	hSub(2,2).Position(1) = hSub(2,1).Position(1) + hSub(2,1).Position(3) + xGap;
	
	hSub(2,1).Position(2) = pStartY;
	hSub(2,2).Position(2) = pStartY;
	hSub(1,1).Position(2) = pStartY+hSub(2,1).Position(4) + yGap;
	hSub(1,2).Position(2) = pStartY+hSub(2,2).Position(4) + yGap;

function h = plot_curves(hAx, hAxNHA, T, segs, fs, yLims, yLimsNHA)
	
	flowColor = [0.07,0.39,0.50];[0.03,0.26,0.34,1];
	plvadColor = [0.87,0.50,0.13];
	nhaColor = [0.76,0.0,0.2];
	%qlvadColor = [0.39,0.83,0.07];
	
	nhaColor = [0.07,0.39,0.50];
	flowColor = [0.76,0.0,0.2];
	
	h(1) = plot(hAx, T.dur, T.Q_relDiff,...
 		'LineWidth',1,'Color',flowColor);  	
	
	nha_bl = calc_nha_at_baseline(segs, T, fs);
	h(4) = plot_nha(hAxNHA, segs, T, nha_bl, yLimsNHA, fs, 'main', nhaColor);
	
    h(2) = plot(hAx, T.dur,T.P_LVAD_relDiff,...
 		'-.','LineWidth',2,'Color',[plvadColor,1]);
	
	hAx.Clipping = 'off';
	ylim(yLims);
	xlim([0,max(T.dur)])

function hPlt = plot_rpm_order_map(hAx, colRange, colMap, t, order, map, yLim)
	
	hPlt = imagesc(hAx, t, order, map);

	colormap(hAx, colMap)
	caxis(hAx, colRange);

	set(hAx,'ydir','normal');
	yticks(hAx, 0:1:max(order));
	hAx.YLim = yLim;
	xlim(hAx, t([1,end]))

function hPlt = make_panels_colum(hSub, T, var, map, fs, segs, mapScale, colorMap, yLims1, yLims2, yTicks2)
	
	t = map.time;
	order = map.order;
	map = map.([var,'_map']);
	
	plot_rpm_order_map(hSub(1), mapScale, colorMap, t, order, map, yLims1);
	hPlt = plot_curves(hSub(2), hSub(2), T, segs, fs, yLims2, yLims2);
	
 	make_xticks_and_time_str(hSub, segs);
 	adjust_yticks(hSub(2), yTicks2);
 	adjust_ax_format(hSub);
 	linkaxes(hSub,'x')
	xlim(hSub,[0,max(T.dur)])
	
	add_shades_for_transition_segments(hSub, segs, yLims1, yLims2);
	add_xlines_and_grid(hSub(2));
 	
function [hFig, hSub] = init_panels(spec, figWidth, figHeight)
	
	hFig = figure(spec.fig{:},...
		'Name','Q, PLVAD and NHA',...
	    'Position',[150,100,figWidth,figHeight],...
		'PaperUnits','centimeters',...
		'PaperSize',[19,19*(figHeight/figWidth)+0.1]...
		);
	
	hSub(1,1) = subplot(2,2,1,spec.subPlt{:},'FontSize',9);
	hSub(1,2) = subplot(2,2,2,spec.subPlt{:},'FontSize',9);
	hSub(2,1) = subplot(2,2,3,spec.subPlt{:},'FontSize',9);
	hSub(2,2) = subplot(2,2,4,spec.subPlt{:},'FontSize',9);
	
	linkaxes([hSub(2,1),hSub(2,2)],'y')

function add_annotations(hSub, yLims1, segs1, segs2)
	text(hSub(1,1), 15, yLims1(2)*1.14, 'A', 'FontSize',13, 'FontName','Arial','VerticalAlignment','bottom')
	text(hSub(1,2), 15, yLims1(2)*1.14, 'B', 'FontSize',13, 'FontName','Arial','VerticalAlignment','bottom')
	text(hSub(1,1), 0.5*diff(hSub(1,1).XLim), yLims1(2)*1.14, {'Afterload flow reductions'}, 'FontSize',10, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
	text(hSub(1,2), 0.5*diff(hSub(1,2).XLim), yLims1(2)*1.14, {'Balloon obstructions'}, 'FontSize',10, 'FontName','Arial','VerticalAlignment','bottom','HorizontalAlignment','center');
	
	add_steady_state_annotations(hSub(1,1), segs1, yLims1(2)*1.09);
	add_steady_state_annotations(hSub(1,2), segs2, yLims1(2)*1.09);
	
	hXLab = xlabel(hSub(2,2),'(mm:ss)', 'Units','pixels');
 	hYLab(1) = ylabel(hSub(1,1),{'harmonic order'},'Units','pixels');
  	%hYLab(2) = ylabel(hSub(2,1),{'deviation from BL'},'Units','pixels');
	
    hLeg = add_legend_and_colorbar(hSub);
%  	hYyTxt = add_text_as_yylabel(hSub(1,2));
	
	hYLab(1).Position(1) = -25;
 	%hYLab(2).Position(2) = -50;
	hXLab.Position = [315,-14,0];
  	hLeg(1).Position = [sum(hSub(1,2).Position([1,3]))+85, hLeg(1).Position(2), 10, 55];
	hLeg(2).Position = [sum(hSub(2,2).Position([1,3]))+19, hSub(2).Position(2)+10, hLeg(2).Position(3),40];
%  	hYyTxt.Position(1) = hSub(1,2).Position(3)+40;
% 	hYyTxt.Position(2) = 0.5*hSub(1,2).Position(4);
%  	hYyTxt.FontSize = hYLab(1).FontSize;