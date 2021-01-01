function [returnAsCell,entities] = get_cell(entities)
    
    returnAsCell = iscell(entities);
    
    if not(returnAsCell)
        if not(ischar(entities)) || not(isstring(entities))
            entities = {entities};
        else
            entities = cellstr(entities);
        end
    end
     