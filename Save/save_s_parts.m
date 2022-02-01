function save_s_parts(S_parts, proc_path, seq)
	
	welcome('Save S_parts','function')
	
	cellfun(@(c)setfield(c.Properties.UserData,'SequenceID',seq), S_parts,'UniformOutput',false);
	save_filePath = fullfile(proc_path, [seq,'_S_parts']);
	
	%parfeval(@save, 0, save_filePath, 'S_parts');
	save(save_filePath, 'S_parts')
	display_filename([seq,'_S_parts.mat'], proc_path, '\nSaved to:', '\t');
