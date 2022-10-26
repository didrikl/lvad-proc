function F = lookup_baseline_for_best_axis(F, newVar)
	F.([newVar,'_BL']) = nan(height(F),1);
	for i=1:height(F)
		bl_ind = find(F.seq==F.seq(i) & F.analysis_id==F.bl_id(i));
		if not(isempty(bl_ind))
			F.([newVar,'_BL'])(i) = F{bl_ind,F.([newVar,'_var']){bl_ind}};
		end
	end