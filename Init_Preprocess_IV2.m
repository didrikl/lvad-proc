% Initialize from raw data, preprocess and store (in memory and to disc)
inputs = {
	'IV2_Seq6'
% 	'IV2_Seq7'
% 	'IV2_Seq9'
% 	'IV2_Seq10'
% 	'IV2_Seq11'
% 	'IV2_Seq12'
% 	'IV2_Seq13'
% 	'IV2_Seq14'
% 	'IV2_Seq18'
% 	'IV2_Seq19'
	};

% Do separate initialization parts
for i=1:numel(inputs)
	seq = inputs{i}(6:end);
	Environment_Init_IV2
	eval(inputs{i});
	Init_Data_Raw
	Init_Data_Preprocess
	Init_Data_Save
	Init_Data_Roundup
end

% Close all progress bar window and any pop-up messages
close2 all
