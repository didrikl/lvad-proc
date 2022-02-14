function Data = save_in_memory_struct(Data, pc, S, S_parts, Notes)
	
	pc.seqID = get_seq_id(pc.seq);
	Data.(pc.experimentID).(pc.seqID).S = S;
	Data.(pc.experimentID).(pc.seqID).S_parts = S_parts;
	Data.(pc.experimentID).(pc.seqID).Notes = Notes;
	Data.(pc.experimentID).(pc.seqID).Config = pc;