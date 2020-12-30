function [returnAsCell,entities] = get_return_type(entities)
    
    returnAsCell = iscell(entities);
    
    if not(returnAsCell)
        entities = cellstr(entities); 
    end
     