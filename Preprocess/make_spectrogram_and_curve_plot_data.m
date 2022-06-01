function Data = make_spectrogram_and_curve_plot_data(Data, seqDefs, accVar, Config)

	nSeqs = numel(seqDefs);
	for i=1:nSeqs

		welcome(sprintf('Make plot data for %s',seqDefs{i}),'function')
		init_multiwaitbar_make_plot_data(i, nSeqs, seqDefs{i})
		
		% Update Config for current sequence
		eval(seqDefs{i});
		
		if isempty([Config.partSpec{:,2}])
			warning('partSpec is not specified')
			continue
		end
		seq = get_seq_id(Config.seq);
		
		D = Data.(seq);
		[T, rpmOrderMap] = make_segment_plot_data(D, accVar, Config);

		Data.(seq).Plot_Data.T = T;
		Data.(seq).Plot_Data.rpmOrderMap = rpmOrderMap;
		Data.(seq).Plot_Data.partSpec = Config.partSpec;
		
	end

	multiWaitbar('CloseAll');