function notes = init_notes_xlsfile_ver4(fileName, path)
    % 
    % Read named ranges from Notes Excel file. Ranges must be defined by Excel
    % name manager. (Named ranges make the Excel file more flexible w.r.t.
    % changes, but should be double checked.)
    %
    % Column that consists of empty / undefined values are not stored in the
    % notes table
    
    if nargin==1, path = ''; end
    
    % Sheets and ranges to read from Excel sheet (tab names in Excel)
    % NOTE: Notes range defined in name manager is a bit confusing/ error prone
    %       It is therefore avoided to be used.
    notes_sheet = 'Recording notes';
    varsNames_controlled_range = 'Controlled_VarNames';
    varNames_measured_range = 'Measured_VarNames';
    varNames_range = 'Header_VarNames';
    varUnits_range = 'Header_VarUnits';
    experiment_info_sheet = 'Description';
    experiment_info_range = 'Experiment_Info';
    
    % * Name in Excel: Must match the name in Excel, but can be changed easily.
    % * Name Matlab code: Static variable name used in code. Must be valid a
    %   variable name.
    % * Type is used for parsing data from Excel into notes Matlab table
    % * Continuity is a status property, particularily useful when merging with 
    %   recorded data, and for resampling using retime, c.f. the timetable 
    %   VariableContinuity documentation.  
    %   NB: Categoric type take a lot less memory to store
    %   NOTE: Must be listed in the same order as in Excel file.
    %   TODO: Make more flexible wrt. list order
    % TODO: Specific a list of variables for data fusion, while the rest is just
    % stored in the notes table??
    varMap = {...  
        % Name in Excel           Name Matlab code     Type          Continuity
        'Date'                    'date'             'cell'          'event'
        'Timestamp'               'timestamp'        'cell'          'event'
        'Elapsed time'            'durTime'          'duration'      'continuous'
        %'Timer'                   'timer'            'int16'         'event'
        %'X-ray ser.'              'xraySer'          'int16'         'step'
        %'Tag'                     'tag'              'cell'          'event'
        'Part'                    'part'             'categorical'   'step' 
        'Interval'                'intervType'       'categorical'   'step'
        'Event'                   'event'            'categorical'   'step'
        'Par. tag'                'parTag'           'categorical'   'step'
        %'Inject thrombus vol.'    'thrombusVol'      'int16',        'step'
        %'Inject thrombus type'    'thrombusType'     'categorical'   'step'
        'Pump speed'              'pumpSpeed'        'int16'         'step'
        'Balloon level'           'balloonLevel'     'categorical'   'step'
        %'Balloon diameter'        'balloonDiam'      'categorical'   'step'
        %'Manometer control'       'manometerCtrl'    'categorical'   'step'
        %'Catheter type'           'catheter'         'categorical'   'unset'
        %'Clamp flow red.'         'Q_reduction'      'categorical'   'step'
        %'Flow red. target'        'flowRedTarget'    'single'        'event'
        %'Balloon offset'          'balloonOffset'    'categorical'   'step'
        %'Balloon diam. est.'      'balDiamEst'       'int16'         'step'
        'Flow est.'               'Q_LVAD'           'single'        'step'
        'Power'                   'P_LVAD'           'single'        'step'
        %'Flow'                    'Q_noted'          'single'        'step'
        %'Max art. p'              'p_maxArt'         'int16'         'step'
        %'Min art. p'              'p_minArt'         'int16'         'step'
        %'MAP'                     'MAP'              'int16'         'step'
        %'Max pulm. p'             'p_maxPulm'        'int16'         'step'
        %'Min pulm. p'             'p_minPulm'        'int16'         'step'
        %'HR'                      'HR'               'int16'         'step'
        %'CVP'                     'CVP'              'int16'         'step'
        %'SvO2'                    'SvO2'             'int16'         'step'
        %'Cont. CO'                'CO_cont'          'int16'         'step'
        %'Thermo. CO'              'CO_thermo'        'int16'         'step'
        %'Hema-tocrit'             'HCT'              'int16'         'step'
        %'Procedure'               'procedure'        'cell'          'event'
        %'Experiment'              'exper_notes'      'cell'          'event'
        %'Quality control'         'QC_notes'         'cell'          'event'
        %'Interval annotation'     'annotation'       'cell'          'event'
        };

    % Columns to omit (not never in use or always constant in the sequence)
    varNamesToRemove = {
        'date'
        'timestamp'
        'durTime'
        'timer'
        };
    
    % User-set definitions
    % TODO: For OO
    missingValueRepr = {''};
    timeVarName = 'time';
    nHeaderLines = 3;
    
  
    %% Read from Excel file
    
    welcome('Reading notes file')
    
    filePath = check_file_name_and_path_input(fileName,path,{'xlsm','xls','xlsx'});
    display_filename(filePath);
    notes_sheet = check_notes_sheet_name(filePath,notes_sheet);    
    
    notes = readtable(filePath,...
        'Sheet',notes_sheet,...
        'basic',true);
    
    % Read auxillary info
    varNamesInFile = table2cell(readtable(filePath,...
        'Sheet',notes_sheet,...
        'Range',varNames_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    varUnits = table2cell(readtable(filePath,...
        'Sheet',notes_sheet,...
        'Range',varUnits_range,...
        'ReadVariableNames',false,...
        'basic', true));
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
    experimentInfo = table2cell(readtable(filePath,...
        'Sheet',experiment_info_sheet,...
        'Range',experiment_info_range,...
        'ReadVariableNames',false,...
        'basic', true))';
    
    
    %% Map variables 
    % Map variable names in file over to variable names that are used in 
    % Matlab code. Check also which variables that are not matched in mapping.
    % Keep only variables that are matched.
    
    % 1) Set variable names from header in file (regardsless of mapping)
    notes.Properties.VariableNames = varNamesInFile;
    
    % 2) do mapping with what this code expects to be present and what to keep
    [notes, inFile_ind] =  map_varnames(notes, varMap(:,1), varMap(:,2));
    
    varNames_xls = varMap(inFile_ind,1);
    
    
    %% Add metadata
    
    % Structured table metadata
    notes.Properties.Description = 'Experiment notes in Excel';
    notes.Properties.DimensionNames{1} = 'intervals'; 
    notes.Properties.DimensionNames{2} = 'protocol and variables';
    
    % Structured column metadata, used for populating non-matched rows and 
    % for syncing/data fusion
    notes = addprop(notes,{'Controlled','Measured'},{'variable','variable'}); 
    notes.Properties.CustomProperties.Controlled(...
        ismember(varNames_xls,varNames_controlled)) = true;
    notes.Properties.CustomProperties.Measured(...
        ismember(varNames_xls,varNames_measured)) = true;
    notes.Properties.VariableContinuity = varMap(inFile_ind,4);
    
    % Other column metadata
    notes.Properties.VariableDescriptions = cellstr(varNames_xls);
    notes.Properties.VariableUnits = ...
        cellstr(strrep(string(varUnits(inFile_ind)),'NaN',''));
    notes.Properties.UserData = make_init_userdata(filePath);
    notes.Properties.UserData.Experiment_Info = experimentInfo;
    
    %% Parse information
    
    notes = standardizeMissing(notes, missingValueRepr);
    
    % Parse info time, date and dur
    notes = parse_time_cols(notes);
    notes = derive_time_col_not_filled(notes);
    
    % Parse relevant columns, other than time columns
    notes = convert_columns(notes,varMap(inFile_ind,3));

    % Add note row id to be used for data fusion and looking up data
    notes = add_note_row_id(notes, nHeaderLines);
    
    
    %% Remove unneeded columns and finalize with converting to timetable
    
    % Remove specficed columns to be removed
    notes(:,ismember(notes.Properties.VariableNames,varNamesToRemove)) = [];
    
    % Convert to timetable with timestamp as the time column
    notes = table2timetable(notes,'RowTimes',timeVarName);
    
