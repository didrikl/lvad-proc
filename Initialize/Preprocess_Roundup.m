fprintf(['\nInit <strong>',seq,'</strong> done.\n']);

% clear PL US 
% clear S S_parts Notes

clear experimentID;
clear ultrasound_subdir powerlab_subdir notes_subdir experiment_subdir ...
	experiment_path proc_plot_subdir proc_stats_subdir;
clear pl_filePaths us_filePaths notes_filePath;
clear labChart_varMapFile systemM_varMapFile notes_varMapFile;
clear labChart_fileNames notes_fileName ultrasound_fileNames;
clear data_basePath proc_path proc_subdir 
clear pGradVars outsideNoteInclSpec interNoteInclSpec;

clear US_offsets US_drifts PL_offset accChannelToSwap blocksForAccChannelSwap ...
	pChannelToSwap pChannelSwapBlocks PL_offset_files;

clear save_data

multiWaitbar('CloseAll');
close2 all;
clear hWait;
