function save_statistics_as_separate_spreadsheets(Stats, path)

	% Save descriptive stastics
	% ---------------------------------------------------------
	G = Stats.Descriptive_Absolute;
	G_rel = Stats.Descriptive_Relative;
	G_del = Stats.Descriptive_Delta;
	
	g_path = fullfile(path,'Descriptive');

	save_data('Means', g_path, G.avg, 'spreadsheet');
	save_data('St.devs', g_path, G.std, 'spreadsheet');
	save_data('Medians', g_path, G.med, 'spreadsheet');
	save_data('25-percentiles', g_path, G.q1, 'spreadsheet');
	save_data('75-percentiles', g_path, G.q3, 'spreadsheet');
	save_data('Means - Relative', g_path, G_rel.avg, 'spreadsheet');
	save_data('St.devs - Relative', g_path, G_rel.std, 'spreadsheet');
	save_data('Medians - Relative', g_path, G_rel.med, 'spreadsheet');
	save_data('25-percentiles - Relative', g_path, G_rel.q1, 'spreadsheet');
	save_data('75-percentiles - Relative', g_path, G_rel.q3, 'spreadsheet');
	save_data('Means - Delta', g_path, G_del.avg, 'spreadsheet');
	save_data('St.dev.- Delta', g_path, G_del.std, 'spreadsheet');
	save_data('Medians - Delta', g_path, G_del.med, 'spreadsheet');
	save_data('25-percentiles - Delta', g_path, G_del.q1, 'spreadsheet');
	save_data('75-percentile - Delta', g_path, G_del.q3, 'spreadsheet');


	% Save each results table as .mat files and as Excel files
	% ---------------------------------------------------------
	t_path = fullfile(path,'Non-parametric paired test');
	
	save_data('Formatted results', t_path, Stats.Results, 'spreadsheet');
	save_data('P-values', t_path, Stats.Test_P_Values, 'spreadsheet');