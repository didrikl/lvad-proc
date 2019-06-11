function notes = init_notes_xlsfile(filename, read_path)
    if nargin==1, read_path = ''; end
    
    % TODO: Split this function into init and pre-proc functions??
    
    %% Input file format settings
    
    all_vars = {
        'date'
        'timestamp'
        'time_elapsed'
        'experimentPartNo'
        'experimentSubpart'
        'event'
        'thrombusVolume'
        'speedChangeRate'
        'dose'
        'pumpSpeed'
        'afferentPressure'
        'efferentPressure'
        'flow'
        'power'
        'comment'
        };
   
    % Use this to dynamically make note variable names (following Excel sheet)
    % all_vars =  matlab.lang.makeValidName(header,'ReplacementStyle','delete')
    % all_vars = cellfun(@(C) strrep(c(1),lower(c(1))), all_vars)
    
    % Defines what kind variables for each column, used for parsing
    % NOTE: If object-oriented, then should implement check for valid names
    num_cols = {
        'time_elapsed'
        'afferentPressure'
        'efferentPressure'
        'flow'
        'power'
        ...'thrombusVolume'
        'speedChangeRate'
        'pumpSpeed'
        }';
    cat_cols = {
        'experimentPartNo'
        'experimentSubpart'
        'event'
        'thrombusVolume'
        ...'speedChangeRate'
        'dose'
        ...'pumpSpeed'
        }';
    
    % Continuity definitions, e.g. used for populating non-matched rows when 
    % doing syncing/data fusion
    event_vars = {
        'event'
        'thrombusVolume'
        'dose'
        'afferentPressure'
        'efferentPressure'
        'flow'
        'power'
    };
    step_vars = {
        'experimentPartNo'
        'experimentSubpart'
        'speedChangeRate'
        'pumpSpeed'    
    };
    
    % Which variables are controlled or meassured, used for analysis
    controlled_vars = {    
        'thrombusVolume'
        'speedChangeRate'
        'dose'
        'pumpSpeed'
        };
    meassured_vars = {
        'afferentPressure'
        'efferentPressure'
        'flow'
        'power'
        };
    
    missing_value_repr = {'','-'};
    
    % Range to read (as named in the Excel file, c.f. Excel's 'name manager')
    notes_sheet_name = 'Notes';
    notes_range_name = 'Notes';
    notes_header_name = 'Header';
    
    
    experiment_info_sheet_name = 'Experiment';
    info_range_names = {
        'General_info'
        'Experiment_parts'
        'Technical_info'
        };
    
    protocol_sheet_name = 'Protocol';
    
    
    %% Initialize notes
    
    filepath = fullfile(read_path,filename);
    
    notes = readtable(filepath,...
        'Sheet',notes_sheet_name,...
        'Range',notes_range_name,...
        'ReadVariableNames',false,...
        'basic', true); 
    header_lines = readtable(filepath,...
        'Sheet',notes_sheet_name,...
        'Range',notes_header_name,...
        'ReadVariableNames',false,...
        'basic', true);  
    for i=1:numel(info_range_names)
        info.(info_range_names{i}) = readtable(filepath,...
            'Sheet',experiment_info_sheet_name,...
            'Range',info_range_names{i},...
            'ReadVariableNames',false,...
            'basic', true);
    end
    protocol = readtable(filepath,...
        'Sheet',protocol_sheet_name,...
        'ReadVariableNames',false);
    
    % Update and add variable metadata
    notes = standardizeMissing(notes, missing_value_repr);
    notes = addprop(notes,{'ControlledParam','MeassuredParam'},{'variable','variable'});
    notes.Properties.CustomProperties.ControlledParam = ismember(all_vars,controlled_vars);
    notes.Properties.CustomProperties.MeassuredParam = ismember(all_vars,meassured_vars);
    notes.Properties.UserData.info = info;
    notes.Properties.UserData.protocol = protocol;
    notes.Properties.VariableNames = all_vars; % header_lines{1,:}
    notes.Properties.VariableUnits = erase(header_lines{2,:},{'(',')'});
    notes.Properties.VariableDescriptions = header_lines{2,:};
    
    % Metadata used for populating non-matched rows when syncing/data fusion
    notes.Properties.VariableContinuity(step_vars) = 'step';
    notes.Properties.VariableContinuity(event_vars) = 'event';
    
    % Change the time representation, similar to the parsing of recorded data
    notes.timestamp = datetime(notes.timestamp,...
        'ConvertFrom','datenum',...
        'TimeZone','Europe/Oslo');
    
    % Store elapsed time as a Matlab duration vector
    % TODO: Check and decide if this is necessary 
    notes.time_elapsed = seconds(notes.time_elapsed);
    
    % Merge info from the date column into the timestamp before removing date column
    notes.timestamp.Day = notes.date.Day;
    notes.timestamp.Month = notes.date.Month;
    notes.timestamp.Year = notes.date.Year;
    
    % Derive the time column that was not in use when making the notes
    if all(isnan(notes.time_elapsed))
        notes.time_elapsed = seconds(notes.timestamp - notes.timestamp(1));
    elseif all(isnat(notes.timestamp))
        notes.timestamp = datetime(notes.time_elapsed,'ConvertFrom','epochtime',...
            'Epoch',notes.date(1));
    end
    
    % Parse relevant columns to numerical or to categorical
    for j=1:numel(all_vars)
        if ismember(all_vars{j},cat_cols)
            notes.(all_vars{j}) = categorical(notes{:,j});
        end
        if ismember(all_vars{j},num_cols)
            notes.(all_vars{j}) = str2double(strrep(string(notes{:,j}),'-',''));
        end
    end
    
    
    %% Add/remove columns and convert to timetable
    
    notes = add_event_range(notes);
    
    n_header_lines = 3;
    notes = add_note_row_id(notes, n_header_lines);
    
    % Convert to timetable with timestamp as the time column
    notes.date = [];
    notes = table2timetable(notes);
    
    
function notes = add_event_range(notes)
    % Add info about how long the events are running. Two new columns are made,
    % one column for event end time and one column with subscripts for timerange 
    % extractions in timetables.
    %
    % The rule of thumb is that is run until next noted event in the notes.
    % Exceptions are made for events with the key word 'start', which is
    % presumed to be running in parallell until end of experiement or until a
    % similar pairing counterpart event having the key word 'end' instead of
    % 'start'.
    
    n_notes = height(notes);
    
    % Timestamp for when event is considered to be finished. Having this column
    % allows for parallell events running.
    notes.event_end = cell(n_notes,1);
    
    % Subscripts to extract ranges in timetables, just for convenience. It can
    % be also used to quickly view the timerange, but has no other usage. 
    notes.event_timerange = cell(n_notes,1);
    
    event_inds = find(notes.event~='-' & not(ismissing(notes.event)));
    for i=1:numel(event_inds)
        
        % Applying the rule of thomb
        ii = event_inds(i);
        event_stop_ind = ii+1;
        
        % Include steady state as part of the preceeding event/intervention
        while contains(string(notes.experimentSubpart(event_stop_ind)),...
            {'steady-state','steady state'}) && event_stop_ind<n_notes
            event_stop_ind = event_stop_ind+1;
        end
                
        % Handle events that will run i parallell
        event = string(notes.event(ii));
        if contains(event,'start','IgnoreCase',true)
            
            % Search for pairing end of event note
            remaining_events = string(notes.event(ii+1:end));
            event_stop_name = strrep(event,'start','end');
            event_stop_ind = find(remaining_events==event_stop_name,1,'first')+ii;
            
            % No pairing event implies running until the end
            if isempty(event_stop_ind)
                event_stop_ind = n_notes;
            end
            
        end
        
        % Make the timerange
        if ii<n_notes
            end_time = notes.timestamp(event_stop_ind);
        else
            end_time = datetime(inf,'ConvertFrom','datenum','TimeZone','Etc/UTC');
        end
        notes.event_timerange{ii} = timerange(notes.timestamp(ii),end_time,'open');
        notes.event_endTime(ii) = end_time;
        
        
    end
    
function notes = add_note_row_id(notes, n_header_lines)
    % Add note row ID, useful when merging with sensor data
    notes.noteRow = (1:height(notes))'+n_header_lines';
    notes = movevars(notes, 'noteRow', 'Before', 'time_elapsed');
    notes.Properties.VariableContinuity('noteRow') = 'step';
    