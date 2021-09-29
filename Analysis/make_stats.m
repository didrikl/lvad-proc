function stats = make_stats(Data,noteVars,measVars,idSpecs)
    % NOTE: Rename to make_intervention_metrics or make_intervention_features?
	
    welcome('Calculate stats','function')
    
    seqs = fieldnames(Data);
    stats = cell(numel(seqs),1);
	
    % Code if parallellization by parfor loop instead of for loop below:
	%{
        data = cell(numel(seqs),1);
        for j=1:numel(seqs)
            data{j} = S_analysis.(seqs{j});
        end
    %}
	
    for j=1:numel(seqs)
        seq = seqs{j}; 
        welcome([seq,'\n'],'iteration')
        S = Data.(seq).S;
		
        % Remove rows with extra ids in data not listed in id spec file
        extraIDs = not(ismember(S.analysis_id,idSpecs.analysis_id));
        S(extraIDs,:) = [];
        S.analysis_id = removecats(S.analysis_id); 
        S.bl_id = removecats(S.bl_id); 
        
        idStats_meas = groupsummary(S,{'analysis_id','bl_id'},...
            {'mean','std','median',@(x)prctile(x,[25,75])},{measVars},...
            'IncludeEmptyGroups',false);

        idStats_note = groupsummary(S,'analysis_id',...
            'mean',noteVars,...
            'IncludeEmptyGroups',false);
        
		% Code example (for idStats_meas only) to include missing-rows:
		%{
        S_analysis.(seq).group_id = categorical(...
            string(S_analysis.(seq).analysis_id)+" - "+...
            string(S_analysis.(seq).bl_id));
        stats_meas = groupsummary(S_analysis.(seq),group_id,...
            {'mean','std','median',@(x)prctile(x,[25,75])},{meas_vars},...
            'IncludeEmptyGroups',true);
        group_id = split(string(idStats_meas.group_id)," - ");
        idStats_meas.analysis_id = cateogrical(group_id(:,1));
        idStats_meas.bl_id = categorical(group_id(:,2));
        idStats_meas.group_id = []; 
		%}
		
        stats{j} = join(idStats_meas,idStats_note,"Keys","analysis_id");    
        stats{j} = join(stats{j},idSpecs,"Keys","analysis_id");
        stats{j}.id = seq + "_" + string(stats{j}.idLabel);
        stats{j}.seq = repmat(string(seq),height(stats{j}),1);
        
        multiWaitbar('Making steady-state features',(j)/numel(seqs));

    end
   
    stats = merge_table_blocks(stats);
    
    stats.duration = string(seconds(stats.GroupCount_idStats_meas/750),'hh:mm:ss');   
    stats(:,ismember(stats.Properties.VariableNames,...
        {'GroupCount_idStats_meas','GroupCount_idStats_note','analysisDuration'})) = [];
    
    % Tidy up names 
    q1q3_vars = startsWith(stats.Properties.VariableNames,"fun1_");  
    q1q3_vars = stats.Properties.VariableNames(q1q3_vars);
    for i=1:numel(q1q3_vars)
        stats = splitvars(stats,q1q3_vars{i},'NewVariableNames',...
            {[q1q3_vars{i}(6:end),'_25prct'],[q1q3_vars{i}(6:end),'_75prct']});
	end
    stats = change_variablename_prefix_to_suffix(stats,...
        {'mean','std','median','q1','q2'},...
        {'mean','stdev','median','_25prct','_75prct'},'_');
    
	% Tidy up row and column positions
	stats = movevars(stats,{'id','analysis_id','bl_id','seq','idLabel',...
        'categoryLabel','levelLabel','interventionType','contingency','duration',...
        'pumpSpeed','catheter','balloonLev','balloonDiam','balloonVolume','QRedTarget_pst'},...
        'Before',1);
    stats = sortrows(stats,'id','ascend');
	