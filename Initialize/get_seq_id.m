function seqID = get_seq_id(seq)
	seq = split(seq,'_');
	if numel(seq)>1
		seqID = strjoin(seq(2:end),'_');
	end