function [T,raw] = init_cardiaccs_raw_txtfile(fileName,read_path, accVarName)
    
    if nargin<3
        accVarName='acc';
    end
    
    filePath = fullfile(read_path,fileName);
    display_filename(fileName,read_path,'\nReading Cardiaccs text file input')
    %raw= read_cardiaccs_raw_txtfile_parfor(filePath);
    raw = read_cardiaccs_raw_txtfile(filePath);
    
    % Unfold to one row per acc registration and type conversions
    T = parse_cardiaccs_raw(raw);
    
    % Let time be represented as datetime (timestamp) and convert to timetable
    % where the timestamp is not a variable, but an internal row id. Timetable
    % have built-in methods for signal processing
    % NOTE: Move this into parse_cardiaccs_raw .m-file?
    T = make_signal_timetable(T);
    
    T.Properties.VariableNames{'acc'}  = accVarName;
    
function raw = read_cardiaccs_raw_txtfile(filePath)
    
    % Open file and go to first line with a status="ok" record
    fid = fopen(filePath, 'r');
    [row, n_skipped_rows] = spool_to_status_ok(fid);
    
    % Estimate of no. lines per file size in kb, pluss 5 percent
    lines_per_kb = 1274174 / 246143;
    s = dir(filePath);
    filesize_in_kb = s.bytes/1024;
    n_lines_approx = round(1.05*lines_per_kb*filesize_in_kb);
    
    % Subtract already read lines by the spool_to_status function and preallocate
    n_lines_approx = n_lines_approx - n_skipped_rows;
    raw = cell(n_lines_approx,5);
    
    end_of_file = false;
    h_wait = waitbar(0,'Reading raw data');
    
    % Splitting up the reading into bulks, so that we may have a farily adquate
    % progress waitbar. The bulk size can be adjusted in the bulk_step parameter.
    bulk_step = 20000;
    for j=1:bulk_step:n_lines_approx
        
        % Stop if end of file was detected within the current bulk of rows below
        if end_of_file
            break
        end
        
        % Within the bulk of rows, read one-by-one
        for i=j:j+bulk_step-1
            
            % If not end of file, split the line into line entries
            if feof(fid)
                end_of_file = true;
                break;
            end
            row = split(row(4:end-2),'" ')';
            
            % Store frame and t
            raw{i,1} = row{2}(8:end);
            raw{i,2} = row{3}(4:end);
            
            % Skip storing meassurements if status is not OK. Empty placeholders is
            % used instead, as preallocated above
            if strcmp(row{4}(9:10),'ok')
                
                % Store adcscale, accscale, adc, acc (in that order)
                raw{i,3} = row{7}(11:end);
                raw{i,4} = row{8}(11:end);
                raw{i,5} = row{9}(6:end);
                raw{i,6} = row{10}(6:end);
                
            end
            
            % Init next row
            row = fgetl(fid);
            
        end
        
        waitbar(j/n_lines_approx,h_wait)
    end
    fclose(fid);
    
    % Remove extra preallocated rows, if any
    overshooting_inds = cellfun(@isempty,raw(:,1));
    raw(overshooting_inds,:) = [];
    
    raw = cell2table(raw,...
        'VariableNames',{'frame','t','adcscale','accscale','adc','acc'});
    
    % Add info for built-in table properties
    raw = add_cardiaccs_raw_variable_properties(raw);
    raw.Properties.UserData = make_init_userdata(filePath);
    
    close(h_wait)
    
function raw = read_cardiaccs_raw_txtfile_parfor(filePath)
    
    % Open file and go to first line with a status="ok" record
    fid = fopen(filePath, 'r');
    [first_row, n_skipped_rows] = spool_to_status_ok(fid);
    
    % no of lines / size in kb
    lines_per_kb = 1274174 / 246143;
    s = dir(filePath);
    filesize_in_kb = s.bytes/1024;
    n_lines_approx = round(2*lines_per_kb*filesize_in_kb);
    n_lines_approx = n_lines_approx - n_skipped_rows;
    
    lines = cell(n_lines_approx,1);
    lines{1} = first_row;
    i = 1;
    while true
        
        % If not end of file, split the line into line entries
        if feof(fid), break; end
        
        % Init next row
        i = i+1;
        lines{i} = fgetl(fid);
        
    end
    fclose(fid);
    
    % Remove extra preallocated rows, if any
    overshooting_inds = cellfun(@isempty,lines);
    lines(overshooting_inds,:) = [];
    
    
    n_lines = numel(lines);
    raw_adcscale = cell(n_lines,1);
    raw_accscale = cell(n_lines,1);
    raw_adc = cell(n_lines,1);
    raw_acc = cell(n_lines,1);
    raw_t = cell(n_lines,1);
    raw_frame = cell(n_lines,1);
    
    parfor i=1:n_lines
        row = split(lines{i}(4:end-2),'" ')';
        
        % Store frame and t
        raw_frame{i} = row{2}(8:end);
        raw_t{i} = row{3}(4:end);
        
        % Skip storing meassurements if status is not OK. Empty placeholders is
        % used instead, as preallocated above
        if strcmp(row{4}(9:10),'ok')
            
            % Store adcscale, accscale, adc, acc (in that order)
            raw_adcscale{i} = row{7}(11:end);
            raw_accscale{i} = row{8}(11:end);
            raw_adc{i} = row{9}(6:end);
            raw_acc{i} = row{10}(6:end);
            
        end
        
    end
    
    raw = table(raw_frame, raw_t, raw_adcscale, raw_accscale, raw_adc, raw_acc,...
        'VariableNames',{'frame','t','adcscale','accscale','adc','acc'});
    
    raw = add_cardiaccs_raw_variable_properties(raw);
    raw.Properties.UserData = make_init_userdata(filePath);
    
