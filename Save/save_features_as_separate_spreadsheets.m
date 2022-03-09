function save_features_as_separate_spreadsheets(Features, path)

	F = Features.Absolute;
	F_rel = Features.Relative;
	F_del = Features.Delta;
	F_ROC = Features.Absolute_SPSS_ROC;
	W = Features.Paired_Absolute; 
	W_rel = Features.Paired_Relative; 

	% Save feature tables for analysis in Matlab
	save_data('Features', path, F, {'spreadsheet'});
	save_data('Features - Relative', path, F_rel, {'spreadsheet'});
	save_data('Features - Delta', path, F_del, {'spreadsheet'});
	save_data('Features - Paired for Wilcoxens signed rank test - Aboslute',path, W, 'spreadsheet');
	save_data('Features - Paired for Wilcoxens signed rank test - Relative',path, W_rel, 'spreadsheet');
	
	% Save various tables for ROC analysis in SPSS
	roc_path = fullfile(path,'For ROC analysis in SPSS');
	save_data('Features - PCI 1', roc_path, F_ROC.PCI1, 'spreadsheet');
	save_data('Features - PCI 2', roc_path, F_ROC.PCI2, 'spreadsheet');
	save_data('Features - PCI 3', roc_path, F_ROC.PCI3, 'spreadsheet');
	save_data('Features - RHC', roc_path, F_ROC.RHC, 'spreadsheet');
	save_data('Features - 4.73mm or more', roc_path, F_ROC.D_4_73_or_more, 'spreadsheet');
	save_data('Features - 6.60mm or more', roc_path, F_ROC.D_6_60_or_more, 'spreadsheet');
	save_data('Features - 8.52mm or more', roc_path, F_ROC.D_8_52_or_more, 'spreadsheet');
	save_data('Features - 9mm or more', roc_path, F_ROC.D_9_or_more, 'spreadsheet');
	save_data('Features - 10mm or more', roc_path, F_ROC.D_10_or_more, 'spreadsheet');
	save_data('Features - 11mm', roc_path, F_ROC.D_11, 'spreadsheet');

	
