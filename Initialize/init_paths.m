function [read_path, save_path] = init_paths()
    
    read_basedir = 'C:\Data\Recorded\Surface';
    experiment_subdir = 'IV_LVAD_CARDIACCS_1';
    rec_machine_subdir = 'Surface';
    
    save_basedir = 'C:\Data\Processed';
    
    read_path = fullfile(read_basedir,experiment_subdir,rec_machine_subdir);
    save_path = fullfile(save_basedir,experiment_subdir,rec_machine_subdir);
