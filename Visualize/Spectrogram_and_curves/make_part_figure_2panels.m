function hFig = make_part_figure_2panels(T, Notes, map, var, Config, partSpec)

	mapScale = Config.rpmOrderMapScale;
	fs = Config.fs;
	colorMapName = Config.rpmOrderMapColorMapName;
	seqID = Config.seq;
				
	spec = get_plot_specs;
	Colors_IV2
	colorMap = scientificColormaps.(colorMapName);
	shadeColor = [.76 .76 .76];
	echoShadeColor = [.87 .87 .87];
	washoutColor = [0 0 0];
	injectionColor = [0 0 0];

	figWidth = 1300;
	figHeight =  822;
	pWidthMax = 1000;
	yLims = Config.curveYLims;
	yLim_map = Config.mapYLims;
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

	t = map.time;
	order = map.order;
	map = map.([var,'_map']);
	segs = get_segment_info(T, 'dur'); 	
	rpms = unique(T.pumpSpeed(segs.all.startInd),'stable');
	
	tit = make_figure_title(rpms, seqID, partSpec, var, mapScale, colorMapName);
	[hFig, hSub] = init_panels(spec, tit, figWidth, figHeight);
	plot_rpm_order_map(hSub(1), mapScale, colorMap, t, order, map, yLim_map);
	hPlt = plot_curves(hSub(2), T, var, yLims);
	add_shades(hSub(2), segs, segs.all.isEcho, echoShadeColor, 0.20, yLims)
	add_shades(hSub(2), segs, segs.all.isTransitional, shadeColor, 0.30, yLims)
	add_shades(hSub(2), segs, segs.all.isWashout, washoutColor, 0.25, [59 63])
	add_shades(hSub(2), segs, segs.all.isTransitional & segs.all.isInjection, injectionColor, 0.25, [59 63])
	
	add_linked_map_hz_yyaxis(hSub(1), '', rpms);
 	
	make_xticks_and_time_str(hSub, segs);
	add_xlines_and_grid(hSub, segs);
	add_transition_annotations(hSub, T, segs);
 	add_steady_state_annotations(hSub, segs);
	hYLab(1) = ylabel(hSub(1),{'harmonic order'}, 'Units','pixels');
	[hLeg, hCol] = add_legend_and_colorbar(hSub, hPlt, T, var);
	hYyTxt = add_text_as_yylabel(hSub);
	add_seg_info_box(hFig, tit);
	
	linkaxes(hSub,'x')
	set(hSub,'TickDir','both','TickLength',[.0025 .0025])
	adjust_yticks(hSub);
	adjust_positions(T, hSub, hYLab, hYyTxt, hLeg, hCol, pWidthMax);
		
function plot_rpm_order_map(hAx, colRange, colMap, t, order, map, yLim)
	
	imagesc(hAx, t, order, map);

	colormap(hAx, colMap);
	caxis(hAx, colRange);

	set(hAx,'ydir','normal');
	yticks(hAx, 0:1:max(order));
	hAx.YLim = yLim;
	xlim(hAx, t([1,end]))

function h = plot_curves(hAx, T, accVar, yLims)
	
	stdColor = [0.76,0.0,0.15];
	flowColor = [0.03,0.26,0.34];%Colors.Fig.Cats.Speeds4(1,:);
	plvadColor = [0.9961,0.4961,0];%Colors.Fig.Cats.Speeds4(2,:);
	qlvadColor = [0.00,0.78,0];%Colors.Fig.Cats.Speeds4(4,:);

	h(2) = plot(hAx, T.dur,T.Q_relDiff,...
 		'LineWidth',.5,'Color',flowColor);
  	h(1) = plot(hAx, T.dur,-T.([accVar,'_movStd_relDiff']),...
 		'-','LineWidth',.5,'Color',[stdColor,.75]);
  	
	h(3) = plot(hAx, T.dur,T.P_LVAD_relDiff,...
 		'-','LineWidth',2,'Color',[plvadColor,1]);
	h(4) = plot(hAx, T.dur,T.Q_LVAD_relDiff,...
 		':','LineWidth',2,'Color',[qlvadColor,1]);
	
	hAx.Clipping = 'off';
	ylim(yLims);
	xlim([0,max(T.dur)])

