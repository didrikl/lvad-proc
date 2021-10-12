% Initialize from raw data, preprocess and store (in memory and to disc)
inputs = {
	'Init_IV2_Seq6'
	'Init_IV2_Seq7'
	'Init_IV2_Seq9'
	'Init_IV2_Seq10'
	'Init_IV2_Seq11'
	'Init_IV2_Seq12'
	'Init_IV2_Seq13'
	'Init_IV2_Seq14'
	'Init_IV2_Seq18'
	'Init_IV2_Seq19'
	};

% Do separate initialization parts
for i=1:numel(inputs)
	Environment_Init_IV2
	Init_Data_Raw
	Init_Data_Preprocess
	Init_Data_Save
	Init_Data_Roundup
end

% Close all progress bar window and any pop-up messages
close2 all
