function T = add_segment_data_IV2(T,BL,accVar,inds,fs)
	
	acc = T.(accVar)(inds);
	
	% Bandpower and mean power frequency
	[pxx,f] = periodogram(detrend(acc),[],[],fs);
	T.bp(inds) = bandpower(pxx,f,'psd');

	T.Q_diff(inds) = calc_diff_from_baseline_avg(acc,BL.(accVar),'delta');
	T.P_LVAD_diff(inds) = calc_diff_from_baseline_avg(T.P_LVAD(inds),BL.P_LVAD,'delta');
	
	% Make curves discountinious at bewtween segments
	T{inds(end),{'bp','P_LVAD','P_LVAD_diff','P_LVAD_diff'}} = nan;
