function [read_path, save_path] = init_io_paths(experiment_subdir)
    
    % Static definitions for I/O directory structure
    read_root = 'C:\Data';
    input_subdir = 'Recorded';
    output_subdir = 'Processed';
    
    experiment_path = fullfile(read_root,experiment_subdir);
    if not(exist(experiment_path,'dir'))
        experiment_path = uigetdir(read_root,...
            'Experiment folder not found, select which to use...');
    end
    
    if not(experiment_path)
        abort
    end
    
    read_path = fullfile(experiment_path,input_subdir);
    
    % Same structure as read_path, but in a dedicated subdirectory
    save_path = fullfile(read_root,experiment_subdir,output_subdir);
