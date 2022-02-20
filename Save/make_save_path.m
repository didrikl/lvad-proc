function proc_path = make_save_path(Config)
	proc_path = fullfile(Config.data_basePath, Config.seq_subdir, Config.proc_subdir);
	if not(exist(proc_path,'dir'))
		warning('Processed data save path is created')
		mkdir(proc_path); 
	end