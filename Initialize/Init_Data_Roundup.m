clear PL US 
%clear S_parts

clear ultrasound_subdir powerlab_subdir notes_subdir experiment_path
clear pl_filePaths us_filePaths notes_filePath
%clear labChart_varMapFile systemM_varMapFile notes_varMapFile
clear labChart_fileNames notes_fileName ultrasound_fileNames
clear US_drifts PL_offset accChannelToSwap blocksForAccChannelSwap pChannelToSwap pChannelSwapBlocks

multiWaitbar('CloseAll');
clear hWait
fprintf(['\nInit <strong>',seq,'</strong> done.\n'])