function [P,R] = make_paired_signed_rank_test(W, G, pVars, exprType, groupVar)

	welcome('Make paired signed rank test','function')
	
	groups = unique(W.(groupVar));
	
	% Store temporarily results into cell arrays before merging cells into one table
	R = cell(numel(groups),1);
	P = cell(numel(groups),1);

	for g=1:numel(groups)
		R{g} = table;
		P{g} = table;
		
		g_inds = G.med.(groupVar)==groups(g);
		levLab = sort_nat(string(unique(G.med.levelLabel(g_inds))));

		for i=1:numel(pVars)

			var = pVars{i};
			iv_var = var+"_"+levLab;
			p = nan(numel(iv_var),1);
			for j=1:numel(iv_var)

				% For each variable/modality do the paired non-parametric
				% statsitical test for each state level against the nominal state

				% TODO: Use function handle input instead or make it OO
				bl_var = get_baseline_varible_name(var, iv_var{j}, exprType);
				if all(isnan(W.(iv_var{j})(W.pumpSpeed==groups(g)))) || ...
					all(isnan(W.(bl_var)(W.pumpSpeed==groups(g))))
					p(j) = nan;
					iv_var{j}
					bl_var
					groups(g)
					
				else
					p(j) = signrank(...
						W.(bl_var)(W.pumpSpeed==groups(g)),...
						W.(iv_var{j})(W.pumpSpeed==groups(g)));
				end
			end

			% Add categorical info for the states in results table R
			R{g}.pumpSpeed = repmat(groups(g),numel(levLab),1);
			R{g}.levelLabel = removecats(categorical(cellstr(levLab)));
			P{g}.pumpSpeed = repmat(groups(g),numel(levLab),1);
			P{g}.levelLabel = removecats(categorical(cellstr(levLab)));

			% Look up variable median effects and quartiles
			eff = G.med(G.med.pumpSpeed==groups(g),{'levelLabel',var});
			iqr = G.iqr(G.iqr.pumpSpeed==groups(g),{'levelLabel',var});
			q1 = G.q1(G.q1.pumpSpeed==groups(g),{'levelLabel',var});
			q3 = G.q3(G.q3.pumpSpeed==groups(g),{'levelLabel',var});
			eff.Properties.VariableNames(2) = "med "+var;
			iqr.Properties.VariableNames(2) = "iqr "+var;
			q1.Properties.VariableNames(2) = "q1 "+var;
			q3.Properties.VariableNames(2) = "q3 "+var;

			% Store the looked up info in results table R
			R{g} = join(R{g}, eff, 'Keys','levelLabel');
			R{g} = join(R{g}, iqr, 'Keys','levelLabel');
			R{g} = join(R{g}, q1, 'Keys','levelLabel');
			R{g} = join(R{g}, q3, 'Keys','levelLabel');
			
			% Add p values as formatted text columns in results table R
			R{g}.(['p ',var]) = compose("%1.3f",p);

			% Convert values as formatted text columns in results table R
			if contains(var,{'Q','P','pGrad'})
				% Relevant for all except acc vars
				R{g}.("med "+var) = compose("%2.2f",R{g}.("med "+var));
				R{g}.("iqr "+var) = compose("%2.2f",R{g}.("iqr "+var));
				R{g}.("q1 "+var) = compose("%2.2f",R{g}.("q1 "+var));
				R{g}.("q3 "+var) = compose("%2.2f",R{g}.("q3 "+var));
			else
				% Relevant for acc vars: Report in 10^(~3) to save table space
				R{g}.("med "+var) = compose("%1.1f",1000*R{g}.("med "+var));
				R{g}.("iqr "+var) = compose("%1.1f",1000*R{g}.("iqr "+var));
				R{g}.("q1 "+var) = compose("%1.1f",1000*R{g}.("q1 "+var));
				R{g}.("q3 "+var) = compose("%1.1f",1000*R{g}.("q3 "+var));
			end

			% Merge column in R into formatted text columns in R
			R{g}.(var) = R{g}.(['med ',var])+" ["+R{g}.(['iqr ',var])+"] ("+R{g}.(['p ',var])+")";
			% 			R{s}.(var) = R{s}.(['med ',var])+" ["+R{s}.(['q1 ',var])+" "+R{s}.(['q3 ',var])+"]"+", p="+R{s}.(['p ',var]);
			R{g}(:,{['p ',var],['med ',var],['iqr ',var],['q1 ',var],['q3 ',var]}) = [];

			% Store p values numbers in a dedicated table (for convenience)
			P{g}.(var) = p;

		end

		% Sort according to analysis_id, before merging RPM-blocks
		[R{g},P{g}] = sort_results_per_analysis_id(R{g},P{g},G,groups(g));

	end

	% Merge the four RPM tables
	R = merge_table_blocks(R);
	P = merge_table_blocks(P);

function bl_var = get_baseline_varible_name(var, iv_var, exprType)
	% For BL stored in a pairwise structure, with one colum/variable per
	% level and per measurement: 
	% - Define what is baseline for each intervention. 
	% - The baseline name is speed-independent. 
	switch exprType
		case 'G1'
			
			% For intervention set baseline 
			if contains(iv_var,'RPM'), bl_var = var+"_RPM, Nominal"; end
			if contains(iv_var,'Clamp'), bl_var = var+"_Clamp, Nominal";     end 
			if contains(iv_var,'Injection'), bl_var = var+"_Injection, Nominal"; end
			if contains(iv_var,'Balloon'), bl_var = var+"_Balloon, Nominal";   end
			
			% For baseline-to-baseline comparisons
			if contains(iv_var,'Balloon, Nominal'), bl_var = var+"_RPM, Nominal";   end
			if contains(iv_var,'Clamp, Nominal'), bl_var = var+"_RPM, Nominal";     end
			if contains(iv_var,'Injection, Nominal'), bl_var = var+"_Injection, Nominal"; end
			
		case 'IV2'
			if contains(iv_var,'Afterload')
				bl_var = var+"_Afterload, Nominal";
			elseif contains(iv_var,'Preload')
				bl_var = var+"_Preload, Nominal";
			else
				bl_var = var+"_Nominal";
			end
		otherwise
			error('Baseline varible undetermined; Experiment type is incorrect')
	end


function [R,P] = sort_results_per_analysis_id(R,P,G,speed)

	% Add analysis_id from G, to enable sorting (and nothing else)
	G_cats = G.med(G.med.pumpSpeed==speed,{'levelLabel','analysis_id'});
	R = join(R,G_cats,'Keys',{'levelLabel'});
	P = join(P,G_cats,'Keys',{'levelLabel'});
	R = sortrows(R,'analysis_id','ascend');
	P = sortrows(P,'analysis_id','ascend');
	R.analysis_id = [];
	P.analysis_id = [];
