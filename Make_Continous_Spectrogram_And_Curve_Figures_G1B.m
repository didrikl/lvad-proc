close all
Config =  get_processing_config_defaults_G1B;

seqDefs = {
%	'G1B_Seq3' % Pilot
%   	'G1B_Seq6'
%   	'G1B_Seq7'
%  	'G1B_Seq8'
%	'G1B_Seq10'  % Terminated
%   	'G1B_Seq11'
%   	'G1B_Seq12'
%  	'G1B_Seq13'
%	'G1B_Seq14'
	};

accVar = {
 	'accB_x'
    'accB_y'
    'accB_z'
    'accB_norm'
 	};

eventToClip = {
	'Injection, saline'
	'Hands on'
	'Echo on'
	'Fibrillation'
	};

% Data.G1B = make_part_plot_data_per_sequence(Data.G1B, seqDefs, accVar, Config, eventToClip);
% make_part_figures_in_batch(Data.G1B, seqDefs, accVar, Config, ...
%    	@make_all_injection_figures_ver2, 'Spectrogram and curves - All injections - Clipped - accB')

Data.G1B = make_part_plot_data_per_sequence(Data.G1B, seqDefs, accVar, Config);
make_part_figures_in_batch(Data.G1B, seqDefs, accVar, Config, ...
   	@make_all_injection_figures_ver2, 'Spectrogram and curves - All injections - Unclipped - accB')

% set(0,'DefaultFigureVisible','off');
% make_part_figures_in_batch(Data.G1B, seqDefs, accVar, Config, ...
%  	@make_part_figure_2panels, 'Spectrogram and curves - Balloon - accB')


%% 

proc_plot_subdir = Config.proc_plot_subdir;
Config =  get_processing_config_defaults_G1;
Config.proc_plot_subdir = proc_plot_subdir;

accVar = {
 	'accA_x'
    'accA_y'
    'accA_z'
    };

eventToClip = {
	'Injection, saline'
	'Hands on'
	'Echo on'
	'Fibrillation'
	};

% Data.G1B = make_part_plot_data_per_sequence(Data.G1B, seqDefs, accVar, Config, eventToClip);
% make_part_figures_in_batch(Data.G1B, seqDefs, accVar, Config, ...
%  	@make_all_injection_figures_ver2, 'Spectrogram and curves - All injections - Clipped - accA')

Data.G1B = make_part_plot_data_per_sequence(Data.G1B, seqDefs, accVar, Config);
make_part_figures_in_batch(Data.G1B, seqDefs, accVar, Config, ...
   	@make_all_injection_figures_ver2, 'Spectrogram and curves - All injections - Unclipped - accA')


%%
clear accVar seqDefs eventToClip
set(0,'DefaultFigureVisible','on');
