function seqID = convert_to_zero_padded_seq_id(inputs)
	nSeq = size(inputs,1);
	seqID = cell(nSeq,1);
	for i=1:nSeq
		seqID{i} = [inputs{i}(1:3),sprintf('%02d',str2double(inputs{i}(4:end)))];
	end