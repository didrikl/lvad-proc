function T = change_variablename_suffix_to_prefix(T,suffixes,prefixes,separator)

suffixes = cellstr(suffixes);
if nargin<3 || isempty(prefixes), prefixes = suffixes; end
if nargin<4, separator = ''; end


for i=1:numel(suffixes)
    vars = T.Properties.VariableNames(...
        endsWith(T.Properties.VariableNames,[separator,suffixes{i}]));
    nCharsPrefix = length(suffixes{i});
    for j=1:numel(vars)
        if nCharsPrefix == length(vars{j})+1
            % if variablename is same as prefix itself (incl separator):
            % just swap separator posistion 
            newVar = [vars{j}(numel(separator)+1:end),separator];
        else
            % strip suffix and add prefix
            newVar = [prefixes{i},separator,vars{j}(1:end-nCharsPrefix-1)];
        end
        T.Properties.VariableNames{vars{j}} = newVar;          
    end
end