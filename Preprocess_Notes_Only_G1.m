% Read sequence notes made with Excel file template
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

	pc.notes_filePath = init_notes_filepath(pc, seq_subdir, notes_fileName);
	Notes = init_notes_xls(pc.notes_filePath, '', pc.notes_varMapFile);

	idSpecs = init_id_specifications(pc.idSpecs_path);
	Notes = qc_notes_G1(Notes, idSpecs, pc.askToReInit);

	pc.proc_path = make_save_path(pc, seq_subdir);
	save_notes(Notes, pc.proc_path, seq)
	seqID = get_seq_id(seq);
	Data.(Config.experimentID).(seqID).Notes = Notes;
	Preprocess_Roundup;

end

clear inputs i pc