% Store data
proc_path = fullfile(experiment_subdir,proc_subdir);
save(fullfile(proc_path,[seq,'_S_parts']),'S_parts')
save(fullfile(proc_path,[seq,'_S']),'S')
