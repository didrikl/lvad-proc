function US = merge_Q_blocks(US)
	
	welcome('Merge ultrasound data blocks','function')
    
	if not(iscell(US))
		warning('Q block(s) are not cells and probably already merged')
		return
	end
	if numel(US)==1
		US = US{1};
	else
		US = merge_table_blocks(US);
	end

	US.Properties.CustomProperties.Measured(:) = true;
