function F = derive_best_axis_values(F, vars, newVar, sequences)
	F = lookup_sequences(sequences, F);
	F = find_best_axis_per_intervention(F, newVar, vars);
	F = find_best_axis_per_speed(F, [newVar,'_per_speed'], vars, sequences);
	F = lookup_baseline(F, newVar);
	F = lookup_baseline(F, [newVar,'_per_speed']);
	
function F = lookup_baseline(F, newVar)
	F.([newVar,'_BL']) = nan(height(F),1);
	for i=1:height(F)
		bl_ind = find(F.seq==F.seq(i) & F.analysis_id==F.bl_id(i));
		if not(isempty(bl_ind))
			F.([newVar,'_BL'])(i) = F{bl_ind,F.([newVar,'_var']){bl_ind}};
		end
	end

function F = find_best_axis_per_intervention(F, newVar, vars)
	[F.(newVar),col] = max(F{:,vars},[],2);
	F.([newVar,'_var']) = vars(col)';

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
