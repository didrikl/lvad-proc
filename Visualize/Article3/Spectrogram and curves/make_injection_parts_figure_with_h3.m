function [hFig, rpmMapA, rpmMapB, T]  = make_injection_parts_figure_with_h3(...
		Data, seq, varA, varB, partSpecNo, rpmMapA, rpmMapB, T)
	
	eventsToClip = {
		'Injection, saline'
		'Hands on'
		'Echo on'
		'Fibrillation'
		};

	Data = Data.(seq);
	Notes = Data.Notes;
	Config = Data.Config;
	seqID = Config.seq;
	fs = Config.fs;
	movStdWin = Config.movStdWin;
	parts = Config.partSpec(partSpecNo,:);

	Colors_IV2
	colMapName = Config.rpmOrderMapColorMapName;
	colMap = scientificColormaps.(colMapName);
	mapScaleA = [-65, -36];
	mapScaleB = Config.rpmOrderMapScale;
	woShadeCol = [0.00,0.30,0.00];
	woShadeCol = [0 0 0];
	injShadeCol= [0.59,0.16,0.16];
	injShadeCol= [0 0 0];
	echoShadeCol = [0 0 0];
	
	figWidth = 715;
	figHeight =  641;
	pWidthMax = 620;
	yLims = [-2.75,1.75];
	yLim_map = [0.75, 4.25];
	h3YLims = [-5,72];%Config.h3YLims;
	if nargin<6		
		T = extract_from_data(Data, parts, eventsToClip);
		T = add_norms_and_filtered_vars_as_needed({varA;varB}, T, Config);
		T = add_del_diff_from_bl(T, varA, 1, fs, movStdWin);
		rpmMapA = make_rpm_order_map_per_part(T, varA, Config);
		rpmMapB = make_rpm_order_map_per_part(T, varB, Config);	
	end

	t = rpmMapA.time;
	order = rpmMapA.order;
	magsA = rpmMapA.([varA,'_mags']);
	mapA = rpmMapA.([varA,'_map']);
	magsB = rpmMapB.([varB,'_mags']);
	mapB = rpmMapB.([varB,'_map']);

	[T, segs] = add_seg_info_and_dur(T, Notes, fs);	
	[harmA, harmAvgA] = calc_harmonic_salience_per_seg(magsA, t, segs);
	[harmB, harmAvgB] = calc_harmonic_salience_per_seg(magsB, t, segs);
	
	tit = make_figure_title(T, segs, seqID, parts, varA, varB, mapScaleA, colMapName);
	[hFig, hSub] = init_panels(tit, figWidth, figHeight);
	
	plot_map(hSub(3), mapScaleA, colMap, t, order, mapA, yLim_map);
	plot_map(hSub(4), mapScaleB, colMap, t, order, mapB, yLim_map);
	plot_h3(hSub(5), t, harmA(:,3), harmB(:,3), harmAvgA(:,3), harmAvgB(:,3), h3YLims);
	plot_flow_and_plvad(hSub(2), t, T, yLims, segs);
	
   	add_shades(hSub(1), segs, segs.all.isWashout, woShadeCol, 0.35, [.25,0.75]);
	%add_shades(hSub(1), segs, segs.all.isInjection & segs.all.isTransitional, injShadeCol, 0.35, [0.15,.75])
 	add_shades(hSub(1), segs, segs.all.isInjection & segs.all.isTransitional, injShadeCol, 0.7, [.25,0.75]);
 	%add_shades(hSub(1), segs, segs.all.isSteadyState, [1 1 1], 1, [.25,0.75]);
 	add_shades(hSub(1), segs, segs.all.isEcho, echoShadeCol, 0.35, [.25,0.75]);
 	hLine = add_panel_separation_lines(hFig);
	hSub = adjust_axes(hSub, segs, t);
	add_xlines_and_grid(hSub, segs);
	[hYLab, hLeg, hCol, hTxt] = add_annotations(hFig, hSub, segs);
	adjust_positions(T, hSub, hYLab, hLeg, hCol, hTxt, hLine, pWidthMax);