function [hLeg, hCol] = add_legend_and_colorbar(hSub, hPlt, T, accVar)
	bl_inds = T.intervType=='Baseline';
	blAccStd = std(T.(accVar)(bl_inds))*1000;
	blQ = mean(T.Q(bl_inds));
	blP_LVAD = mean(T.P_LVAD(bl_inds));
	blQ_LVAD = mean(T.Q_LVAD(bl_inds));
	legStr = {
		['-SD_{10s},  ',sprintf('%1.1f ',blAccStd),'\itg\rm^2/kHz']
		['\itQ\rm,          ',sprintf('%1.1f L/min',blQ)]
		['\itP\rm_{LVAD},   ',sprintf('%1.1f W',blP_LVAD)]
		['\itQ\rm_{LVAD},   ',sprintf('%1.1f L/min',blQ_LVAD)]
		};
	hLeg = legend(hPlt,legStr,...
		"AutoUpdate","off",...
		"Box","off",...
		'Units','pixels');
	hLeg.Title.String = 'deviation, baseline';
	hCol = colorbar(hSub(1),...
		'Units','pixels',...
		'Box','off');
	hCol.Label.String = '(dB)';
	
function adjust_positions(T, hSub, hYLab, hYyTxt, hLeg, hCol,pWidthMax)
	pWidth = min(1000*T.dur(end)/(30*60), pWidthMax);
	pStartX = 125;
	pStartY = 49;
	gap = 22;
	set(hSub,'Units','pixels');
	hSub(1).Position(4) = 350;
	hSub(2).Position(4) = 400;
	hSub(1).Position(3) = pWidth;
	hSub(2).Position(3) = pWidth;
	hSub(1).Position(1) = pStartX;
	hSub(2).Position(1) = pStartX;
	hSub(1).Position(2) = pStartY+hSub(2).Position(4)+gap;
	hSub(2).Position(2) = pStartY;
	hYLab(1).Position(1) = -55;
	hLeg.Position = [pWidth+pStartX+8, hSub(2).Position(2), hLeg.Position(3:4)];
	hCol.Position = [pWidth+pStartX+90, hCol.Position(2), 10, 75];
	hYyTxt.Position(1) = sum(hSub(2).Position([1,3])-20);
	
function tit = make_figure_title(rpms, seqID, partSpec, accVar, mapColScale, colorMapName)
	
	if not(isempty(partSpec{1}))
		parts = [partSpec{1}(1),partSpec{2}];
	else
		parts = partSpec{2};
	end	
	parts = strjoin(string(parts),',');
	rpm = strjoin(string(rpms),',');
	mapColScale = mat2str(mapColScale);
	tit = sprintf('%s - Part [%s] - %s - [%s] RPM - %s - %s %s', ...
		seqID, parts, partSpec{3}, rpm, accVar, colorMapName, mapColScale);

function add_seg_info_box(hFig, tit)
    tit = strsplit(tit,' - ');
	str{1} = ['\bf',strrep(tit{3},'_','\_'),'\rm'];
	%str{2} = [strrep(tit{1},'_','\_'),', ',tit{2}];
	str{2} = strrep(strrep(tit{4},'[',''),']','');
	str{3} = strrep(tit{5},'_','\_');
	annotation(hFig,'textbox',...
		[0.0025 0.6175 0.13 0.38],...
		...[0 0.615 0.13 0.38],...
		'String',str,...
		'VerticalAlignment','top',...
		'EdgeColor',[.15 .15 .15],...
		'BackgroundColor',[1 1 1],...
		'FaceAlpha',0.35,...
		'FitBoxToText','on',...
		'FontName','Roboto Condensed Medium',...Arial Narrow',...
		'FontSize',7.5);

function add_segment_annotation(hAx, segs, whichSegs, labStr, labRot, color)
	if nargin<5, labRot = 0; end
	if nargin<6, color = [0 0 0]; end

	if labRot==0
		horAlign = 'center';
		vertAlign = 'top';%'middle';%'top';
	elseif labRot==90 
		horAlign = 'right'; 
		vertAlign = 'top';
	else
		horAlign = 'center'; 
		vertAlign = 'middle';
	end
	
	yLims = ylim(hAx);
	whichSegs = find(whichSegs);
	durs = segs.all.startDur(whichSegs);
		
	for i=1:numel(durs)
		if labRot==90
			x = segs.all.startDur(whichSegs(i));
			y = yLims(2)*0.985;
		else	
			x = segs.main.MidDur(find(segs.main.StartDur==durs(i),1,'first'));
			y = yLims(2)*0.985;
		end
		if not(isempty(x))
			text(hAx, x, y, labStr, ...
				'Color',color,...
				'HorizontalAlignment',horAlign,...
				'VerticalAlignment',vertAlign,...
				'FontName','Arial Narrow',...
				'FontSize',9,...
				'Rotation',labRot)
		end
	end

