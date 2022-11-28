close all

set(0,'DefaultFigureVisible','off');

seqDefs = {
%    	'G1B1_Seq6'
%    	'G1B1_Seq7'
%  	'G1B1_Seq8'
 	'G1B1_Seq10'  % Terminated
%    	'G1B1_Seq11'
%    	'G1B1_Seq12'
%   	'G1B1_Seq13'
	};

eventToClip = {
	'Injection, saline'
	'Hands on'
	'Echo on'
	'Fibrillation'
	};


%% Plots for driveline accelerometer
% Must have sequences for G1B1 loaded

Config =  get_processing_config_defaults_G1B1;

accVar = {
    'accB_x'
    'accB_y'
    'accB_z'
    'accB_norm'
 	};

Data.G1B1 = make_part_plot_data_per_sequence(Data.G1B1, seqDefs, accVar, Config, eventToClip);
make_part_figures_in_batch(Data.G1B1, seqDefs, accVar, Config, ...
	@make_all_injection_figures_ver2, 'Spectrogram and curves - All injections - Clipped - accB')

Data.G1B1 = make_part_plot_data_per_sequence(Data.G1B1, seqDefs, accVar, Config);
make_part_figures_in_batch(Data.G1B1, seqDefs, accVar, Config, ...
   	@make_all_injection_figures_ver2, 'Spectrogram and curves - All injections - Unclipped - accB')



%% Plots for pump accelerometer
% Must have sequences for G1B1 loaded

proc_plot_subdir = Config.proc_plot_subdir;
Config =  get_processing_config_defaults_G1;
Config.proc_plot_subdir = proc_plot_subdir;

accVar = {
 	'accA_x'
    'accA_y'
    'accA_z'
    };

Data.G1B1 = make_part_plot_data_per_sequence(Data.G1B1, seqDefs, accVar, Config, eventToClip);
make_part_figures_in_batch(Data.G1B1, seqDefs, accVar, Config, ...
	@make_all_injection_figures_ver2, 'Spectrogram and curves - All injections - Clipped - accA')

Data.G1B1 = make_part_plot_data_per_sequence(Data.G1B1, seqDefs, accVar, Config);
make_part_figures_in_batch(Data.G1B1, seqDefs, accVar, Config, ...
	@make_all_injection_figures_ver2, 'Spectrogram and curves - All injections - Unclipped - accA')


%% Roundup

clear accVar seqDefs eventToClip
set(0,'DefaultFigureVisible','on');
