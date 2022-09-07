%Make_Part_Plot_Data_G1B


seqDefs = {
      'G1B_Seq3'
  	 'G1B_Seq6'
  	 'G1B_Seq7'
 	 'G1B_Seq8'
  	 'G1B_Seq11'
  	 'G1B_Seq12'
 %	 'G1B_Seq13'
    'G1B_Seq14'
	};

accVar = {
	'accB_x'
	'accB_y'
	'accB_z'
  	'accB_norm'
%     	'accB_x_NF_HP'
%     	'accB_y_NF_HP'
%     	'accB_z_NF_HP'
%   	'accB_norm_NF_HP'
	};

close all
saveFig = true;
set(0,'DefaultFigureVisible','off');
Config =  get_processing_config_defaults_G1B;
make_part_figures_in_batch(Data.G1B, seqDefs, accVar, saveFig, Config)
set(0,'DefaultFigureVisible','on');
