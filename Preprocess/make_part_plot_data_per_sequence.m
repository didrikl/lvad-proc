function Data = make_part_plot_data_per_sequence(Data, seqDefs, accVar, Config)

	[~, seqDefs] = get_cell(seqDefs);
	nSeqs = numel(seqDefs);
	
	for i=1:nSeqs

		welcome(sprintf('Make plot data for %s',seqDefs{i}),'module')
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
 		rpmOrderMap = make_rpm_order_map_per_part(T_parts, accVar, Config);
 		
		remVars = {
			'analysis_id'
			'part'
			'intervType'
			'event'
			'Q_LVAD'
			'P_LVAD'
			'balDiam'
			'balLev'
			'pumpSpeed'
			'embVol'
			'embType'
			'QRedTarget_pst'
			};
		T_parts = remove_variables(T_parts, remVars);
 		Data.(seq).Plot_Data.T = T_parts;
		Data.(seq).Plot_Data.RPM_Order_Map = rpmOrderMap;
		
	end

	multiWaitbar('CloseAll');
	