function [line, n_rows_to_skip, first_record_found] = spool_to_status_ok(fid)

% Spool to first record with status="OK"
first_record_found = false;
n_rows_to_skip = 1;
while true
    
    %Read row
    line = fgetl(fid);
    
    if contains(line,'status="ok"')
        first_record_found = true;
        break
    end
    
    % Stop reading at the end of file
    if feof(fid) %~ischar(tline)
        warning('Reached end of file without any lines having status="OK"')
        break
    end
    
    n_rows_to_skip  = n_rows_to_skip +1;
    
end
