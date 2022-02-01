function seqID = get_seq_id(seq)
	seq = split(seq,'_');
	seqID = seq{end};