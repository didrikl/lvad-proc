function [P,R] = make_results_table_from_paired_signed_rank_test(W,G,pVars,levLabVar)
	
	speeds=[2200,2500,2800,3100];
	levLab = sort_nat(string(unique(G.med.(levLabVar))));

	% Store temporarily results into cell arrays before merging cells into one table
	R = cell(numel(speeds),1);
	P = cell(numel(speeds),1);
	
	for s=1:numel(speeds)
		R{s} = table;
		P{s} = table;
		for i=1:numel(pVars)
			
			var = pVars{i};
			iv_var = var+"_"+levLab;
			bl_var = var+"_Nominal";
			p = nan(numel(iv_var),1);
			for j=1:numel(iv_var)
				p(j) = signrank(...
					W.(bl_var)(W.pumpSpeed==speeds(s)),...
					W.(iv_var{j})(W.pumpSpeed==speeds(s)));
			end
			
			R{s}.pumpSpeed = repmat(speeds(s),numel(levLab),1);
			R{s}.levelLabel = categorical(cellstr(levLab));
			P{s}.pumpSpeed = repmat(speeds(s),numel(levLab),1);
			P{s}.levelLabel = categorical(cellstr(levLab));
			
			eff = G.med(G.med.pumpSpeed==speeds(s),{'levelLabel',var});
			iqr = G.iqr(G.iqr.pumpSpeed==speeds(s),{'levelLabel',var});
			q1 = G.q1(G.q1.pumpSpeed==speeds(s),{'levelLabel',var});
			q3 = G.q3(G.q3.pumpSpeed==speeds(s),{'levelLabel',var});
			
			eff.Properties.VariableNames(2) = "med "+var;
			iqr.Properties.VariableNames(2) = "iqr "+var;
			q1.Properties.VariableNames(2) = "q1 "+var;
			q3.Properties.VariableNames(2) = "q3 "+var;
			
			R{s} = join(R{s},eff,'Keys','levelLabel');
			R{s} = join(R{s},iqr,'Keys','levelLabel');
			R{s} = join(R{s},q1,'Keys','levelLabel');
			R{s} = join(R{s},q3,'Keys','levelLabel');
			
			% Fill p values as formatted text into text columns
			R{s}.(['p ',var]) = compose("%1.3f",p);
			if contains(var,{'Q','P','pGrad'})
				R{s}.("med "+var) = compose("%2.2f",R{s}.("med "+var));
				R{s}.("iqr "+var) = compose("%2.2f",R{s}.("iqr "+var));
				R{s}.("q1 "+var) = compose("%2.2f",R{s}.("q1 "+var));
				R{s}.("q3 "+var) = compose("%2.2f",R{s}.("q3 "+var));
			else
				R{s}.("med "+var) = compose("%2.2f",1000*R{s}.("med "+var));
				R{s}.("iqr "+var) = compose("%2.2f",1000*R{s}.("iqr "+var));
				R{s}.("q1 "+var) = compose("%2.2f",1000*R{s}.("q1 "+var));
				R{s}.("q3 "+var) = compose("%2.2f",1000*R{s}.("q3 "+var));
			end
			R{s}.(var) = R{s}.(['med ',var])+" ["+R{s}.(['iqr ',var])+"] ("+R{s}.(['p ',var])+")";
% 			R{s}.(var) = R{s}.(['med ',var])+" ["+R{s}.(['q1 ',var])+...
% 				" "+R{s}.(['q3 ',var])+"]"+", p="+R{s}.(['p ',var]);
			
			R{s}(:,{['p ',var],['med ',var],['iqr ',var],['q1 ',var],['q3 ',var]}) = [];
			
			P{s}.(var) = p;
			
		end
		
		R{s} = join(R{s},G.med(G.med.pumpSpeed==speeds(s),{'levelLabel','analysis_id'}),...
			'Keys',{'levelLabel'});
		R{s} = sortrows(R{s},'analysis_id','ascend');
		R{s}.analysis_id = [];
		
		P{s} = join(P{s},G.med(G.med.pumpSpeed==speeds(s),{'levelLabel','analysis_id'}),...
			'Keys',{'levelLabel'});
		P{s} = sortrows(P{s},'analysis_id','ascend');
		P{s}.analysis_id = [];
		
	end
	R = merge_table_blocks(R);
	P = merge_table_blocks(P);
