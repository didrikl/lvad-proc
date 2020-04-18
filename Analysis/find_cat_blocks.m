function [blocks,vars] = find_cat_blocks(T,vars,sampleRate)
    % Find block ranges for a set of variables that can be treated as
    % categorical (converted to categorical if not already categorical.) 
    % 
    % It will assume regular sampling rate can be applied to the whole of T 
    % (even if was clipped and merged, and thus have gaps causing incoherent 
    % time steps). 
    % 
    % Output:
    %  blocks: Block ranges stored in a struct. 
    %     The struct contains the fields:
    %
    %        start_durSec{i,j,j}
    %           Block start time in duration seconds (stored as double) of
    %           variable index i, value j from the categorical value set (with
    %           ununsed categories removed) ane block number j
    %
    %        end_durSec{i,j,j}
    %           Block end time in the same representation as with start_durSec
    %
    %        start_inds
    %           Start time in duration seconds (stored as double) of the
    %           combined blocks of all given categories and their values
    %
    %        end_inds
    %           End time in duration seconds (stored as double) of the
    %           combined blocks of all given categories and their values
    %
    
    
    if nargin<3, [sampleRate, T] = get_sampling_rate(T); end
    blocks = struct;
    if height(T)==0, return; end
    
    vars = check_var_input_from_table(T,vars);
    vars = cellstr(vars);
    vars = vars(not(cellfun(@isempty,vars)));
    
    dur = linspace(0,1/sampleRate*height(T),height(T))';
    
    for i=1:numel(vars)
        
        cats = get_cats(T,vars{i});
        for j=1:numel(cats)
            
            if not(iscategorical(T.(vars{i})))
                T.(vars{i}) = categorical(T.(vars{i}));
            end
            times = dur(T.(vars{i})==cats(j));

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
   