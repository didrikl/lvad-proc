function user_data = make_init_userdata(filename,filepath)
    % Gather freely formated info/metadata into a struct, that can be stored
    % with a Matlab table in its table properties.
    
    user_data = struct;
    user_data.read_date = datetime('now');
    user_data.filename = filename;
    user_data.filepath = filepath;
    s = dbstack;
    user_data.source_code = s(end);
    
