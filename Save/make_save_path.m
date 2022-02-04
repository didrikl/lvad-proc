function proc_path = make_save_path(pc, seq_subdir)
	proc_path = fullfile(pc.data_basePath, seq_subdir, pc.proc_subdir);
	if not(exist(proc_path,'dir'))
		warning('Processed data save path is created')
		mkdir(proc_path); 
	end