function nha = calc_nha(T, inds, fs, vars)
	
	if nargin<4, vars = {'accA_x_NF_HP','accA_y_NF_HP','accA_z_NF_HP'}; end
	[~, vars] = get_cell(vars);
	
	bp = nan(numel(vars,1));
	for i=1:numel(vars)
		[pxx,f] = periodogram(detrend(T.(vars{i})(inds)),[],[],fs);
		bp(i) = 1000*bandpower(pxx,f,'psd');
	end

	nha = sqrt( sum( bp.^2,2,"omitnan"));
