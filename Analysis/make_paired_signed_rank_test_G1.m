function [P,R] = make_paired_signed_rank_test_G1(W, G, pVars)

	welcome('Make paired signed rank test','function')

	R = table;
	P = table;

	levLab = sort_nat(string(unique(G.med.levelLabel)));%(g_inds))))

	for i=1:numel(pVars)

		var = pVars{i};
		iv_vars = var+"_"+levLab;
		p = nan(numel(iv_vars),1);
		for j=1:numel(iv_vars)

			% For each variable/modality do the paired non-parametric
			% statsitical test for each state level against the nominal state
			bl_var = get_baseline_varible_name(var, iv_vars{j});
			if all(isnan(W.(iv_vars{j}))) || all(isnan(W.(bl_var)))
				p(j) = nan;
				warning('Only NaNs')
			else
				p(j) = signrank(W.(bl_var),W.(iv_vars{j}));
			end

		end

		% Add categorical info for the states in results table R
		R.levelLabel = removecats(categorical(cellstr(levLab)));
		P.levelLabel = removecats(categorical(cellstr(levLab)));

		% Look up variable median effects and quartiles
		eff = G.med(:,{'levelLabel',var});
		iqr = G.iqr(:,{'levelLabel',var});
		q1 = G.q1(:,{'levelLabel',var});
		q3 = G.q3(:,{'levelLabel',var});
		eff.Properties.VariableNames(2) = "med "+var;
		iqr.Properties.VariableNames(2) = "iqr "+var;
		q1.Properties.VariableNames(2) = "q1 "+var;
		q3.Properties.VariableNames(2) = "q3 "+var;

		% Store the looked up info in results table R
		R = join(R, eff, 'Keys','levelLabel');
		R = join(R, iqr, 'Keys','levelLabel');
		R = join(R, q1, 'Keys','levelLabel');
		R = join(R, q3, 'Keys','levelLabel');
		
		% Add p values as formatted text columns in results table R
		R.(['p ',var]) = compose("%1.3f",p);

		% Convert values as formatted text columns in results table R
		if contains(var,{'Q','P','pGrad'})
			% Relevant for all except acc vars
			R.("med "+var) = compose("%2.2f",R.("med "+var));
			R.("iqr "+var) = compose("%2.2f",R.("iqr "+var));
			R.("q1 "+var) = compose("%2.2f",R.("q1 "+var));
			R.("q3 "+var) = compose("%2.2f",R.("q3 "+var));
		else
			% Relevant for acc vars: Report in 10^(~3) to save table space
			R.("med "+var) = compose("%1.1f",1000*R.("med "+var));
			R.("iqr "+var) = compose("%1.1f",1000*R.("iqr "+var));
			R.("q1 "+var) = compose("%1.1f",1000*R.("q1 "+var));
			R.("q3 "+var) = compose("%1.1f",1000*R.("q3 "+var));
		end

		% Merge column in R into formatted text columns in R
		R.(var) = R.(['med ',var])+" ["+R.(['iqr ',var])+"] ("+R.(['p ',var])+")";
		% R{s}.(var) = R{s}.(['med ',var])+" ["+R{s}.(['q1 ',var])+" "+R{s}.(['q3 ',var])+"]"+", p="+R{s}.(['p ',var]);
		R(:,{['p ',var],['med ',var],['iqr ',var],['q1 ',var],['q3 ',var]}) = [];

		% Store p values numbers in a dedicated table (for convenience)
		P.(var) = p;

	end

	R = join(R, G.med(:,{'levelLabel','GroupCount'}), 'Keys','levelLabel');


function bl_var = get_baseline_varible_name(var, iv_var)
	% Define what is baseline for each intervention.
	% For BL stored in a pairwise structure, with one colum/variable per
	% level and per measurement, with the following naming convention:
	% ...
	
	bl_var = split(iv_var,', ');

	if endsWith(bl_var{1},'RPM')
		% For RPM intervention against 2400 RPM
		bl_var{2} = '2400';
	elseif contains(iv_var,', Nominal')
		% For "intervention set BL" against "RPM BL"
		bl_var{1} = [var,'_RPM'];
	else
		% For intervention against "intervention set BL"
		bl_var{3} = 'Nominal';
	end

	bl_var = strjoin(bl_var,', ');


