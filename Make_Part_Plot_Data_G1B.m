seqDefs = {
     'G1B_Seq3'
  	 'G1B_Seq6'
  	 'G1B_Seq7'
  	 'G1B_Seq8'
  	 'G1B_Seq11'
 	 'G1B_Seq12'
  	 'G1B_Seq13'
  	 'G1B_Seq14'
	};

accVar = {
	'accB_x_HP'
	'accB_y_HP'
	'accB_z_HP'
  	'accB_norm_HP'
	'accB_x_NF_HP'
   	'accB_y_NF_HP'
   	'accB_z_NF_HP'
 	'accB_norm_NF_HP'
	};

Config =  get_processing_config_defaults_G1B;

Data.G1B = make_part_plot_data_per_sequence(Data.G1B, seqDefs, accVar, Config);
