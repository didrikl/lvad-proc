%% Path

% Add all subdirectories from current path into Matlab path
addpath(genpath('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab'));


%% Clearing of memory and command line

% Make command window empty (but keeping command history in memory)
fprintf(repmat('\n',1,20))
home

 
% Close all figures
%close all;

% Clear function so that persistent variables defined within these are cleared
clear Save_Table Save_Figure
clear h_left_shade_sub1 h_left_shade_sub2 h_left_shade_zoom
clear h_right_shade_sub1 h_right_shade_sub2 h_right_shade_zoom


%% Information

warning('on')
warning('off','MATLAB:table:ModifiedAndSavedVarnames')
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame')
warning('off','verbose')
warning('off','backtrace')


%% Plotting

% Make plots silently with invisible figures, which may be handy when producing 
% many plots in a batch
%current_default_figure_visible = get(0,'DefaultFigureVisible');
set(0,'DefaultFigureVisible','off');

% Control whether to use separate windows for figures or not
%set(0,'DefaultFigureWindowStyle','docked')
%set(0,'DefaultFigureWindowStyle','normal')

%set(0,'DefaultAxesColorOrder',brewermap(NaN,'Accent'))

% Starting in R2018b, some pan interactions are enabled by default, regardless
% of the pan mode. If you want to disable these default interactions, then use:
set(groot,'defaultAxesCreateFcn','disableDefaultInteractivity(gca)')