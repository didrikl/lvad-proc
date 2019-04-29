function [path, filename] = Save_Table(data, filename, path, varargin)
    % Write Matlab table to text files, using writetable.
    %
    % Check if there is already an exsisting file with the same filename in 
    % the saving directory path. If there is an exsisting file, then let the
    % user decide what action to do. The persistent variables
    % overwrite_existing og ignore_saving_for_existing allows the program to
    % remember choices goverening future action, in case there is an existing
    % file.
    %
    % See also writetable, Save_Destination_Check
    
    fprintf('\nSaving data as ASCII tables\n')
    
    % Persistent boolean switches for saving
    persistent overwrite_existing
    persistent ignore_saving_for_existing
     
    % First argument may be a figure handle for a specific figure to save,
    % otherwise use current figure as the figure to save.
    % ...to be written
    
    % Initialize the persistent variables, if not done before
    if isempty(overwrite_existing)
        overwrite_existing = false;
    end
    if isempty(ignore_saving_for_existing)
        ignore_saving_for_existing = false;
    end

    % Check if there is already an exsisting file with the same filename in
    % the saving directory path. If there is an exsisting file, then let the
    % user decide what action to do.
    [path, filename, overwrite_existing, ignore_saving_for_existing] = ...
        Save_Destination_Check(path, filename, overwrite_existing, ...
        ignore_saving_for_existing);
    
    % Saving time tables is not supported, but will not make any difference
    if istimetable(data)
        data = timetable2table(data);
    end

    if filename
        filepath = fullfile(path,filename);
        writetable(data, filepath, varargin{:})
        fprintf('\nData saved to: \n');
        disp(filepath);
    end