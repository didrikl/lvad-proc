function make_spectrogram_and_curve_figure_per_ids_G1(...
		S, supTit, var, rpm, fs, IDs1, IDs2)
	legStr = {'\itQ\rm','\itP\rm_{LVAD}','NHA\it_y\rm'};

	durLim = 180;
	res = 0.020;
	overlapPst = 50;
	yLim_map = [0.5,5.07];

	figWidth = 1400;
	figHeight =  800;
	panelHeight = 250;
	panelWidthFactor = 0.5;
	xGap = 22;
	yGap = 7;
	xStart = 68;
	yStart = 38;
	
	Colors_IV2
	spec = get_plot_specs;
	colorMap = scientificColormaps.batlowW; 
	%colorMap = scientificColormaps.lisbon;
	colorRange = [-65,-40]; % for Seq13
	
	[T1, segStarts1, segEnds1] = make_plot_data_G1(IDs1, S, var, fs, durLim);
	[T2, segStarts2, segEnds2] = make_plot_data_G1(IDs2, S, var, fs, durLim);
	[map1,order1,rpm1,mapTime1] = make_rpm_order_map(T1,var,fs,'pumpSpeed',res,overlapPst);
	[map2,order2,rpm2,mapTime2] = make_rpm_order_map(T2,var,fs,'pumpSpeed',res,overlapPst);
% 	T1 = add_order_track(map1, order1, rpm1, mapTime1, T1, [var,'_H3']);
% 	T2 = add_order_track(map2, order2, rpm2, mapTime2, T2, [var,'_H3']);
	
	figure(spec.fig{:},...
		'Name',sprintf('%s - %s',supTit,var),...
		'Position',[150,50,figWidth,figHeight]);
	
	hSub(1,1) = subplot(2,2,1,spec.subPlt{:});
	plot_rpm_order_map(hSub(1,1), colorRange, colorMap, mapTime1, order1, map1, yLim_map, segEnds1);
	
	hSub(1,2) = subplot(2,2,2,spec.subPlt{:});
	plot_rpm_order_map(hSub(1,2),colorRange, colorMap, mapTime2, order2, map2, yLim_map, segEnds2);
	hSub(2,1) = subplot(2,2,3,spec.subPlt{:});
	plot_curves_G1(T1);
	hSub(2,2) = subplot(2,2,4,spec.subPlt{:});
	hPlt = plot_curves_G1(T2);
	
	% Add annotations
	hSubTit(1) = subtitle(hSub(1,1),{'Control interventions,','graft clamp'});
	hSubTit(2) = subtitle(hSub(1,2),{'Balloon interventions,','areal inflow obstructions'});
	hNum(1) = text(hSub(1,1),15,3.85,'A');
	hNum(2) = text(hSub(1,2),15,3.85,'B');
	add_xlines(hSub, segStarts1, segStarts2, spec, T2);
	hLeg = legend(hPlt,legStr,spec.leg{:},'FontSize',15);
	hColBar = add_colorbar(hSub, spec);
	hYLab1(1) = ylabel(hSub(1,1),{'accelerometer signal,','harmonic order'});
	hYLab1(2) = add_linked_map_hz_yyaxis(hSub(1,2), 'frequency (Hz)', rpm, order2);
	hXLab = xlabel('(sec)',spec.xLab{:});
	
	% Adjustments
	adjust_axes_limits_and_ticks(hSub);
	hSub = position_panels(hSub, xStart, yStart, segEnds1, segEnds2, ...
		panelWidthFactor, panelHeight, xGap, yGap);
	adjust_formatting(hSub, spec, hYLab1, hSubTit, hXLab, hNum);
	adjust_annotation_positions(hLeg, hNum, hSubTit, hYLab1, hColBar, hSub, hXLab);

function hSub = position_panels(hSub, xStart, yStart, segEnds1, segEnds2, widthFactor, height, xGap, yGap)
	width1 = segEnds1(end)*widthFactor;
	xPos = xStart+width1+xGap;
	yPos = yStart+height+yGap;
	width2 = segEnds2(end)*widthFactor;
	set(hSub(1,1),'Position',[xStart,yPos,width1,height])
	set(hSub(1,2),'Position',[xPos,yPos,width2,height])
	set(hSub(2,1),'Position',[xStart,yStart,width1,height])
	set(hSub(2,2),'Position',[xPos,yStart,width2,height])

function hColBar = add_colorbar(hSub, spec)
	hColBar = colorbar(hSub(1,2),spec.colorBar{:});
	hColBar.Label.String = {'(dB)'};

function adjust_axes_limits_and_ticks(hSub)
	xticks(hSub(2,1),hSub(1,1).XTick([1,2,end]))
	xlim(hSub(1,1).XLim)
	xticks(hSub(1,1).XTick)
	xlim(hSub(1,2).XLim)
	xticks(hSub(2,2),hSub(1,2).XTick)
	set(hSub(2,:),'YLim',[0,7],'YTick',0:2:8);

function adjust_annotation_positions(...
		hLeg, hNum, hSubTit, hYLab1, hColBar, hSub, hXLab)
	hLeg.Position(1) = hLeg.Position(1)+150;
	hLeg.Position(2) = hLeg.Position(2)-3;
	hNum(1,1).Position(2) = hSubTit(1,1).Position(2)+10;
	hNum(1,2).Position(2) = hSubTit(1,2).Position(2)+10;
	hYLab1(1).Position(1) = hYLab1(1).Position(1)-5;
	hYLab1(1).Position(2) = hYLab1(1).Position(2)+3;
	hYLab1(2).Position(2) = hYLab1(2).Position(2)+3;
	hColBar.Position = [hLeg.Position(1),hSub(1,2).Position(2)-2,11,45];
	hXLab.Position(1) = 349;
	hXLab.Position(2) = -15;

function adjust_formatting(hSub, spec, hYLab1, hSubTit, hXLab, hNum)
	format_axes(hSub,spec);
	set(hYLab1,spec.yLab{:})
	set(hSubTit,spec.subTit{:},'FontSize',18.5)
	set(hXLab,spec.xLab{:})
	set(hNum,spec.numeral{:})

function add_xlines(hSub, segStarts1, segStarts2, spec, T2)
	xline(hSub(1,1),segStarts1(1),'Label','baseline',spec.xline{:});
	xline(hSub(1,1),segStarts1(2),'Label','25%-75% flow reductions',spec.xline{:});
	xline(hSub(1,2),segStarts2(1),'Label','baseline',spec.xline{:});
	
	for i=2:numel(segStarts2)
		arealObstr = unique(T2.arealObstr_xRay_pst(T2.balLev_xRay==i-1));
		arealObstr = num2str(mean(arealObstr,'omitnan'),2);
		xline(hSub(1,2),segStarts2(i),'Label',[arealObstr,'%'],spec.xline{:});
	end
