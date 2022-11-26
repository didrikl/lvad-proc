close all
set(0,'DefaultFigureVisible','off');

seqDefs = {
	'G1_Seq3'
  	'G1_Seq6'
   	'G1_Seq7'
    'G1_Seq8'
  	'G1_Seq11'
   	'G1_Seq12'
  	'G1_Seq13'
	'GB_Seq14'
	};

accVar = {
	'accA_x'
    'accA_y'
    'accA_z'
	'accA_x_NF_HP'
    'accA_y_NF_HP'
    'accA_z_NF_HP'
 	};


Config =  get_processing_config_defaults_G1;

Data.G1 = make_part_plot_data_per_sequence(Data.G1, seqDefs, accVar, Config);

make_part_figures_in_batch(Data.G1B, seqDefs, accVar, Config, ...
 	@make_part_figure_2panels, 'Spectrogram and curves - accB')


%% Roundup

clear accVar seqDefs eventToClip
set(0,'DefaultFigureVisible','on');