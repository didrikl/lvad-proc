function SS_rows = get_baseline_rows(T)
    
    % Get rows for 'baseline' and 'control baseline' intervals
    SS_rows = contains(lower(string(T.intervType)),{'baseline'});
    
end