function filePaths = init_pl_filepaths(Config)
	filePaths = fullfile(Config.data_basePath, Config.seq_subdir, ...
		Config.powerlab_subdir, Config.labChart_fileNames);
end