%% Path for source code

% Load source code paths into Matlab path
addpath(genpath('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab'));

% Make command window empty (but keeping command history in memory)
fprintf(repmat('\n',1,20))
home
cd('C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab')
ls

%% Clearing of memory

% Close all figures
close all;

% Clear function so that persistent variables defined within these are cleared
clear functions global
if numel(who)>1
	switch questdlg('Clear all (workspace variables and more)?','Yes','No')
		case 'Yes', clear variables
		case 'Cancel', abort
	end
end

multiWaitbar('CloseAll');


%% Information

warning('on')
warning('off','MATLAB:table:ModifiedAndSavedVarnames')
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame')
warning('off','verbose')
warning('off','backtrace')


%% Plotting

% Control whether to use separate windows for figures or not
%set(0,'DefaultFigureWindowStyle','docked')
%set(0,'DefaultFigureWindowStyle','normal')

%set(0,'DefaultAxesColorOrder',brewermap(NaN,'Accent'))

% Starting in R2018b, some pan interactions are enabled by default, regardless
% of the pan mode. If you want to disable these default interactions, then use:
set(groot,'defaultAxesCreateFcn','disableDefaultInteractivity(gca)')

%set(groot,'DefaultFigureGraphicsSmoothing','on')
set(0, 'DefaultFigureRenderer', 'painters');

% To run plotting in the background
%set(0,'DefaultFigureVisible','off');
set(0,'DefaultFigureVisible','on');

clear e