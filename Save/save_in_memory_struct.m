function Data = save_in_memory_struct(Data, Config, S, S_parts, rpmOrderMap, Notes)
	
	Config.seqID = get_seq_id(Config.seq);
	Data.(Config.experimentID).(Config.seqID).S = S;
	Data.(Config.experimentID).(Config.seqID).S_parts = S_parts;
	Data.(Config.experimentID).(Config.seqID).Plot_Data.RPM_Order_Map = rpmOrderMap;
	Data.(Config.experimentID).(Config.seqID).Notes = Notes;
	Data.(Config.experimentID).(Config.seqID).Config = Config;