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
    
    