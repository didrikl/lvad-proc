function G = make_group_stats(F, idSpecs, seqs)
    
	if nargin>2, F = lookup_sequences(seqs, F); end

	% Find and use only numeric colums
	numIdSpecVars = idSpecs(:,vartype('numeric')).Properties.VariableNames;
	F = F(:,not(ismember(F.Properties.VariableNames,numIdSpecVars)));
	
	% Aggregate intervention mertrics (already caluclated e.g. as mean, st.devs 
	% and band powers) over groups of sequences (experiments)
    G.avg = groupsummary(F,'analysis_id','mean',F(:,vartype('numeric')).Properties.VariableNames);
    G.std = groupsummary(F,'analysis_id','std',F(:,vartype('numeric')).Properties.VariableNames);
    G.med = groupsummary(F,'analysis_id','median',F(:,vartype('numeric')).Properties.VariableNames);
    G.q1 = groupsummary(F,'analysis_id',@(x)prctile(x,25),F(:,vartype('numeric')).Properties.VariableNames);
    G.q3 = groupsummary(F,'analysis_id',@(x)prctile(x,75),F(:,vartype('numeric')).Properties.VariableNames);
    G.iqr = groupsummary(F,'analysis_id',@iqr,F(:,vartype('numeric')).Properties.VariableNames);
    
	% Automatically made prefixes by groupsummary
	prefixes = {'mean_','std_','median_','fun1_'};

	% Add categorical info from idSpecs
	G = structfun(@(S) ...
		removevars(S,ismember(S.Properties.VariableNames,prefixes+"GroupCount"))...
		,G,'UniformOutput',false);
    G = structfun( @(S)join(S,idSpecs,'Keys','analysis_id'), ...
		G,'UniformOutput',false);
    
	% Tidy up automatically given aggegate names
	G = structfun(@(S)change_variablename_prefix(S,prefixes,{'','','',''}),G,'UniformOutput',false);
    G = structfun(@(S)movevars(S,idSpecs.Properties.VariableNames,'Before',1),G,'UniformOutput',false);
    
	