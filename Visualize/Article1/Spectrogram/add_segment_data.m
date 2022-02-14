function T = add_segment_data(T,BL,accVar,inds,fs)
	
	T = join_notes(T,T.Properties.UserData.Notes);
	BL = join_notes(BL,BL.Properties.UserData.Notes);
	
	acc = T.(accVar)(inds);
	
	% Bandpower and mean power frequency
	[pxx,f] = periodogram(detrend(acc),[],[],fs);
	T.bp(inds) = bandpower(pxx,f,'psd');

	T.Q_diff(inds) = calc_diff_from_baseline_avg(acc,BL.(accVar),'delta');
	T.P_LVAD_diff(inds) = calc_diff_from_baseline_avg(T.P_LVAD(inds),BL.P_LVAD,'delta');
	
	% Make curves discountinious at bewtween segments
	T{inds(end),{'bp','P_LVAD','P_LVAD_diff','P_LVAD_diff'}} = nan;