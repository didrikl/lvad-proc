function Notes = pre_proc_notes_IV2(Notes, Config)
	Notes = add_obstruction_pst(Config, Notes, 'balDiam', 'arealObstr_pst');
	%Notes = add_balloon_volume(Notes);
	
