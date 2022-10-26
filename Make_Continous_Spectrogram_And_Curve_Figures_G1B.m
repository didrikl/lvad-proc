close all

seqDefs = {
	%'G1B_Seq3'
   	'G1B_Seq6'
   	'G1B_Seq7'
  	'G1B_Seq8'
   	'G1B_Seq11'
   	'G1B_Seq12'
   	'G1B_Seq13'
	%'G1B_Seq14'
	};


%%

Config =  get_processing_config_defaults_G1B;
accVar = {
 	'accB_x'
    'accB_y'
    'accB_z'
    'accB_norm'
 	};

Data.G1B = make_part_plot_data_per_sequence(Data.G1B, seqDefs, accVar, Config);
make_part_figures_in_batch(Data.G1B, seqDefs, accVar, Config, ...
 	@make_all_injection_figures_ver2, 'Spectrogram and curves - All injections - accB')

%set(0,'DefaultFigureVisible','off');
%make_part_figures_in_batch(Data.G1B, seqDefs, accVar, Config, ...
% 	@make_part_figure_2panels, 'Spectrogram and curves - accB')
%set(0,'DefaultFigureVisible','on');


%% 

proc_plot_subdir = Config.proc_plot_subdir;
Config =  get_processing_config_defaults_G1;
Config.proc_plot_subdir = proc_plot_subdir;
accVar = {
 	'accA_x'
    'accA_y'
    'accA_z'
    'accA_norm'
 	};

Data.G1B = make_part_plot_data_per_sequence(Data.G1B, seqDefs, accVar, Config);
make_part_figures_in_batch(Data.G1, seqDefs, accVar, Config, ...
 	@make_all_injection_figures_ver2, 'Spectrogram and curves - All injections - accA')



%%
clear accVar seqDefs
