function hFig = make_part_figure_2panels_with_nha(T1, T2, map1, map2, Notes, ...
		var, partSpec, fs, yLims1, yLims2, yTicks2, widthFactor)
	
	Colors_IV2
	cMapName = 'batlowW';
	cMap = scientificColormaps.(cMapName);
	cMapScale = [-64, -38];
	spec = get_plot_specs;
	
	figWidth = 715;
	figHeight =  600;
	pHeight1 = 190;
	pHeight2 = 290;

	%   If clipping of transitional segments in between
% 	[map1.map,map1.order,~,map1.mapTime] = make_rpm_order_map(T1, var, fs, 'pumpSpeed', res, overlapPst);
% 	[map2.map,map2.order,~,map2.mapTime] = make_rpm_order_map(T2, var, fs, 'pumpSpeed', res, overlapPst);
	[T1, segs1] = make_dur_and_seg_info(T1, Notes, fs);
	[T2, segs2] = make_dur_and_seg_info(T2, Notes, fs);
	
	[hFig, hSub] = init_panels(spec, figWidth, figHeight);
	make_panels_colum(hSub(:,1), T1, var, map1, fs, segs1, cMapScale, cMap, yLims1, yLims2, yTicks2);
	make_panels_colum(hSub(:,2), T2, var, map2, fs, segs2, cMapScale, cMap, yLims1, yLims2, yTicks2);
	
	rpms = unique(T2.pumpSpeed(segs2.all.startInd),'stable');
 	add_linked_map_hz_yyaxis(hSub(1,2), '', rpms);
 	
 	hYLab(1) = ylabel(hSub(1,1),{'harmonic order'},'Units','pixels');
  	hYLab(2) = ylabel(hSub(2,1),{'deviation from BL'},'Units','pixels');
	hLeg = add_legend_and_colorbar(hSub);
 	hYyTxt = add_text_as_yylabel(hSub(1,2));
	text(hSub(1,1),0,yLims1(2)+diff(yLims1)*.090,'A','FontSize',15,'FontName','Arial')
	text(hSub(1,2),0,yLims1(2)+diff(yLims1)*.090,'B','FontSize',15,'FontName','Arial')

	adjust_panel_positions(T1, T2, hSub, widthFactor, pHeight1, pHeight2);
	adjust_annotation_positions(hSub, hYLab, hYyTxt, hLeg);
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
		'\itP\rm_{LVAD}'
		'NHA'
		};
	hLeg(2) = legend(hSub(end,2),legStr2,...
		"AutoUpdate","off",...
		"Box","off",...
		'Units','pixels');
	
function adjust_panel_positions(T1, T2, hSub, widthFactor, pHeight1, pHeight2)
	
	pWidth1 = min(890*T1.dur(end)/widthFactor,1200);
	pWidth2 = min(890*T2.dur(end)/widthFactor,1200);
	
	pStartX = 65;
	pStartY = 50;
	yGap = 10;
	xGap = 35;
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

function adjust_annotation_positions(hSub, hYLab, hYyTxt, hLeg)

 	hYLab(1).Position(1) = -50;
 	hYLab(2).Position(1) = -50;
 	hLeg(1).Position = [sum(hSub(1,2).Position([1,3]))+45, hLeg(1).Position(2), 10, 55];
	hLeg(2).Position = [sum(hSub(2,2).Position([1,3]))+20, hSub(2).Position(2)+10, hLeg(2).Position(3),40];
 	hYyTxt.Position(1) = hSub(1,2).Position(3)+40;
	hYyTxt.Position(2) = 0.5*hSub(1,2).Position(4);
 	hYyTxt.FontSize = hYLab(1).FontSize;

function h = plot_curves(hAx, hAxNHA, T, segs, fs, yLims, yLimsNHA)
	
	flowColor = [0.03,0.26,0.34,1];%Colors.Fig.Cats.Speeds4(1,:);
	plvadColor = [0.87,0.50,0.13];%[0.9961,0.4961,0];%Colors.Fig.Cats.Speeds4(2,:);
	%qlvadColor = [0.39,0.83,0.07];%[0.00,0.78,0];%Colors.Fig.Cats.Speeds4(4,:);

	h(1) = plot(hAx, T.dur, T.Q_relDiff,...
 		'LineWidth',1,'Color',flowColor);  	
	
	nha_bl = calc_nha_at_baseline(segs, T, fs);
	h(4) = plot_nha(hAxNHA, segs, T, nha_bl, yLimsNHA, fs);
	
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
 	add_transition_annotations(hSub(2), T, segs);
  	add_steady_state_annotations(hSub(2), segs);

function [hFig, hSub] = init_panels(spec, figWidth, figHeight)
	
	hFig = figure(spec.fig{:},...
		'Position',[150,100,figWidth,figHeight],...
		'PaperUnits','centimeters',...
		'PaperSize',[19,30]...
		);
	
	hSub(1,1) = subplot(2,2,1,spec.subPlt{:});
	hSub(1,2) = subplot(2,2,2,spec.subPlt{:});
	hSub(2,1) = subplot(2,2,3,spec.subPlt{:});
	hSub(2,2) = subplot(2,2,4,spec.subPlt{:});
	
	linkaxes([hSub(2,1),hSub(2,2)],'y')
