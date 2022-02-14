function seqs = check_missing_sequences(seqs, D)
	misSeqs = seqs(not(ismember(seqs,fieldnames(D))));
	if not(isempty(misSeqs))
		warning('Sequences not present in data: \n\t%s',strjoin(seqs,'\n\t'))
	end
	seqs = seqs(ismember(seqs,fieldnames(D)));
