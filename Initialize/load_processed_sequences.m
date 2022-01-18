function Data = load_processed_sequences(seqNames,seqFilePaths)

	welcome('Loading processed data files')
	Data = struct;
	seqNames = cellstr(seqNames);
	seqFilePaths = cellstr(seqFilePaths);

	Data = load_data(Data,'S',seqFilePaths,seqNames);
	Data = load_data(Data,'S_parts',seqFilePaths,seqNames);
	Data.Sequences = fieldnames(Data);

function Data = load_data(Data,dataType,seqFilePaths,seqNames)

	seqFilePaths = seqFilePaths+"_"+dataType+".mat";
	nSeqs = numel(seqNames);

	for i=1:nSeqs

		seq = seqNames{i};
		seqFilePath = seqFilePaths{i};
		display_filename(seqFilePath,'',['\nLoading processed ',dataType,' file']);
		try
			load(seqFilePath)
			seqNoStr = sprintf('%.2d',str2double(seq(8:end)));
			Data.([seq(1:7),seqNoStr]).(dataType) = eval(dataType);
		catch err
			warning('File not loaded')
			disp(err)
			continue
		end
		cancel = multiWaitbar(['Loading processed ',dataType,' files'],i/nSeqs);
		if cancel, break, end

	end
