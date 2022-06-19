function hFig = make_part_figure_3panels_with_nha(T1, T2, map1, map2, Notes, ...
		var, partSpec, fs, yLims1, yLims2, yLims3, yTicks2, yTicks3, widthFactor)
	
	Colors_IV2
	cMapName = 'batlowW';
	cMap = scientificColormaps.(cMapName);
	cMapScale = [-64, -38];
	spec = get_plot_specs;

	figWidth = 800;
	figHeight =  750;
	pHeight1 = 195;
	pHeight23 = 215;

	map1 = map1.([var,'_map']);
	map2 = map2.([var,'_map']);
%   If clipping of transitional segments in between
% 	[map1.map,map1.order,~,map1.mapTime] = make_rpm_order_map(T1, var, fs, 'pumpSpeed', res, overlapPst);
% 	[map2.map,map2.order,~,map2.mapTime] = make_rpm_order_map(T2, var, fs, 'pumpSpeed', res, overlapPst);
	[T1, segs1] = make_dur_and_seg_info(T1, Notes, fs);
	[T2, segs2] = make_dur_and_seg_info(T2, Notes, fs);
	
	[hFig, hSub] = init_panels(spec, figWidth, figHeight);
	make_panels_colum(hSub(:,1), T1, map1, fs, segs1, cMapScale, cMap, yLims1, yLims2, yLims3, yTicks2, yTicks3);
	hPlt = make_panels_colum(hSub(:,2), T2, map2, fs, segs2, cMapScale, cMap, yLims1, yLims2, yLims3, yTicks2, yTicks3);

 	rpms = unique(T2.pumpSpeed(segs2.all.startInd),'stable');
  	add_linked_map_hz_yyaxis(hSub(1,2), '', rpms);
  	
  	hYLab(1) = ylabel(hSub(1,1),{'harmonic order'},'Units','pixels');
  	hYyTxt = add_text_as_yylabel(hSub(1,2));
   	hYLab(2) = ylabel(hSub(2,1),{'deviation from BL average'},'Units','pixels');
  	hLeg = add_legend_and_colorbar(hSub, hPlt);
 	text(hSub(1,1),0,yLims1(2)+diff(yLims1)*.095,'A','FontSize',15,'FontName','Arial')
 	text(hSub(1,2),0,yLims1(2)+diff(yLims1)*.095,'B','FontSize',15,'FontName','Arial')
 
 	adjust_panel_positions(T1, T2, hSub, widthFactor, pHeight1, pHeight23);
 	adjust_annotation_positions(hSub, hYLab, hYyTxt, hLeg);
	make_axes_invisible(hSub);
 
	seqID = get_seq_id(Notes.Properties.UserData.Experiment_Info.ExperimentID);
	hFig.Name = make_figure_title(rpms, seqID, partSpec, var, cMapScale, ...
		cMapName, '2 panels, with NHA');

function hLeg = add_legend_and_colorbar(hSub, hPlt)
	
	hLeg(1) = colorbar(hSub(1,2),...
		'Units','pixels',...
		'Box','off');
	hLeg(1).Label.String = '(dB)';
	
	legStr2 = {
		'\itQ\rm'
		'\itQ\rm_{LVAD}'
		'\itP\rm_{LVAD}'
		};
	hLeg(3) = legend(hSub(3,2),hPlt(1:end-1),legStr2,...
		"AutoUpdate","off",...
		"Box","off",...
		'Units','pixels');
	
	legStr3 = {
		'NHA'
		};
	hLeg(2) = legend(hSub(2,2),hPlt(end),legStr3,...
		"AutoUpdate","off",...
		"Box","off",...
		'Units','pixels');
	
function adjust_panel_positions(T1, T2, hSub, widthFactor, pHeight1, pHeight23)
	pWidth1 = min(1000*T1.dur(end)/widthFactor,1000);
	pWidth2 = min(1000*T2.dur(end)/widthFactor,1000);
	
	pStartX = 67;
	pStartY = 50;
	yGap = 12;
	xGap = 37;
	set(hSub,'Units','pixels');
	
	hSub(1,1).Position(4) = pHeight1;
	hSub(2,1).Position(4) = pHeight23;
	hSub(3,1).Position(4) = pHeight23;
	hSub(1,2).Position(4) = pHeight1;
	hSub(2,2).Position(4) = pHeight23;
	hSub(3,2).Position(4) = pHeight23;
	hSub(1,1).Position(3) = pWidth1;
	hSub(2,1).Position(3) = pWidth1;
	hSub(3,1).Position(3) = pWidth1;
	hSub(1,2).Position(3) = pWidth2;
	hSub(2,2).Position(3) = pWidth2;
	hSub(3,2).Position(3) = pWidth2;
	
	hSub(1,1).Position(1) = pStartX;
	hSub(2,1).Position(1) = pStartX;
 	hSub(3,1).Position(1) = pStartX;
 	hSub(1,2).Position(1) = hSub(1,1).Position(1) + hSub(1,1).Position(3) + xGap;
 	hSub(2,2).Position(1) = hSub(2,1).Position(1) + hSub(2,1).Position(3) + xGap;
 	hSub(3,2).Position(1) = hSub(2,1).Position(1) + hSub(2,1).Position(3) + xGap;
 	
 	hSub(3,1).Position(2) = pStartY;
 	hSub(3,2).Position(2) = pStartY;
	hSub(2,1).Position(2) = pStartY+hSub(3,1).Position(4) + yGap;
 	hSub(2,2).Position(2) = pStartY+hSub(3,2).Position(4) + yGap;
 	hSub(1,1).Position(2) = hSub(2,1).Position(2) + hSub(2,1).Position(4) + yGap;
 	hSub(1,2).Position(2) = hSub(2,2).Position(2) + hSub(2,2).Position(4) + yGap;

