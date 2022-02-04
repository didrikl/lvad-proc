function [P,R] = make_paired_signed_rank_test(W, G, pVars, exprType)

	welcome('Make paired signed rank test','function')
	
	% TODO: Make generic or with input!!!
	%speeds=[2200,2500,2800,3100];
	speeds=[2200,2400,2600];

	levLab = sort_nat(string(unique(G.med.('levelLabel'))));

	% Store temporarily results into cell arrays before merging cells into one table
	R = cell(numel(speeds),1);
	P = cell(numel(speeds),1);

	for s=1:numel(speeds)
		R{s} = table;
		P{s} = table;
		for i=1:numel(pVars)

			var = pVars{i};
			iv_var = var+"_"+levLab;
			p = nan(numel(iv_var),1);
			for j=1:numel(iv_var)

				% For each variable/modality do the paired non-parametric
				% statsitical test for each state level against the nominal state

				% TODO: Use function handle input instead
				bl_var = get_baseline_varible_name(var, iv_var{j}, exprType);

				if all(isnan(W.(iv_var{j})(W.pumpSpeed==speeds(s))))
					p(j) = nan;
				else
					p(j) = signrank(...
						W.(bl_var)(W.pumpSpeed==speeds(s)),...
						W.(iv_var{j})(W.pumpSpeed==speeds(s)));
				end
			end

			% Add categorical info for the states in results table R
			R{s}.pumpSpeed = repmat(speeds(s),numel(levLab),1);
			R{s}.levelLabel = categorical(cellstr(levLab));
			P{s}.pumpSpeed = repmat(speeds(s),numel(levLab),1);
			P{s}.levelLabel = categorical(cellstr(levLab));

			% Look up variable median effects and quartiles
			eff = G.med(G.med.pumpSpeed==speeds(s),{'levelLabel',var});
			iqr = G.iqr(G.iqr.pumpSpeed==speeds(s),{'levelLabel',var});
			q1 = G.q1(G.q1.pumpSpeed==speeds(s),{'levelLabel',var});
			q3 = G.q3(G.q3.pumpSpeed==speeds(s),{'levelLabel',var});
			eff.Properties.VariableNames(2) = "med "+var;
			iqr.Properties.VariableNames(2) = "iqr "+var;
			q1.Properties.VariableNames(2) = "q1 "+var;
			q3.Properties.VariableNames(2) = "q3 "+var;

			% Store the looked up info in results table R
			R{s} = join(R{s}, eff, 'Keys','levelLabel');
			R{s} = join(R{s}, iqr, 'Keys','levelLabel');
			R{s} = join(R{s}, q1, 'Keys','levelLabel');
			R{s} = join(R{s}, q3, 'Keys','levelLabel');
			
			% Add p values as formatted text columns in results table R
			R{s}.(['p ',var]) = compose("%1.3f",p);

			% Convert values as formatted text columns in results table R
			if contains(var,{'Q','P','pGrad'})
				% Relevant for all except acc vars
				R{s}.("med "+var) = compose("%2.2f",R{s}.("med "+var));
				R{s}.("iqr "+var) = compose("%2.2f",R{s}.("iqr "+var));
				R{s}.("q1 "+var) = compose("%2.2f",R{s}.("q1 "+var));
				R{s}.("q3 "+var) = compose("%2.2f",R{s}.("q3 "+var));
			else
				% Relevant for acc vars: Report in 10^(~3) to save table space
				R{s}.("med "+var) = compose("%1.1f",1000*R{s}.("med "+var));
				R{s}.("iqr "+var) = compose("%1.1f",1000*R{s}.("iqr "+var));
				R{s}.("q1 "+var) = compose("%1.1f",1000*R{s}.("q1 "+var));
				R{s}.("q3 "+var) = compose("%1.1f",1000*R{s}.("q3 "+var));
			end

			% Merge column in R into formatted text columns in R
			R{s}.(var) = R{s}.(['med ',var])+" ["+R{s}.(['iqr ',var])+"] ("+R{s}.(['p ',var])+")";
			% 			R{s}.(var) = R{s}.(['med ',var])+" ["+R{s}.(['q1 ',var])+" "+R{s}.(['q3 ',var])+"]"+", p="+R{s}.(['p ',var]);
			R{s}(:,{['p ',var],['med ',var],['iqr ',var],['q1 ',var],['q3 ',var]}) = [];

			% Store p values numbers in a dedicated table (for convenience)
			P{s}.(var) = p;

		end

		% Sort according to analysis_id, before merging RPM-blocks
		[R{s},P{s}] = sort_results_per_analysis_id(R{s},P{s},G,speeds(s));

	end

	% Merge the four RPM tables
	R = merge_table_blocks(R);
	P = merge_table_blocks(P);

function bl_var = get_baseline_varible_name(var, iv_var, exprType)
	switch exprType
		case 'G1'
			if contains(iv_var,'Clamp')
				bl_var = var+"_Nominal, Clamp";
			elseif contains(iv_var,'Injection')
				bl_var = var+"_Nominal, Injection";
			else
				bl_var = var+"_Deflated, Lev0";
			end

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
