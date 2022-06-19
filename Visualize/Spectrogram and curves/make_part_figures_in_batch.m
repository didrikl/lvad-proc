function make_part_figures_in_batch(Data, seqDefs, accVar, saveFig, Config)
	
	nVars = numel(accVar);
	for k=1:numel(seqDefs)
		
		% NOTE: Do as in make_spectrogram_and_curve_plot_data?
		eval(seqDefs{k});
		seq = get_seq_id(Config.seq);
		seqID = [Config.experimentID,'_',seq];
		partSpec = Config.partSpec;
		savePath = fullfile(Config.data_basePath, Config.seq_subdir, ...
			Config.proc_plot_subdir, 'Spectrogram and curve plots');
		
		nPartSegments = numel(Data.(seq).Plot_Data.T);
		if nPartSegments~=size(Config.partSpec,1)
			error(['Part definitions in sequence definition file must ',...
				'correspond to what is preprocessed'])
		end

		for i=1:nPartSegments
			for j=1:nVars
				
				T = Data.(seq).Plot_Data.T{i};				
				Notes = Data.(seq).Notes;
				map = Data.(seq).Plot_Data.rpmOrderMap{i};
				
% 				hFig = make_part_figure_2panels(T, Notes, map.(accVar{j}), ...
% 					accVar{j}, seqID, partSpec(i,:), Config.fs);
				hFig = make_part_figure_3panels(T, Notes, map.(accVar{j}), ...
					accVar{j}, seqID, partSpec(i,:), Config.fs);
				
				if saveFig
					save_figure(hFig, savePath, hFig.Name, 300)
					%save_figure(hFig, savePath, hFig.Name, 600)
					print(hFig,hFig.Name,'-dsvg')
				end

			end
		end
		close all

	end
