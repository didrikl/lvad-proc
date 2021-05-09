function stats = make_stats(ids,seqs,S_analysis,vars,std_vars)
    stats = table;
    stats.IntervID = repmat("",numel(ids)*numel(seqs),1);
    stats.Seq = repmat("",numel(ids)*numel(seqs),1);
    stats.ID = repmat("",numel(ids)*numel(seqs),1);
    stats.PumpSpeed = cellstr(repmat("",numel(ids)*numel(seqs),1));
    
    welcome('Calculate stats','function')
    
    for k=1:numel(vars)
        fprintf('\nVariable: %s\n',vars{k})
        avg_col = nan(height(stats),1);
        std_col = nan(height(stats),1);

        jj=1;
        for i=1:numel(ids)
            
            for j=1:numel(seqs)
                
                S = S_analysis.(seqs{j});
                inds = S.analysis_id==ids(i);
                
                avg_col(jj) = mean(S.(vars{k})(inds),'omitnan');
                if ismember(vars{k},std_vars)
                    std_col(jj) = std(S.(vars{k})(inds),'omitnan');
                end
                
                if k==1
                    stats.ID(jj) = string(ids(i))+" "+string(seqs{j});
                    stats.Seg(jj) = string(seqs{j});
                    stats.IntervID(jj) = string(ids(i));
                    stats.PumpSpeed{jj} = num2str(unique(S.pumpSpeed(inds)));
                end
                
                jj = jj+1;
                
            end
            
        end
        
        stats.(vars{k}) = avg_col;
        if ismember(vars{k},std_vars)
            stats.([vars{k},'_std']) = std_col;
        end
                
    end
    
end