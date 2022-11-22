function make_part_figures_in_batch(Data, seqDefs, accVar, Config, fnc, subDir)
	% Make figures in batch 
	%
	% Run in batch for the sequences and varibles given as input by the
	% function fnc handle input. 
	% 
	% Plot data must be prepared on the forehand, stored in 
	% Data.ExperX.SeqX.Plot_Data.T. Which recording parts/segments that shall be 
	% used must be specified in the sequence definition file (e.g. G1_Seq6).

	nVars = numel(accVar);
	
	for k=1:numel(seqDefs)
		
 		% Import sequence specification from file
		eval(seqDefs{k});
		seq = get_seq_id(Config.seq);
		partSpec = Data.(seq).Plot_Data.partSpec;		
		
		welcome(['Make figures in batch for ',seq,'\n'])
		fprintf(['Function: ',func2str(fnc)])
	
		isOK = check_partSpec_consistency(partSpec, Config.partSpec);
		if not(isOK), continue; end

		for i=1:size(partSpec,1)
			
			for j=1:nVars
				
				Notes = Data.(seq).Notes;
				T = Data.(seq).Plot_Data.T{i};				
				map = Data.(seq).Plot_Data.RPM_Order_Map{i};

				hFig = fnc(T, Notes, map, accVar{j}, Config, partSpec(i,:));
				
				savePath = fullfile(Config.data_basePath, Config.seq_subdir, ...
					Config.proc_plot_subdir, subDir);
	
				save_figure(hFig, fullfile(savePath,'png'), hFig.Name, 'png', 300);
				%save_figure(hFig, fullfile(savePath,'svg'), hFig.Name, 'svg');
				
			end
			close all

		end
		
	end

function isOK = check_partSpec_consistency(partSpec, partSpecInConfig)
	isOK = true;
	if not(isequal(partSpec, partSpecInConfig))
		isOK = false;
		fprintf('\n\n')
		msg = ['Part definitions in sequence definition file must ',...
			'correspond to what is preprocessed'];
		msgbox(msg)
		warning(msg)
		fprintf('\npartSpec in Plot_Data:\n\n')
		disp(partSpec)
		fprintf('\npartSpec in Config (as in sequence definition):\n\n')
		disp(partSpecInConfig)
	end
