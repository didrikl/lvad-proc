function T = add_balloon_levels_from_xray(T, lims)
	
	N = numel(lims);	
	balLev = nan(height(T),1);
	balLev(T.balDiam_xRay<lims(2)) = 0;
	
	speeds = unique(T.pumpSpeed);
	for j=1:numel(speeds)
		for i=N-1:-1:1

			inds = T.balDiam_xRay>=lims(i) & T.balDiam_xRay<lims(i+1) ...
				& T.pumpSpeed==speeds(j) & not(isnan(T.balDiam_xRay));
			balLev(inds) = i-1;

			% Handle cases of multiple diameters within a level
			diams = unique(T.balDiam_xRay(inds));
			if numel(diams)>1
				extra_inds = T.balDiam_xRay==diams(1:end-1) & inds;
				balLev(extra_inds) = i-2;
				warning(['Multiple diameters found within the same level',...
					'\n\tSpeed: %s\n\tNote rows: %s\n\tDiameters: %s'],...
					string(speeds(j)),strjoin(string(T.noteRow(extra_inds)),', '),...
					strjoin(string(diams),', '));
			end

		end
	end

	T.balLev_xRay = balLev;
	T.Properties.CustomProperties.Measured("balLev_xRay") = true;
	T = movevars(T,'balLev_xRay',"After","balDiam_xRay");