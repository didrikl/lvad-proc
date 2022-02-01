function T = remove_variables(T, varNames)
    
    [returnAsCell,T] = get_cell(T);
    
    % Loop instead of using removevars with cellfun, to handle the case of 
    % non-present variables
    for i=1:numel(T)
        T{i}(:,ismember(T{i}.Properties.VariableNames,varNames)) = [];
    end
    
    if not(returnAsCell)
        T = T{1};
    end