
seqDefs = {
    'G1_Seq3'
   	'G1_Seq6'
   	'G1_Seq7'
  	'G1_Seq8'
   	'G1_Seq11'
   	'G1_Seq12'
   	'G1_Seq13'
   	'G1_Seq14'
	};

accVar = {
 	'accA_x'
 	'accA_y'
 	'accA_z'
	'accA_norm'
  	'accA_x_NF_HP'
 	'accA_y_NF_HP'
 	'accA_z_NF_HP'
	'accA_norm_NF_HP'
	};

close all
saveFig = true;

set(0,'DefaultFigureVisible','off');
Data.G1 = make_spectrogram_and_curve_plot_data(Data.G1, seqDefs, accVar);
make_spectrogram_and_curve_plot_figure(Data.G1, seqDefs, accVar, saveFig)
set(0,'DefaultFigureVisible','on');
