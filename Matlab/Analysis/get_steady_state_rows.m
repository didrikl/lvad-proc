function SS_rows = get_steady_state_rows(T)
    
    SS_rows = contains(lower(string(T.intervType)),{'baseline','steady'});
    
end