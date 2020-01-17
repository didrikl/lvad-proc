function signal = make_signal_timetable(signal, include_time_duration)
   
    timestamp_fmt = 'dd-MMM-uuuu HH:mm:ss.SSS';
    
    % Default is to exclude t (to save memory, as it can readily be derived
    % in a timetable)
    if nargin==1, include_time_duration = false; end
    
    % Make other/more useful time representations
    signal.time = datetime(signal.t/1000,...
        'ConvertFrom','posixtime',...
        'Format',timestamp_fmt,...
        'TimeZone','Europe/Oslo');
    
    if not(include_time_duration)
        signal.t = [];
    end
        
    % Make timetable, and add properties metadata
    signal = table2timetable(signal);
        
    % Metadata used for populating non-matched rows when syncing
    signal.Properties.VariableContinuity(:) = 'continuous';
    
    % Add metadata for picking out sensor-messured data, when analysing
    signal = addprop(signal,'MeassuredSignal','variable');
    signal.Properties.CustomProperties.MeassuredSignal(:) = true;
    
   