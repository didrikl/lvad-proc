function user_data = make_init_userdata(fileName,path)
    % Gather freely formated info/metadata into a struct, that can be stored
    % with a Matlab table/timetable in its table properties.
    
    if nargin==1
        [path,fileName,fileExt]=fileparts(fileName);
        fileName = [fileName,fileExt];
    end
    
    user_data = struct;
    user_data.ReadDate = datetime('now');
    user_data.FileName = fileName;
    user_data.FilePath = fullfile(path,fileName);
    user_data.Path = path;
    s = dbstack;
    user_data.SourceCode = s(end);
    