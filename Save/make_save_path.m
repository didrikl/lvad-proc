function proc_path = make_save_path(pc)
	proc_path = fullfile(pc.data_basePath, pc.seq_subdir, pc.proc_subdir);
	if not(exist(proc_path,'dir'))
		warning('Processed data save path is created')
		mkdir(proc_path); 
	end