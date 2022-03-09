function save_config(Config)

	welcome('Save processing config','function')
		
	filepath = fullfile(Config.proc_path,[Config.seq,'_Config']);
	save(filepath,'Config');
	display_filename([Config.seq,'_Config.mat'], Config.proc_path, '\nSaved to:', '\t');
