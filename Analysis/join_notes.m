function S = join_notes(S, Notes, vars)
	
	% Take all measured variables from Notes, if not specified
	if nargin<3
		vars = Notes.Properties.VariableNames(...
				Notes.Properties.CustomProperties.Measured);
	end

	% 
	notInNotesVars = vars(not(ismember(vars,Notes.Properties.VariableNames)));
	if not(isempty(notInNotesVars))
		warning('Specified variables to join from Notes do not exist: \n\t%s',...
			strjoin(notInNotesVars,', '));
		vars = vars(ismember(vars,Notes.Properties.VariableNames));
	end

	keyVars = {
		'analysis_id'
		'bl_id'
		};
	vars = vars(not(ismember(vars,keyVars)));
	vars = [keyVars;vars(:)];
	
	[returnAsCell,S] = get_cell(S);
		
	for i=1:numel(S)
		
		% Do not join variables already in S
		vars = vars(not(ismember(vars,S{i}.Properties.VariableNames)));

		S{i} = join(S{i},Notes(:,[{'noteRow'};vars(:)]),'Keys','noteRow');
		S{i} = movevars(S{i},{'noteRow','analysis_id','bl_id'},"Before",1);

	end

	if not(returnAsCell), S = S{1}; end