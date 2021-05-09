function [start_inds, end_inds, rpm_vals] = find_rpm_blocks(T)
    if height(T)==0
        start_inds = 0;
        end_inds = 0;
        rpm_vals = nan;
        return
    end
    if iscategorical(T.pumpSpeed) 
        T.pumpSpeed = double(string(T.pumpSpeed));
    end
    
    end_inds = [find(diff(T.pumpSpeed));height(T)];
    start_inds = [1;end_inds(1:end-1)+1];
    rpm_vals = T.pumpSpeed(start_inds);
    if numel(rpm_vals)>1
        fprintf(['Multiple blocks of RPM in signal part:\n\tRPM values: ',...
            '%s\n'],mat2str(unique(rpm_vals)));      
    end
    
    nan_rpm = isnan(rpm_vals);
    start_inds = start_inds(not(nan_rpm));
    end_inds = end_inds(not(nan_rpm));
    rpm_vals = rpm_vals(not(nan_rpm));