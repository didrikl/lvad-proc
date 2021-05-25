function T = change_variablename_prefix_to_suffix(T,prefixes,suffixes,separator)

prefixes = cellstr(prefixes);
if nargin<2 || isempty(suffixes), suffixes = prefixes; end
if nargin<3, separator = ''; end


for i=1:numel(prefixes)
    vars = T.Properties.VariableNames(...
        startsWith(T.Properties.VariableNames,[prefixes{i},separator]));
    nCharsPrefix = length(prefixes{i});
    for j=1:numel(vars)
        if nCharsPrefix == length(vars{j})+1
            % variablename is same as prefix itself (incl separator) 
            newVar = [separator,vars{j}(1:end-1)];
        else
            % strip prefix and add suffix
            newVar = [vars{j}(nCharsPrefix+2:end),separator,suffixes{i}];
        end
        T.Properties.VariableNames{vars{j}} = newVar;          
    end
end