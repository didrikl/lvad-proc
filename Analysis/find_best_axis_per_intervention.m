function F = find_best_axis_per_intervention(F, newVar, vars)
	[F.(newVar),col] = max(F{:,vars},[],2);
	F.([newVar,'_var']) = vars(col)';