function [hFig, hSub] = init_panels(title, figWidth, figHeight)
	
	hFig = figure(...
		'Name',title, ...
		'Position',[100,100,figWidth,figHeight], ...
		'Color',[.95 .95 .95], ...
		...'Color',[1 1 1], ...
		'InvertHardCopy','Off', ....
		'PaperUnits','centimeters', ...
		'PaperSize',[19,19*(figHeight/figWidth)+0.1] );
	
	hSub(1) = subplot(6, 1, 1);
	hSub(2) = subplot(6, 1, 2);
	hSub(3) = subplot(6, 1, 3);
	hSub(4) = subplot(6, 1, 4);
	hSub(5) = subplot(6, 1, 5);
	hSub(6) = subplot(6, 1, 6);
	set(hSub,...
		'FontSize',8.25, ...
		'FontName','Arial', ...
		'LineWidth',1.05, ...
		'TickDir','out', ...
		'TickLength',[.006 .006], ...
		'Units','points', ...
		'Nextplot','add' );
	
	hSub(1).YAxis.Visible = 'off';
	hSub(6).YAxis.Visible = 'off';
	hSub(6).XAxis.FontSize = 7.75;
	
	hSub(2).XAxis.Visible = 'off';
	hSub(3).XAxis.Visible = 'off';
	hSub(4).XAxis.Visible = 'off';
	hSub(5).XAxis.Visible = 'off';
	
	hSub(3).Layer = 'top';
	hSub(4).Layer = 'top';
	
	ylim(hSub(1), [0 1]);
	yticks(hSub(1), []);
	xticks(hSub(1), []);
	
	linkaxes(hSub,'x')
	
function plot_map(hAx, colRange, colMap, t, order, map, yLim)
	
	imagesc(hAx, t, order, map);

	colormap(hAx, colMap);
	caxis(hAx, colRange);

	set(hAx,'ydir','normal');
	yticks(hAx, 0:1:max(order));
	hAx.YLim = yLim;
	xlim(hAx, t([1,end]))

function h = plot_h3(hAx, t, h3A, h3B, h3AAvg, h3BAvg, yLims)
	
	h3BColor = [0.76,0.0,0.2];
	h3AColor = [0.2,0.2,0.2];
	
 	h(1) = plot(hAx, t, movmedian(h3A,20), '-', ...
 		'LineWidth',0.5, ...
   		'Color',[h3AColor,.45], ...
		'HandleVisibility','off');
	plot(hAx, t, h3AAvg, '-', ...
		'LineWidth',1.5, ...
		'Color',[h3AColor,.5], ...
		'HandleVisibility','off' ...
		);
	h(2) = plot(hAx, t, h3AAvg, ':', ...
		'LineWidth',1.5, ...
		'Color',[h3AColor,1]);

 	h(3) = plot(hAx, t, movmedian(h3B,20), '-', ...
 		'LineWidth',0.5, ...
   		'Color',[h3BColor,.45], ...
		'HandleVisibility','off');
	plot(hAx, t, h3BAvg, '-', ...
		'LineWidth',1.5, ...
		'Color',[h3BColor,.5], ...
		'HandleVisibility','off' ...
		);
	h(4) = plot(hAx, t, h3BAvg, ':', ...
		'LineWidth',1.5, ...
		'Color',[h3BColor,1] ...
		);
	
	ylim(hAx, yLims);
	hAx.YAxis.Color = [0.15 0.15 0.15];

 	patch(hAx, 'XData',[t(1),t(end),t(end),t(1)], 'YData',[-5,-5,3.8,3.8],...
 		'FaceAlpha',0.16,...
 		'EdgeColor','none',...
 		'HandleVisibility','off');

