% Read sequence notes made with Excel file template
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
	pc = get_processing_config_defaults_IV2;
	eval(inputs{i});
	idSpecs = init_id_specifications(pc.idSpecs_path);
	pc.notes_filePath = init_notes_filepath(pc);

	Notes = init_notes_xls(pc.notes_filePath, '', pc.notes_varMapFile);
	Notes = qc_notes_IV2(Notes, idSpecs, pc.askToReInit);

	Data = save_preprocessed_notes_only(pc, Notes, Data);
	Preprocess_Roundup;
end

clear inputs i pc