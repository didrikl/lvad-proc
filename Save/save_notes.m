function save_notes(Notes, proc_path, seq)

	welcome('Save Notes and data config','function')
	
	Notes.Properties.UserData.SequenceID = seq;
	filepath = fullfile(proc_path,[seq,'_Notes']);
	save(filepath,'Notes');
	display_filename([seq,'_Notes.mat'], proc_path, '\nSaved to:', '\t');
