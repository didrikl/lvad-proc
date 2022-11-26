function hFig = make_all_injection_figures_ver2(T, Notes, map, var, Config, partSpec)

	mapScale = Config.rpmOrderMapScale;
	fs = Config.fs;
	colorMapName = Config.rpmOrderMapColorMapName;
	seqID = [Config.experimentID,'_',Config.seq];
	
	spec = get_plot_specs;
	Colors_IV2
	colorMap = scientificColormaps.(colorMapName);
	shadeColor = [.76 .76 .76];
	echoShadeColor = [.87 .87 .87];
	
	figWidth = 1800;
	figHeight =  900;
	pWidthMax = 1300;
	h3YLims = [-5,72];
	yLims = [-75,75];
	yLim_map = [0.75, 4.25];
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
	mags = map.([var,'_mags']);
	map = map.([var,'_map']);
	segs = get_segment_info(T, 'dur'); 	
	rpms = unique(T.pumpSpeed(segs.all.startInd),'stable');
	[h3, h3Avg] = calc_harmonic_salience_per_seg(mags, t, segs);

	tit = make_figure_title(rpms, seqID, partSpec, var, mapScale, colorMapName);
	[hFig, hSub] = init_panels(spec, tit, figWidth, figHeight);

	plot_rpm_order_map(hSub(2), mapScale, colorMap, t, order, map, yLim_map);
	plot_h3(hSub(3), t, h3(:,3), h3Avg(:,3), h3YLims);
	plot_curves(hSub(1), t, T, yLims, segs);
	
  	add_shades(hSub(1), segs, segs.all.isEcho, echoShadeColor, 0.20, [50, 76])
  	add_shades(hSub(1), segs, segs.all.isTransitional, shadeColor, 0.30, [50, 76])

	make_xticks_and_time_str(hSub, segs);
	add_xlines_and_grid(hSub, segs);
	add_transition_annotations(hSub(1), T, segs);
 	add_steady_state_annotations(hSub(1), segs);
	hYLab(1) = ylabel(hSub(2),{'harmonic order'}, 'Units','pixels');
	hYLab(2) = ylabel(hSub(3),{'\itH\rm_3 (dB)'}, 'Units','pixels');
	hSub(2).YTickLabel = {'0','1','2','\bf3\rm','4'}';
	[hLeg, hCol] = add_legend_and_colorbar(hSub);
	hSub(2).Layer = 'top';
	linkaxes(hSub,'x')
	xlim([min(t),max(t)])
	set(hSub,'TickDir','both','TickLength',[.0025 .0025])
	adjust_positions(T, hSub, hYLab, hLeg, hCol, pWidthMax);
	hSub(1).XAxis.Visible = 'off';
	
function plot_rpm_order_map(hAx, colRange, colMap, t, order, map, yLim)
	
	imagesc(hAx, t, order, map);

	colormap(hAx, colMap);
	caxis(hAx, colRange);

	set(hAx,'ydir','normal');
	yticks(hAx, 0:1:max(order));
	hAx.YLim = yLim;
	xlim(hAx, t([1,end]))

function plot_h3(hAx, t, h3, h3Avg, yLims)
	h3Color = [0.76,0.0,0.2];

	plot(hAx, t, movmedian(h3,20), '-',...
		'LineWidth',0.3,...
  		'Color',[h3Color,.5]);
	plot(hAx, t, h3Avg, '-',...
		'LineWidth',2.5,...
		'Color',[h3Color,.2],...
		'HandleVisibility','off');
	plot(hAx, t, h3Avg, '-.',...
		'LineWidth',2.2,...
		'Color',[h3Color,.85]);
	
    ylim(hAx, yLims)
	hAx.YAxis.Color = [0.15 0.15 0.15];

	patch(hAx, 'XData',[t(1) t(end) t(end) t(1)],'YData',[-5, -5, 4.75 4.75],...
		'FaceAlpha',0.15,...
		'EdgeColor','none',...
		'HandleVisibility','off');


