% Store data
% TODO: Make functions
    
proc_path = fullfile(data_basePath,experiment_subdir,proc_subdir);
if not(exist(proc_path,'dir')), mkdir(proc_path); end
    
welcome('Save preprocessed sequence','module')

welcome('Save S_parts','function')
multiWaitbar('Saving S_parts','Busy','Color',ColorsProcessing.Orange);        
save_filePath = fullfile(proc_path,[seq,'_S_parts']);
%parfeval(@save,0,fullfile(proc_path,[seq,'_S_parts']),'S_parts');
save(fullfile(proc_path,[seq,'_S_parts']),'S_parts')
display_filename([seq,'_S_parts.mat'],proc_path,'\nSaved to:','\t');
multiWaitbar('Saving S_parts','Close');        

welcome('Save S','function')
multiWaitbar('Saving S','Busy','Color',ColorsProcessing.Orange);        
%parfeval(@save,0,fullfile(proc_path,[seq,'_S']),'S');
save(fullfile(proc_path,[seq,'_S']),'S')
display_filename([seq,'_S.mat'],proc_path,'\nSaved to:','\t');
multiWaitbar('Saving S','Busy','Close');        

save(fullfile(proc_path,[seq,'_Notes']),'Notes')
display_filename([seq,'_Notes.mat'],proc_path,'\nSaved to:','\t');

seqID = [seq(1:7),sprintf('%.2d',str2double(seq(8:end)))];
Data.(seqID).S = S;
Data.(seqID).S_parts = S_parts;
Data.(seqID).Notes = Notes; 

