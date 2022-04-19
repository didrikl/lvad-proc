function Notes = pre_proc_notes(Notes, Config)
	Notes = derive_cardiac_output(Notes);
	Notes = add_obstruction_pst(Config, Notes);
	Notes = add_balloon_volume(Notes);
	Notes = add_balloon_levels_from_xray(Notes, Config.balLevDiamLims);
	Notes = update_id_to_revised_balloon_levels(Notes);

