function T_parts = add_del_diff_from_bl(T_parts, vars, nParts, fs, movStdWin)
	
	welcome('Adding delta differences from BL','Function');
	fprintf('Variables:')
	
	[~, vars] = get_cell(vars);
	[returnAsCell, T_parts] = get_cell(T_parts);
	
	for j=1:numel(vars)
		fprintf(['\n\t',vars{j}]);
		for i=1:nParts
			
			T_parts{i} = add_delta_diff(T_parts{i}, vars{j}, fs, movStdWin);
			
			% TODO: Move to separate function
			isWashout = ismember(T_parts{i}.event,'Washout');
			T_parts{i}{isWashout,[{'Q','Q_delDiff','P_LVAD','P_LVAD_delDiff'},...
				[vars{j},'_movStd_delDiff']]} = nan;
			
		end
	end
	
	if not(returnAsCell), T_parts = T_parts{1}; end
	fprintf('\n')

function T = add_delta_diff(T, accVar, fs, movStdWin)
		
	bl_inds = get_baseline_inds(T);
	BL = T(bl_inds,:);
	
	MovObj = dsp.MovingStandardDeviation(fs*movStdWin);
	
	acc = T.(accVar);
	acc_bl = BL.(accVar);

	% Calculate standard deviation and moving standard deviations
	BL.([accVar,'_std'])(:) = std(BL.(accVar));
	BL.([accVar,'_movStd']) = calc_moving_acc_statistic(acc_bl, MovObj);
	T.([accVar,'_movStd'])= calc_moving_acc_statistic(acc, MovObj);

	T.Q_delDiff = calc_diff_from_baseline_avg(T.Q, BL.Q, 'delta');
	T.P_LVAD_delDiff = calc_diff_from_baseline_avg(T.P_LVAD, BL.P_LVAD, 'delta');
	T.Q_LVAD_delDiff = calc_diff_from_baseline_avg(T.Q_LVAD, BL.Q_LVAD, 'delta');
	T.([accVar,'_movStd_delDiff']) = calc_diff_from_baseline_avg(T.([accVar,'_movStd']), BL.([accVar,'_std']), 'delta');

	% Make curves of discrete values discountinious at between segments
 	break_inds = diff(T.time)>seconds(1);
 	T{break_inds,{'P_LVAD','Q_LVAD','P_LVAD_delDiff','Q_LVAD_delDiff'}} = nan;
