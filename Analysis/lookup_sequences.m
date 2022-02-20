function F = lookup_sequences(seqs, F)
	% Use only a selection of sequences if specified
	misSeqs = seqs(not(ismember(seqs,F.seq)));
	if not(isempty(misSeqs))
		warning('Sequences not found: %s',strjoin(misSeqs,'\n\t'));
	end
	notUseSeqs = F.seq(not(ismember(F.seq,seqs)));
	if not(isempty(notUseSeqs))
		warning('Sequences not used: %s',strjoin(notUseSeqs,'\n\t'));
		F = F(ismember(F.seq,seqs),:);
	end