close all
set(0,'DefaultFigureVisible','off');

seqDefs = {
    %'IV2_Seq6'
	%'IV2_Seq7'
	%'IV2_Seq9'
	%'IV2_Seq10'
	'IV2_Seq11'
	'IV2_Seq12'
	%'IV2_Seq13'
	%'IV2_Seq14'
	%'IV2_Seq18'
	%'IV2_Seq19'
	};

accVar = {
 	'accA_x'
  	'accA_y'
  	'accA_z'
	'accA_norm'
  	'accA_x_NF'
  	'accA_y_NF'
  	'accA_z_NF'
	'accA_norm_NF_HP'
	};

Config =  get_processing_config_defaults_IV2;

Data.IV2 = make_part_plot_data_per_sequence(Data.IV2, seqDefs, accVar, Config);

make_part_figures_in_batch(Data.IV2, seqDefs, accVar, Config, ...
   	@make_part_figure_2panels, 'Spectrogram and curves - Balloon - accA')


%% Roundup

clear accVar seqDefs eventToClip
set(0,'DefaultFigureVisible','on');
