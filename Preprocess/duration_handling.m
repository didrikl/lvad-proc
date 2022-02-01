function S_id = duration_handling(S_id, idSpec)
	% Warn if recording interval duration is less than specifices in ID
	% specification file. Also, if duration exceeds with 2 or more seconds, then
	% cut 1 seconds of the recording at the start and end of the interval. The
	% cut is done as a mitigation measure against inaccuracies in timestames
	% (round off errors, human note response, clock drift corrections and clock
	% offsets).
	
	% NOTE: Which solution is best?
	% - Strip 1 secs at each side of the id-interval?
	% - Strip down to exact duration according to the protocol evenly
	%   distributed at each side of the id intererval?
	
	if height(S_id)==0
		if not(idSpec.contingency) && not(idSpec.extra) 
			warning('Missing data');
		end
	else
		totDur = S_id.time(end)-S_id.time(1);
		%fprintf('%s duration\n',string(totDur))
		if totDur<idSpec.analysisDuration
			warning(sprintf('Duration is less than in protocol (%s)',...
				string(idSpec.analysisDuration)));
		elseif totDur>idSpec.analysisDuration+seconds(2)
			dur = S_id.time - S_id.time(1);
			cut_inds = dur<seconds(1) | dur>totDur-seconds(1);
			S_id(cut_inds,:) = [];
			totDur = S_id.time(end)-S_id.time(1);
			fprintf('%s duration\n',string(totDur))
		end
		
	end