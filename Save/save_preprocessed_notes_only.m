function Data = save_preprocessed_notes_only(Config, Notes, Data)
	Config.proc_path = make_save_path(Config);
	save_notes(Notes, Config.proc_path, Config.seq)
	seqID = get_seq_id(Config.seq);
	Data.(Config.experimentID).(seqID).Notes = Notes;
	Data.(Config.experimentID).(seqID).S.Properties.UserData.Notes = Notes;
	for j=1:numel(Data.(Config.experimentID).(seqID).S_parts)
		Data.(Config.experimentID).(seqID).S_parts{j}.Properties.UserData.Notes = Notes;
	end
