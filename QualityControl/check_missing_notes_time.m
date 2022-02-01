function [isNatPauseStart, isMissingTimestamp] = check_missing_notes_time(notes)
	% Get and display essiential note rows with missing time stamps
	
	natPause_rows = find(isnat(notes.time) & notes.intervType=='Pause');
	first_part_row = find(notes.part~='-',1,'first');
	natPause_rows = natPause_rows(natPause_rows>first_part_row);
	natPauseStart_rows = natPause_rows(notes.intervType(natPause_rows-1)~='Pause');
	isPart = notes.part~='-' & not(isundefined(notes.part));
	
	% All pause intervals should start with a timestamp
	if any(natPauseStart_rows)
		fprintf('\nTimestamps missing for start of pauses:\n\n')
		missing_pause_timestamps = notes(natPauseStart_rows,:);
		disp(missing_pause_timestamps)
	end
	isNatPauseStart = false(height(notes),1);
	isNatPauseStart(natPauseStart_rows)=true;
	
	% Check for missing timestamps at rows associated with a recording part,
	% but not because of missing date info
	isMissingTimestamp = isnat(notes.time) & isPart;
	if any(isMissingTimestamp)
		fprintf('\nTimestamps missing for part-defined rows:\n\n')
		missing_part_timestamps = notes(isMissingTimestamp,:);
		disp(missing_part_timestamps)
	end