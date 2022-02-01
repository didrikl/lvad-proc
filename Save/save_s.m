function save_s(S, proc_path, seq)
	
	welcome('Save S','function')
	
	filepath = fullfile(proc_path,[seq,'_S']);
	
	%parfeval(@save, 0, filepath, 'S');
	save(filepath,'S')
	display_filename([seq,'_S.mat'], proc_path, '\nSaved to:', '\t');
