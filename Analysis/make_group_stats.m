function G = make_group_stats(F,idSpecs)
    
    G.avg = groupsummary(F,'analysis_id','mean',F(:,vartype('numeric')).Properties.VariableNames);
    G.std = groupsummary(F,'analysis_id','std',F(:,vartype('numeric')).Properties.VariableNames);
    G.med = groupsummary(F,'analysis_id','median',F(:,vartype('numeric')).Properties.VariableNames);
    G.q1 = groupsummary(F,'analysis_id',@(x)prctile(x,25),F(:,vartype('numeric')).Properties.VariableNames);
    G.q3 = groupsummary(F,'analysis_id',@(x)prctile(x,75),F(:,vartype('numeric')).Properties.VariableNames);
    
    G = structfun(@(S)join(S,idSpecs,'Keys','analysis_id'),G,'UniformOutput',false);
    G = structfun(@(S)change_variablename_prefix(S,{'mean_','std_','median_','fun1_'},{'','','',''}),G,'UniformOutput',false);
    G = structfun(@(S)movevars(S,idSpecs.Properties.VariableNames,'Before',1),G,'UniformOutput',false);
    
