function init_multiwaitbar_preproc(i, nSeqs, seq)
	multiWaitbar('CloseAll');
	Colors_For_Processing
	[~, hWait] = multiWaitbar('Sequences', (i-1)/nSeqs, 'Color',ColorsProcessing.Orange);
	hWait.Name = ['Sequences, ',seq];
	multiWaitbar('Reducing to analysis ID segments',0,'Color',ColorsProcessing.Green);
	multiWaitbar('Calculate RPM order map',0,'Color',ColorsProcessing.Green);
	multiWaitbar('Splitting into parts',0,'Color',ColorsProcessing.Green);
	multiWaitbar('Data fusion',0,'Color',ColorsProcessing.Green);
	multiWaitbar('Resample/retime signal',0,'Color',ColorsProcessing.Green);
	multiWaitbar('Read LabChart .mat files', 0, 'CanCancel','on','Color',ColorsProcessing.Green);
end