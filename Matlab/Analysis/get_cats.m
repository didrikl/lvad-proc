function cats = get_cats(T,var,ignoreUnused)
    % Extract categories of variables in a table, in a naturally sorted order.
    
    if nargin<3, ignoreUnused = false; end
    
    if iscategorical(T.(var))
    
        if ignoreUnused
            cats = sort_nat(categories(removecats(T.(var))));
        else
            cats = sort_nat(categories(T.(var)));
        end
    else
        cats = sort_nat(cellstr(string(unique(T.(var)))));
        warning(sprintf(['\n\t%s is not categorical.',...
                '\n\t(Color order when plotting may vary)\n'],var));
    end