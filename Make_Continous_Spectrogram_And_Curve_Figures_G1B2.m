close all
set(0,'DefaultFigureVisible','off');

seqDefs = {
  	'G1B2_Seq6'
  	'G1B2_Seq7'
 	'G1B2_Seq8'
	'G1B2_Seq11'
  	'G1B2_Seq12'
 	'G1B2_Seq13'
	};

eventToClip = {
	'Injection, saline'
	'Hands on'
	'Echo on'
	'Fibrillation'
	};

%% Plots for driveline accelerometer
% Must have sequences for G1B2 loaded

Config =  get_processing_config_defaults_G1B2;

accVar = {
    'accB_x'
    'accB_y'
    'accB_z'
    'accB_norm'
 	};

Data.G1B2 = make_part_plot_data_per_sequence(Data.G1B2, seqDefs, accVar, Config, eventToClip);

make_part_figures_in_batch(Data.G1B2, seqDefs, accVar, Config, ...
   	@make_part_figure_2panels, 'Spectrogram and curves - Balloon - accB')


%% Roundup

clear accVar seqDefs eventToClip
set(0,'DefaultFigureVisible','on');
