function T = add_segment_data_G1(T,BL,accVar,inds,fs)
	
	movStdWin = 10;
	MovObj = dsp.MovingStandardDeviation(T.fs*movStdWin);
	
	acc = T.(accVar)(inds);
	
	% Bandpower and mean power frequency
	[pxx,f] = periodogram(detrend(acc),[],[],fs);
	T.bp(inds) = bandpower(pxx,f,'psd');

	% Calculate standard deviation and moving standard deviations
	T.accStd(inds) = std(acc);
	BL.accStd(:) = std(BL.(accVar));
	BL.yMovStd = calc_moving_acc_statistic(BL.(accVar),MovObj);
	T.accMovStd(inds) = calc_moving_acc_statistic(acc,MovObj);

	T.Q_diff(inds) = calc_diff_from_baseline_avg(acc,BL.(accVar),'delta');
	T.P_LVAD_diff(inds) = calc_diff_from_baseline_avg(T.P_LVAD(inds),BL.P_LVAD,'delta');
	T.accStd_diff(inds) = calc_diff_from_baseline_avg(T.accStd(inds),BL.accStd,'delta');
	T.accStd_diff(inds) = calc_diff_from_baseline_avg(T.accMovStd(inds),BL.accStd,'delta');

	T.Q_relDiff(inds) = calc_diff_from_baseline_avg(acc,BL.(accVar),'delta');
	T.P_LVAD_relDiff(inds) = calc_diff_from_baseline_avg(T.P_LVAD(inds),BL.P_LVAD,'relative');
	T.accStd_relDiff(inds) = calc_diff_from_baseline_avg(T.accStd(inds),BL.accStd,'relative');
	T.accStd_relDiff(inds) = calc_diff_from_baseline_avg(T.accMovStd(inds),BL.accStd,'relative');

	% Make curves discountinious at bewtween segments
	T{inds(end),{'bp','P_LVAD','P_LVAD_diff','P_LVAD_diff'}} = nan;

	% TODO:
	% Implement join with Notes to get categorical info and noted values
