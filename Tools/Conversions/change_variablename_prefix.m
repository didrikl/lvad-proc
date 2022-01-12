function T = change_variablename_prefix(T,prefixes,newPrefixes,separator)

prefixes = cellstr(prefixes);
newPrefixes = cellstr(newPrefixes);
if nargin<4, separator = ''; end

for i=1:numel(prefixes)
    vars = T.Properties.VariableNames(...
        startsWith(T.Properties.VariableNames,[prefixes{i},separator]));
    nCharsPrefix = length(prefixes{i});
    for j=1:numel(vars)
        if nCharsPrefix == length(vars{j})+numel(separator)
            % variablename is same as prefix itself (incl separator) 
            newVar = [newPrefixes,separator];
        else
            % strip prefix and add suffix
            newVar = [newPrefixes{i},separator,vars{j}(nCharsPrefix+numel(separator)+1:end)];
		end

		% TODO: Checks if varibles already exists by check_table_var_output
		try
		T.Properties.VariableNames{vars{j}} = newVar;          
		catch
		vars{j}
	    end
    end
end