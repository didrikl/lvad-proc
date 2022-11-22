function [harm, harmAvg, segs] = calc_harmonic_salience_per_seg(mags, t, segs)
	% Get tracked harmonic saliance
	%
	% Input:
	%   mags:    pre-calculated tracked orders of 
	%            [0.95, 1, 1.05, 1.95, 2, 2.05, 2.95, 3, 3.05, 3.95, 4, 4.05],
	%            as e.g. done in the function make_rpm_order_map_per_part
	%   t:       time instances for mags (c.f. above)
	%   segs:    recording segment info, with segment durations
	%
	% Output:
	%   harm:    saliance for 1st-4th. harmonic, stored column-wise,
	%            for each segment time instance, handy for plotting
	%   harmAvg: saliance for 1st-4th. harmonic averages, stored column-wise,
	%            for each segment time instance, handy for plotting
	%   segs:    harmonic saliance averages as in harmAvg, but stored as a 
	%            segment single-point index, as e.g. made by the function 
	%            get_segment_info

	% Use decibel scale
	mags = mag2db(mags);

	harm = nan(size(mags, 2), 4);
	harmAvg =  nan(size(mags, 2), 4);
	
	% Loop over harmonic order 1-4
	for j=1:4
		
		for i=1:height(segs.main)

			% get whole segment (either transitional or steady-state) indices
			inds = t>=segs.main.StartDur(i) & t<segs.main.EndDur(i);
			
			% Subtract the mean of reference bands: Becomes a form of 
			% signal-to-NHA ratio when using desibel scale is being used 
			% (logorithmic rules apply)
			harm(inds,j) = mags(j*3-1,inds)-0.5*(mags(j*3-2,inds)+mags(j*3,inds));
			%harm(inds,j) = mags(j*3-1,inds)-(mags(j*3-2,inds));
			
			harmAvg_val = mean(harm(inds,j),'omitnan');
					
			harmAvg(inds,j) = harmAvg_val;
			
			if segs.main.isWashout(i), harmAvg(inds,j) = nan; end
			% if segs.main.isEcho(i), harm(inds,j) = nan; end
			if segs.main.isTransitional(i), harmAvg(inds,j) = nan; end
			harmAvg(find(inds==1, 1, 'last'),j) = nan;
		
			% Store in segment info table
			segs.main.(['h',num2str(j),'Avg'])(i) = harmAvg_val;
			
		end
	
	end
