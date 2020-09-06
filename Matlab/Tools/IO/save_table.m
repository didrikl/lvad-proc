function [save_path, fileName] = save_table(fileName, save_path, data, filetype, varargin)
    % SAVE_TABLE
    % Write Matlab table to text files, using writetable, with convenient
    % user interactions.
    %
    % Usage:
    %   save_table(fileName, path, data, filetype, varargin)
    %
    % Input:
    %   filetype must be either
    %       'matlab' for saving to binary .mat file,
    %       'spreadsheet' for saving to Excel file or
    %       'text' for saving to ascii text file
    %   varargin is used for additional parameter options for filetype is
    %       either 'text' or 'spreadsheet'.
    %
    % Check if there is already an exsisting file with the same fileName in
    % the saving directory path. If there is an exsisting file, then let the
    % user decide what action to do. The persistent variables
    % overwrite_existing og ignore_saving_for_existing allows the program to
    % remember choices goverening future action, in case there is an existing
    % file.
    %
    % See also writetable, save_destination_check, timetable2table
    
    % Note that save_path is handled as a separate input, instead of the
    % possiblity to be baked into the fileName. This help to avoid unintendent
    % saving in current working directory.
    
    % Name of the table as it exist in memory
    tabname = inputname(3);
    
    % If inputs are given as strings, then parse to char for compability
    % TODO: Test support for fileName given as string?
    [fileName, save_path, varargin{:}] = convertStringsToChars(...
        fileName, save_path, varargin{:});

    % Input validations
    if not(any(strcmpi(filetype,{'matlab','text','csv','spreadsheet'})))
        error(['Incorrect filetype is given. Type help save_table ',...
            'to see supported file types.'])
    elseif ~isa(data,'table') && ~isa(data,'timetable')
        error('Third input argument is not a table or timetable');
    end
    
    fprintf('\nSaving table from workspace to disc: %s\n',tabname)
    
    % Initialize persistent boolean switches for saving
    persistent overwrite_existing
    persistent ignore_saving_for_existing
    if isempty(overwrite_existing)
        overwrite_existing = false;
    end
    if isempty(ignore_saving_for_existing)
        ignore_saving_for_existing = false;
    end
    
    [subfolder,fileName,ext] = fileparts(fileName);
    if not(strcmpi(filetype,ext))
        warning('Saving with new file extention according to given filetype');
    end
    switch lower(filetype)
        case 'matlab'
            fileName = [fileName,'.mat'];
        case 'text'
            fileName = [fileName,'.txt'];
        case 'csv'
            fileName = [fileName,'.csv'];
        case 'spreadsheet'
            fileName = [fileName,'.xls'];
    end
    save_path = fullfile(save_path,subfolder);
    
    % Check if there is already an exsisting file with the same fileName in
    % the saving directory path. If there is an exsisting file, then let the
    % user decide what action to do. 
    [save_path, fileName, overwrite_existing, ignore_saving_for_existing] = ...
        save_destination_check(save_path, fileName, overwrite_existing, ...
        ignore_saving_for_existing);
    
    % If cancelled in user interaction, then just return without saving
    if not(fileName)
        warning('No saving done.')
        return;
    end
    
    filePath = fullfile(save_path,fileName);
    
    try
        switch lower(filetype)
            
            % NOTE: Could support saving structs and appending with new fields
            % and the possibility of overwriting existing fields. It might be
            % already working with varargin
            % TODO: Test saving structs with varargin
            case 'matlab'
                
                eval([inputname(3),'=data;']);
                save(filePath,tabname,varargin{:});
            
            case {'csv'}
                
                % Saving time tables is not supported in writetable,
                % but will probably not make any difference
                if istimetable(data)
                    data = timetable2table(data);
                end
                writetable(data, filePath, 'FileType', 'text', 'Delimiter', 'comma', varargin{:})
                
            case {'text','spreadsheet'}
                
                % Saving time tables is not supported in writetable,
                % but will probably not make any difference
                if istimetable(data)
                    data = timetable2table(data);
                end
                writetable(data, filePath, 'FileType', filetype, varargin{:})
                
        end
        
        display_filename(fileName,save_path,'\nTable saved to file:');
             
    catch ME
        
        if strcmp(ME.identifier,'MATLAB:table:write:FileOpenInAnotherProcess')
            warning('No data saved. File is open in another process.');
        elseif strcmp(ME.identifier,'MATLAB:table:write:FileOpenError')
            warning('No data saved. Could not open/create file for saving.');
        else
            warning('No data saved. Something went wrong.')
            disp(ME)
        end
        
    end
    
