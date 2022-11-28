% Read sequence notes made with Excel file template
inputs = {
	'IV2B_Seq6'
	'IV2B_Seq7'
	'IV2B_Seq9'
	'IV2B_Seq10'
	'IV2B_Seq11'
	'IV2B_Seq12'
	'IV2B_Seq13'
	'IV2B_Seq14'
 	'IV2B_Seq18'
	'IV2B_Seq19'
	};


% Do separate initialization parts
for i=1:numel(inputs)
	Config =  get_processing_config_defaults_IV2B;
	eval(inputs{i});
	idSpecs = init_id_specifications(Config.idSpecs_path);
	Config.notes_filePath = init_notes_filepath(Config);

	Notes = init_notes_xls(Config.notes_filePath, '', Config.notes_varMapFile);
	Notes = qc_notes_IV2(Notes, idSpecs, Config.askToReInit);
	Notes = pre_proc_notes_IV2(Notes, Config);

	Data = save_preprocessed_notes_only(Config, Notes, Data);
	Preprocess_Roundup;
end

clear inputs i pc