close all
set(0,'DefaultFigureVisible','off');

seqDefs = {
	'IV2B_Seq6'
	'IV2B_Seq7'
	'IV2B_Seq9'
	'IV2B_Seq10'
	'IV2B_Seq11'
	'IV2B_Seq12'
	'IV2B_Seq13'
	'IV2B_Seq14'
	'IV2B_Seq18'
	'IV2B_Seq19'
	};

accVar = {
	'accB_x'
	'accB_y'
	'accB_z'
	'accB_norm'
	'accB_x_NF'
	'accB_y_NF'
	'accB_z_NF'
	'accB_norm_NF_HP'
	};

Config =  get_processing_config_defaults_IV2B;

Data.IV2B = make_part_plot_data_per_sequence(Data.IV2B, seqDefs, accVar, Config);

make_part_figures_in_batch(Data.IV2B, seqDefs, accVar, Config, ...
	@make_part_figure_2panels, 'Spectrogram and curves - Balloon - accB')


%% Roundup

clear accVar seqDefs eventToClip
set(0,'DefaultFigureVisible','on');
