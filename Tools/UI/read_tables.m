function data = Read_Tables(filenames, read_basepath)
    
    % Assume filenames contain full file paths if read_basepath is not given
    if nargin==1
        read_basepath = '';
    end
    
    % Read data into a cell array of tables
    n_files = numel(filenames);
    data = cell(n_files,2);
    
    if not(exist(read_basepath,'dir'))
        warning('Can not read file(s). Reading path does not exist')
        return
    end
    
    for i=1:n_files
            
        filepath = fullfile(read_basepath,filenames{i});
        if not(exist(filepath,'file'))
            warning(['Can not read file. File does not exist: ',filenames{i}])
            continue
        end
        
        % Read data as Matlab table
        data{i,1} = readtable(filepath);
        
        % Add some metadata to the table
        data{i,1}.Properties.UserData.read_filepath = filepath;
        data{i,1}.Properties.UserData.proc_avg_date = datetime('now');        
        S = dbstack();
        if numel(S)>1
            data{i,1}.Properties.UserData.calling_script = S(2).file;
        else
            data{i,1}.Properties.UserData.calling_script = '';
        end
        data{i,2} = filenames{i};
    end
    
