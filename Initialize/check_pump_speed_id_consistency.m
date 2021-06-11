function inds = check_pump_speed_id_consistency(T)
    T.analysis_id(ismissing(T.analysis_id)) = '-';
    T.bl_id(ismissing(T.bl_id)) = '-';
    
    analysis_id = char(string(T.analysis_id));
    bl_id = char(string(T.bl_id));
    inds = bl_id(:,2)~=analysis_id(:,2);
    
    % ignore nominal recording intervals and intervals with only bl_id
    inds = inds & analysis_id(:,4)~='0' & analysis_id(:,1)~='-';
    
    if any(inds)
        fprintf('\n')
        warning(sprintf(...
            'Inconsistent pump speed id between analysis ID and baseline ID\n'))
        if nargout==0
            fprintf('\n')
            disp(T(inds,:))
        end
    end
