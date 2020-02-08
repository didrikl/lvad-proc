function [read_path, save_path] = init_io_paths(experiment_subdir)
    
    % Static definitions for I/O directory structure
    read_root = 'C:\Data\IVS\Didrik';
    input_subdir = 'Recorded';
    output_subdir = 'Processed';
    
    fprintf('\nInitializing directory structure\n')
    
    read_root = fullfile([read_root,'\']);
    experiment_subdir = fullfile([experiment_subdir,'\']);
    input_subdir = fullfile([input_subdir,'\']);
    output_subdir = fullfile([output_subdir,'\']);
    
    read_root = check_path_existence(read_root);
    if not(read_root) 
        error('Data root path not specified'); 
    end
    
    fprintf('\nExperiment:')
    experiment_path = check_path_existence(fullfile(read_root,experiment_subdir));
    display_filename('',experiment_path);
    if not(experiment_path) 
        error('Experiment path not specified'); 
    end
    
    fprintf('\nReading:')
    read_path = check_path_existence(fullfile(experiment_path,input_subdir));
    display_filename('',read_path);
    if not(experiment_path) 
        error('Read path not specified'); 
    end
    
    % Same structure as read_path, but in a dedicated subdirectory. (For saving
    % there is not need to check its existence)
    fprintf('\nSaving:')
    save_path = fullfile(read_root,experiment_subdir,output_subdir);
    display_filename('',save_path);
    
    cd(experiment_path)

    