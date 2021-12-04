function PL = fill_PL_comments(PL)
	for i=1:numel(PL)
		coms = table2timetable(PL{i}.Properties.UserData.Comments(:,{'time','comments'}));
		coms.comments = categorical(strip(string(coms.comments)));
		coms.Properties.VariableContinuity('comments') = 'step';
		PL{i} = synchronize(PL{i},coms);
	end
