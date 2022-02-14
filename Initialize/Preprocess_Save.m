%% Store data on disc and in memory
      
welcome(['Save preprocessed sequences ',pc.seq],'module')

save_s_parts(S_parts, pc.proc_path, pc.seq)
save_s(S, pc.proc_path, pc.seq)
save_notes(Notes, pc.proc_path, pc.seq)
save_config(pc)
Data = save_in_memory_struct(Data, pc, S, S_parts, Notes);
