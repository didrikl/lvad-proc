function yDiff = calc_diff_from_baseline_avg(y,y_bl,diffType)
	% TODO: Make a caller function that add to tables, like add_moving..., with
	% check of input/output variable names and input/output names specified as arguments

	yAvg_bl = mean(y_bl,'omitnan');

	switch lower(diffType)
		case 'relative'
			yDiff = 100*(y-yAvg_bl)/yAvg_bl;
		case 'delta'
			yDiff = y-yAvg_bl;
		case 'absolute'
			yDiff = abs(y-yAvg_bl);
		otherwise
			warning(sprintf('diffType %s is not supported',diffType));
	end
