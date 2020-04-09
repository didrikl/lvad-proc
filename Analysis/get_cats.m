function cats = get_cats(T,var)
    % Extract categories of variables in a table, in a naturally sorted order.
    
    if iscategorical(T.(var))
        cats = sort_nat(cellstr(categories(T.(var))));
    else
        cats = sort_nat(cellstr(string(unique(T.(var)))));
        warning(sprintf(['\n\t%s is not categorical.',...
                '\n\t(Color order when plotting may vary)\n'],var));
    end