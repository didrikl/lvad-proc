function T = init_labchart_mat_files(fileNames,path,varMapFile)
    % INIT_POWERLAB_RAW_MATFILE
    % Read and parse data (blocks of data stored in separate files) exported 
    % as .mat file from PowerLab's software LabChart.
    %
    % Convert from one single array of data to a (2-D) to a matlab timetable.
    % Additional metadata is parsed and stored with the timetable properties.
    % Timestamps in the table are represented as datetime array object.
    %
    % Usage:
    %     T = init_powerlab_raw_matfile(fileName,read_path,varMap)
    %
    % varMap is used to set variable continuity, which is used when doing
    % resampling by the retime function.
    %
    % See also timetable, datetime, retime
    
    % NOTE: if OO, one could make each sensor described by a sensor class, e.g.
    % for accelerometer a parent class and child class for cardiaccs. Could be
    % useful if different digital sampling boxes are used.
    
    if nargin==1, path = ''; end
    eval(varMapFile);
    
    % Default viewing format of timestamps (Could be made OO)
    timestampFmt = 'dd-MMM-uuuu HH:mm:ss.SSSS';

    welcome('Initialize LabChart .mat files')
    
    [returnAsCell,fileNames] = get_cell(fileNames);
    [filePaths,fileNames,~] = check_file_name_and_path_input(fileNames,path,'mat');
    
    % Initialization of LabChart block(s), with support for block composed of 
    % paralell files (with exported as different set of LabChart channels)
    nFiles = numel(fileNames);
    T = cell(nFiles,1);
    for i=1:nFiles
        
        fprintf('\n<strong>File (no %d/%d) </strong>',i,nFiles)
        display_filename('',fileNames{i});
        
		cancel = multiWaitbar('Reading .mat files',(i-1)/nFiles);  
        if confirm_waitbar_cancel(cancel,'Reading .mat files'), break; end
        
        T{i} = read_signal_file_into_table(filePaths{i},timestampFmt);
        
        if height(T{i})<2
            warning('File read contains one or zero rows of data.')
            continue
        end
        
        if i>1              
            T(1:i) = handle_nonchronological_order(T(1:i));
            [T{i},T{i-1}] = handle_overlapping_ranges(T{i},T{i-1},true);
        end
         
    end
    
    % Remove cell spaces for partial channel sets
    T = T(not(cellfun(@isempty,T)));
    
    % When block channel set is complete: Check intergrity, keep only
    % what is specificed to keep and cast columns according to varMap
    for i=1:numel(T)
		
		% Keep only user-specified variables
		[T{i},inFile_inds] = map_varnames(T{i}, varMap(:,1), varMap(:,2));
		
		% User-specified metadata for how data fusion shall be done
		T{i}.Properties.VariableContinuity = varMap(inFile_inds,4);
		
		% Convert to specified numeric format (e.g. pressure as single)
		T{i} = convert_columns(T{i},varMap(inFile_inds,3));
		
		% Gather 3 components as one variable (convenient when all 3 components
		% are arguments in combination with other inputs, and also when viewing)
		%B{i} = spatial_comp_as_vector(B{i},{'accA_x','accA_y','accA_z'},'accA');
		
	end
	
	if not(returnAsCell), T = T{1}; end
    multiWaitbar('Reading .mat files',1,'CanCancel','off');  
        