function h = plot_flow_and_plvad(hAx, t, T, yLims, segs)
	
	plvadColor = [0.87,0.50,0.13];
	flowColor = [.3 .3 .3];
	flowColor = [0.56,0.67,0.74];

	for i=1:height(segs.main)
		inds = t>=segs.main.StartDur(i) & t<segs.main.EndDur(i);
		if segs.main.isWashout(i), T.P_LVAD_delDiff(inds) = nan; end
 		if segs.main.isTransitional(i), T.P_LVAD_delDiff(inds) = nan; end
	end
	
  	h(2) = plot(hAx, T.dur,T.Q_delDiff,...
    		'LineWidth',.25,...
   		'Color',[flowColor,0.9]);
    
	plot(hAx, T.dur,T.P_LVAD_delDiff, '-',...
		'LineWidth',1.5,...
		'Color',[plvadColor,0.6],...
		'HandleVisibility','off');
	plot(hAx, T.dur,T.Q_LVAD_delDiff, '-',...
		'LineWidth',1.5,...
		'Color',[0 0 0,0.6],...
		'HandleVisibility','off');
	h(3) = plot(hAx, T.dur,T.P_LVAD_delDiff, ':',...
	 		'LineWidth',1.5,...
	 		'Color',plvadColor);
	
	hAx.Clipping = 'off';
	ylim(hAx, yLims);
	xlim([0,max(T.dur)])
	hAx.YAxis.Color = [.15 .15 .15];
	
function [hLeg, hCol] = add_legend_and_colorbar(hSub)
	
	[hLeg(1), hIcons1] = legend(hSub(2), {'flow\rm','\itP\rm_{LVAD}'});
	[hLeg(2), hIcons2] = legend(hSub(5), {'PH','DL'});
	
	legPosX = 0.50;
	legIconWidth = 0.27;
	legIconGap = 0.07;
 	hIcons1(1).Position(1) = legPosX+legIconWidth+legIconGap*0.5;
	hIcons1(2).Position(1) = legPosX+legIconWidth+legIconGap*0.5;
	hIcons1(3).XData = [legPosX, legPosX+legIconWidth*0.9];
  	hIcons1(4).XData = [legPosX, legPosX+legIconWidth*0.9];
  	hIcons1(5).XData = [legPosX, legPosX+legIconWidth*0.9];
  	hIcons1(6).XData = [legPosX, legPosX+legIconWidth*0.9];
 	hIcons2(1).Position(1) = legPosX+legIconWidth+legIconGap;
	hIcons2(2).Position(1) = legPosX+legIconWidth+legIconGap;
	hIcons2(3).XData = [legPosX, legPosX+legIconWidth];
  	hIcons2(4).XData = [legPosX, legPosX+legIconWidth];
  	hIcons2(5).XData = [legPosX, legPosX+legIconWidth];
  	hIcons2(6).XData = [legPosX, legPosX+legIconWidth];
 	
	set(hLeg,...
		"AutoUpdate","off", ...
		"Box","off", ...
		'Units','pixels' ...
		);

	hCol(1) = colorbar(hSub(3),...
		'Units','pixels',...
		'Box','off');
	hCol(1).Label.String = '(dB)';
	hCol(1).Label.String = '(dB)';
	hCol(1).Label.Rotation = 0;
	hCol(2) = colorbar(hSub(4),...
		'Units','pixels',...
		'Box','off');
	hCol(2).Label.String = '(dB)';
	hCol(2).Label.Rotation = 0;
	
