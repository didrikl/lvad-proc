%#ok<*NASGU> 

% Initialize from raw data, preprocess and store (in memory and to disc)
inputs = {
%	'G1_Seq3' % (pilot)
% 	'G1_Seq6'
 	'G1_Seq7'
% 	'G1_Seq8'
% 	'G1_Seq11'
% 	'G1_Seq12'
% 	'G1_Seq13'
% 	'G1_Seq14'
	};

askToReInit = false;

% Do separate initialization parts
for i=1:numel(inputs)
	seq = inputs{i};
	Environment_Init_G1 % TODO make generic
	eval(inputs{i});

	Init_Data_Raw;
	Preprocess_Sequence_G1;
	Preprocess_Save;
end

Preprocess_Roundup;
