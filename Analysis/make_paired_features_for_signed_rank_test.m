function W = make_paired_features_for_signed_rank_test(F, pVars)

	% Assert unique levelLabel amonst effect and control interventions
	% 	F = join(F,idSpecs(:,{'analysis_id','interventionType'}),'Keys',analysis_id);

	F = F(ismember(F.interventionType,{'Control','Effect'}),:);

	% Prepare data for paired statistical test, e.g. in SPSS
	W = unstack(...
		F,pVars,'levelLabel',...
		'GroupingVariables',{'seq','pumpSpeed'},...
		'VariableNamingRule','preserve');
