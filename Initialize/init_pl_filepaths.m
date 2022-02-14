function filePaths = init_pl_filepaths(pc)
	filePaths = fullfile(pc.data_basePath, pc.seq_subdir, ...
		pc.powerlab_subdir, pc.labChart_fileNames);
end