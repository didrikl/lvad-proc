function T = adjust_for_constant_time_offset(T,files_with_time_offset,offset_behind)
    
    welcome('Adjusting for constant time offset')
       
    if isempty(T)
        warning('Input data table %s is empty',inputname(1))
        return
    end

    [returnAsCell,T] = get_cell(T);
    
    if numel(offset_behind)==1
        offset_behind = repmat(offset_behind,1,numel(files_with_time_offset));
    elseif numel(offset_behind)~=numel(files_with_time_offset)
        warning(['Number of time offsets must equal the number of files',...
            'if multiple time offset are to be used']);
    end
    
    for i=1:numel(T)
        ii = find(ismember(T{i}.Properties.UserData.FileName,files_with_time_offset));
        if not(isempty(ii))
            display_block_varnames(T{i})
            fprintf('\nAdjusting %s\n',(offset_behind(ii(1))))
            T{i}.time = T{i}.time+offset_behind(ii(1));
        end
        
    end
    
    if not(returnAsCell), T = T{1}; end
    