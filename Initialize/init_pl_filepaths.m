function filePaths = init_pl_filepaths(Config, experiment_subdir, fileNames)
	filePaths = fullfile(Config.data_basePath, experiment_subdir, ...
		Config.powerlab_subdir, fileNames);
end