%% Store data on disc and in memory
      
welcome(['Save preprocessed sequences ',seq],'module')

pc.proc_path = make_save_path(pc, seq_subdir);
save_s_parts(S_parts, pc.proc_path, seq)
save_s(S, pc.proc_path, seq)
save_notes(Notes, pc.proc_path, seq)
Data = save_in_memory_struct(Data, Config, pc, S, S_parts, Notes, seq);
