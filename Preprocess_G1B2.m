%#ok<*NASGU>
% Do all or separate initialization of sequences (experiments)
% Initialize from raw data, preprocess and store (in memory and to disc)

run('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Initialize\Environment.m')

inputs = {
 	'G1B2_Seq3'
 	'G1B2_Seq6'
 	'G1B2_Seq7'
 	'G1B2_Seq8'
	'G1B2_Seq11'
 	'G1B2_Seq12'
 	'G1B2_Seq13'
 	'G1B2_Seq14'
	};

for i=1:numel(inputs)

	% Init defauls, sequence specific inputs and progress bar.
	Config =  get_processing_config_defaults_G1B2;
	eval(inputs{i});
	init_multiwaitbar_preproc(i, numel(inputs), Config.seq);
	
	% Init Data if not present in memory, otherwise update  
	Data.G1B2.(get_seq_id(Config.seq)).Config = Config;

	% Init individual data source with adjustment input
	Init_Data_Raw_G1;

	% Data fusion, derive signals, clip into segments and continous parts
	Preprocess_Sequence_G1B;

	% Store on disc
 	save_s_parts(S_parts, Config.proc_path, Config.seq)
 	save_s(S, Config.proc_path, Config.seq)
 	save_notes(Notes, Config.proc_path, Config.seq)
 	save_config(Config)
	
	% Store in Data struct and cleanup memory
	Data = save_in_memory_struct(Data, Config, S, S_parts, Notes);
	Preprocess_Roundup;
	
end

clear inputs i
