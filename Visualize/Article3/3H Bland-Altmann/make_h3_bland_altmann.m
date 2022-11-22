function [hFig, rpmMapA, rpmMapB, T]  = make_h3_bland_altmann(...
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
	parts = Config.partSpec(partSpecNo,:);

	figWidth = 715;
	figHeight =  300;
	yLims = [-10,10];
	if nargin<6		
		T = extract_from_data(Data, parts, eventsToClip);
		T = add_norms_and_filtered_vars_as_needed({varA;varB}, T, Config);
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
	
	tit = make_figure_title(T, segs, seqID, parts, varA, varB);
	[hFig, hAx] = init_figure(tit, figWidth, figHeight);
	dH3 = harmA(:,3)-harmB(:,3);
	
	blSeg = segs.main(segs.main.isBaseline,:);
	blInds = t>=blSeg.StartDur & t<=blSeg.EndDur;
	avg3H = 0.5*(harmA(:,3)+harmB(:,3));
	avg3H_std = std(avg3H);
	%scatter(hAx, avgH3, dH3, 12, 'MarkerFaceColor',[0.64,0.08,0.18],'MarkerFaceAlpha',0.5,'MarkerEdgeColor',[0.93,0.69,0.13],'MarkerEdgeAlpha',0.9)
	%scatter(hAx, avgH3(not(blInds)), dH3(not(blInds)), 9, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.5)
	scatter(hAx, avg3H(not(blInds)), dH3(not(blInds)), 8, 'MarkerEdgeAlpha',1)
	hold on
	scatter(hAx, avg3H(blInds), dH3(blInds), 8, 'filled', 'MarkerFaceAlpha',0.3,'MarkerEdgeColor','flat','MarkerEdgeAlpha',0.65)
	%scatter(hAx, avgH3(blInds), dH3(blInds), 9, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.6)
	%scatter(hAx, avgH3(blInds), dH3(blInds), 9, 'filled','MarkerFaceColor','flat','MarkerFaceAlpha',0.7)
% 	yline(hAx, 2*avg3H_std,'LineWidth',1,'LineStyle','-','Label','2 SD','LabelVerticalAlignment','top','LabelHorizontalAlignment','right')
% 	yline(hAx, -2*avg3H_std,'LineWidth',1,'LineStyle','-','Label','-2 SD','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right')
	xlabel('\itS\rm_{3H} mean')
	ylabel('\itS\rm_{3H} diff.')
	hLeg = legend(hAx, {'Injection.','baseline'},'AutoUpdate','on','Box','off','Location','southeastoutside','Units','pixels');
% 	[hYLab, hLeg, hCol, hTxt] = add_annotations(hFig, hSub, segs);
% 	adjust_positions(T, hSub, hYLab, hLeg, hCol, hTxt, hLine, pWidthMax);

    hAx.Position = [33,33,430,185];
	hLeg.Position = [630 45 60 25];
function [hFig, hAx] = init_figure(title, figWidth, figHeight)
	
	hFig = figure(...
		'Name',title, ...
		'Position',[100,100,figWidth,figHeight], ...
		'Color',[.95 .95 .95], ...
		...'Color',[1 1 1], ...
		'InvertHardCopy','Off', ....
		'PaperUnits','centimeters', ...
		'PaperSize',[19,19*(figHeight/figWidth)+0.1] );
	
	hAx = axes(hFig);
	set(hAx,...
		'FontSize',8.25, ...
		'FontName','Arial', ...
		'LineWidth',1.05, ...
		'TickDir','out', ...
		'TickLength',[.006 .006], ...
		'Units','points', ...
		'Nextplot','add' );

function tit = make_figure_title(T, segs, seqID, partSpec, varA, varB)
	rpms = unique(T.pumpSpeed(segs.all.startInd),'stable');
	
	if not(isempty(partSpec{1}))
		parts = [partSpec{1}(1),partSpec{2}];
	else
		parts = partSpec{2};
	end	
	parts = strjoin(string(parts),',');
	rpm = strjoin(string(rpms),',');
	tit = sprintf('%s - Part [%s] - %s - [%s] RPM - %s and %s', ...
		seqID, parts, partSpec{3}, rpm, varA, varB);

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
