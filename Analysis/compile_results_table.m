function R = compile_results_table(R, levSortOrder, rpm_order, R_rel)
	relVars = {
		'Q_LVAD_mean'
		'P_LVAD_mean'
		'Q_mean'
		'pGraft_mean'
		};
	
	R.pumpSpeed = categorical(R.pumpSpeed, rpm_order, 'Ordinal',true);
	R.levelLabel = categorical(R.levelLabel, levSortOrder, 'Ordinal',true);
	R_rel.pumpSpeed = categorical(R_rel.pumpSpeed, rpm_order, 'Ordinal',true);
	R_rel.levelLabel = categorical(R_rel.levelLabel, levSortOrder, 'Ordinal',true);
	R = sortrows(R, {'pumpSpeed','levelLabel'});
	R = join(R,R_rel, 'Keys',{'pumpSpeed','levelLabel'}, 'RightVariables',relVars);
