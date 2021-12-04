function T = compile_signal_parts_with_baseline_first(bl_part, T, parts, cbl_part)
	
	% Extract relevant data, and baseline is always put first
    if numel(bl_part)==2
        BL = T{bl_part{1}}(T{bl_part{1}}.noteRow==bl_part{2},:);
        T = merge_table_blocks([{BL};T(sort([parts,cbl_part]))]);
    else
        T = merge_table_blocks(T(parts));
    end
end