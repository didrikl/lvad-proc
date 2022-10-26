function hFig = make_part_figure_2panels_with_nha_G1B(T1, T2, map1, map2, Notes, ...
		var, partSpec, fs, yLims1, yLims2, yTicks2, widthFactor)
	
	Colors_IV2
	cMapName = 'batlowW';
	cMap = scientificColormaps.(cMapName);
	cMapScale = [-85, -55];
	spec = get_plot_specs;
	
	figWidth = 710;
	figHeight =  423;
	pHeight1 = 150;
	pHeight2 = 200;

	[T1, segs1] = make_dur_and_seg_info(T1, Notes, fs);
	[T2, segs2] = make_dur_and_seg_info(T2, Notes, fs);
	
	[hFig, hSub] = init_panels(spec, figWidth, figHeight);
	
	adjust_panel_positions(T1, T2, hSub, widthFactor, pHeight1, pHeight2);
	hYAx = make_offset_axes(hSub(:,1), 12);
	
	make_panels_colum(hSub(:,1), T1, var, map1, fs, segs1, cMapScale, cMap, yLims1, yLims2, yTicks2);
	make_panels_colum(hSub(:,2), T2, var, map2, fs, segs2, cMapScale, cMap, yLims1, yLims2, yTicks2);
	adjust_yticks(hYAx(2), yTicks2);
 	adjust_ax_format(hSub, hYAx);
 	
 	rpms = unique(T2.pumpSpeed(segs2.all.startInd),'stable');
%  	hYYLab = add_linked_map_hz_yyaxis(hSub(1,2), '', rpms);

 	add_annotations(hSub, hYAx, yLims1, segs1, segs2);

	hSub(1,2).YAxis(1).Visible = 'off';
 	hSub(2,2).YAxis(1).Visible = 'off';
	hSub(1,1).XAxis(1).Visible = 'off';
	hSub(1,2).XAxis(1).Visible = 'off';
		
	seqID = get_seq_id(Notes.Properties.UserData.Experiment_Info.ExperimentID);
	hFig.Name = make_figure_title(rpms, seqID, partSpec, var, cMapScale, ...
		cMapName, '2 panels, with NHA');

function hYAx = make_offset_axes(hSub, xGap)
	% Make main axes offset and "actual data axes" invisible

	% Make extra axes to offset
	for i=1:size(hSub,1)
		hYAx(i) = copyobj(hSub(i), gcf); 
		hYAx(i).Position(1) = hYAx(i).Position(1)-xGap;
		set(hYAx(i), 'LineWidth',1, 'box','off', 'Color','none', ...
			'YGrid','off', 'XGrid','off')
		hYAx(i).XAxis.Color = 'none';
		hSub(i).YAxis.Color = 'none';
	end	
	
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

	hPlt = get(hSub(end,2), 'Children');
	hLeg(2) = legend(hPlt([3,1,2]), legStr2,...
		"AutoUpdate","off",...
		"Box","off",...
		'Units','pixels');
	
function adjust_panel_positions(T1, T2, hSub, widthFactor, pHeight1, pHeight2)
	
	pWidth1 = min(920*T1.dur(end)/widthFactor,1200);
	pWidth2 = min(920*T2.dur(end)/widthFactor,1200);
	
	pStartX = 56;
	pStartY = 42;
	yGap = 7;
	xGap = 24;
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

function hPlt = make_panels_colum(hSub, T, var, map, fs, segs, mapScale, colorMap, yLims1, yLims2, yTicks2)
	
	t = map.time;
	order = map.order;
	map = map.([var,'_map']);
	
	plot_rpm_order_map(hSub(1), mapScale, colorMap, t, order, map, yLims1);
	hPlt = plot_curves(hSub(2), hSub(2), T, segs, fs, yLims2, yLims2, var);
	
 	make_xticks_and_time_str(hSub, segs);
 	adjust_yticks(hSub(2), yTicks2);
 	linkaxes(hSub,'x')
	xlim(hSub,[0,max(T.dur)])
	
	add_shades_for_transition_segments(hSub, segs, yLims1, yLims2);
	add_xlines_and_grid(hSub(2));

function hPlt = plot_rpm_order_map(hAx, colRange, colMap, t, order, map, yLim)
	
	hPlt = imagesc(hAx, t, order, map);

	colormap(hAx, colMap)
	caxis(hAx, colRange);

	set(hAx,'ydir','normal');
	yticks(hAx, 0:1:max(order));
	hAx.YLim = yLim;
	xlim(hAx, t([1,end]))

