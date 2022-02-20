function Data = load_processed_sequences(seqNames, seqFilePaths)

	welcome('Loading processed data files')
	Data = struct;
	seqNames = cellstr(seqNames);
	seqFilePaths = cellstr(seqFilePaths);

	init_multiwaitbar_saved_preproc
	Data = load_data(Data,'S',seqFilePaths,seqNames);
	Data = load_data(Data,'S_parts',seqFilePaths,seqNames);
	Data = load_data(Data,'Notes',seqFilePaths,seqNames);
	Data = load_data(Data,'Config',seqFilePaths,seqNames);
	multiWaitbar('CloseAll');

function Data = load_data(Data,dataType,seqFilePaths,seqNames)

	seqFilePaths = seqFilePaths+"_"+dataType+".mat";
	nSeqs = numel(seqNames);

	for i=1:nSeqs
	
		seq = get_seq_id(seqNames{i});
		seqFilePath = seqFilePaths{i};
		display_filename(seqFilePath,'',['\nLoading processed ',dataType,' file']);
		try
			load(seqFilePath)
			Data.(seq).(dataType) = eval(dataType);
		catch err
			warning('File not loaded')
			disp(err)
			continue
		end
		cancel = multiWaitbar(['Loading processed ',dataType,' files'],i/nSeqs);
		if cancel, break, end

	end
