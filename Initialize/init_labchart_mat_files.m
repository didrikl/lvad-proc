function B = init_labchart_mat_files(fileNames,path,varMap)
    % INIT_POWERLAB_RAW_MATFILE
    % Read and parse data (blocks of data stored in separate files) exported 
    % as mat file from PowerLab's LabChart program.
    %
    % Convert from one single array of data to a (2-D) to a matlab timetable.
    % Additional metadata is parsed and stored with the timetable properties.
    %
    % Usage:
    %     init_powerlab_raw_matfile(fileName,read_path)
    %
    % See also timetable
    
    if nargin==1, path = ''; end
    [filePaths,fileNames,paths] = check_file_name_and_path_input(fileNames,path);
    
    % Default viewing format of timestamps (not very important)
    timestampFmt = 'dd-MMM-uuuu HH:mm:ss.SSSS';

    % NOTE: if OO, one could make each sensor described by a sensor class, e.g.
    % for accelerometer a parent class and child class for cardiaccs. Could be
    % useful if different digital sampling boxes are used.
    
    welcome('Initializing LabChart .mat files')
    
    % Initialization of Powerlab block(s), with support for block consisting 
    % of having paralell files (with different LabChart channels)
    nFiles = numel(fileNames);
    B = cell(nFiles,1);
    for i=1:nFiles
        fprintf('\n<strong>File (no %d/%d): </strong>',i,nFiles)
        display_filename(fileNames{i},paths{i});
        
        % if cell of parallell files
        B{i} = read_signal_file_into_table(filePaths{i},timestampFmt);
        
        if i>1
            %[B,isPar] = check_parallell_ranges(B,i,fileNames);
            [~, isOverlap] = overlapsrange(B{i},B{i-1});
            if all(isOverlap)
                B{i}=[B{i-1},B{i}];
                B{i-1} = [];
            end
        end
        
    end
    
    B = B(not(cellfun(@isempty,B)));
    nBlocks = numel(B);
    for i=1:nBlocks
        % Check for overlapping ranges of already initialized files
        B = check_overlapping_blocks(B,i,fileNames);
             
        % Keep only user-specified variables 
        [B{i},inFile_inds] = map_varnames(B{i}, varMap(:,1), varMap(:,2));

        % User-specified metadata for how data fusion shall be done 
        B{i}.Properties.VariableContinuity = varMap(inFile_inds,4);
        
        % Convert to specified numeric format (e.g. pressure as single)
        B{i} = convert_columns(B{i},varMap(inFile_inds,3));

        % Gather 3 components as one variable (convenient when all 3 components
        % are arguments in combination with other inputs, and also when viewing)
        %B{i} = spatial_comp_as_vector(B{i},{'accA_x','accA_y','accA_z'},'accA');
        %B{i} = spatial_comp_as_vector(B{i},{'accB_x','accB_y','accB_z'},'accB');
        
    end
      
function B = check_overlapping_blocks(B,i,fileNames)
    for ii=1:i-1
        [isOverlap,overlapRows] = overlapsrange(B{i},B{ii});
        if any(isOverlap)
            overlap_range = string(...
                B{ii}.time(find(overlapRows,1,'last'))...
                -B{ii}.time(find(overlapRows,1,'first')));
            warning(sprintf([...
                '\n\tFile overlaps %s (%d time samples) with file %s.',...
                '\n\tOverlapping ranges are only keep from the first file'],...
                overlap_range,nnz(overlapRows),fileNames{ii}));
            B{ii}(overlapRows,:) = [];
        end
    end


function T = read_signal_file_into_table(filePath,timestamp_fmt)    
    
    % New waitbar for each file; progress updates per column
    % TODO: Change to multiwaitbar in calling function, and handle passed as
    % function argument
    [~,fileName,~] = fileparts(filePath);
    progress = 0;
    h_wait = waitbar(progress,['Initializing: ',strrep(fileName,'_','\_'),'.mat']);
    
    % Read data with variable organized and accessible in a struct d
    raw = load('-mat', filePath);
    
    % Parse metadata that are needed to construct a table
    [n_vars,n_intervals] = size(raw.datastart);
    varnames = genvarname(string(raw.titles));
    interv_start_timestamps = datetime(raw.blocktimes,...
        'ConvertFrom','datenum',...
        'Format',timestamp_fmt,...
        'TimeZone','Europe/Oslo');
    
    interv_lengths = raw.dataend-raw.datastart;
    wait_complete = sum(sum(interv_lengths));
    
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
            col_interv = raw.data(raw.datastart(j,i):raw.dataend(j,i))';
            col_interv = timetable(col_interv,...
                'SampleRate',raw.samplerate(j,i),...
                'VariableNames',varnames(j),...
                'StartTime',interv_start_timestamps(i));
            col = [col;col_interv];
            
            % Update progress represented in no of samples in the interval
            progress = progress+(interv_lengths(j,i)/wait_complete);
            waitbar(progress,h_wait);
            
        end
               
        % Setting variable behaviour for merging and resampling (as in the
        % function append_signal_variable_column used below
        col.Properties.VariableContinuity = {'continuous'};
        
        % Append signal with new column. This requires that the samplerate for
        % each variable to be the same (at each separate interval).
        if j>1
            T = append_signal_variable_column(T,col,...
                raw.samplerate(j-1,:),raw.samplerate(j,:),varnames{j});
        else
            T = col;
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
    
    close2(h_wait)
 
function comments = make_comments_table(raw,T)
    comments = table;
    comments.channel = raw.com(:,1);
    comments.time = T.time(raw.com(:,3));
    comments.text = raw.comtext;
       
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
    interv_units = repmat('',n_vars,n_interv);
    col_units = repmat('',n_vars,1);
    for j=1:n_vars
        
        % Look up unit for each interval, if given
        for i=1:n_interv  
            if unittextmap(j,i)>0
                interv_units{j,i} = strip(unittext(unittextmap(j,i)));
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
            col_units{j} = unittext(var_unit_no);
       
        end
    
    end
