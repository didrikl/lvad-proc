function make_spectrogram_and_curve_plot_figure(Data, seqDefs, accVar, saveFig)
	
	Config = get_processing_config_defaults_G1;
	nVars = numel(accVar);
	for k=1:numel(seqDefs)
		
		% NOTE: Do as in make_spectrogram_and_curve_plot_data?
		eval(seqDefs{k});
		seq = get_seq_id(Config.seq);
		seqID = [Config.experimentID,'_',seq];
		partSpec = Config.partSpec;

		nPartSegments = numel(Data.(seq).Plot_Data.T);
		savePath = fullfile(Config.data_basePath, Config.seq_subdir, ...
			Config.proc_plot_subdir, 'Spectrogram and curve plots');
		for i=1:nPartSegments
			for j=1:nVars
				T = Data.(seq).Plot_Data.T{i};
				Notes = Data.(seq).Notes;
				map = Data.(seq).Plot_Data.rpmOrderMap{i};
				hFig = make_figure(T, Notes, map.(accVar{j}), ...
					accVar{j}, seqID, partSpec(i,:), Config.fs);
				
				if saveFig
					save_figure(hFig, savePath, hFig.Name, 600)
				end

			end
		end
		close all

	end

	% TODO: 
	% 2. Finne Q spikes for hvert steady state segment