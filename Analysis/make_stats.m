function stats = make_stats(S_analysis,note_vars,meas_vars,id_specs)
    
    welcome('Calculate stats','function')
    
    seqs = fieldnames(S_analysis);
    stats = cell(numel(seqs),1);

    % NOTE: Code if parallellization
    %     data = cell(numel(seqs),1);
    %     for j=1:numel(seqs)
    %         data{j} = S_analysis.(seqs{j});
    %     end
    
    for j=1:numel(seqs)
        seq = seqs{j}; 
        
        stats_meas = groupsummary(S_analysis.(seq),{'analysis_id','bl_id'},...
            {'mean','std','median',@(x)prctile(x,[25,75])},{meas_vars});
        stats_note = groupsummary(S_analysis.(seq),'analysis_id',...
            'mean',{note_vars});
        stats{j} = join(stats_meas,stats_note,"Keys","analysis_id");
        stats{j} = join(stats{j},id_specs,"Keys","analysis_id");
        
        stats{j}.id = seq + "_" + string(stats{j}.idLabel);
        stats{j}.seq = repmat(string(seq),height(stats{j}),1);
    end
   
    stats = merge_table_blocks(stats);
    
    stats.duration = string(seconds(stats.GroupCount_stats_meas/750),'hh:mm:ss');
    
    stats(:,ismember(stats.Properties.VariableNames,...
        {'GroupCount_stats_meas','GroupCount_stats_note','analysisDuration'})) = [];
    
    q1q3_vars = startsWith(stats.Properties.VariableNames,"fun1_");  
    q1q3_vars = stats.Properties.VariableNames(q1q3_vars);
    for i=1:numel(q1q3_vars)
        stats = splitvars(stats,q1q3_vars{i},'NewVariableNames',...
            {[q1q3_vars{i}(6:end),'_25prct'],[q1q3_vars{i}(6:end),'_75prct']});
    end
    
    stats = change_variablename_prefix_to_suffix(stats,...
        {'mean','std','median','q1','q2'},...
        {'mean','stdev','median','_25prct','_75prct'},'_');
    stats = movevars(stats,{'id','analysis_id','bl_id','seq','idLabel',...
        'categoryLabel','levelLabel','effectInterv','contingency','duration',...
        'pumpSpeed','catheter','balloonDiam','balloonVolume','QRedTarget_pst'},...
        'Before',1);
    
    stats = sortrows(stats);