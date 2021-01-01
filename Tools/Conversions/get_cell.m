function [returnAsCell,entities] = get_cell(entities)
    
    returnAsCell = iscell(entities);
    
    if not(returnAsCell)
        entities = cellstr(entities); 
    end
     