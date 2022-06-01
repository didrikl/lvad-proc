
seqDefs = {
    'IV2_Seq6'
	%'IV2_Seq7'
	};

accVar = {
 	'accA_x'
  	'accA_y'
  	'accA_z'
	%'accA_norm'
  	'accA_x_NF'
  	'accA_y_NF'
  	'accA_z_NF'
	%'accA_norm_NF_HP'
	};

close all
saveFig = true;
set(0,'DefaultFigureVisible','off');

Config =  get_processing_config_defaults_IV2;
Data.IV2 = make_spectrogram_and_curve_plot_data(Data.IV2, seqDefs, accVar, Config);
make_spectrogram_and_curve_plot_figure(Data.IV2, seqDefs, accVar, saveFig, Config)

set(0,'DefaultFigureVisible','on');
