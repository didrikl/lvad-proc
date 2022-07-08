%#ok<*NASGU>
% Do all or separate initialization of sequences (experiments)
% Initialize from raw data, preprocess and store (in memory and to disc)

run('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Initialize\Environment.m')

inputs = {
%   	'G1B_Seq3' % (pilot)
%     	'G1B_Seq6'
%     	'G1B_Seq7'
%     	'G1B_Seq8'
    'G1B_Seq11'
  	'G1B_Seq12'
    'G1B_Seq13'
  	'G1B_Seq14'
	};

for i=1:numel(inputs)

	% Init defauls, sequence specific inputs and progress bar.
	Config =  get_processing_config_defaults_G1B;
	eval(inputs{i});
	init_multiwaitbar_preproc(i, numel(inputs), Config.seq);
	
	% Init Data if not present in memory, otherwise update  
	Data.G1.(get_seq_id(Config.seq)).Config = Config;

	% Init individual data source with adjustment input
	Init_Data_Raw_G1;

	% Data fusion, derive signals, clip into segments and continous parts
	Preprocess_Sequence_G1B;

	% Store in Data (memory) and to disc
	Preprocess_Save;

	Preprocess_Roundup;
end

clear inputs i
