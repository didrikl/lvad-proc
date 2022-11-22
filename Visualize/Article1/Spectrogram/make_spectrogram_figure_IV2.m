function make_spectrogram_figure_IV2(S, supTit, var, rpm, fs, IDs1, IDs2)
	
	legStr = {'\itQ\rm','\itP\rm_{LVAD}','NHA\it_y\rm'};

	durLim = 120;
	res = 0.010;
	overlapPst = 95;
	yLim_map = [0.5,4.07];

	figWidth = 1200;
	figHeight =  785;
	panelHeight = 250;
	panelWidthFactor = 0.64;
	xGap = 22;
	yGap = 7;
	xStart = 68;
	yStart = 38;
	
	Colors_IV2
	
	spec = get_plot_specs;
	cMap = scientificColormaps.batlowW; % colormap(scientificColormaps.lisbon)
	cRange = [-62,-40]; % for Seq13
	
	IDs1 = make_segment_id_for_given_rpm(rpm, IDs1);
	IDs2 = make_segment_id_for_given_rpm(rpm, IDs2);

	[T1, segStarts1, segEnds1] = make_plot_data(IDs1, S, var, fs, durLim);
	[T2, segStarts2, segEnds2] = make_plot_data(IDs2, S, var, fs, durLim);
	[map1,order1,~,mapTime1] = make_rpm_order_map(T1,var,fs,'pumpSpeed',res,overlapPst);
	[map2,order2,~,mapTime2] = make_rpm_order_map(T2,var,fs,'pumpSpeed',res,overlapPst);

	figure(spec.fig{:},...
		'Name',sprintf('%s - %s',supTit,var),...
		'Position',[10,40,figWidth,figHeight]);
	
	hSub(1,1) = subplot(2,2,1,spec.subPlt{:});
	plot_rpm_order_map(hSub(1,1), cRange, cMap, mapTime1, order1, map1, yLim_map, segEnds1);
	
	hSub(1,2) = subplot(2,2,2,spec.subPlt{:});
	plot_rpm_order_map(hSub(1,2),cRange, cMap, mapTime2, order2, map2, yLim_map, segEnds2);
	hSub(2,1) = subplot(2,2,3,spec.subPlt{:});
	plot_curves(T1);
	hSub(2,2) = subplot(2,2,4,spec.subPlt{:});
	hPlt = plot_curves(T2);
	
	% Add annotations
	hSubTit(1) = subtitle(hSub(1,1),{'Control interventions,','outflow clamp'});
	hSubTit(2) = subtitle(hSub(1,2),{'Balloon interventions,','areal inflow obstructions'});
	hNum(1) = text(hSub(1,1),15,3.85,'A');
	hNum(2) = text(hSub(1,2),15,3.85,'B');
	add_xlines(hSub, segStarts1, segStarts2, spec);
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

function segIDs = make_segment_id_for_given_rpm(rpm, segIDs)
	rpm_id = num2str(find(ismember([2200,2500,2800,3100],rpm)));
	segIDs = replaceBetween(segIDs,2,2,rpm_id);

function hSub = position_panels(hSub, xStart, yStart, segEnds1, segEnds2, widthFactor, height, xGap, yGap)
	width1 = segEnds1(end)*widthFactor;
	xPos = xStart+width1+xGap;
	yPos = yStart+height+yGap;
	width2 = segEnds2(end)*widthFactor;
	set(hSub(1,1),'Position',[xStart,yPos,width1,height])
	set(hSub(1,2),'Position',[xPos,yPos,width2,height])
	set(hSub(2,1),'Position',[xStart,yStart,width1,height])
	set(hSub(2,2),'Position',[xPos,yStart,width2,height])

function h_colBar = add_colorbar(hSub, spec)
	h_colBar = colorbar(hSub(1,2),spec.colorBar{:});
	h_colBar.Label.String = {'(dB)'};

function adjust_axes_limits_and_ticks(hSub)
	xticks(hSub(2,1),hSub(1,1).XTick([1,2,end]))
	xlim(hSub(1,1).XLim)
	xticks(hSub(1,1).XTick)
	xlim(hSub(1,2).XLim)
	xticks(hSub(1,1).XTick)
	set(hSub(2,:),'YLim',[0,7],'YTick',0:2:8);

function adjust_annotation_positions(...
		hLeg, hNum, hSubTit, hYLab1, hColBar, hSub, hXLab)
	hLeg.Position(1) = hLeg.Position(1)+18;
	hLeg.Position(2) = hLeg.Position(2)-3;
	hNum(1,1).Position(2) = hSubTit(1,1).Position(2)+10;
	hNum(1,2).Position(2) = hSubTit(1,2).Position(2)+10;
	hYLab1(1).Position(1) = hYLab1(1).Position(1)-5;
	hYLab1(1).Position(2) = hYLab1(1).Position(2)+3;
	hYLab1(2).Position(2) = hYLab1(2).Position(2)+3;
	hColBar.Position = [838,hSub(1,2).Position(2)-2,11,45];
	hXLab.Position(1) = 349;
	hXLab.Position(2) = -15;

function adjust_formatting(hSub, spec, hYLab1, hSubTit, hXLab, hNum)
	format_axes(hSub,spec);
	set(hYLab1,spec.yLab{:})
	set(hSubTit,spec.subTit{:},'FontSize',13)
	set(hXLab,spec.xLab{:})
	set(hNum,spec.numeral{:})

function add_xlines(hSub, segStarts1, segStarts2, spec)
	xline(hSub(1,1),segStarts1(1),'Label','baseline',spec.xline{:});
	xline(hSub(1,1),segStarts1(2),'Label','20%-80% flow reductions',spec.xline{:});
	xline(hSub(1,2),segStarts2(1),'Label','baseline',spec.xline{:});
	xline(hSub(1,2),segStarts2(2),'Label','27%',spec.xline{:});
	xline(hSub(1,2),segStarts2(3),'Label','45%',spec.xline{:});
	xline(hSub(1,2),segStarts2(4),'Label','75%',spec.xline{:});

function [hYLab, hSub] = add_linked_map_hz_yyaxis(hSub, yyLab, rpm, order)
	orderTicks = hSub.YTick;
	yyaxis(hSub,'right')
	hSub.YAxis(2).Color = hSub.YAxis(1).Color;
	linkprop(hSub.YAxis, 'Limits');
	yticks(0:1:max(order));
	set(hSub,'YTickLabel',strsplit(num2str(orderTicks*(rpm/60),'%2.0f ')));
	hYLab = ylabel(hSub,yyLab);
