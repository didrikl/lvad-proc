function Data = load_config(pc, Data)
	load(fullfile(pc.stats_path,'pc'),'pc');
	Data = setfield(Data,'Config',pc);
