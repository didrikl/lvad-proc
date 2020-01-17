function notes = init_notes_xlsfile_v3_2(filename, read_path)
    % 
    % Read named ranges from Notes Excel file. Ranges must be defined by Excel
    % name manager. (Named ranges make the Excel file more flexible w.r.t.
    % changes, but should be double checked.)
    %
    % Column that consists of empty / undefined values are not stored in the
    % notes table
    
    % Sheets and ranges to read from Excel sheet (tab names in Excel)
    notes_sheet = 'Notes';
    notes_range = 'Notes';
    varsNames_controlled_range = 'Controlled_VarNames';
    varNames_measured_range = 'Measured_VarNames';
    varNames_range = 'Header_VarNames';
    varUnits_range = 'Header_VarUnits';
    
    seqInfo_equip_sheet = 'Equipment';       
    seqInfo_equip_range = 'Equipment';
    
    seqInfo_sheet = 'Sequence description';
    seqInfo_parts_range = 'Sequence_Part_Descriptions';
    seqInfo_general_range = 'Sequence_General_Info';
    
    % * Name in Excel: Must match the name in Excel, but can be changed easily.
    % * Name Matlab code: Static variable name used in code. Must be valid a
    %   variable name.
    % * Type is used for parsing data from Excel into notes Matlab table
    % * Continuity is a status property, particularily useful when merging with 
    %   recorded data, c.f. timetable VariableContinuity documentation.  
    excel_matlab_var_map = {    
        ...   
        % Name in Excel            Name Matlab code     Type          Continuity
        'Date'                     'date'               'cell'        'unset'
        'Timestamp'                'timestamp'          'cell'        'unset'
        'Elapsed time'             'time_elapsed'       'numeric'     'unset'
        'Dur'                      'event_duration'     'numeric'     'event'
        'Part'                     'seq_part'           'categoric'   'step'
        'Interval type'            'intervType'         'categoric'   'step'
        'Event'                    'event'              'categoric'   'event'
        'Thrombus volume'          'thrombusVolume'     'categoric'   'step'
        'Speed change rate'        'speedChangeRate'    'categoric'   'step'
        'Dose'                     'dose'               'categoric'   'step'
        'Pump speed'               'pumpSpeed'          'categoric'   'step'
        'Balloon level'            'balloonLevel'       'categoric'   'step'
        'Balloon offset'           'balloonOffset'      'categoric'   'step'
        'Catheter type'            'catheterType'       'categoric'   'step'
        'Clamp flow reduction'     'flowReduction'      'categoric'   'step'
        'Afferent pressure'        'afferentPressure'   'numeric'     'event'
        'Effenrent pressure'       'efferentPressure'   'numeric'     'event'
        'Flow estimate'            'flow'               'numeric'     'event'
        'Power'                    'power'              'numeric'     'event'
        'Unclamped baseline flow'  'unclampFlow'        'numeric'     'step'
        'Comment'                  'comment'            'cell'        'event'
        ...
        };

    % TODO: For OO
    missing_value_repr = {'','-','NA','N/A'};

    %% Read from Excel file
    
    % TODO: For OO...
    if nargin==1, read_path = ''; end
    filepath = fullfile(read_path,filename);
    
    notes = readtable(filepath,...
        'Sheet',notes_sheet,...
        'Range',notes_range,...
        'ReadVariableNames',false,...
        'basic',true); 
    varNames = table2cell(readtable(filepath,...
        'Sheet',notes_sheet,...
        'Range',varNames_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    varUnits = table2cell(readtable(filepath,...
        'Sheet',notes_sheet,...
        'Range',varUnits_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    varNames_controlled = table2cell(readtable(filepath,...
        'Sheet',notes_sheet,...
        'Range',varsNames_controlled_range,...
        'ReadVariableNames',false,...
        'basic',true));
    varNames_measured = table2cell(readtable(filepath,...
        'Sheet',notes_sheet,...
        'Range',varNames_measured_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    
    seqInfo_equipment = table2cell(readtable(filepath,...
        'Sheet',seqInfo_equip_sheet,...
        'Range',seqInfo_equip_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    
    seqInfo_parts = table2cell(readtable(filepath,...
        'Sheet',seqInfo_sheet,...
        'Range',seqInfo_parts_range,...
        'ReadVariableNames',false,...
        'basic', true))';   
    seqInfo_general = table2cell(readtable(filepath,...
        'Sheet',seqInfo_sheet,...
        'Range',seqInfo_general_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    
    
    %% Parse and store all into one table
    varNames_xls = excel_matlab_var_map(:,1);
    varNames_mat = excel_matlab_var_map(:,2);
    
    missing_vars = varNames_mat(not(ismember(varNames_xls,varNames)));
    if not(isempty(missing_vars))
        warning(['Matlab variable name mapping is incomplete with following:'...
            sprintf('\n\t'),strjoin(missing_vars,'\n\t')])
    end

    notes.Properties.VariableNames = varNames_mat(ismember(varNames_xls,varNames));
    notes.Properties.VariableUnits = erase(string(varUnits),{'(',')'});
    
    % Update and add variable metadata
    notes = standardizeMissing(notes, missing_value_repr);
    
    notes = addprop(notes,{'Controlled','Measured'},{'variable','variable'}); 
    notes.Properties.CustomProperties.Controlled(ismember(varNames_xls,varNames_controlled)) = true;
    notes.Properties.CustomProperties.Measured(ismember(varNames_xls,varNames_measured)) = true;
    
    notes.Properties.UserData.Seq_info.Equipment = seqInfo_equipment;
    notes.Properties.UserData.Seq_info.General = seqInfo_general;
    notes.Properties.UserData.Seq_info.Parts = seqInfo_parts;
    notes.Properties.VariableDescriptions = varNames_xls;

    % Metadata used for populating non-matched rows when syncing/data fusion
    notes.Properties.VariableContinuity = excel_matlab_var_map(:,4);

    %% Parse time info
    
    % 'timestamp' and 'date' into 'time' (datetime vector)
    notes.time = datetime(double(string(notes.timestamp)),...
        'ConvertFrom','datenum',...
        'TimeZone','Europe/Oslo');
    notes.time.Day = notes.date.Day;
    notes.time.Month = notes.date.Month;
    notes.time.Year = notes.date.Year;
     
    % Represent time_elapsed as a total duration vector in seconds
    notes.time_elapsed = seconds(notes.time_elapsed);
 
    % Derive the time column that was not in use when making the notes
    if all(isnan(notes.time_elapsed))
         notes.time_elapsed = seconds(notes.time - notes.time(1));
    elseif all(isnat(notes.time))
         notes.timestamp = datetime(notes.time_elapsed,...
             'ConvertFrom','epochtime',...
             'Epoch',notes.date(1));
    else
        warning('No time info given')
    end
    
    
    %% Parse all columns, other than time columns
    
    % Parse relevant columns to numerical or to categorical
    for j=1:numel(excel_matlab_var_map(:,3))
        switch excel_matlab_var_map{j,3}
            case 'categoric'
                notes.(varNames_mat{j}) = categorical(notes{:,j});
            case 'numeric'
                notes.(varNames_mat{j}) = str2double(string(notes{:,j}));
        end
    end
    
    %% Add derived columns and remove unneeded columns
    
    notes = add_event_range(notes);
    
    n_header_lines = 3;
    notes = add_note_row_id(notes, n_header_lines);
    
    % Remove date columm, as this info is included in time
    notes(:,{'timestamp','date'}) = [];
    
    % Convert to timetable with timestamp as the time column
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
        while contains(string(notes.intervType(event_stop_ind)),...
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
        end_time
        notes.event_timerange{ii} = timerange(notes.timestamp(ii),end_time,'open')
        notes.event_endTime(ii) = end_time;
        
        
    end
    
function notes = add_note_row_id(notes, n_header_lines)
    % Add note row ID, useful when merging with sensor data
    notes.noteRow = (1:height(notes))'+n_header_lines';
    notes = movevars(notes, 'noteRow', 'Before', 'time_elapsed');
    notes.Properties.VariableContinuity('noteRow') = 'step';