function adjust_positions(T, hSub, hYLab, hLeg, hCol, hTxt, hLine, pWidthMax)
	pWidth = min(500*T.dur(end)/(30*60), pWidthMax);
	pStartX = 37.5;
	pStartY = 19.5;
	pHeight1 = 12.5;
	pHeight2 = 110;
	pHeight3 = 170;
	pHeight4 = 170;
	pHeight5 = 120;
	pHeight6 = 1;
	gap = 8;
	set(hSub, 'Units','pixels');
	set(hSub(1), 'Color','none')
	hSub(1).Position(4) = pHeight1;
	hSub(2).Position(4) = pHeight2;
	hSub(3).Position(4) = pHeight3;
	hSub(4).Position(4) = pHeight4;
	hSub(5).Position(4) = pHeight5;
	hSub(6).Position(4) = pHeight6;
	
	hSub(1).Position(3) = pWidth;
	hSub(2).Position(3) = pWidth;
	hSub(3).Position(3) = pWidth;
	hSub(4).Position(3) = pWidth;
	hSub(5).Position(3) = pWidth;
	hSub(6).Position(3) = pWidth;
	
	hSub(1).Position(1) = pStartX;
	hSub(2).Position(1) = pStartX;
	hSub(3).Position(1) = pStartX;
	hSub(4).Position(1) = pStartX;
	hSub(5).Position(1) = pStartX;
	hSub(6).Position(1) = pStartX;
	
	hSub(6).Position(2) = pStartY+0*gap;
	hSub(5).Position(2) = pStartY+pHeight6+1*gap;
	hSub(4).Position(2) = pStartY+pHeight6+pHeight5+2*gap;
	hSub(3).Position(2) = pStartY+pHeight6+pHeight5+pHeight4+3*gap;
	hSub(2).Position(2) = pStartY+pHeight6+pHeight5+pHeight4+pHeight3+4*gap;
	hSub(1).Position(2) = pStartY+pHeight6+pHeight5+pHeight4+pHeight3+pHeight2+5*gap;
	
	hYLab(1).Position(1) = -20;
	hYLab(2).Position(1) = -20;
	hYLab(3).Position(1) = -20;
	hYLab(4).Position(1) = -19;
	
    hLeg(1).Position(1) = hLeg(1).Position(1)+55;
	hLeg(2).Position(1) = hLeg(2).Position(1)+55;
	hLeg(1).Position(2) = hSub(2).Position(2);
	hLeg(2).Position(2) = hSub(5).Position(2);

	hCol(1).Position = [pWidth+pStartX+14, hCol(1).Position(2), 5.5, 35];
	hCol(2).Position = [pWidth+pStartX+14, hCol(2).Position(2), 5.5, 35];
	hCol(1).Label.Position = [2.65,-24,0];
	hCol(2).Label.Position = [2.65,-43.5,0];

	hTxt(1).Position([1,2]) = [-35,hSub(2).Position(4)];
	hTxt(2).Position([1,2]) = [-35,hSub(3).Position(4)];
	hTxt(3).Position([1,2]) = [-35,hSub(4).Position(4)];
	hTxt(4).Position([1,2]) = [-35,hSub(5).Position(4)];

	hLine(1).Position(2) = sum(hSub(3).Position([2,4]))+0.5*gap;
	hLine(2).Position(2) = sum(hSub(4).Position([2,4]))+0.5*gap;
	hLine(3).Position(2) = sum(hSub(5).Position([2,4]))+0.5*gap;

function tit = make_figure_title(T, segs, seqID, partSpec, varA, varB, colScale, colMap)
	rpms = unique(T.pumpSpeed(segs.all.startInd),'stable');
	
	if not(isempty(partSpec{1}))
		parts = [partSpec{1}(1),partSpec{2}];
	else
		parts = partSpec{2};
	end	
	parts = strjoin(string(parts),',');
	rpm = strjoin(string(rpms),',');
	colScale = mat2str(colScale);
	tit = sprintf('%s - Part [%s] - %s - [%s] RPM - %s and %s - %s %s', ...
		seqID, parts, partSpec{3}, rpm, varA, varB, colMap, colScale);

function add_segment_annotation(hAx, segs, whichSegs, labStr, labRot, color)
	if nargin<5, labRot = 0; end
	if nargin<6, color = [0 0 0]; end

	if labRot==0
		horAlign = 'center';
		vertAlign = 'top';
	elseif labRot==90 
		horAlign = 'right'; 
		vertAlign = 'middle';
	else
		horAlign = 'center'; 
		vertAlign = 'middle';
	end
	
	yLims = ylim(hAx);
	durs = segs.all.startDur(whichSegs);
		
	for i=1:numel(durs)
		x = segs.main.MidDur(find(segs.main.StartDur==durs(i),1,'first'));
		y = 1*yLims(2);
		if not(isempty(x))
			text(hAx, x, y, labStr, ...
				'Color',color,...
				'HorizontalAlignment',horAlign,...
				'VerticalAlignment',vertAlign,...
				'FontName','Arial',...
				'FontSize',8,...
				'Rotation',labRot)
		end
	end

