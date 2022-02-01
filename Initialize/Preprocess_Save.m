%% Store data on disc and in memory
      
welcome(['Save preprocessed sequences ',seq],'module')

proc_path = make_save_path(Config, experiment_subdir);
save_s_parts(S_parts, proc_path, seq)
save_s(S, proc_path, seq)
save_notes(Notes, proc_path, seq)
Data = save_in_memory_struct(Data, Config, S, S_parts, Notes, seq);
