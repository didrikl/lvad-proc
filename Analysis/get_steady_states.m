function T = get_steady_states(T)
    
    T(contains(lower(string(T.intervType)),{'baseline','steady'}),:)
    
end