function h = plot_curves(hAx, t, T, yLims, segs)
	
	flowColor = [0.07,0.39,0.50];
	plvadColor = [0.87,0.50,0.13];

	for i=1:height(segs.main)
		inds = t>=segs.main.StartDur(i) & t<segs.main.EndDur(i);
		if segs.main.isWashout(i), T.P_LVAD_relDiff(inds) = nan; end
 		if segs.main.isTransitional(i), T.P_LVAD_relDiff(inds) = nan; end
	end
	
	h(2) = plot(hAx, T.dur,T.Q_relDiff,...
  		'LineWidth',.35,...
 		'Color',[flowColor,0.75]);
    
	plot(hAx, T.dur,T.P_LVAD_relDiff, '-',...
		'LineWidth',2.5,...
		'Color',[plvadColor,0.2],...
		'HandleVisibility','off');
	h(3) = plot(hAx, T.dur,T.P_LVAD_relDiff, ':',...
	 		'LineWidth',2.2,...
	 		'Color',plvadColor);
	
	hAx.Clipping = 'off';
	ylim(hAx, yLims);
	xlim([0,max(T.dur)])
	hAx.YAxis.Color = [.15 .15 .15];

	adjust_yticks(hAx);	
	
function [hLeg, hCol] = add_legend_and_colorbar(hSub)
	
hLeg(1) = legend(hSub(1), {'\itQ\rm','\itP\rm_{LVAD}'});
hLeg(2) = legend(hSub(3), {'median','mov. median'});
set(hLeg,"AutoUpdate","off", "Box","off", 'Units','pixels');
	
	hCol = colorbar(hSub(2),...
		'Units','pixels',...
		'Box','off');
	hCol.Label.String = '(dB)';
	
function adjust_positions(T, hSub, hYLab, hLeg, hCol,pWidthMax)
	pWidth = min(1000*T.dur(end)/(30*60), pWidthMax);
	pStartX = 50;
	pStartY = 49;
	pHeightMap = 270;
	pHeightCurves = 270;
	gap = 0;
	set(hSub,'Units','pixels');
	hSub(1).Position(4) = pHeightCurves;
	hSub(2).Position(4) = pHeightMap;
	hSub(3).Position(4) = pHeightCurves;
	hSub(1).Position(3) = pWidth;
	hSub(2).Position(3) = pWidth;
	hSub(3).Position(3) = pWidth;
	hSub(1).Position(1) = pStartX;
	hSub(2).Position(1) = pStartX;
	hSub(3).Position(1) = pStartX;
	hSub(3).Position(2) = pStartY;
	hSub(2).Position(2) = pStartY+hSub(3).Position(4)+gap;
	hSub(1).Position(2) = pStartY+hSub(3).Position(4)+gap+hSub(2).Position(4)+gap;
	
	hYLab(1).Position(1) = -35;
	hLeg(1).Position = [pWidth+pStartX+20, hSub(1).Position(2), hLeg(1).Position(3:4)];
	hLeg(2).Position = [pWidth+pStartX+20, hSub(3).Position(2), hLeg(2).Position(3:4)];
	hCol.Position = [pWidth+pStartX+50, hCol.Position(2), 10, 75];
	
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
	whichSegs = find(whichSegs);
	durs = segs.all.startDur(whichSegs);
		
	for i=1:numel(durs)
		x = segs.main.MidDur(find(segs.main.StartDur==durs(i),1,'first'));
		% 			y = yLims(2)*0.99;
		y = yLims(2);
		if not(isempty(x))
			text(hAx, x, y, labStr, ...
				'Color',color,...
				'HorizontalAlignment',horAlign,...
				'VerticalAlignment',vertAlign,...
				'FontName','Arial Narrow',...
				'FontSize',8.5,...
				'Rotation',labRot)
		end
	end

