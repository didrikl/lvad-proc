function T = split_table_into_parts(T)
    
    fprintf('\nSplitting signal into sequence parts\n')
    parts = sort_nat(unique(string(S.part(not(ismissing(S.part))))));
    parts(strcmp(parts,'-')) = [];
    n_parts = max(double(parts));
    S_parts = cell(n_parts,1);
    for i=1:n_parts
        fprintf('\tPart %s\n',parts{i})
        S_parts{i} = S(S.part==parts(i),:);
    end
    fprintf('\nDone.\n')