function TT = handle_nonchronological_order(TT)
    % Function is under develeopment
    
    for i=1:numel(TT)-1
        
        if isempty(TT{i}), continue; end
        
        if TT{end}.time(1)<TT{i}.time(1)
            warning('Non-chronological file order detected')
        end
    end