function adjust_annotation_positions(hSub, hYLab, hYyTxt, hLeg)

 	hYLab(1).Position(1) = -50;
 	hYLab(2).Position(1) = -50;
 	hYLab(2).Position(2) = -(0.5*hSub(3,1).Position(2))+12;
 	
	hLeg(1).Position = [sum(hSub(1,2).Position([1,3]))+50, hLeg(1).Position(2), 10, 55];
	hLeg(2).Position = [sum(hSub(2,2).Position([1,3]))+25, hSub(2).Position(2)+10, hLeg(2).Position(3),40];
 	hLeg(3).Position = [sum(hSub(3,2).Position([1,3]))+25, hSub(3).Position(2)+10, hLeg(3).Position(3),40];
 	hYyTxt.Position(1) = hSub(1,2).Position(3)+40;
	hYyTxt.Position(2) = 0.5*hSub(1,2).Position(4);
 	hYyTxt.FontSize = hYLab(1).FontSize;

function hPlt = make_panels_colum(hSub, T, map, fs, segs, mapScale, colorMap, yLims1, yLims2, yLimsNHA, yTicks2, yTicksNHA)
	
	plot_rpm_order_map(hSub(1), mapScale, colorMap, map.time, map.order, map.map, yLims1);
	hPlt = plot_curves(hSub(3), hSub(2), T, segs, fs, yLims2, yLimsNHA);
	
 	make_xticks_and_time_str(hSub, segs);
 	adjust_yticks(hSub(3), yTicks2);
 	adjust_yticks(hSub(2), yTicksNHA);
 	adjust_ax_format(hSub);
	xlim(hSub,[0,max(T.dur)])
	
	ylim(hSub(2),yLimsNHA)
	ylim(hSub(3),yLims2)
	
	shadeColor = [1 1 1];
	add_shades(hSub(1), segs, segs.all.isEcho, shadeColor, 0.40, [yLims1(1) yLims1(2)])
	add_shades(hSub(1), segs, segs.all.isTransitional, shadeColor, 0.40, [yLims1(1) yLims1(2)])
	add_shades(hSub(3), segs, segs.all.isEcho, shadeColor, 0.50, [yLims2(1) yLims2(2)])
	add_shades(hSub(3), segs, segs.all.isTransitional, shadeColor, 0.50, [yLims2(1) yLims2(2)])
	add_shades(hSub(2), segs, segs.all.isEcho, shadeColor, 0.50, [yLimsNHA(1) yLimsNHA(2)])
	add_shades(hSub(2), segs, segs.all.isTransitional, shadeColor, 0.50, [yLimsNHA(1) yLimsNHA(2)])
	
	add_xlines_and_grid(hSub(2));
 	add_xlines_and_grid(hSub(3));
 	add_transition_annotations(hSub(2), T, segs);
  	add_steady_state_annotations(hSub(2), segs);

function make_axes_invisible(hSub)
	hSub(1,2).YAxis(1).Visible = 'off';
	hSub(2,2).YAxis(1).Visible = 'off';
	hSub(3,2).YAxis(1).Visible = 'off';
	hSub(2,1).XAxis(1).Visible = 'off';
	hSub(2,2).XAxis(1).Visible = 'off';

function [hFig, hSub] = init_panels(spec, figWidth, figHeight)
	
	hFig = figure(spec.fig{:},...
		'Position',[150,100,figWidth,figHeight]);
	
	hSub(1,1) = subplot(3,2,1,spec.subPlt{:});
	hSub(1,2) = subplot(3,2,2,spec.subPlt{:});
	hSub(2,1) = subplot(3,2,3,spec.subPlt{:});
	hSub(2,2) = subplot(3,2,4,spec.subPlt{:});
	hSub(3,1) = subplot(3,2,5,spec.subPlt{:});
	hSub(3,2) = subplot(3,2,6,spec.subPlt{:});

	linkaxes([hSub(2,1),hSub(2,2)],'y')
	linkaxes([hSub(3,1),hSub(3,2)],'y')
	linkaxes([hSub(1,1),hSub(2,1),hSub(3,1)],'x')
	linkaxes([hSub(1,2),hSub(2,2),hSub(3,2)],'x')