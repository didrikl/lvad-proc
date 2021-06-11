function F_rel = make_relative_feats(feats,vars)

    seqs = unique(feats.seq);
    F_rel = cell(numel(seqs),1);
    cols = startsWith(feats.Properties.VariableNames,vars+"_");
        
    for i=1:numel(seqs)
        feats_i = feats(feats.seq==seqs{i},:);
        feats_i_rel = feats_i;
        feats_i_rel{:,cols} = nan*feats_i_rel{:,cols};
        for j=1:height(feats_i)
            bl_row = find(feats_i.analysis_id==feats_i.bl_id(j));
            
            if isempty(bl_row)
                warning(sprintf(['Basline row not found',...
                    '\n\tRow where Analysis_id = bl_id = %s',...
                    '\n\tSequence: %s'],...
                    string(feats.bl_id(j)),string(seqs{i})));
                feats_i_rel{j,cols} = (feats_i{j,cols}-NaN);
            
%             elseif contains(string(feats_i.categoryLabel(j)),'Nominal')
%                 feats_i_rel{j,cols} = 0;%(feats_i{j,cols}-NaN);
            
            else
                bl_vals = feats_i{bl_row,cols};
                feats_i_rel{j,cols} = (feats_i{j,cols}-bl_vals)./bl_vals;
            end
            
        end
        F_rel{i} = feats_i_rel;
    end
    
    F_rel = merge_table_blocks(F_rel);
    F_rel = sortrows(F_rel,'id','ascend');
