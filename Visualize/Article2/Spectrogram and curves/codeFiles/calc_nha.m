function nha = calc_nha(T, inds, fs)
	accVars = {'accA_x_NF_HP','accA_y_NF_HP','accA_z_NF_HP'};
	
	bp = nan(numel(accVars,1));
	for i=1:numel(accVars)
		[pxx,f] = periodogram(detrend(T.(accVars{i})(inds)),[],[],fs);
		bp(i) = 1000*bandpower(pxx,f,'psd');
	end

	nha = sqrt( sum( bp.^2,2,"omitnan"));
