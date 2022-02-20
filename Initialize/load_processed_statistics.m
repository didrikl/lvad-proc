function Data = load_processed_statistics(Config, Data)
	load(fullfile(Config.stats_path,'Feature_Statistics'),'Feature_Statistics');
	Data = setfield(Data,'Feature_Statistics',Feature_Statistics);
