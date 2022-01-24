% Store data
% TODO: Make functions
    
proc_path = fullfile(data_basePath,experiment_subdir,proc_subdir);
if not(exist(proc_path,'dir')), mkdir(proc_path); end
    
welcome('Save preprocessed sequences','module')

welcome('Save S_parts','function')
multiWaitbar('Saving S_parts','Busy','Color',ColorsProcessing.Orange);        
save_filePath = fullfile(proc_path,[seq,'_S_parts']);
%parfeval(@save,0,fullfile(proc_path,[seq,'_S_parts']),'S_parts');
save(fullfile(proc_path,[seq,'_S_parts']),'S_parts')
display_filename([seq,'_S_parts.mat'],proc_path,'\nSaved to:','\t');
multiWaitbar('Saving S_parts','Close');        

for i=1:numel(S_parts)
	S_parts{i}.Properties.Description = 'Fused data - Part no. segments';
	S_parts{i}.Properties.UserData.SequenceID = seq;
end

welcome('Save S','function')
multiWaitbar('Saving S','Busy','Color',ColorsProcessing.Orange);        
%parfeval(@save,0,fullfile(proc_path,[seq,'_S']),'S');
save(fullfile(proc_path,[seq,'_S']),'S')
display_filename([seq,'_S.mat'],proc_path,'\nSaved to:','\t');
multiWaitbar('Saving S','Busy','Close');        

save(fullfile(proc_path,[seq,'_Notes']),'Notes')
display_filename([seq,'_Notes.mat'],proc_path,'\nSaved to:','\t');

S.Properties.Description = 'Fused data - Analysis ID segments';
S.Properties.UserData.SequenceID = seq;

Notes.Properties.Description = 'Pre-processed notes';
Notes.Properties.UserData.SequenceID = seq;

seqID = split(seq,'_');
seqID = seqID{2};%[seqID{2}(1:3),sprintf('%.2d',str2double(seqID{2}(4:end)))];
Data.(seqID).S = S;
Data.(seqID).S_parts = S_parts;
Data.(seqID).Notes = Notes; 

fprintf(['\nInit <strong>',seq,'</strong> saved.\n'])

