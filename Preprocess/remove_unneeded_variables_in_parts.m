function S_parts = remove_unneeded_variables_in_parts(S_parts,forcedToRem)
	
	if nargin<2, forcedToRem = {''}; end
	varsToRetain = 'noteRow';
	
	for i=1:numel(S_parts)
		varsToRem = S_parts{i}.Properties.VariableNames(...
			(not(S_parts{i}.Properties.CustomProperties.Measured) | ... % derived variables
			not(S_parts{i}.Properties.VariableContinuity=='continuous')) | ... % values from notes
			ismember(S_parts{i}.Properties.VariableNames,forcedToRem));
		varsToRem = varsToRem(not(ismember(varsToRem,varsToRetain)));
		S_parts{i}(:,varsToRem) = [];
	end
