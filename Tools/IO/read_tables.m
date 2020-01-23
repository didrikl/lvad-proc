function data = read_tables(fileNames, read_path)
    
    % Assume fileNames contain full file paths if read_basepath is not given
    if nargin==1
        read_path = '';
    end
    
    % Read data into a cell array of tables
    n_files = numel(fileNames);
    data = cell(n_files,2);
    
    display_filename(fileNames,read_path,'Reading table(s) from file(s) to workspace')
    read_path = check_path_existence(read_path);
    if not(read_path), return; end
    
    for i=1:n_files
            
        filePath = fullfile(read_path,fileNames{i});
        if not(exist(filePath,'file'))
            warning(['Can not read file. File does not exist: ',fileNames{i}])
            continue
        end
        
        % Read data as Matlab table
        data{i,1} = readtable(filePath);
        
        % Add some metadata to the table
        data{i,1}.Properties.UserData.read_filePath = filePath;
        data{i,1}.Properties.UserData.proc_avg_date = datetime('now');        
        S = dbstack();
        if numel(S)>1
            data{i,1}.Properties.UserData.calling_script = S(2).file;
        else
            data{i,1}.Properties.UserData.calling_script = '';
        end
        data{i,2} = fileNames{i};
    end
    