function add_steady_state_annotations(hSub, segs)
	
	% RPM levels and segment baselines
	speeds = unique(segs.all.pumpSpeed);
	speeds = speeds(not(ismember(speeds,0)));
	if numel(speeds)>1
		for i=1:numel(speeds)
			
			whichSegs = segs.all.pumpSpeed==speeds(i) & segs.all.isNominal & not(ismember(lower(string(segs.all.event)),'hands on'));
			lab = ['\bf',num2str(speeds(i)),'\rm'];
			add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)

			whichSegs = segs.all.pumpSpeed==speeds(i) & segs.all.isBaseline;
			lab = {['\bf',num2str(speeds(i)),'\rm'],'\bfbaseline\rm'};
			add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)

		end
	else
		whichSegs = segs.all.isBaseline;
		lab = '\bfbaseline\rm';
		add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)
	end

	% balloon levels
	try
		levs = unique(segs.all.balLev_xRay);
		for i=1:numel(levs)
			whichSegs = segs.all.balLev_xRay==levs(i) & segs.all.isBalloon & segs.all.isSteadyState;
			lab = "\bf"+"level "+string(levs(i));
			add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)
		end
	catch
		levs = unique(segs.all.balLev);
		for i=1:numel(levs)
			whichSegs = segs.all.balLev==levs(i) & segs.all.isBalloon & segs.all.isSteadyState;
			lab = "\bf"+"level "+string(levs(i));
			add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)
		end
	end
	
	% clamp levels
	levs = unique(segs.all.QRedTarget_pst);
	for i=1:numel(levs)
		whichSegs = segs.all.QRedTarget_pst==levs(i) & segs.all.isSteadyState & segs.all.isClamp;
		lab = "\bf"+string(levs(i))+"%";
		add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)
	end
	
	% injections
	embVols = unique(segs.all.embVol);
	embVols = embVols(not(ismember(embVols,'-')));
	for i=1:numel(embVols)
		whichSegs = segs.all.embVol==embVols(i) & segs.all.isSteadyState;
		lab = "\bf"+string(embVols(i))+" ml";
		add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)
	end
	embType = unique(segs.all.embType);
	embType = embType(not(ismember(embType,'-')));
	for i=1:numel(embType)
		whichSegs = segs.all.embType==embType(i) & segs.all.isSteadyState;
		lab = "\newline"+lower(string(embType(i)));
		add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)
	end

	add_segment_annotation(hSub(2), segs, segs.all.isEcho, 'echo', 0)
	
function add_transition_annotations(hSub, T, segs)
	events = unique(segs.all.event);
	for i=1:numel(events)
		if ismember(events(i),'-'), continue; end
		isEvent = ismember(T.event(segs.all.startInd),events(i));
		isEvent = isEvent & not(segs.all.isEcho);
		add_segment_annotation(hSub(2), segs, isEvent, lower(string(events(i))), 90, [.15 .15 .15])
	end

function hYyTxt = add_text_as_yylabel(hSub)
	hYyTxt = text(hSub(1),max(xlim(hSub(1))),mean(ylim(hSub(1))),'Hz',Rotation=90);
	hYyTxt.Units = 'pixels'; 

function adjust_yticks(hSub)
	yticks(hSub(2),-80:20:40)
	ytickformat(hSub(2), 'percentage')

function hSub = add_xlines_and_grid(hSub, segs)
	%xline(hSub(1), segs.main.EndDur(1:end-1), 'Alpha',0.7, 'LineWidth',.6, 'LineStyle','--','Color',[1 1 1]);
	%xline(hSub(2), segs.main.EndDur(1:end-1), 'Alpha',1.0, 'LineWidth',.75, 'LineStyle','--','Color',[1 1 1]);
	
	hSub(2).YGrid = 'on';
	hSub(2).GridLineStyle = '-';
	hSub(2).GridAlpha = .1;

function [hFig, hSub] = init_panels(spec, tit, figWidth, figHeight)
	hFig = figure(spec.fig{:},...
		'Name',tit,...
		'Position',[250,150,figWidth,figHeight]);
	hSub(1) = subplot(2,1,1,spec.subPlt{:},'FontSize',11,'LineWidth',0.74);
	hSub(2) = subplot(2,1,2,spec.subPlt{:},'FontSize',11,'LineWidth',0.74);
