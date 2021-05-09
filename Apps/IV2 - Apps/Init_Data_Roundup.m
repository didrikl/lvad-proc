clear PL US S

clear ultrasound_subdir powerlab_subdir notes_subdir experiment_subdir
clear pl_filePaths us_filePaths notes_filePath
clear labChart_varMapFile systemM_varMapFile notes_varMapFile
clear labChart_fileNames notes_fileName ultrasound_fileNames
clear US_drifts

multiWaitbar('CloseAll');
fprintf(['\nInit ',seq,' done.\n'])