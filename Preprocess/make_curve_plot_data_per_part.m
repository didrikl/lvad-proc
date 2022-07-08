function T_parts = make_curve_plot_data_per_part(Data, accVar, Config)

	movStdWin = Config.movStdWin;
	partSpec = Config.partSpec;
	accVar = cellstr(accVar);
	fs = Config.fs; 
	nParts = size(partSpec,1);
	
	% Extract relevant part, BL and Notes info
	T_parts = cell(nParts,1);
	for i=1:nParts
		T_parts{i} = extract_from_data(Data, partSpec(i,:));
	end

	T_parts = add_norms_and_filtered_variables(accVar, T_parts, Config);
	
	nVars = numel(accVar);
	waitIncr = 1/(nParts*nVars);
	for j=1:nVars	
		for i=1:nParts
			multiWaitbar('Calculate curve','Increment',waitIncr);
			T_parts{i} = add_relative_diff(T_parts{i}, accVar{j}, fs, movStdWin);
		end
	end

function T = add_relative_diff(T, accVar, fs, movStdWin)
	
	bl_inds = get_baseline_inds(T);
	BL = T(bl_inds,:);
	
	MovObj = dsp.MovingStandardDeviation(fs*movStdWin);
	
	acc = T.(accVar);
	acc_bl = BL.(accVar);
	
	% Bandpower and mean power frequency
	% 	[pxx,f] = periodogram(detrend(acc),[],[],fs);
	% 	T.bp(inds) = bandpower(pxx,f,'psd');

	% Calculate standard deviation and moving standard deviations
	BL.([accVar,'_std'])(:) = std(BL.(accVar));
	BL.([accVar,'_movStd']) = calc_moving_acc_statistic(acc_bl, MovObj);
	T.([accVar,'_movStd'])= calc_moving_acc_statistic(acc, MovObj);

	T.Q_relDiff = calc_diff_from_baseline_avg(T.Q,BL.Q,'relative');
	T.P_LVAD_relDiff = calc_diff_from_baseline_avg(T.P_LVAD,BL.P_LVAD,'relative');
	T.Q_LVAD_relDiff = calc_diff_from_baseline_avg(T.Q_LVAD,BL.Q_LVAD,'relative');
	T.([accVar,'_movStd_relDiff']) = calc_diff_from_baseline_avg(T.([accVar,'_movStd']),BL.([accVar,'_std']),'relative');

	% Make curves of discrete values discountinious at bewetween segments
 	break_inds = diff(T.time)>seconds(1);
 	T{break_inds,{'P_LVAD','Q_LVAD','P_LVAD_relDiff','Q_LVAD_relDiff'}} = nan;

function inds = get_baseline_inds(T)
	inds = ismember(T.intervType,{'Baseline','baseline'}) &...
		not(contains(lower(string(T.event)),{'echo'}));
	if nnz(inds)==0
		warning('No baseline denoted in Notes, first steady-state is used instead.')
		segs = get_segment_info(T);
		firstSS = find(ismember(segs.main.intervType,'Steady-state'),1,'first');
		inds = segs.all.startInd(firstSS):segs.all.endInd(firstSS);
	elseif diff(find(inds))>1
		warning('Multiple baseline segments in Notes')
	end

function T = add_norms_and_filtered_variables(accVar, T, Config)
	
	% Derive Eucledian norm of acc signal components
	T = add_norms(accVar, T, 'A');
	T = add_norms(accVar, T, 'B');
	
	% Add notch and highpass filtered acc component signals, as needed
	T = add_filtered_acc_components(T, accVar, 'A', 'x', Config);
	T = add_filtered_acc_components(T, accVar, 'A', 'y', Config);
	T = add_filtered_acc_components(T, accVar, 'A', 'z', Config);
	T = add_filtered_acc_components(T, accVar, 'A', 'norm', Config);
	T = add_filtered_acc_components(T, accVar, 'B', 'x', Config);
	T = add_filtered_acc_components(T, accVar, 'B', 'y', Config);
	T = add_filtered_acc_components(T, accVar, 'B', 'z', Config);
	T = add_filtered_acc_components(T, accVar, 'B', 'norm', Config);

function T = add_filtered_acc_components(T, accVars, accID, compID, Config)

	NW = Config.harmonicNotchFreqWidth;
	cut = Config.harmCut;
	cutShift = Config.harmCutFreqShift;
	fs = Config.fs;

	var = ['acc',accID,'_',compID];
	if not(any(contains(accVars, var))), return; end

	% 	% notch filter for component
	if any(contains(accVars, [var,'_NF']))
		T = add_harmonics_filtered_variables(T, {var}, {[var,'_NF']}, NW, fs);
	end

	% highpass filter for notch-filtered component
	if any(contains(accVars, [var,'_HP']))
		T = add_highpass_RPM_filter_variables(T, {var}, {[var,'_HP']},...
			cut, 'harm', cutShift, fs);
	end

 	% highpass filter component
	if any(contains(accVars, [var,'_NF_HP']))
		T = add_highpass_RPM_filter_variables(T, {[var,'_NF']}, {[var,'_NF_HP']},...
			cut, 'harm', cutShift, fs);
	end

	% remove any temporary component 
	remVars = {var,[var,'_NF']};
	remVars = remVars(ismember(remVars, accVars));
	T = cellfun(@(c) removevars(c, remVars), T, 'UniformOutput',false);

function T = add_norms(accVars, T, accID)
	
	normVar = ['acc',accID,'_norm'];
	xVar = ['acc',accID,'_x'];
	yVar = ['acc',accID,'_y'];
	zVar = ['acc',accID,'_z'];
	
	if not(any(contains(accVars, normVar))), return; end

	% unfiltered norm
	T = add_spatial_norms(T, 2, {xVar,yVar,zVar}, normVar);