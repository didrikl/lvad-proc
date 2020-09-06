function blocks = find_cat_block_inds(T,cat_vars)
    
    if height(T)==0, return; end
    
    vars = check_var_input_from_table(T,cat_vars);
    vars = cellstr(vars);
    vars = vars(not(cellfun(@isempty,vars)));
    
    c = join(string(T{:,vars}));
    blocks = table;
    end_inds = [find(c(1:end-1)~=c(2:end));numel(c)];
    blocks.start_inds = [1;end_inds(1:end-1)+1];
    blocks.end_inds = end_inds;
    
    %blocks.categories = T{blocks.start_inds,vars};
    %blocks(:,vars) = T(blocks.start_inds,vars)
    T = timetable2table(T);
    blocks.block_categories = T(blocks.start_inds,vars);
    
    if nargout==0
        f = get(0,'Format');
        format long
        blocks
        format(f)
    end
    