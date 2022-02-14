function save_processing_config(pc)

	welcome('Save processing config','function')
		
	filepath = fullfile(pc.proc_path,[pc.seq,'_Config']);
	save(filepath,'pc');
	display_filename([pc.seq,'_Config.mat'], pc.proc_path, '\nSaved to:', '\t');
