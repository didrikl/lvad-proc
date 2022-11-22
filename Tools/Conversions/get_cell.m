function [returnAsCell, entities] = get_cell(entities)

	if iscell(entities)
		returnAsCell = true;
	else
		returnAsCell = false;
	end

	if not(returnAsCell)
		if not(ischar(entities)) || not(isstring(entities))
			entities = {entities};
		else
			entities = cellstr(entities);
		end
	end
