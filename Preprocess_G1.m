%#ok<*NASGU>

% Initialize from raw data, preprocess and store (in memory and to disc)
inputs = {
	'G1_Seq3' % (pilot)
	'G1_Seq6'
	'G1_Seq7'
	'G1_Seq8'
  	'G1_Seq11'
  	'G1_Seq12'
  	'G1_Seq13'
  	'G1_Seq14'
	};

% Do separate initialization parts
for i=1:numel(inputs)
	Config =  get_processing_config_defaults_G1;
	eval(inputs{i});
	Data.G1.(get_seq_id(Config.seq)).Config = Config;
	init_multiwaitbar_preproc(i, numel(inputs), Config.seq);

	Init_Data_Raw_G1;
	Preprocess_Sequence_G1;
	Preprocess_Save;
	Preprocess_Roundup;
end

clear inputs i pc
