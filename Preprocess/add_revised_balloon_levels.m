function T = add_revised_balloon_levels(T, lims)
	
	N = numel(lims);	
	balLev = nan(height(T),1);
	balLev(T.balDiam_xRay_mean<lims(1)) = 0;
	for i=N-1:-1:1
		
		inds = T.balDiam_xRay_mean>=lims(i) & T.balDiam_xRay_mean<lims(i+1);
		balLev(inds) = i;
		
		% Handle cases of multiple diameters within a level
		diams = unique(T.balDiam_xRay_mean(inds));
		if numel(diams)>1
			extra_inds = T.balDiam_xRay_mean==diams(1:end-1);
			balLev(extra_inds) = i-1;
		end

	end
	
	T.balLev_xRay = balLev;