function [hYLab, hLeg, hCol, hTxt] = add_annotations(hFig, hSub, segs)
	add_steady_state_annotations(hSub(1), segs);
	hYLab = add_axis_labels(hSub);
	[hLeg, hCol] = add_legend_and_colorbar(hSub);
	hTxt = add_panel_numerals(hSub);
	add_subtitles;
	%add_rectangle_around_3harm(hFig);
	add_arrows_at_thrid_harmonic(hFig);
	
function add_steady_state_annotations(hAx, segs)
	
	% segment baselines
	add_segment_annotation(hAx, segs, segs.all.isBaseline, 'BL', 0)

	% injections
	embVols = unique(segs.all.embVol);
	whichSegs = find(ismember(segs.all.embVol, embVols) & ...
		segs.all.isSteadyState & segs.all.isInjection);
	for i=1:numel(whichSegs)
		add_segment_annotation(hAx, segs, whichSegs(i), "#"+i, 0)
	end

	whichSegs = find(segs.all.isWashout);
	add_segment_annotation(hAx, segs, whichSegs, "", 0)

	whichSegs = find(segs.all.isEcho);
	add_segment_annotation(hAx, segs, whichSegs, '', 0)

function hSub = add_xlines_and_grid(hSub, segs)

%  	hSub(2).YGrid = 'on';
%  	hSub(2).GridLineStyle = ':';
%  	hSub(2).GridAlpha = .11;
%  	hSub(5).YGrid = 'on';
%  	hSub(5).GridLineStyle = ':';
%  	hSub(5).GridAlpha = .11;
	
 	xLabs = xticklabels(hSub(6));
 	xt = xticks(hSub(6));
	xticks(hSub(6), xt(not(cellfun(@isempty,xLabs))))
 	xticklabels(hSub(6), xLabs(not(cellfun(@isempty,xLabs))))
 	
	for i=1:height(segs.main)
		if contains(string(segs.main.event(i)),'Injection, embolus')
			xline(hSub(1), segs.main.StartDur(i), 'Color',[.15 .15 .15], 'LineWidth', 0.7, 'Alpha',1)
  			xline(hSub(2), segs.main.StartDur(i), 'Color',[.15 .15 .15], 'LineWidth', 0.7, 'Alpha',0.55, 'LineStyle','-')
			xline(hSub(5), segs.main.StartDur(i), 'Color',[.15 .15 .15], 'LineWidth', 0.7, 'Alpha',0.55, 'LineStyle','-')
		end
		if contains(string(segs.main.event(i)),'Washout')
			xline(hSub(1), segs.main.StartDur(i), 'Color',[.15 .15 .15], 'LineWidth', 0.7, 'Alpha',1);
			xline(hSub(2), segs.main.StartDur(i), 'Color',[.4 .4 .4], 'LineWidth', 0.7, 'Alpha',0.8, 'LineStyle',':');
			xline(hSub(5), segs.main.StartDur(i), 'Color',[.4 .4 .4], 'LineWidth', 0.7, 'Alpha',0.8, 'LineStyle',':');
		end
	end

	remTicks = [];
	for i=1:height(segs.main)-1
		if not(contains(string(segs.main.event(i+1)),'Injection, embolus'))
			remTicks = [remTicks,i];
		end
	end
	hSub(6).XTick(remTicks) = [];
	hSub(6).XTickLabel(remTicks) = [];
	xticks(hSub(1),[])
	
function hSub = adjust_axes(hSub, segs, t)
	make_xticks_and_time_str(hSub, segs, 0);
	xlim([min(t),max(t)])
	hSub(3).YTickLabel = {'0','1','2','\bf3\rm','4'}';
	hSub(4).YTickLabel = {'0','1','2','\bf3\rm','4'}';
	yticks(hSub(2), -2:1:1)
	
