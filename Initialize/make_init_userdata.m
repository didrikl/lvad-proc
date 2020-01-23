function user_data = make_init_userdata(fileName,filePath)
    % Gather freely formated info/metadata into a struct, that can be stored
    % with a Matlab table in its table properties.
    
    if nargin==1
        [filePath,fileName,fileExt]=fileparts(fileName);
        fileName = fullfile(fileName,fileExt);
    end
    
    user_data = struct;
    user_data.read_date = datetime('now');
    user_data.fileName = fileName;
    user_data.filePath = filePath;
    s = dbstack;
    user_data.source_code = s(end);
    
