function misNum = check_missing_numeric_data(T, numVarsNotToCheck)
	notCheckCols = ismember(T.Properties.VariableNames,numVarsNotToCheck);
	T(:,notCheckCols) = [];
	misNum = any(isnan(T{:,vartype('numeric')}),2) & ...
		contains(string(T.intervType),{'steady','baseline'},'IgnoreCase',true);
