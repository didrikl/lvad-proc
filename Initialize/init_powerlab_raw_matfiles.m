function B = init_powerlab_raw_matfiles(fileNames,raw_Basepath)
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
    
    if nargin==1, raw_Basepath = ''; end
    filePaths = fullfile(raw_Basepath,fileNames);
    
    % Default viewing format of timestamps (not very important)
    timestampFmt = 'dd-MMM-uuuu HH:mm:ss.SSS';

    % NOTE: if OO, one could make each sensor described by a sensor class, e.g.
    % for accelerometer a parent class and child class for cardiaccs. Could be
    % useful if different digital sampling boxes are used.
    acc_gyr_sampleRate = 540;
    p_sampleRate = 1000;
    
    var_map = {
        ...   
        % LabChart name  Matlab name  Sensor sample rate
        'Trykk1'         'affP'       p_sampleRate
        'Trykk2'         'effP'       p_sampleRate
        'SensorAAccX'    'accA_x'     acc_gyr_sampleRate
        'SensorAAccY'    'accA_y'     acc_gyr_sampleRate
        'SensorAAccZ'    'accA_z'     acc_gyr_sampleRate
        'SensorAGyrX'    'gyrA_x'     acc_gyr_sampleRate
        'SensorAGyrY'    'gyrA_y'     acc_gyr_sampleRate
        'SensorAGyrZ'    'gyrA_z'     acc_gyr_sampleRate
        'SensorBAccX'    'accB_x'     acc_gyr_sampleRate
        'SensorBAccY'    'accB_y'     acc_gyr_sampleRate
        'SensorBAccZ'    'accB_z'     acc_gyr_sampleRate            
        'SensorBGyrX'    'gyrB_x'     acc_gyr_sampleRate
        'SensorBGyrY'    'gyrB_y'     acc_gyr_sampleRate
        'SensorBGyrZ'    'gyrB_z'     acc_gyr_sampleRate
        };


    fprintf('\nInitializing PowerLab:\n')
    
    % Initialization of Powerlab block file(s)
    B = cell(numel(fileNames),1);
    for i=1:numel(fileNames)
        
        fprintf(display_filename(fileNames{i}))
        
        B{i} = read_signal_block(filePaths{i},timestampFmt);
        
        % TODO: Check for overlap with already read data, in case double saving
        % from LabChart
        
        B{i} = map_varnames(B{i}, var_map(:,1), var_map(:,2));
        
        B{i}.Properties.DimensionNames{1} = 'time'; 
               
        % Storing info about sensors (metadata for each variable)
        B{i} = addprop(B{i},'SensorSampleRate','variable');
        in_use = ismember(B{i}.Properties.VariableNames,var_map(:,2));
        B{i}.Properties.CustomProperties.SensorSampleRate(in_use) = var_map{:,3};
        
        % Gather 3 components as one variable (convenient when all 3 components
        % are arguments in combination with other inputs, and also when viewing)
        B{i} = spatial_comp_as_vector(B{i},{'accA_x','accA_y','accA_z'},'accA');
        B{i} = spatial_comp_as_vector(B{i},{'accB_x','accB_y','accB_z'},'accB');
        B{i} = spatial_comp_as_vector(B{i},{'gyrA_x','gyrA_y','gyrA_z'},'gyrA');
        B{i} = spatial_comp_as_vector(B{i},{'gyrB_x','gyrB_y','gyrB_z'},'gyrB');
        
        % All variables shall be treated as continous and measured in data fusion
        B{i} = addprop(B{i},'Measured','variable');
        B{i}.Properties.CustomProperties.Measured(:) = true;
        B{i}.Properties.VariableContinuity(:) = 'continuous';
        
 
        
    end   
    
    fprintf('\nInitializing PowerLab done.\n')

    
function T_block = read_signal_block(filePath,timestamp_fmt)    
    
    
    % Read data with variable organized and accessible in a struct d
    raw = load('-mat', filePath);
    
    % Parse raw metadata that are needed
    [n_vars,n_intervals] = size(raw.datastart);
    varnames = genvarname(string(raw.titles));
    [col_unit,interv_units] = make_unit_string_arr(raw);
    interv_lengths = raw.dataend-raw.datastart;
    interv_start_timestamps = datetime(raw.blocktimes,...
        'ConvertFrom','datenum',...
        'Format',timestamp_fmt,...
        'TimeZone','Europe/Oslo');
    % NOTE: Furhter development could include reading/parsing comments made
    %       in PowerLab. 
    
    % TODO: Change to multiwaitbar in calling function, and handle passed as
    % function argument
    wait_complete = sum(sum(interv_lengths));
    wait_progress = 0;
    [~,fileName,~] = fileparts(filePath);
    h_wait = waitbar(wait_progress,['Initializing: ',strrep(fileName,'_','\_'),'.mat']);
    
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
            waitbar(wait_progress,h_wait);
            
        end
        
        % Setting variable behaviour for merging and resampling (as in the
        % function append_signal_variable_column used below
        col.Properties.VariableContinuity = {'continuous'};
        
        % Append signal with new column. This requires that the samplerate for
        % each variable to be the same (at each separate interval).
        if j>1
            T_block = append_signal_variable_column(T_block,col,...
                raw.samplerate(j-1,:),raw.samplerate(j,:),varnames{j});
        else
            T_block = col;
        end

    end
    
    % Variable metadata
    % TODO: Move to calling code, and check for consistency for all blocks, for
    % which units and descriptions are stored in userdata cell array.
    T_block.Properties.VariableUnits = col_unit;
    T_block.Properties.VariableDescriptions = cellstr(raw.titles);
        
    % Store various/unstructured info (start with initializing standard info)
    T_block.Properties.UserData = make_init_userdata(filePath);
    T_block.Properties.UserData.Headers = cellstr(raw.titles);
    T_block.Properties.UserData.ColumnUnits = col_unit;
    T_block.Properties.UserData.IntervalStartTimes = interv_start_timestamps;
    T_block.Properties.UserData.IntervalUnits = interv_units;
    
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
