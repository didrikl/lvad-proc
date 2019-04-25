%% Memory

% Close all figures
close all;

% Clear function so that persistent variables defined within these are cleared
clear Save_Table Save_Figure


%% Information

warning('off','MATLAB:table:ModifiedAndSavedVarnames')
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame')
%warning('off','verbose')
%warning('off','backtrace')


%% Plotting

% Make plots silently with invisible figures, which may be handy when producing 
% many plots in a batch
%if run_in_background
%    current_default_figure_visible = get(0,'DefaultFigureVisible');
%    set(0,'DefaultFigureVisible','off');
%end

% Control whether to use separate windows for figures or not
%set(0,'DefaultFigureWindowStyle','docked')
%set(0,'DefaultFigureWindowStyle','normal')