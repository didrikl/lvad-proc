function [signal,raw] = init_cardiaccs_raw_txtfile(rec_file,read_path)
    
    raw = read_cardiaccs_raw_txtfile(rec_file,read_path);
    %raw= read_cardiaccs_raw_txtfile_parfor(filename,read_path);
    
    % Unfold to one row per acc registration and type conversions
    signal = parse_cardiaccs_raw(raw);
    
    % Let time be represented as datetime (timestamp) and convert to timetable
    % where the timestamp is not a variable, but an internal row id. Timetable
    % have built-in methods for signal processing
    % NOTE: Move this into parse_cardiaccs_raw .m-file?
    signal = make_signal_timetable(signal);
