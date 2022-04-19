function F = get_best_axis_bl(F, ctrl_inds, speed_inds, classifier)
	best_ctrl_inds = find(ctrl_inds & speed_inds);
	for l=1:numel(best_ctrl_inds)
		ctrl_ax = F.([classifier,'_var']){best_ctrl_inds(l)};
		F.(classifier)(best_ctrl_inds(l)) = ...
			F.(ctrl_ax)(best_ctrl_inds(l));
	end