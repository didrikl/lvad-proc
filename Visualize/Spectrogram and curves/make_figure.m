function hFig = make_figure(T, Notes, map, accVar, seqID, partSpec, fs)
	
	spec = get_plot_specs;
	Colors_IV2
	colorMapName = 'batlowW';
	colorMap = scientificColormaps.(colorMapName);
	%colorMap = parula;
	mapScale = [-65, -36];
	figWidth = 1300;
	figHeight =  800;
	yLims = [-100,55];
	yLim_map = [0.75, 5.95];
	shadeColor = [.9 .9 .9];
	echoShadeColor = [.9 .9 .9];
	noteVarsNeeded = {
		'part'               
		'intervType'         
		'event'              
		'Q_LVAD'             
		'P_LVAD'      
		'balDiam_xRay'
		'balLev_xRay'         
		'arealObstr_xRay_pst'
		'embVol'             
		'embType'            
		'pumpSpeed'          
		'QRedTarget_pst'
		};
	T = join_notes(T, Notes, noteVarsNeeded);
	T.dur = linspace(0,1/fs*height(T),height(T))';

	%TODO:
	% - Make Q spikes detections and indicate on the plots

	segs = get_segment_info(T);
 	
	rpms = unique(T.pumpSpeed(segs.all.startInd),'stable');
	tit = make_figure_title(rpms, seqID, partSpec, accVar, mapScale, colorMapName);
	hFig = figure(spec.fig{:},...
		'Name',tit,...
		'Position',[250,150,figWidth,figHeight]);
	hSub(1) = subplot(2,1,1,spec.subPlt{:},'FontSize',11,'LineWidth',0.74);
	hSub(2) = subplot(2,1,2,spec.subPlt{:},'FontSize',11,'LineWidth',0.74);
	
	hPlt = plot_curves(hSub(2), T, accVar, yLims);
	add_shades(hSub(2), segs, segs.all.isEcho, echoShadeColor, 0.20, [1.05*yLims(1) 70])
	add_shades(hSub(2), segs, segs.all.isTransitional, shadeColor, 0.4, [1.05*yLims(1) 70])
	
	plot_rpm_order_map(hSub(1), mapScale, colorMap, map.time, map.order, map.map, yLim_map);
	add_linked_map_hz_yyaxis(hSub(1), '', rpms);
 	add_transition_annotations(hSub, T, segs);
 	add_steady_state_annotations(hSub, segs);
	hYLab(1) = ylabel(hSub(1),{'harmonic order'}, 'Units','pixels');
	[hLeg, hCol] = add_legend_and_colorbar(hSub, hPlt, T, accVar);
	hYyTxt = add_text_as_yylabel(hSub);
	add_seg_info_box(hFig, tit);
	
	linkaxes(hSub,'x')
	set(hSub,'TickDir','out','TickLength',[.006 .006])
	adjust_yticks(hSub);
	make_xticks_and_time_str(hSub, segs);
	add_xlines_and_grid(hSub, segs);
	adjust_positions(T, hSub, hYLab, hYyTxt, hLeg, hCol);
	
function h = plot_curves(hAx, T, accVar, yLims, Colors)
	
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

function plot_rpm_order_map(hAx, colRange, colMap, t, order, map, yLim)
	
	imagesc(hAx, t, order, map);

	colormap(hAx, colMap)
	caxis(hAx, colRange);

	set(hAx,'ydir','normal');
	yticks(hAx, 0:1:max(order));
	hAx.YLim = yLim;
	xlim(hAx, t([1,end]))
	

function xLabels = make_xticks_and_time_str(hSub, segs)
	xt = [0;segs.all.endDur];
	
	xticks(hSub(2),xt);
	xLabels = hSub(2).XTick;
	xLabels = seconds(xLabels);
	xLabels.Format = 'mm:ss';
	xLabels = string(xLabels);
	xLabels(not(ismember(xt,segs.main.EndDur))) = '';
	xticklabels(hSub(2), xLabels);
	xtickangle(hSub(2), 45);
	xticklabels(hSub(1),{})
	xt = xticks(hSub(2));
	xticks(hSub(1),xt);

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
	
