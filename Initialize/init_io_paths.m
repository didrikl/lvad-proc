function [read_path, save_path] = init_io_paths(sequence,data_root)
    
    % Static definitions for I/O directory structure
    input_subdir = 'Recorded';
    output_subdir = 'Processed';
    
    welcome('Initializing directory structure')
    
    data_root = check_data_root_path(data_root);
    seq_path = check_sequence_path(data_root,sequence);
    read_path = check_read_path(seq_path,input_subdir);
    save_path = check_save_path(seq_path,output_subdir);
    
    cd(seq_path)
   
function save_path = check_save_path(seq_path,output_subdir)
    % Same structure as read_path, but in a dedicated subdirectory. (For saving
    % there is not need to check its existence)
    fprintf('\nSaving path:')
    save_path = fullfile(seq_path,output_subdir);
    display_filename('',save_path);
    
function seq_path = check_read_path(seq_path,input_subdir)
    
    fprintf('\nReading path:')
    pattern = fullfile(seq_path,input_subdir);
    seq_path = get_path(pattern);
    
    display_filename('',seq_path);
    if not(seq_path)
        error('Reading path path not specified');
    end
    
function seq_path = check_sequence_path(read_root,sequence)
    
    fprintf('\nExperiment sequence path:')
    pattern = fullfile(read_root,['*',sequence,'*']);
    seq_path = get_path(pattern);
    
    display_filename('',seq_path);
    if not(seq_path)
        error('Experiment sequence path not specified');
    end
    
function data_root_path = check_data_root_path(data_root_path)
    
    fprintf('\nData root:')
    data_root_path = get_path(data_root_path);
    
    display_filename('',data_root_path);
    if not(data_root_path)
        error('Data root path not specified');
    end