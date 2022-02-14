function Data = save_preprocessed_notes_only(pc, Notes, Data)
	pc.proc_path = make_save_path(pc);
	save_notes(Notes, pc.proc_path, pc.seq)
	seqID = get_seq_id(pc.seq);
	Data.(pc.experimentID).(seqID).Notes = Notes;
	Data.(pc.experimentID).(seqID).S.Properties.UserData.Notes = Notes;
	for j=1:numel(Data.(pc.experimentID).(seqID).S_parts)
		Data.(pc.experimentID).(seqID).S_parts{j}.Properties.UserData.Notes = Notes;
	end
