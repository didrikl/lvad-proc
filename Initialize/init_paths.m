function [read_path, save_path] = init_paths(experiment_subdir)
    
    read_basedir = 'C:\Data';
        
    read_path = fullfile(read_basedir,experiment_subdir,'Recorded');
    
    % Same structure as read_path, but in a dedicated subdirectory
    save_path = fullfile(read_basedir,experiment_subdir,'Processed');
