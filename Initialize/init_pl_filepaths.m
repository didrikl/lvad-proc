function filePaths = init_pl_filepaths(pc, seq_subdir, fileNames)
	filePaths = fullfile(pc.data_basePath, seq_subdir, ...
		pc.powerlab_subdir, fileNames);
end