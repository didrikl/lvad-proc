function US = merge_Q_blocks(US)
	if not(iscell(US))
		warning('Q block(s) are not cells and probably already merged')
		return
	end
	if numel(US)==1
		US = US{1};
	else
		US = merge_table_blocks(US);
	end
end