function h = plot_curves(hAx, hAxNHA, T, segs, fs, yLims, yLimsNHA, var)
	
	flowColor = [0.07,0.39,0.50];%[0.03,0.26,0.34,1];
	nhaColor = [0.76,0.0,0.2];
	plvadColor = [0.87,0.50,0.13];
	%qlvadColor = [0.39,0.83,0.07];
	
	h(1) = plot(hAx, T.dur, T.Q_relDiff,...
 		'LineWidth',1, 'Color',flowColor);  	
	
	nha_bl = calc_nha_at_baseline(segs, T, fs, var);
	h(4) = plot_nha(hAxNHA, segs, T, nha_bl, yLimsNHA, fs, 'main', nhaColor, var);
	
    h(2) = plot(hAx, T.dur,T.P_LVAD_relDiff, '-.',...
		'LineWidth',2, 'Color',[plvadColor,1]);
	
	hAx.Clipping = 'off';
	ylim(yLims);
	xlim([0,max(T.dur)])

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

function add_annotations(hSub, hYAx, yLims1, segs1, segs2)
	text(hSub(1,1), 15, yLims1(2)*1.042, 'A', 'FontSize',13, 'FontName','Arial','VerticalAlignment','bottom')
	text(hSub(1,2), 15, yLims1(2)*1.042, 'B', 'FontSize',13, 'FontName','Arial','VerticalAlignment','bottom')
	text(hSub(1,1), 0.5*diff(hSub(1,1).XLim), yLims1(2)*1.054, {'clamp flow reductions'}, 'FontSize',9.5, 'FontName','Arial','FontWeight','normal','VerticalAlignment','bottom','HorizontalAlignment','center');
	text(hSub(1,2), 0.5*diff(hSub(1,2).XLim), yLims1(2)*1.054, {'balloon inflow obstructions'}, 'FontSize',9.5, 'FontName','Arial','FontWeight','normal','VerticalAlignment','bottom','HorizontalAlignment','center');
	
	add_steady_state_annotations(hSub(1,1), segs1, yLims1(2)*0.97, [1 1 1]); %1.09
	add_steady_state_annotations(hSub(1,2), segs2, yLims1(2)*0.97, [1 1 1]);
	
	hXLab = xlabel(hSub(2,2),'(mm:ss)', 'Units','pixels','FontSize',9);
 	hYLab(1) = ylabel(hYAx(1),{'harmonic order'},'Units','pixels');
  	%hYLab(2) = ylabel(hYAx(2),{'deviation from BL'},'Units','pixels');
	
    hLeg = add_legend_and_colorbar(hSub);
%  	hYyTxt = add_text_as_yylabel(hSub(1,2));
	
	hYLab(1).Position(1) = -25;
 	%hYLab(2).Position(2) = -50;
	hXLab.Position = [320,-14,0];
  	hLeg(1).Position = [sum(hSub(1,2).Position([1,3]))+85, hLeg(1).Position(2), 10, 55];
	hLeg(2).Position = [sum(hSub(2,2).Position([1,3]))+19, hSub(2).Position(2)+10, hLeg(2).Position(3),40];
%  	hYyTxt.Position(1) = hSub(1,2).Position(3)+40;
% 	hYyTxt.Position(2) = 0.5*hSub(1,2).Position(4);
%  	hYyTxt.FontSize = hYLab(1).FontSize;

%   annotation(gcf, 'line', [0.415 0.414], [0.9375 0],'Color',[.15 .15 .15]);

function bp_bl = calc_nha_at_baseline(segs, T, fs, var)
	% TODO: Change to use of find baseline function!?!
	blSeg = find(segs.all.isBaseline);
	inds_bl = [];
	for i=1:numel(blSeg)
		inds_bl = [inds_bl,segs.all.startInd(blSeg(i)):segs.all.endInd(blSeg(i))];
	end
	if isempty(inds_bl)
		inds_bl = segs.main.startInd(1):segs.main.endInd(1);
	end
	bp_bl = calc_nha(T, inds_bl, fs, var);

function nha = calc_nha(T, inds, fs, var)
	[pxx,f] = periodogram(detrend(T.(var)(inds)),[],[],fs);
	nha = 1000*bandpower(pxx,f,'psd');

function h = plot_nha(hAx, segs, T, nha_bl, yLims, fs, segType, nhaColor, var)
	
	if nargin<7, segType = 'main'; end
	if nargin<8, nhaColor = [0.76,0.0,0.2]; end
	
	nha = nan(height(T),1);
	for i=1:height(segs.(segType))-1
		if segs.(segType).isTransitional(i), continue; end
		if segs.(segType).isEcho(i), continue; end
		inds = segs.(segType).startInd(i):segs.(segType).startInd(i+1);%segs.main.endInd(i);
		nha(inds) = calc_nha(T, inds, fs, var);	
	end
	if not(segs.(segType).isTransitional(end))
		inds = segs.(segType).startInd(end):height(T);
		nha(inds) = calc_nha(T, inds, fs, var);
	end

	nha_relDiff = calc_diff_from_baseline_avg(nha, nha_bl, 'relative');
	
	h(1) = plot(hAx, T.dur, nha_relDiff,...
 		'-','LineWidth',2.5,'Color',[nhaColor,0.85]);
	
	hAx.Clipping = 'off';
	ylim(yLims);
	xlim([0,max(T.dur)])

	