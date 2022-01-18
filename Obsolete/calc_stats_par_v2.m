function stats = calc_stats_par(ids_specs,id_col,seqs,S_analysis,...
        vars,spread_vars,bandpow_vars)
    
    ids_specs = ids_specs(1:50,:);
    ids = ids_specs.(id_col);
    
    nRows = numel(ids)*numel(seqs);
    e = categorical(repmat(missing,nRows,1));
    stats = table(e,e,e,e,e,e,e,'VariableNames',{'spssID','analysis_id',...
        'Seq','CategoryLabel','pumpSpeed','Catheter','FlowRedTarget'});
    
%     stats.IntervID = repmat("",numel(ids)*numel(seqs),1);
%     stats.Seg = cellstr(repmat("",height(stats),1));
%     stats.ID = repmat("",numel(ids)*numel(seqs),1);
%     stats.CategoryLabel = cellstr(repmat("",numel(ids)*numel(seqs),1));
%     stats.pumpSpeed = cellstr(repmat("",numel(ids)*numel(seqs),1));
%     stats.Catheter = cellstr(repmat("",numel(ids)*numel(seqs),1));
%     stats.FlowRedTarget = cellstr(repmat("",numel(ids)*numel(seqs),1));
%     stats.balLev = cellstr(repmat("",numel(ids)*numel(seqs),1));
    
    welcome('Calculate stats','function')
    
    
    % TODO: Make parfor 
    avg_cols = cell(numel(vars),1);
    std_cols = cell(numel(vars),1);
    q1_cols = cell(numel(vars),1);
    q3_cols = cell(numel(vars),1);
    
    parfor k=1:numel(vars)
        fprintf('\nVariable: %s\n',vars{k})
        avg_col = nan(height(stats),1);
        std_col = nan(height(stats),1);
        med_col = nan(height(stats),1);
        q1_col = nan(height(stats),1);
        q3_col = nan(height(stats),1);
        %iqr_col = nan(height(stats),1);
        %prct10_col = nan(height(stats),1);
        %prct90_col = nan(height(stats),1);
        bp_col = nan(height(stats),1);
        mpf_col = nan(height(stats),1);
        
        jj=1;
        var = vars{k};
        for i=1:numel(ids)
            
            for j=1:numel(seqs)
                S = S_analysis.(seqs{j});
                inds = S.analysis_id==ids(i);
                
                avg_col(jj) = mean(S.(var)(inds),'omitnan');
                if ismember(var,spread_vars)
                    std_col(jj) = std(S.(var)(inds),'omitnan');
                    med_col(jj) = median(S.(var)(inds),'omitnan');
                    
                    percentiles = prctile(S.(var)(inds),[25,75]);
                    q1_col(jj) = percentiles(:,1);
                    q3_col(jj) = percentiles(:,2);
                    %percentiles = prctile(S.(vars{k})(inds),[25,75,10,90]);
                    %iqr_col(jj) = diff(percentiles);
                    %prct10_col(jj) = percentiles(:,3);
                    %prct90_col(jj) = percentiles(:,4);
                end
                
                if ismember(var,bandpow_vars)
                    fs = 750;
                    freqRange = [1,6]*ids_specs.pumpSpeed(i)/60;
                    if isfinite(freqRange)
                        x = S.(var)(not(isnan(S.(var))));
                        %jj
                        [mpf,bp] = meanfreq(x,fs,freqRange);
                        bp_col(jj) = bp;
                        mpf_col(jj) = mpf;
                    end
                end
                
%                 if k==1
%                     stats.ID(jj) = string(ids(i))+" "+string(seqs{j});
%                     stats.Seg{jj} = string(seqs{j});
%                     stats.IntervID(jj) = string(ids(i));
%                     stats.CategoryLabel{jj} = string(ids_specs.CategoryLabel(i));
%                     stats.pumpSpeed{jj} = string(ids_specs.pumpSpeed(i));
%                     stats.Catheter{jj} = string(ids_specs.Catheter(i));
%                     stats.FlowRedTarget{jj} = string(ids_specs.FlowRedTarget(i));
%                     stats.balLev{jj} = string(ids_specs.balLev(i));
%                 end
                
                jj = jj+1;
                
            end
            
        end
        
        avg_cols{k} = avg_col;
        if ismember(vars{k},spread_vars)
            std_cols{k} = std_col;
            q1_cols{k} = q1_col;
            q3_cols{k} = q3_col;
        end
%         if ismember(vars{k},bandpow_vars)
%             stats.([vars{k},'_bp']) = bp_col;
%             stats.([vars{k},'_mpf']) = mpf_col;       
%         end
        
        
%         stats.(vars{k}) = avg_col;
%         if ismember(vars{k},spread_vars)
%             stats.([vars{k},'_std']) = std_col;
%             stats.([vars{k},'_med']) = std_col;
%             stats.([vars{k},'_q1']) = q1_col;
%             stats.([vars{k},'_q3']) = q3_col;     
%         end
%         if ismember(vars{k},bandpow_vars)
%             stats.([vars{k},'_bp']) = bp_col;
%             stats.([vars{k},'_mpf']) = mpf_col;       
%         end
        
    end
    
%     stats.IntervID =  categorical(stats.IntervID);
%     stats.Seg = categorical(stats.Seg);
%     stats.CategoryLabel = categorical(stats.CategoryLabel);
%     stats.pumpSpeed = categorical(stats.pumpSpeed);
%     stats.Catheter = categorical(stats.Catheter);
%     stats.FlowRedTarget = categorical(stats.FlowRedTarget);
%     stats.balLev = categorical(stats.balLev);
    
end