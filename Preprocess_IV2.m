%#ok<*NASGU> 

% Initialize from raw data, preprocess and store (in memory and to disc)
Config_IV2
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
	pc = get_processing_config_defaults_G1;
	pc.askToReInit = true;
	eval(inputs{i});
	init_multiwaitbar_preproc(i, numel(inputs), seq);
	
	Init_Data_Raw_IV2
	Preprocess_Sequence_IV2
	Preprocess_Save
	Preprocess_Roundup
end

clear inputs i


