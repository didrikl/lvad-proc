function [blocks,vars] = find_cat_blocks(T,vars)
    
    blocks = struct;
    if height(T)==0, return; end
    
    vars = check_var_input_from_table(T,vars);
    vars = cellstr(vars);
    vars = vars(not(cellfun(@isempty,vars)));
    
    for i=1:numel(vars)
        
        cats = get_cats(T,vars{i});
        for j=1:numel(cats)
            
            if not(iscategorical(T.(vars{i})))
                T.(vars{i}) = categorical(T.(vars{i}));
            end
            times = T.dur(T.(vars{i})==cats(j));

            if numel(times)==0
                blocks.start_durSec{i,j,1} = [];
                blocks.end_durSec{i,j,1} = [];
                continue; 
            end
            
            start_inds = [1;find( diff(times)>1 )+1];
            end_inds = [start_inds(2:end)-1;numel(times)];
            for k=1:numel(start_inds)
                blocks.start_durSec{i,j,k} = times(start_inds(k));
                blocks.end_durSec{i,j,k} = times(end_inds(k));
            end
            
        end
        
    end
    
    % Find block ranges combined for all categoric variables in vars
    blocks = find_cat_val_blocks(T,blocks);
    
    
function blocks = find_cat_val_blocks(T,blocks)
    
    block.start_times = unique([blocks.start_durSec{:,:,:}]);
    block.end_times = unique([blocks.end_durSec{:,:,:}]);
    blocks.start_inds = nan(numel(block.start_times),1);
    blocks.end_inds = nan(numel(block.end_times),1);
    for i=1:numel(block.start_times)
        blocks.start_inds(i) = find(T.dur==block.start_times(i));
        blocks.end_inds(i) = find(T.dur==block.end_times(i));
    end
   