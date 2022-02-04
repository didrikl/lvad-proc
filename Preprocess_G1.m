%#ok<*NASGU> 

% Initialize from raw data, preprocess and store (in memory and to disc)
Config_G1
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
	pc = get_processing_config_defaults_G1;
	pc.askToReInit = true;
	eval(inputs{i});
	init_multiwaitbar_preproc(i, numel(inputs), seq);
	
	Init_Data_Raw_G1;
	Preprocess_Sequence_G1;
	Preprocess_Save;
	Preprocess_Roundup;
end

clear inputs i pc Config