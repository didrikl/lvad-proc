function isIrregularParts = check_irregular_notes_parts(notes)
	% Part categories must be positive integer in increasing order, as they are
	% used in creating cell array of timetables for each part, for which the
	% indices would correspond to the part numbering.
	
	notes_parts = notes(notes.part~='-',:);
	parts = str2double(string(notes_parts.part));
	
	irregularParts_ind = find(diff(parts)<0)+1;
	if any(irregularParts_ind)
		fprintf('\nIrregular decreasing parts numbering found:\n\n')
		notes_parts(irregularParts_ind,:)
	end
	
	nonPosInt_ind = find(mod(not(isnan(parts)),1));
	if any(nonPosInt_ind)
		fprintf('\nNon positiv integer parts numbering found:\n\n')
		notes_parts(nonPosInt_ind,:)
	end
	
	isIrregularParts = false(height(notes),1);
	isIrregularParts(irregularParts_ind) = true;
	isIrregularParts(nonPosInt_ind) = true;
