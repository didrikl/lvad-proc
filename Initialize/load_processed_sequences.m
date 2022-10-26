function Data = load_processed_sequences(seqNames, seqFilePaths, whatToLoad)

	welcome('Loading processed data files')
	Data = struct;
	seqNames = cellstr(seqNames);
	seqFilePaths = cellstr(seqFilePaths);

	init_multiwaitbar_saved_preproc

	if nargin<3
		whatToLoad = {'S','S_parts','Notes','Config','RPM_order_maps'};
	end

	for i=1:numel(whatToLoad)
		Data = load_data(Data, whatToLoad{i}, seqFilePaths, seqNames);
	end
	
	multiWaitbar('CloseAll');

function Data = load_data(Data,dataType,seqFilePaths,seqNames)

	seqFilePaths = seqFilePaths+"_"+dataType+".mat";
	nSeqs = numel(seqNames);

	allErr = "";
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
			allErr = [allErr;erase(err.message,"Unable to find file or directory ")];
			continue
		end
		
		cancel = multiWaitbar(['Loading processed ',dataType,' files'],i/nSeqs);
		if cancel, break, end

	end

	if length(allErr)>1
		msgbox(["Unable to find files or directories";...
			"--------------------------------------------";allErr])
	end

