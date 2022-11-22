function T_parts = add_rel_diff_from_bl(T_parts, vars, nParts, fs, movStdWin)
	
	welcome('Adding relative differences from BL','Function');
	fprintf('Variables:')
	
	[~, vars] = get_cell(vars);
	[returnAsCell, T_parts] = get_cell(T_parts);
	
	for j=1:numel(vars)
		fprintf(['\n\t',vars{j}]);
		for i=1:nParts
			
			T_parts{i} = add_relative_diff(T_parts{i}, vars{j}, fs, movStdWin);
			
			isWashout = ismember(T_parts{i}.event,'Washout');
			T_parts{i}{isWashout,[{'Q','Q_relDiff','P_LVAD','P_LVAD_relDiff'},...
				[vars{j},'_movStd_relDiff']]} = nan;
			
		end
	end
	
	if not(returnAsCell), T_parts = T_parts{1}; end
	fprintf('\n')

function T = add_relative_diff(T, accVar, fs, movStdWin)
		
	bl_inds = get_baseline_inds(T);
	BL = T(bl_inds,:);
	
	MovObj = dsp.MovingStandardDeviation(fs*movStdWin);
	
	acc = T.(accVar);
	acc_bl = BL.(accVar);

	% Calculate standard deviation and moving standard deviations
	BL.([accVar,'_std'])(:) = std(BL.(accVar));
	BL.([accVar,'_movStd']) = calc_moving_acc_statistic(acc_bl, MovObj);
	T.([accVar,'_movStd'])= calc_moving_acc_statistic(acc, MovObj);

	T.Q_relDiff = calc_diff_from_baseline_avg(T.Q, BL.Q, 'relative');
	T.P_LVAD_relDiff = calc_diff_from_baseline_avg(T.P_LVAD, BL.P_LVAD, 'relative');
	T.Q_LVAD_relDiff = calc_diff_from_baseline_avg(T.Q_LVAD, BL.Q_LVAD, 'relative');
	T.([accVar,'_movStd_relDiff']) = calc_diff_from_baseline_avg(T.([accVar,'_movStd']), BL.([accVar,'_std']), 'relative');

	% Make curves of discrete values discountinious at between segments
 	break_inds = diff(T.time)>seconds(1);
 	T{break_inds,{'P_LVAD','Q_LVAD','P_LVAD_relDiff','Q_LVAD_relDiff'}} = nan;
