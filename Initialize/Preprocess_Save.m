%% Store data on disc and in memory
      
welcome(['Save preprocessed sequences ',Config.seq],'module')

save_s_parts(S_parts, Config.proc_path, Config.seq)
save_s(S, Config.proc_path, Config.seq)
save_rpm_order_map(rpmOrderMap, Config.proc_path, Config.seq);

save_notes(Notes, Config.proc_path, Config.seq)
save_config(Config)

Data = save_in_memory_struct(Data, Config, S, S_parts, rpmOrderMap, Notes);
