function [T_parts, rpmOrderMap] = make_segment_plot_data(Data, accVar, Config)

	res = 0.01;
	overlapPst = 80; 
	movStdWin = 10;
	
	partSpec = Config.partSpec;
	accVar = cellstr(accVar);

	nParts = size(partSpec,1);
	T_parts = cell(nParts,1);
	rpmOrderMap = cell(nParts,1);
	
	% Extract relevant part, BL and Notes info
	for i=1:nParts
		T_parts{i} = extract_from_data(Data, partSpec(i,:));
	end

	T_parts = add_derived_variables(accVar, T_parts, Config);
	
	nVars = numel(accVar);
	waitIncr = 1/(nParts*nVars);
	for j=1:nVars	
		for i=1:nParts
			
			multiWaitbar('Calculate spectrogram','Increment',waitIncr);
			T_parts{i} = add_relative_diff(T_parts{i}, accVar{j}, Config.fs, movStdWin);
 			
			[map,order,rpm,time] = make_rpm_order_map(T_parts{i}, accVar{j}, ...
				Config.fs, 'pumpSpeed', res, overlapPst);

			% For now not needed:
			% if not(contains(accVar,'_NF'))
			%     ordertrack(...,'Amplitude','power')
			% end
			
			rpmOrderMap{i}.(accVar{j}).map = map;
			rpmOrderMap{i}.(accVar{j}).order = order;
			rpmOrderMap{i}.(accVar{j}).rpm = rpm;
			rpmOrderMap{i}.(accVar{j}).time = time;

		end
	end

	unneededVars = {'intervType','event','Q_LVAD','P_LVAD','pumpSpeed'};
	T_parts = cellfun(@(c) removevars(c,unneededVars),T_parts,...
		'UniformOutput',false);
end

function T = add_relative_diff(T, accVar, fs, movStdWin)
	
	bl_inds = get_baseline_inds(T);
	
	BL = T(bl_inds,:);
	
	% NOTE: Take fs and movStdWin from Config?
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

end

function inds = get_baseline_inds(T)
	inds = ismember(T.intervType,{'Baseline','baseline'}) &...
		not(contains(lower(string(T.event)),{'echo'}));
	if nnz(inds)==0
		warning('No baseline denoted in Notes')
		%Ask_List_ui()
	elseif diff(find(inds))>1
		warning('Multiple baseline segments in Notes')
		%Ask_List_ui()
	end
end

function T = add_derived_variables(accVar, T, Config)
	% Preprocess/derive new varibles
	
	% Derive Eucledian norm signal, if needed
	T = add_norms(accVar, T, Config);

	if any( contains(accVar,'x_NF') & not(contains(accVar,'_HP')) )
		T = add_harmonics_filtered_variables(T, {'accA_x'}, {'accA_x_NF'},...
			Config.harmonicNotchFreqWidth, Config.fs);
	elseif any(contains(accVar,'x_NF_HP'))
		T = add_harmonics_filtered_variables(T, {'accA_x'}, {'accA_x_NF'},...
			Config.harmonicNotchFreqWidth, Config.fs);
		T = add_highpass_RPM_filter_variables(T, {'accA_x_NF'}, {'accA_x_NF_HP'},...
			Config.harmCut, 'harm', Config.harmCutFreqShift, Config.fs);
	elseif any(contains(accVar,'x_HP'))
		T = add_highpass_RPM_filter_variables(T, {'accA_x_NF'}, {'accA_x_NF_HP'},...
			Config.harmCut, 'harm', Config.harmCutFreqShift, Config.fs);
	end

	if any( contains(accVar,'y_NF') & not(contains(accVar,'_HP')) )
		T = add_harmonics_filtered_variables(T, {'accA_y'}, {'accA_x_NF'},...
			Config.harmonicNotchFreqWidth, Config.fs);
	elseif any(contains(accVar,'y_NF_HP'))
		T = add_harmonics_filtered_variables(T, {'accA_y'}, {'accA_y_NF'},...
			Config.harmonicNotchFreqWidth, Config.fs);
		T = add_highpass_RPM_filter_variables(T, {'accA_y_NF'}, {'accA_y_NF_HP'},...
			Config.harmCut, 'harm', Config.harmCutFreqShift, Config.fs);
	elseif any(contains(accVar,'y_HP'))
		T = add_highpass_RPM_filter_variables(T, {'accA_y_NF'}, {'accA_y_NF_HP'},...
			Config.harmCut, 'harm', Config.harmCutFreqShift, Config.fs);
	end

	if any( contains(accVar,'z_NF') & not(contains(accVar,'_HP')) )
		T = add_harmonics_filtered_variables(T, {'accA_z'}, {'accA_z_NF'},...
			Config.harmonicNotchFreqWidth, Config.fs);
	elseif any(contains(accVar,'z_NF_HP'))
		T = add_harmonics_filtered_variables(T, {'accA_z'}, {'accA_z_NF'},...
			Config.harmonicNotchFreqWidth, Config.fs);
		T = add_highpass_RPM_filter_variables(T, {'accA_z_NF'}, {'accA_z_NF_HP'},...
			Config.harmCut, 'harm', Config.harmCutFreqShift, Config.fs);
	elseif any(contains(accVar,'z_HP'))
		T = add_highpass_RPM_filter_variables(T, {'accA_z_NF'}, {'accA_z_NF_HP'},...
			Config.harmCut, 'harm', Config.harmCutFreqShift, Config.fs);
	end

end
	

function T = add_norms(accVar, T, Config)
	
	% just unfiltered norm
	if any( contains(accVar,'norm') & not(contains(accVar,'_NF')) & not(contains(accVar,'_HP')) )
		T = add_spatial_norms(T, 2, {'accA_x','accA_y','accA_z'}, 'accA_norm');
		
	% just notch filtered norm
	elseif any( contains(accVar,'norm') & contains(accVar,'_NF') & not(contains(accVar,'_HP')) )
		T = add_spatial_norms(T, 2, {'accA_x','accA_y','accA_z'}, 'accA_norm');
		T = add_harmonics_filtered_variables(T,...
			{'accA_norm'},{'accA_norm_NF'}, Config.harmonicNotchFreqWidth, Config.fs);
		T = cellfun( @(c) removevars(c,'accA_norm'), T);
	else
		T = add_spatial_norms(T, 2, {'accA_x','accA_y','accA_z'}, 'accA_norm');
		T = add_harmonics_filtered_variables(T,...
			{'accA_norm'},{'accA_norm_NF'}, Config.harmonicNotchFreqWidth, Config.fs);
		T = add_highpass_RPM_filter_variables(T,...
			{'accA_norm_NF'}, {'accA_norm_NF_HP'},...
			Config.harmCut, 'harm', Config.harmCutFreqShift, Config.fs);
	end
end