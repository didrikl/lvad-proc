function signal = init_m3_raw_textfile(filename,read_path)

    timestamp_fmt = 'dd-MMM-uuuu HH:mm:ss.SSS';
    
    filepath = fullfile(read_path, filename);
    signal = init_m3_raw_textfile_read(filepath);
    signal.timestamp = datetime(signal{:,1},...
        'InputFormat',"yyyy/MM/dd HH:mm:ss",...
        'Format',timestamp_fmt,...
        'TimeZone','Europe/Oslo');
    
    % Make timetable, and add properties metadata
    signal = table2timetable(signal,'RowTimes','timestamp');
    
    signal = retime(signal,'regular','fillwithmissing','SampleRate',1);
    
    % Metadata used for populating non-matched rows when syncing
    signal.Properties.VariableContinuity(:) = 'continuous';
    
    % Add metadata for picking out sensor-messured data, when analysing
    signal.Properties.VariableUnits = {'L/min','uL/sec','','uL'};
    signal = addprop(signal,'MeassuredSignal','variable');
    signal.Properties.CustomProperties.MeassuredSignal(:) = true;
    
   
    
    