function T = extract_from_data(Data, partSpec)
	
	partNo = partSpec{2};
	T = cell(height(partNo),1);
	for i=1:numel(partNo)
		if partNo>numel(Data.S_parts)
			error('Part no is to big');
		end
		T{i} = Data.S_parts{partNo};
		if height(T{i})==0
			error('Part is empty');
		end
	end
	if numel(partNo)>1
		T = merge_table_blocks(T);
	else
		T = T{1};
	end

	% In case baseline is to be taken from a separate part
	if not(isempty(partSpec{1}))
		blPartNo = partSpec{1}(1);
		blRow = partSpec{1}(2);
		if blPartNo>numel(Data.S_parts)
			error('BL part no is to big');
		end
		BL = Data.S_parts{blPartNo};
		BL = BL(BL.noteRow==blRow);
		if height(BL)
			error('Part is empty');
		end
		BL.intervType='Baseline';
		T = merge_table_blocks(BL,T);
	end
end