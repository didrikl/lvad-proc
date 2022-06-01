function R = compile_results_table(R, levSortOrder, R_rel)
	relVars = {
		%'Q_LVAD_mean'
		'P_LVAD_mean'
		'Q_mean'
		'accA_xyz_NF_HP_b1_pow_norm'
		'accA_xyz_NF_HP_b2_pow_norm'
		%'accA_xyz_NF_HP_b1_pow_sum'
		%'accA_xyz_NF_HP_b2_pow_sum'
		%'pGraft_mean'
		};
	
	R.levelLabel = categorical(R.levelLabel, levSortOrder, 'Ordinal',true);
	R_rel.levelLabel = categorical(R_rel.levelLabel, levSortOrder, 'Ordinal',true);
	
	% Sort according to ordinal order
	R = sortrows(R, {'levelLabel'});
	R_rel = sortrows(R_rel, {'levelLabel'});
	
	P = split(R_rel{:,relVars});
% 	P1 = P(:,:,1);
% 	P2 = P(:,:,2);
% 	P = P1+" "+P2;
    P = P(:,:,1);
	P = table(P);
	P = splitvars(P,'P','NewVariableNames',relVars+"_rel");
	R = [R,P];


	%R = join(R,R_rel, 'Keys',{'levelLabel'}, 'RightVariables',relVars);
	R = movevars(R,'GroupCount','After','levelLabel');