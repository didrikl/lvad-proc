function F = find_best_axis_per_speed(F, newVar, vars, seqs)
	speeds = unique(F.pumpSpeed);
	bal_inds = F.balDiam_xRay_mean>0;
	for i=1:numel(seqs)
		seq_inds = F.seq==seqs{i};
		for j=1:numel(speeds)
			s_inds = F.pumpSpeed==speeds(j);
			[~,col] = max(sum(F{seq_inds & s_inds & bal_inds,vars}));
			F.([newVar,'_var'])(seq_inds & s_inds) = vars(col);
			F.(newVar)(seq_inds & s_inds) = F{seq_inds & s_inds, vars(col)};
		end
	end
