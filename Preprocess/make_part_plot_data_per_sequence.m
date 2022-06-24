function Data = make_part_plot_data_per_sequence(Data, seqDefs, accVar, Config)

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
		
		Data.(seq).Plot_Data.partSpec = Config.partSpec;
		
		T_parts = make_curve_plot_data_per_part(Data.(seq), accVar, Config);
		Data.(seq).Plot_Data.T = T_parts;
		
		rpmOrderMap = make_rpm_order_map_per_part(T_parts, accVar, Config);
		Data.(seq).Plot_Data.RPM_Order_Map = rpmOrderMap;
 		
	end

	multiWaitbar('CloseAll');