function T = read_signal_file_into_table(filePath,timestamp_fmt)    
    
    
    % Read data with variable organized and accessible in a struct d
    raw = load('-mat', filePath);
    
    % Parse metadata that are needed to construct a table
    [n_vars,n_intervals] = size(raw.datastart);
    varnames = genvarname(string(raw.titles));
    interv_start_timestamps = datetime(raw.blocktimes,...
        'ConvertFrom','datenum',...
        'Format',timestamp_fmt,...
        'TimeZone','Europe/Oslo');
    
    start_appending = false;
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
        
        % Let each interval per column (variable) be a timetable to allow for
        % different samplerates among the different intervals
        for i=1:n_intervals
            
            % Append column with new interval. There is no need to resample,
            % if the sample rates for each interval is not constant do no not 
            % result in unequal column lenght in output table. 
            if not(raw.datastart(j,i)==-1)  
                col_interv_inds = raw.datastart(j,i):raw.dataend(j,i);
                col_interv = raw.data(col_interv_inds)';
                col_interv = timetable(col_interv,...
                    'SampleRate',raw.samplerate(j,i),...
                    'VariableNames',varnames(j),...
                    'StartTime',interv_start_timestamps(i));
                col = [col;col_interv];
            end
            
        end
               
        % Setting variable behaviour for merging and resampling (as in the
        % function append_signal_variable_column used below
        
        % Append signal with new column. This requires that the samplerate for
        % each variable to be the same (at each separate interval).
        if isempty(col)
            warning(sprintf('Empty column for variable %s',varnames{j}))
            continue
        end
        col.Properties.VariableContinuity = {'continuous'};
        if start_appending
            T = append_signal_variable_column(T,col,...
                raw.samplerate(j-1,:),raw.samplerate(j,:),varnames{j});
        else
            T = col;
            start_appending = true;
        end       
        
    end
       
    % Parse metadata to will be stored as table metadata
    [col_unit,interv_units] = make_unit_string_arr(raw);
    T.Properties.Description = 'PowerLab data recorded in LabChart';
    T.Properties.DimensionNames{1} = 'time'; 
    T.Properties.DimensionNames{2} = 'variables';
    T.Properties.VariableUnits = cellstr(col_unit);
    T.Properties.VariableDescriptions = cellstr(raw.titles);
    T.Properties.UserData = make_init_userdata(filePath);
    T.Properties.UserData.Headers = cellstr(raw.titles);
    T.Properties.UserData.ColumnUnits = col_unit;
    T.Properties.UserData.IntervalStartTimes = interv_start_timestamps;
    T.Properties.UserData.IntervalUnits = interv_units;
    T.Properties.UserData.Comments = make_comments_table(raw,T);
    
    % All variables shall be treated as continous and measured in data fusion
    T = addprop(T,'Measured','variable');
    T.Properties.CustomProperties.Measured(:) = true;

    
function comments = make_comments_table(raw,T)
    comments = table;
    comments.channel = raw.com(:,1);
    comments.time = T.time(raw.com(:,3));
    comments.comments = raw.comtext(raw.com(:,5),:);
       
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
        % NOTE: Consider using retime if samplerate differs, before appending.
        % This requires some procedure to decide which samplerate to use, e.g.
        % max or min samplerate.
        signal = synchronize(signal,col);
    end

function [col_units,interv_units] = make_unit_string_arr(raw)
    % Make a string array of units, for each variable and interval. Start user
    % interaction if intervals units are not consistent for each variable.
    unittextmap = raw.unittextmap;
    unittext = string(raw.unittext);
    vars = cellstr(raw.titles);
      
    [n_vars,n_interv] = size(unittextmap);
    interv_units = repmat('',n_interv,n_vars);
    col_units = repmat('',n_vars,1);
    for j=1:n_vars
        
        % Look up unit for each interval, if given
        for i=1:n_interv  
            if unittextmap(j,i)>0
                interv_units{i,j} = strip(unittext(unittextmap(j,i)));
            end
        end

        % Find/determine unit for the whole signal variable column
        var_unit_no = unique(unittextmap(j,:));
        if numel(var_unit_no)>1

            warning(['Muliple units used for variable ',vars{j},'.'])
            
            % If different units at different intervals, then user must decide how
            % to handle this for the one column containing all recording intervals   
            units_in_use = cellstr(unique([interv_units{:,j}]));%  char(interv_units(var_unit_no(var_unit_no>0));
            options = [units_in_use,{'Set no unit','Type new unit'}];
            opt = ask_list_ui(options,'Set variable unit');
            opt=numel(options)-1;
            if opt<=numel(options)-2
                col_units{j} = unittext(opt);
            elseif opt==numel(options)-1
                col_units{j} = '';
            elseif opt==numel(options)
                col_units{j} = string(input('Type unit --> ','s'));
            end
      
        elseif var_unit_no==-1
            
            warning(['Unit not specified for variable ',vars{j},'.'])
            col_units{j} = '';
        
        else
            % All good; Use the uniquely found unit for all recording intervals
            col_units{j} = unittext(var_unit_no);
       
        end
    
    end

 