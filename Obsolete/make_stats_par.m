function stats = make_stats(S_analysis,note_vars,meas_vars)
    
    welcome('Calculate stats','function')
    
    ids_specs = init_id_specifications('ID_Definitions_IV2');
    seqs = fieldnames(S_analysis);
    
    stats = cell(numel(seqs),1);
    data = cell(numel(seqs),1);
    for j=1:numel(seqs)
        data{j} = S_analysis.(seqs{j});
    end
    
    parfor j=1:numel(seqs)
        pc.seq = seqs{j}; 
        
        stats_meas = groupsummary(data{j},{'analysis_id','bl_id'},...
            {'mean','std','median',@(x)prctile(x,[25,75])},{meas_vars});
        stats_note = groupsummary(data{j},'analysis_id',...
            'mean',{note_vars});
        stats{j} = join(stats_meas,stats_note,"Keys","analysis_id");
        stats{j} = join(stats{j},ids_specs,'LeftKeys','analysis_id','RightKeys','analysis_id');
        
        stats{j}.id = seq + "_" + string(stats{j}.LabelID);
%         s = string(S_analysis.(seq).analysis_id)+", "+string(S_analysis.(seq).bl_id);
%         s = split(unique(s),', ');
%         t = table(categorical(s(:,1)),categorical(s(:,2)),'VariableNames',{'analysis_id','bl_id'});
%         stats{j} = join(stats{j},t,'Keys','analysis_id'); 
        stats{j}.pc.seq = repmat(string(seq),height(stats{j}),1);
    end
   
    stats = merge_table_blocks(stats);
    
    q1q3_vars = contains(stats.Properties.VariableNames,"fun1_");
    stats.Properties.VariableNames(q1q3_vars) = ...
        strrep(stats.Properties.VariableNames(q1q3_vars),"fun1_","q1q3_");
    stats = movevars(stats,{'id','analysis_id','bl_id','seq','LabelID',...
        'LevelLabel','CategoryLabel','Contingency','pumpSpeed','Catheter',...
        'balLev','FlowRedTarget'},'Before',1);
    stats.GroupCount_stats_meas = [];
    
  
%      rel_vars = stats.Properties.VariableNames(...
%          contains(stats.Properties.VariableNames,"std_"));
     