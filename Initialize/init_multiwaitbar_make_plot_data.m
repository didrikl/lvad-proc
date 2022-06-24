function init_multiwaitbar_make_plot_data(i, nSeqs, seq)
	multiWaitbar('CloseAll');
	Colors_For_Processing
	[~, hWait] = multiWaitbar(sprintf('Make plot data: %s',seq), ...
		(i-1)/nSeqs, 'Color',ColorsProcessing.Orange);
	hWait.Name = ['Sequences, ',seq];
	