function add_steady_state_annotations(hAx, segs)
	
	% RPM levels and segment baselines
	speeds = unique(segs.all.pumpSpeed);
	speeds = speeds(not(ismember(speeds,0)));
	if numel(speeds)>1
		for i=1:numel(speeds)
			
			whichSegs = segs.all.pumpSpeed==speeds(i) & segs.all.isNominal & not(ismember(lower(string(segs.all.event)),'hands on'));
			lab = ['\bf',num2str(speeds(i)),'\rm'];
			add_segment_annotation(hAx, segs, whichSegs, lab, 0)

			whichSegs = segs.all.pumpSpeed==speeds(i) & segs.all.isBaseline;
			lab = {['\bf',num2str(speeds(i)),'\rm'],'\bfBL\rm'};
			add_segment_annotation(hAx, segs, whichSegs, lab, 0)

		end
	else
		whichSegs = segs.all.isBaseline;
		lab = '\bfbaseline\rm';
		add_segment_annotation(hAx, segs, whichSegs, lab, 0)
	end

	% injections
	embVols = unique(segs.all.embVol);
	embVols = embVols(not(ismember(embVols,'-')));
	for i=1:numel(embVols)
		whichSegs = segs.all.embVol==embVols(i) & segs.all.isSteadyState;
		lab = "\bf"+string(embVols(i))+" ml";
		add_segment_annotation(hAx, segs, whichSegs, lab, 0)
	end
	embType = unique(segs.all.embType);
	embType = embType(not(ismember(embType,'-')));
	for i=1:numel(embType)
		whichSegs = segs.all.embType==embType(i) & segs.all.isSteadyState;
		lab = "\newline"+lower(string(embType(i)));
		add_segment_annotation(hAx, segs, whichSegs, lab, 0)
	end

	add_segment_annotation(hAx, segs, segs.all.isEcho, 'echo', 0)
	
function add_transition_annotations(hAx, T, segs)
	events = unique(segs.all.event);
	for i=1:numel(events)
		if ismember(events(i),'-'), continue; end
		isEvent = ismember(T.event(segs.all.startInd),events(i));
		isEvent = isEvent & not(segs.all.isEcho);
		event = lower(string(events(i)));
		event = strrep(event,'injection, embolus','injection');
		event = strrep(event,'injection, saline','saline');
		add_segment_annotation(hAx, segs, isEvent, event, 90, [.15 .15 .15])
	end

function adjust_yticks(hAx)
	yticks(hAx,-80:20:50)
	ytickformat(hAx, 'percentage')

function hSub = add_xlines_and_grid(hSub, segs)
	hSub(1).YGrid = 'on';
	hSub(1).GridLineStyle = '-';
	hSub(1).GridAlpha = .15;
	hSub(3).YGrid = 'on';
	hSub(3).GridLineStyle = '-';
	hSub(3).GridAlpha = .15;
	
 	xLabs = xticklabels(hSub(3));
 	xt = xticks(hSub(3));
 	xticks(hSub(3), xt(not(cellfun(@isempty,xLabs))))
 	xticklabels(hSub(3), xLabs(not(cellfun(@isempty,xLabs))))
 	xticks(hSub(1), xt(not(cellfun(@isempty,xLabs))))

	hSub(1).XGrid = 'on';
	hSub(1).GridLineStyle = '-';
	hSub(1).GridAlpha = .11;
	hSub(3).XGrid = 'on';
	hSub(3).GridLineStyle = '-';
	hSub(3).GridAlpha = .11;

	for i=1:height(segs.main)
		if contains(string(segs.main.event(i)),'Injection, embolus')
			xline(hSub(3), segs.main.StartDur(i), 'Color',[.15 .15 .15])
			xline(hSub(2), segs.main.StartDur(i), 'Color',[.15 .15 .15])
			xline(hSub(1), segs.main.StartDur(i), 'Color',[.15 .15 .15])
		end
	end

function [hFig, hSub] = init_panels(spec, tit, figWidth, figHeight)
	hFig = figure(spec.fig{:},...
		'Name',tit,...
		'Position',[10,20,figWidth,figHeight]);
	hSub(2) = subplot(3,1,2,spec.subPlt{:},'FontSize',10, 'FontName','Arial', 'LineWidth',0.74);
	hSub(1) = subplot(3,1,1,spec.subPlt{:},'FontSize',10, 'FontName','Arial', 'LineWidth',0.74);
	hSub(3) = subplot(3,1,3,spec.subPlt{:},'FontSize',10, 'FontName','Arial', 'LineWidth',0.74);
	hSub(3).Clipping = 'off';
	hSub(3).XAxis.FontSize = 8.5;
