function cats = get_cats(T,var)
    if iscategorical(T.(var))
        cats = sort_nat(cellstr(categories(T.(var))));
    else
        cats = sort_nat(cellstr(string(unique(T.(var)))));
        warning(sprintf(['\nVariable %s is not categorical.',...
                'Color order when plotting may vary\n',var]));
    end