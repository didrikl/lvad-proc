function Data = make_part_plot_data_in_batch_parfor(Data, seqDefs, accVar, Config)

	nSeqs = numel(seqDefs);
	D = cell(nSeqs,1);
	C = cell(nSeqs,1);
	for i=1:nSeqs
		eval(seqDefs{i});
		C{i} = Config;
		seq{i} = get_seq_id(C{i}.seq);		
		D{i}= Data.(seq{i});
	end
	
	hBar = parfor_progressbar(nSeqs,'Make plot data');  %create the progress bar
	parfor i=1:nSeqs

		%welcome(sprintf('Make plot data for %s',seqDefs{i}),'function')
		%init_multiwaitbar_make_plot_data(i, nSeqs, seqDefs{i})
		hBar.iterate(1)
		% Update Config for current sequence
		%eval(seqDefs{i});
		
		if isempty([C{i}.partSpec{:,2}])
			warning('partSpec is not specified')
			continue
		end
		%seq = get_seq_id(C{i}.seq);
		
		%D = Data.(seq);
		[T, rpmOrderMap] = make_segment_plot_data(D{i}, accVar, C{i});

		D{i}.Plot_Data.T = T;
		D{i}.Plot_Data.rpmOrderMap = rpmOrderMap;
		D{i}.Plot_Data.partSpec = C{i}.partSpec;
		
	end

	for i=1:numel(nSeqs)
		Data.(seq{i}) = D{i};
	end

	%multiWaitbar('CloseAll');