function signal = parse_cardiaccs_raw(raw, include_adc)
    
    % Default is to exclude adc signal, assumed it is not in use/been recorded
    if nargin==1, include_adc= false; end
        
    % Vectorized parsing of regular numric data (to be used in for-loop below)
    t_raw = str2doubleq(raw.t);
    
    % Calculate elapsed time between each row (repeat the last dt, instead of
    % using nan)
    dt_raw = [diff(t_raw);t_raw(end)-t_raw(end-1)];
    
    % Drop rows to avoid multiple time values
    % (the simple solution as apposed to calculating an average)
    [dt_raw,t_raw,raw] = drop_duplicate_time_rows(dt_raw,t_raw,raw);
    
    % Assume constant scales
    adc_scale = raw.adcscale{1};
    acc_scale = raw.accscale{1};
    
    % Split acc into separate 3-tuple records
    acc_records = regexp(raw.acc,'(-?\d*,-?\d*,-?\d*)','tokens');
    
    % Separate function (for loops) for wether to include adc, which will save
    % processing time and memory when adc is excluded.
    if not(include_adc)
        [t,acc] = unfold(t_raw,dt_raw,acc_records);
    else
        adc_raw = str2doubleq(raw.adc).*str2doubleq(adc_scale);
        [t,acc,adc] = unfold_include_adc(t_raw,dt_raw,acc_records,adc_raw);
    end
    
    % Convert to from string to 1x3 numeric array, scaled to gravational units
    acc = double(split(string(cellfun(@char,acc,'UniformOutput',false)),','));
    
    % Convert to units in given scale in acc_scale (vector or scalar)
    acc = acc.*str2doubleq(acc_scale);
    
    % Make a new table for all signal data
    signal = table(t,acc);
    signal.Properties.UserData = raw.Properties.UserData;
    signal.Properties.VariableDescriptions{'acc'} = '3-component acceleration vector';
    signal.Properties.VariableUnits{'acc'} = 'g';
    if include_adc
        signal.adc = adc;
        signal.Properties.VariableDescriptions{'adc'} = 'ECG';
        signal.Properties.VariableUnits{'adc'} = 'mV';
    end

function [dt_raw,t_raw,raw] = drop_duplicate_time_rows(dt_raw,t_raw,raw)
    % Drop rows to avoid multiple time values, except for the last of each
    % set of mulitple time rows.
    
    row_drop_ind = dt_raw==0;
    n_row_drop = sum(row_drop_ind);
    dt_raw(row_drop_ind) = [];
    t_raw(row_drop_ind) = [];
    raw(row_drop_ind,:) = [];
    fprintf('\nDropped %d rows (%2.1g pst) with duplicate time values.\n',...
        n_row_drop,n_row_drop/height(raw));
    
    
function [t,acc] = unfold(t_raw,dt_raw,acc_records)

    [n_records,end_inds,start_inds,n_rows] =  find_unfold_distr(acc_records);
       
    t = nan(n_rows,1);
    acc = cell(n_rows,1);
    
    tstep_vec = dt_raw./n_records;
    
    for i=1:numel(t_raw)
        
        % New row indices for the "unfolded" data corresponding to raw data row i
        inds = start_inds(i):end_inds(i);
        
        % Local time step for linear interpolation for t, until next row
        t(inds) = t_raw(i) + (0:tstep_vec(i):dt_raw(i)-tstep_vec(i))';
        
        % One-by-one assignment of acc records over each index in inds
        acc(inds) = acc_records{i}';
        
    end
  
function [t,acc,adc] = unfold_include_adc(t_raw,dt_raw,acc_records,adc_raw)

    [n_records,end_inds,start_inds,n_rows] =  find_unfold_distr(acc_records);
           
    t = nan(n_rows,1);
    acc = cell(n_rows,1);
    adc = cell(n_rows,1);
    for i=1:numel(t_raw)
        
        % New row indices for the "unfolded" data corresponding to raw data row i
        inds = start_inds(i):end_inds(i);
        
        % Linear interpolation for t, until next row
        tstep = dt_raw(i)/n_records(i);
        t(inds) = t_raw(i) + (0:tstep:dt_raw(i)-tstep)';
        
        % One-by-one assignment of acc records over each index in inds
        acc(inds) = acc_records{i}';
        
        % Step-wise repeated assignment for each index in inds
        adc(inds) = adc_raw(i);

    end
    
function [n_records,end_inds,start_inds,n_rows] = find_unfold_distr(acc_records)
    
    % Pre-allocate set of indices for each set of acc records
    n_records = cellfun(@(c)size(c,2),acc_records);
    end_inds = cumsum(n_records);
    start_inds = [1;end_inds(1:end-1)+1];
    
    % Pre-allocate unfolded varibles, in accordance to one row per acc record
    n_rows = sum(n_records);
    
    
