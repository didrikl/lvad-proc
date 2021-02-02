function T = remove_variables(T,varNames)
    
    [returnAsCell,T] = get_cell(T);
    
    for i=1:numel(T)
        T{i}(:,ismember(T{i}.Properties.VariableNames,varNames)) = [];
    end
    
    if not(returnAsCell)
        T = T{1};
    end