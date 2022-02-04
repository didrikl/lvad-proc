fprintf(['\nInit <strong>',seq,'</strong> done.\n']);

clear PL US 
% clear S S_parts Notes

clear labChart_fileNames notes_fileName ultrasound_fileNames;
clear pl_filePaths us_filePaths notes_filePath;
clear seq seq_subdir seqID
clear save_data

multiWaitbar('CloseAll');
close2 all;
clear hWait;