function [T, segs] = add_seg_info_and_dur(T, Notes, fs)
	noteVarsNeeded = {
		'part'               
		'intervType'         
		'event'              
		'Q_LVAD'             
		'P_LVAD'      
		'balDiam_xRay'
		'balLev_xRay'         
		'arealObstr_xRay_pst'
		'balDiam'
		'balLev'         
		'pumpSpeed'          
		'QRedTarget_pst'
		'embVol'
		'embType'
		};
	T = join_notes(T, Notes, noteVarsNeeded);
	T.dur = linspace(0,1/fs*height(T),height(T))';
	segs = get_segment_info(T, 'dur');

function add_rectangle_around_3harm(hFig)
	
	annotation(hFig, 'rectangle',[0.03046641 0.4015625 0.88931 0.02344],...
		'Color',[0.76 0 0.2],...
		'LineWidth',1,...
		'FaceAlpha',1);

function hArr = add_arrows_at_thrid_harmonic(hFig)
	
	hArr(1) = annotation(hFig,'textarrow',[0.95610 0.92634],[0.69388 0.69388],...
		'Color',[.15 .15 .15],...
		'TextColor',[0 0 0], ...
		'String',' \itS\rm_{3h}');

	hArr(2) = annotation(hFig,'textarrow',[0.95610 0.92634],[0.41069 0.41069],...
		'Color',[0.7607843 0 0.2],...
		'TextColor',[0 0 0], ...
		'String',' \itS\rm_{3h}');

	set(hArr, ...
		'Units','pixels', ...
		'LineWidth',1.25,...
		'VerticalAlignment','middle',...
		'HorizontalAlignment','left',...
		'HeadWidth',6.5,...
		'HeadStyle','plain',...
		'HeadLength',6.5,...
		'FontSize',8.25)

function hLine = add_panel_separation_lines(hFig)	
	hLine(1) = annotation(hFig,'line',[0 1],[0.74408 0.74408]);
	hLine(2) = annotation(hFig,'line',[0 1],[0.4685 0.4685]);
	hLine(3) = annotation(hFig,'line',[0 1],[0.19374 0.19374]);
	set(hLine, 'Units','pixels', 'Color', [0.15,0.15,0.15])

function [hYLab, hXLab] = add_axis_labels(hSub)
	hYLab(1) = ylabel(hSub(2),{'change'});
	hYLab(2) = ylabel(hSub(3),{'harmonic'});
	hYLab(3) = ylabel(hSub(4),{'harmonic'});
	hYLab(4) = ylabel(hSub(5),{'\itS\rm_{3h}'});
	hXLab = xlabel(hSub(6), '(mm:ss)', 'Units','pixels');
	hXLab.Position = [635,-1,0];
	set([hYLab, hXLab], 'Units','pixels', 'FontSize',8.25, 'FontName','arial')
	
function hSubTit = add_subtitles
	hSubTit(1) = annotation(gcf,'textbox',...
		[0.9415 0.742119021875 0.0522388059701493 0.0359223300970873],...
		'String','PH');
	
	hSubTit(2) = annotation(gcf,'textbox',...
		[0.9415 0.4647592028125 0.0522388059701493 0.0359223300970873],...
		'String','DL');
	set(hSubTit, ...
		'FontWeight','bold',...
		'FontSize',8.5,...
		'FontName','arial',...
		'EdgeColor','none',...
		'FitBoxToText','on',...
		'Units','pixels');

function hTxt = add_panel_numerals(hSub)
	hTxt(1) = text(hSub(2), 0, 0, 'A');	
	hTxt(2) = text(hSub(3), 0, 0, 'B');
	hTxt(3) = text(hSub(4), 0, 0, 'C');
	hTxt(4) = text(hSub(5), 0, 0, 'D');
	set(hTxt, ...
		'FontSize',11.5, ...
		'FontName','Arial', ...
		'VerticalAlignment','top', ...
		'units','pixels');
