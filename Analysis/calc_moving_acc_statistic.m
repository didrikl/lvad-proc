function yMov = calc_moving_acc_statistic(y,MovObj)
	% Calculate moving statistic in a numeric array y, using the dsp
	% library object as input, created by e.g. 
	% MovObj = MovingStandardDeviation(fs*movStdWin);
	%
	% The output contains NaN up to the window length
	yMov = MovObj(y);
	yMov(1:MovObj.WindowLength) = nan;
	
	% Truncate output in case input is shorter than window length
	if length(y)<length(yMov)
		yMov = yMov(1:length(y));
		warning(['Input for moving stattistic calculation is short than ',...
		'the calculation window length.'])
	end