function notes = add_note_row_id(notes, n_header_lines)
    % Add note row ID, useful when merging with sensor data
    notes.noteRow = (1:height(notes))'+n_header_lines';
    notes = movevars(notes, 'noteRow', 'Before', 'durTime');
    notes.Properties.VariableContinuity('noteRow') = 'step';
       
function notes_sheet = check_notes_sheet_name(filePath,notes_sheet)
    sheets_in_file = sheetnames(filePath);
    if not(ismember(notes_sheet,sheets_in_file))
        msg = sprintf('No sheet named %s in file.',notes_sheet);
        warning(msg);
        sheet_opts = cellstr("Continue, use: "+sheets_in_file);
        resp = ask_list_ui([sheet_opts;'Abort'],msg);
        if resp==numel(sheets_in_file)+1
            abort
        else
            notes_sheet = sheets_in_file{resp};
        end    
    end
    
 function notes = parse_time_cols(notes)
     % Merge 'timestamp' and 'date' into 'time' (datetime vector)
     notes.time = datetime(double(string(notes.timestamp)),...
         'ConvertFrom','datenum',...
         'TimeZone','Europe/Oslo');
    notes.time.Day = notes.date.Day;
    notes.time.Month = notes.date.Month;
    notes.time.Year = notes.date.Year;
     
    % Represent time_elapsed as a total duration vector in seconds
    if ismember('durTime',notes.Properties.VariableNames)
        notes.durTime = seconds(notes.durTime);
    else
        notes.durTime = seconds(nan(height(notes),1));
    end
    
 function notes = derive_time_col_not_filled(notes)
    % Derive the time column that was not in use when filling out the notes
    
    empty_dur_col = all(isnan(notes.durTime));
    empty_timestamp_col = all(isnat(notes.time));
    if empty_dur_col && empty_timestamp_col
        warning('No time info given')
    elseif empty_dur_col
        parts_list = double(unique(notes.part,'sorted'));
        parts_list = parts_list(not(isnan(parts_list)));
        parts_col = double(notes.part);
        for i=1:numel(parts_list)
            part_inds = parts_col==parts_list(i);
            part_start = notes.time(find(part_inds,1,'first'));
            notes.durTime(part_inds) = notes.time(part_inds) - part_start;
        end
    elseif empty_timestamp_col
         notes.time = datetime(notes.durTime,...
             'ConvertFrom','epochtime',...
             'Epoch',notes.date(1));
    end
    