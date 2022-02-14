% Read sequence notes made with Excel file template
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
	eval(inputs{i});
	idSpecs = init_id_specifications(pc.idSpecs_path);	
	pc.notes_filePath = init_notes_filepath(pc);

	Notes = init_notes_xls(pc.notes_filePath, '', pc.notes_varMapFile);
	Notes = qc_notes_G1(Notes, idSpecs, pc.askToReInit);
	Notes = derive_cardiac_output(Notes);
	Notes = calc_obstruction(pc, Notes);

    Data = save_preprocessed_notes_only(pc, Notes, Data);
	Preprocess_Roundup;
end

clear inputs i