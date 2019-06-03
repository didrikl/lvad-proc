function [save_path, filename] = save_table(filename, save_path, data, filetype, varargin)
    % SAVE_TABLE
    % Write Matlab table to text files, using writetable, with convenient
    % user interactions.
    %
    % Usage:
    %   save_table(filename, path, data, filetype, varargin)
    %
    % Input:
    %   filetype must be either
    %       'matlab' for saving to binary .mat file,
    %       'spreadsheet' for saving to Excel file or
    %       'text' for saving to ascii text file
    %   varargin is used for additional parameter options for filetype is
    %       either 'text' or 'spreadsheet'.
    %
    % Check if there is already an exsisting file with the same filename in
    % the saving directory path. If there is an exsisting file, then let the
    % user decide what action to do. The persistent variables
    % overwrite_existing og ignore_saving_for_existing allows the program to
    % remember choices goverening future action, in case there is an existing
    % file.
    %
    % See also writetable, save_destination_check, timetable2table
    
    % Note that save_path is handled as a separate input, instead of the
    % possiblity to be baked into the filename. This help to avoid unintendent
    % saving in current working directory.
    
    % Name of the table as it exist in memory
    tabname = inputname(3);
    
    % If inputs are given as strings, then parse to char for compability
    % TODO: Test support for filename given as string?
    [filename, save_path, varargin{:}] = convertStringsToChars(...
        filename, save_path, varargin{:});

    % Input validations
    if not(any(strcmpi(filetype,{'matlab','text','spreadsheet'})))
        warning(['Incorrect filetype is given. Type help save_table ',...
            'to see supported file types.'])
        return
    end
    if isa(data,'timetable')
        warning('Timetables are converted to regular table before saving.');
    elseif ~isa(data,'table')
        error('Third input argument is not a table or timetable');
    end
    
    
    fprintf('\nSaving the table %s to disc\n',tabname)
    
    % Initialize persistent boolean switches for saving
    persistent overwrite_existing
    persistent ignore_saving_for_existing
    if isempty(overwrite_existing)
        overwrite_existing = false;
    end
    if isempty(ignore_saving_for_existing)
        ignore_saving_for_existing = false;
    end
    
    [~,~,ext] = fileparts(filename);
    if not(ext)
        switch lower(filetype)
            case 'matlab'
                filename = fullfile(filename,'.mat');
            case 'text'
                filename = fullfile(filename,'.csv');
            case 'spreadsheet'
                filename = fullfile(filename,'.xls');
        end
    end
    
    % Check if there is already an exsisting file with the same filename in
    % the saving directory path. If there is an exsisting file, then let the
    % user decide what action to do. 
    [save_path, filename, overwrite_existing, ignore_saving_for_existing] = ...
        save_destination_check(save_path, filename, overwrite_existing, ...
        ignore_saving_for_existing);
    
    % If cancelled in user interaction, then just return without saving
    if not(filename)
        warning('No saving done.')
        return;
    end
    
    filepath = fullfile(save_path,filename);
    
    try
        switch lower(filetype)
            
            % NOTE: Could support saving structs and appending with new fields
            % and the possibility of overwriting existing fields. It might be
            % already working with varargin
            % TODO: Test saving structs with varargin
            case 'matlab'
                
                eval([inputname(3),'=data;']);
                save(filepath,tabname, varargin{:});
                
            case {'text','spreadsheet'}
                
                % Saving time tables is not supported in writetable,
                % but will probably not make any difference
                if istimetable(data)
                    data = timetable2table(data);
                end
                
                writetable(data, filepath, 'FileType', filetype, varargin{:})
                
        end
        
        fprintf('\nFile saved: \n')
        fprintf(['\tName: ',strrep(filename,'\','\\'),'\n']);
        fprintf(['\tPath: ',strrep(save_path,'\','\\'),'\n'])
             
    catch ME
        
        if strcmp(ME.identifier,'MATLAB:table:write:FileOpenInAnotherProcess')
            warning('No data saved. File is open with no write access.');
        else
            warning('No data saved. Something went wrong.')
            disp(ME)
        end
        
    end
    
