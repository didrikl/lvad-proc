%#ok<*NASGU> 

run('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Initialize\Environment.m')

% Initialize from raw data, preprocess and store (in memory and to disc)
data = struct;
inputs = {
	'IV2_Seq6'
   	'IV2_Seq7'
	'IV2_Seq9'
	'IV2_Seq10'
	'IV2_Seq11'
	'IV2_Seq12'
	'IV2_Seq13'
	'IV2_Seq14'
	'IV2_Seq18'
	'IV2_Seq19'
	};

% Do separate initialization parts
for i=1:numel(inputs)

	% Initialize
	Config =  get_processing_config_defaults_IV2;
	eval(inputs{i});
	init_multiwaitbar_preproc(i, numel(inputs), Config.seq);
	
	% Init individual data source with adjustment input
	Init_Data_Raw_IV2
	
	% Data fusion, derive signals, clip into segments and continous parts
	Preprocess_Sequence_IV2
	
	% Store on disc
	save_s_parts(S_parts, Config.proc_path, Config.seq)
	save_s(S, Config.proc_path, Config.seq)
	save_notes(Notes, Config.proc_path, Config.seq)
	save_config(Config)
	
	% Store in Data struct and cleanup memory
	Data = save_in_memory_struct(Data, Config, S, S_parts, Notes);
	Preprocess_Roundup

end

clear inputs i


