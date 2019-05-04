function signal = init_powerlab_raw_matfile(filename,read_path)
    % INIT_POWERLAB_RAW_MATFILE
    % Read and parse data exported as mat file from PowerLab's LabChart
    % program.
    %
    % Convert from one single array of data to a (2-D) to a matlab timetable.
    % Additional metadata is parsed and stored with the timetable properties.
    %
    % Usage:
    %     timetable(filename,read_path), where read_path is optional.
    %
    % See also timetable
    
    if nargin==1
        % Default reading path. (Could also e.g. be set by user.) 
        read_path = '';
    end
    
    % Default viewing format of timestamps (not very important)
    timestamp_fmt = 'dd-MMM-uuuu HH:mm:ss.SSS';
    
    % Read data with variable organized and accessible in a struct d
    raw = load('-mat', fullfile(read_path,filename));
    
    % Parse raw metadata that are needed
    [n_vars,n_intervals] = size(raw.datastart);
    varnames = genvarname(string(raw.titles));
    [col_unit,interv_units] = make_unit_string_arr(raw);
    interv_lengths = raw.dataend-raw.datastart;
    interv_start_timestamps = datetime(raw.blocktimes,...
        'ConvertFrom','datenum',...
        'Format',timestamp_fmt);
    % TODO: Implement storing of comments/flags
    % NOTE: Must figure out how PowerLab stores comments/flags

    wait_complete = sum(sum(interv_lengths));
    wait_progress = 0;
    h_wait = waitbar(wait_progress,'Reading raw data');    
    
    for j=1:n_vars
        
        % Make each variable recorded as a timetable
        col = timetable;
        
        % Display warning: It will be an issue if the sample rates is not
        % equal between the different variables, until resampling is
        % implementet below
        if any(diff(raw.samplerate(j,:)))
            warning(['Sample rates is not constant for all recording ',...
                'intervals for variable ',varnames{j}])
        end
        
        for i=1:n_intervals
            
            % Append column with new interval. There is no need to resample if
            % the sample rates for each interval is not constant.
            col_interv = raw.data(raw.datastart(j,i):raw.dataend(j,i))';           
            col_interv = timetable(col_interv,...
                'SampleRate',raw.samplerate(j,i),...
                'VariableNames',varnames(j),...
                'StartTime',interv_start_timestamps(i));
            col = [col;col_interv];
            
            % Update progress represented in no of samples in the interval
            wait_progress = wait_progress+(interv_lengths(j,i)/wait_complete);
            waitbar(wait_progress,h_wait,'Reading raw data');
            
        end
        
        % Setting variable behaviour for merging and resampling
        col.Properties.VariableContinuity = {'continuous'};
        
        % Append signal with new column. This requires that the samplerate for
        % each variable to be the same (at each separate interval).
        if j>1
            signal = append_signal_variable_column(signal,col,...
                raw.samplerate(j-1,:),raw.samplerate(j,:),varnames{j});
        else
            signal = col;
        end

    end
    
    % Variable metadata
    signal.Properties.VariableUnits = col_unit;
    signal.Properties.VariableDescriptions = cellstr(raw.titles);
    
    % Store various/unstructured info (start with initializing standard info)
    signal.Properties.UserData = make_init_userdata(filename,read_path);
    signal.Properties.UserData.interv_start_timestamps = interv_start_timestamps;
    signal.Properties.UserData.interv_units = interv_units;
    
    close2(h_wait)
  
function signal = append_signal_variable_column(signal,col,...
        signal_samplerates, col_samplerates, varname)
    % Compare signal and new variable column samplerates at each recording
    % interval and compare the number of rows. If samplerates and number of rows
    % are matching, then simply append new colum to the signal (the quicker
    % method). If non-matching, then syncronization must be applied (the slower
    % method).
    if not(any(diff([signal_samplerates;col_samplerates]))) ...
            && height(signal)==height(col)
        signal(:,varname) = col;
    else
        % TODO: Consider using retime if samplerate differs, before appending.
        % This requires some procedure to decide which samplerate to use, e.g.
        % max or min samplerate. Or, find a better method....
        signal = synchronize(signal,col);
    end

function [col_units,interv_units] = make_unit_string_arr(raw)
    % Make a string array of units, for each variable and interval. Start user
    % interaction if intervals units are not consistent for each variable.
    unittextmap = raw.unittextmap;
    unittext = string(raw.unittext);
    vars = cellstr(raw.titles);
      
    [n_vars,n_interv] = size(unittextmap);
    interv_units = repmat("",n_vars,n_interv);
    col_units = repmat("",n_vars,1);
    for j=1:n_vars
        
        % Look up unit for each interval, if given
        for i=1:n_interv  
            if unittextmap(j,i)>0
                interv_units(j,i) = unittext(unittextmap(j,i));
            end
        end

        % Find/determine unit for the whole signal variable column
        var_unit_no = unique(unittextmap(j,:));
        if numel(var_unit_no)>1

            warning(['Muliple units used for variable ',vars{j},'.'])
            
            % If different units at different intervals, then user must decide how
            % to handle this for the one column containing all recording intervals   
            units_in_use = char(interv_units(var_unit_no(var_unit_no>0)));
            options = {
                units_in_use
                'Ignore, use no units'
                'Type new unit'
                };
            opt = ask_list_ui(options,'Set variable unit');
            if opt<=numel(options)-2
                col_units(j) = unittext(opt);
            elseif opt==numel(options)-1
                col_units(j) = '';
            elseif opt==numel(options)
                col_units(j) = string(input('Type unit --> ','s'));
            end
      
        else

            % Use the uniquely found unit for all recording intervals
            col_units(j) = unittext(var_unit_no);
       
        end
    
    end
