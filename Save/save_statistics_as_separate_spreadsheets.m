function save_statistics_as_separate_spreadsheets(Stats, path)

	% Save descriptive stastics
	% ---------------------------------------------------------
	G = Stats.Descriptive_Absolute;
	G_rel = Stats.Descriptive_Relative;
	G_del = Stats.Descriptive_Delta;
	R = Stats.Results;
	
	g_path = fullfile(path,'Descriptive');

	G_avg = G.avg;
	G_std = G.std;
	G_med = G.med;
	G_q1 = G.q1;
	G_q3 = G.q3;
	G_rel_avg = G_rel.avg;
	G_rel_std = G_rel.std;
	G_rel_med = G_rel.med;
	G_rel_q1 = G_rel.q1;
	G_rel_q3 = G_rel.q3;
	G_del_avg = G_del.avg;
	G_del_std = G_del.std;
	G_del_med = G_del.med;
	G_del_q1 = G_del.q1;
	G_del_q3 = G_del.q3;

	save_data('Means', g_path, G_avg, 'spreadsheet');
	save_data('St.devs', g_path, G_std, 'spreadsheet');
	save_data('Medians', g_path, G_med, 'spreadsheet');
	save_data('25-percentiles', g_path, G_q1, 'spreadsheet');
	save_data('75-percentiles', g_path, G_q3, 'spreadsheet');
	save_data('Means - Relative', g_path, G_rel_avg, 'spreadsheet');
	save_data('St.devs - Relative', g_path, G_rel_std, 'spreadsheet');
	save_data('Medians - Relative', g_path, G_rel_med, 'spreadsheet');
	save_data('25-percentiles - Relative', g_path, G_rel_q1, 'spreadsheet');
	save_data('75-percentiles - Relative', g_path, G_rel_q3, 'spreadsheet');
	save_data('Means - Delta', g_path, G_del_avg, 'spreadsheet');
	save_data('St.dev.- Delta', g_path, G_del_std, 'spreadsheet');
	save_data('Medians - Delta', g_path, G_del_med, 'spreadsheet');
	save_data('25-percentiles - Delta', g_path, G_del_q1, 'spreadsheet');
	save_data('75-percentile - Delta', g_path, G_del_q3, 'spreadsheet');


	% Save each results table as .mat files and as Excel files
	% ---------------------------------------------------------
	t_path = fullfile(path,'Non-parametric paired test');
	
	Test_P_Values_Absolute = Stats.Test_P_Values_Absolute;
	Test_P_Values_Relative = Stats.Test_P_Values_Relative;
	save_data('P-values - Absolute', t_path, Test_P_Values_Absolute, 'spreadsheet');
	save_data('P-values - Relative', t_path, Test_P_Values_Relative, 'spreadsheet');

	save_data('Results', path, R, 'spreadsheet');
	

	