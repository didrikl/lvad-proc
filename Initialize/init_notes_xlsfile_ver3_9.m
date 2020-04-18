function notes = init_notes_xlsfile_ver3_9(fileName, read_path)
    % 
    % Read named ranges from Notes Excel file. Ranges must be defined by Excel
    % name manager. (Named ranges make the Excel file more flexible w.r.t.
    % changes, but should be double checked.)
    %
    % Column that consists of empty / undefined values are not stored in the
    % notes table
    
    if nargin==1, read_path = ''; end
    
    % Sheets and ranges to read from Excel sheet (tab names in Excel)
    % TODO: Notes range defined in name manager is a bit confusing(?)
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
    %   NB: Categoric type take a lot less memory to store
    var_map = {    
        ...   
        % Name in Excel           Name Matlab code     Type            Continuity
        'Date'                    'date'               'cell'          'event'
        'Timestamp'               'timestamp'          'cell'          'event'
        'Elapsed time'            'part_elapsedTime'   'duration'      'continuous'
        'Dur'                     'event_duration'     'int16'         'event'
        'Part'                    'part'               'categorical'   'step'
        'Interval type'           'intervType'         'categorical'   'step'
        'Event'                   'event'              'categorical'   'step'
        'Thrombus volume'         'thrombusVol'        'categorical'   'step'
        'Speed change rate'       'speedChangeRate'    'categorical'   'step'
        'Dose'                    'dose'               'categorical'   'step'
        'Pump speed'              'pumpSpeed'          'int16'         'step'
        'Balloon level'           'balloonLevel'       'categorical'   'step'
        'Balloon diameter'        'balloonDiam'        'categorical'   'step'
        'Balloon offset'          'balloonOffset'      'categorical'   'step'
        'Catheter type'           'catheter'           'categorical'   'unset'
        'Clamp flow reduction'    'flowReduction'      'categorical'   'step'
        'Afferent pressure'       'affP_noted'         'single'        'event'
        'Effenrent pressure'      'effP_noted'         'single'        'event'
        'Flow estimate'           'Q_noted'            'single'        'step'
        'Power'                   'power_noted'        'single'        'step'
        'Reduced baseline flow'   'redBaseFlow'        'single'        'event'
        'Comment'                 'comment'            'cell'          'event'
        ...
        };

    % Columns to omit (not in use or always constant in the sequence)
    varNames_unneeded = {
        'date'
        'timestamp'
        'part_elapsedTime'
        'event_duration'
        'thrombusVol'
        'speedChangeRate'
        'dose'
        'balloonOffset'
        'affP_noted'
        'effP_noted'
        };
    
    % TODO: For OO
    missing_value_repr = {''};
    time_varName = 'time';
    n_header_lines = 3;
    
  
    %% Read from Excel file
    
    welcome('Reading notes file')
    
    % TODO: For OO...
    filePath = fullfile(read_path,fileName);
    display_filename(read_path,fileName);
    
    notes = readtable(filePath,...
        'Sheet',notes_sheet,...
        'Range',notes_range,...
        'ReadVariableNames',false,...
        'basic',true); 
    varNames = table2cell(readtable(filePath,...
        'Sheet',notes_sheet,...
        'Range',varNames_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    varUnits = table2cell(readtable(filePath,...
        'Sheet',notes_sheet,...
        'Range',varUnits_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    varNames_controlled = table2cell(readtable(filePath,...
        'Sheet',notes_sheet,...
        'Range',varsNames_controlled_range,...
        'ReadVariableNames',false,...
        'basic',true));
    varNames_measured = table2cell(readtable(filePath,...
        'Sheet',notes_sheet,...
        'Range',varNames_measured_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    
    seqInfo_equipment = table2cell(readtable(filePath,...
        'Sheet',seqInfo_equip_sheet,...
        'Range',seqInfo_equip_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    
    seqInfo_parts = table2cell(readtable(filePath,...
        'Sheet',seqInfo_sheet,...
        'Range',seqInfo_parts_range,...
        'ReadVariableNames',false,...
        'basic', true))';   
    seqInfo_general = table2cell(readtable(filePath,...
        'Sheet',seqInfo_sheet,...
        'Range',seqInfo_general_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    
    
    %% Parse and store all into one table
    varNames_xls = var_map(:,1);
    varNames_mat = var_map(:,2);
    notes.Properties.VariableNames = varNames;
    notes = map_varnames(notes, varNames_xls, varNames_mat);

    % Update and add variable metadata
    notes = standardizeMissing(notes, missing_value_repr);
    
    % Variable metadata, just descriptions
    notes.Properties.VariableDescriptions = varNames_xls;
    notes.Properties.VariableUnits = erase(string(varUnits),{'(',')'});
    
    % Variable metadata used for populating non-matched rows for syncing/fusion
    notes = addprop(notes,{'Controlled','Measured'},{'variable','variable'}); 
    notes.Properties.CustomProperties.Controlled(ismember(varNames_xls,varNames_controlled)) = true;
    notes.Properties.CustomProperties.Measured(ismember(varNames_xls,varNames_measured)) = true;
    notes.Properties.VariableContinuity = var_map(:,4);

    % Various user-data
    notes.Properties.UserData = make_init_userdata(filePath);
    notes.Properties.UserData.Seq_info.Equipment = seqInfo_equipment;
    notes.Properties.UserData.Seq_info.General = seqInfo_general;
    notes.Properties.UserData.Seq_info.Parts = seqInfo_parts;

    
    %% Parse time info
    
    % 'timestamp' and 'date' into 'time' (datetime vector)
    notes.time = datetime(double(string(notes.timestamp)),...
        'ConvertFrom','datenum',...
        'TimeZone','Europe/Oslo');
    notes.time.Day = notes.date.Day;
    notes.time.Month = notes.date.Month;
    notes.time.Year = notes.date.Year;
     
    % Represent time_elapsed as a total duration vector in seconds
    notes.part_elapsedTime = seconds(notes.part_elapsedTime);
 
    % Derive the time column that was not in use when making the notes
    % TODO: Move to separate function, to avoid derived columns before
    % resampling and merging processes
    if all(isnan(notes.part_elapsedTime))
        parts = unique(notes.part);
        parts = parts(not(cellfun(@isempty,parts)));
        for i=1:numel(parts)
            part_inds = ismember(notes.part,parts{i});
            part_start = notes.time(find(part_inds,1,'first'));
            notes.part_elapsedTime(part_inds) = notes.time(part_inds) - part_start;
        end
    elseif all(isnat(notes.time))
         notes.time = datetime(notes.part_elapsedTime,...
             'ConvertFrom','epochtime',...
             'Epoch',notes.date(1));
    else
        warning('No time info given')
    end
    
    %% Parse all columns, other than time columns
    
    % Parse relevant columns to numerical or to categorical
    % Cast all columns, other than time columns
    notes = convert_columns(notes,var_map(:,3));

    
    %% Add derived columns
    
    % TODO: Move add_event_range to notes_qc and/or init_feats
    intervTypesToIncludeinEventRange = {'steady','baseline'};
    notes = add_event_range(notes, intervTypesToIncludeinEventRange);
    
    notes = add_note_row_id(notes, n_header_lines);
    
    
    %% Remove unneeded columns and finalize with converting to timetable
    
    % Remove specficed columns to be removed
    notes(:,ismember(notes.Properties.VariableNames,varNames_unneeded)) = [];
    
    % Convert to timetable with timestamp as the time column
    notes = table2timetable(notes,'RowTimes',time_varName);
    
    
function notes = add_event_range(notes, intervTypesToIncludeinEventRange)
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
    
    % Subscripts to extract ranges in timetables, just for convenience. It can
    % be also used to quickly view the timerange, but has no other usage. 
    notes.event_timerange = cell(n_notes,1);
    
    event_inds = find(...
        (notes.event~='-' & not(ismissing(notes.event))) ...
        | notes.intervType=='Continue from pause');
    for i=1:numel(event_inds)
        
        % Applying the rule of thomb
        ii = event_inds(i);
        event_stop_ind = ii+1;%find(notes.event(ii:end)~='-',1,'first');
        
        % Include steady-states and baselines as part of the precursor event when
        % deriving timeranges for the event
        while contains(lower(string(notes.intervType(event_stop_ind))),...
            intervTypesToIncludeinEventRange) && event_stop_ind<n_notes
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
                event_stop_ind = find(notes.time>notes.time(ii),1,'last');
                warning('\n\tThe parallell running event %s was not ended.',event)
            end
            
        end
        
        % Make the timerange
        if ii<n_notes
            end_time = notes.time(event_stop_ind);
        else
            end_time = datetime(inf,'ConvertFrom','datenum','TimeZone','Etc/UTC');
        end
        notes.event_timerange{ii} = timerange(notes.time(ii),end_time,'open');
        notes.event_endTime(ii) = end_time;
        
        
    end
    
function notes = add_note_row_id(notes, n_header_lines)
    % Add note row ID, useful when merging with sensor data
    notes.noteRow = (1:height(notes))'+n_header_lines';
    notes = movevars(notes, 'noteRow', 'Before', 'part_elapsedTime');
    notes.Properties.VariableContinuity('noteRow') = 'step';