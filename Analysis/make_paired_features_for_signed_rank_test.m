function W = make_paired_features_for_signed_rank_test(F, pVars, interventionTypes)

	% Assert unique levelLabel amonst effect and control interventions
	% 	F = join(F,idSpecs(:,{'analysis_id','interventionType'}),'Keys',analysis_id);

	groupVars = {'seq','pumpSpeed'};

	if nargin>2
		F = F(ismember(F.interventionType,interventionTypes),:);
	end

	pVars = check_table_var_input(F, pVars);

	% Prepare data for paired statistical test, e.g. in SPSS
	W = unstack(...
		F,pVars,'levelLabel',...
		'GroupingVariables',groupVars,...
		'VariableNamingRule','preserve');

	% Make consistent naming for number of pVars is only one
	if numel(pVars)==1
		levVars = W.Properties.VariableNames(...
			not(ismember(W.Properties.VariableNames,groupVars)));
		W.Properties.VariableNames(levVars) = pVars+"_"+levVars;
	end