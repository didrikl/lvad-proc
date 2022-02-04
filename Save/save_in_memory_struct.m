function Data = save_in_memory_struct(Data, Config, pc, S, S_parts, Notes, seq)
	
	seqID = get_seq_id(seq);
	
	experID = Config.experimentID;
	
	Data.(experID).(seqID).S = S;
	Data.(experID).(seqID).S_parts = S_parts;
	Data.(experID).(seqID).Notes = Notes;

	Data.(experID).Config = Config;
	Data.(experID).(seqID).Processing_Config = pc;