function adjust_positions(T, hSub, hYLab, hYyTxt, hLeg, hCol)
	pWidth = min(1000*T.dur(end)/(30*60),1000);
	pStartX = 130;
	pStartY = 49;
	gap = 21;
	set(hSub,'Units','pixels');
	hSub(1).Position(4) = 330;
	hSub(2).Position(4) = 400;
	hSub(1).Position(3) = pWidth;
	hSub(2).Position(3) = pWidth;
	hSub(1).Position(1) = pStartX;
	hSub(2).Position(1) = pStartX;
	hSub(1).Position(2) = pStartY+hSub(2).Position(4)+gap;
	hSub(2).Position(2) = pStartY;
	hYLab(1).Position(1) = -55;
	hLeg.Position = [pWidth+pStartX+10, hSub(2).Position(2), hLeg.Position(3:4)]; 
	hCol.Position = [pWidth+pStartX+110, hCol.Position(2), 10, 75];
	hYyTxt.Position(1) = sum(hSub(1).Position([1,3]));

function tit = make_figure_title(rpms, seqID, partSpec, accVar, mapColScale, colorMapName)
	
	if not(isempty(partSpec{1}))
		parts = [partSpec{1}(1),partSpec{2}];
	else
		parts = partSpec{2};
	end	
	parts =  mat2str(str2double(string(parts)));
	rpm = strjoin(string(rpms),',');
	mapColScale = mat2str(mapColScale);
	tit = sprintf('%s - Part %s - %s - [%s] RPM - %s - %s %s', ...
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
		'FontName','Arial Narrow',...'Roboto Condensed Medium',...Arial Narrow',...
		'FontSize',9.5);

function add_segment_annotation(hAx, segs, whichSegs, labStr, labRot, color)
	if nargin<5, labRot = 0; end
	if nargin<6, color = [0 0 0]; end

	if labRot==0
		horAlign = 'center';
		vertAlign = 'top';%'middle';%'top';
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
		midDur = segs.main.MidDur(...
			find(segs.main.StartDur==durs(i),1,'first'));
		if not(isempty(midDur))
			text(hAx, midDur, yLims(2)*0.98, labStr, ...
				'Color',color,...
				'HorizontalAlignment',horAlign,...
				'VerticalAlignment',vertAlign,...
				'FontName','Arial Narrow',...
				'FontSize',9,...
				'Rotation',labRot)
		end
	end

function add_steady_state_annotations(hSub, segs)
	
	speeds = unique(segs.all.pumpSpeed);
	if numel(speeds)>1
		for i=1:numel(speeds)
			lab = [num2str(speeds(i)),''];

			whichSegs = segs.all.pumpSpeed==speeds(i) & segs.all.isNominal;
			add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)

			whichSegs = segs.all.pumpSpeed==speeds(i) & segs.all.isBaseline;
			lab = {lab,'\bfbaseline\rm'};
			add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)

		end
	else
		whichSegs = segs.all.isBaseline;
		lab = '\bfbaseline\rm';
		add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)
	end


	levs = unique(segs.all.balLev_xRay);
	for i=1:numel(levs)
		lab = 'level '+string(levs(i));
		
		whichSegs = segs.all.balLev_xRay==levs(i) & segs.all.isBalloon & segs.all.isSteadyState;
		add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)
	end

	levs = unique(segs.all.QRedTarget_pst);
	for i=1:numel(levs)
		whichSegs = segs.all.QRedTarget_pst==levs(i) & segs.all.isSteadyState & segs.all.isAfterload;
		lab = string(levs(i))+'%';
		add_segment_annotation(hSub(2), segs, whichSegs, lab, 0)
	end

	add_segment_annotation(hSub(2), segs, segs.all.isEcho, 'echo', 0)
	
function add_transition_annotations(hSub, T, segs)
	events = unique(segs.all.event);
	for i=1:numel(events)
		if ismember(events(i),'-'), continue; end
		isEvent = ismember(T.event(segs.all.startInd),events(i));
		isEvent = isEvent & not(segs.all.isEcho);
		add_segment_annotation(hSub(2), segs, isEvent, lower(string(events(i))), 90, [.5 .5 .5])
	end

function hYyTxt = add_text_as_yylabel(hSub)
	hYyTxt = text(hSub(1),max(xlim(hSub(1))),mean(ylim(hSub(1))),'Hz',Rotation=90);
	hYyTxt.Units = 'pixels'; 

function adjust_yticks(hSub)
	yticks(hSub(2),-80:20:40)
	ytickformat(hSub(2), 'percentage')

function hSub = add_xlines_and_grid(hSub, segs)
	xline(hSub(1), segs.main.EndDur(1:end-1), 'Alpha',0.7, 'LineWidth',.6, 'LineStyle','--','Color',[1 1 1]);
	%xline(hSub(2), segs.main.EndDur(1:end-1), 'Alpha',1.0, 'LineWidth',.75, 'LineStyle','--','Color',[1 1 1]);
	
	hSub(2).YGrid = 'on';
	hSub(2).GridLineStyle = '-';
	hSub(2).GridAlpha = .1;
