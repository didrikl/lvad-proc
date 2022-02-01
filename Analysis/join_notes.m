function S = join_notes(S, Notes)
	
	vars = Notes.Properties.VariableNames(...
		Notes.Properties.CustomProperties.Measured);
	
	% Do not join variables already in S
	vars = vars(not(ismember(vars,S.Properties.VariableNames)));
	
	S = join(S,Notes(:,[{'noteRow'},vars]),'Keys','noteRow');
