
%% Import colors used for processing UI
Colors_For_Processing


%%

data_basePath = 'D:\Data\IVS\Didrik\IV2 - Data\';
analysis_path = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\Stats';

idSpecs_path = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Notater\Excel spreadsheets\ID_Spefications_IV2.xlsx';
idSpecs = init_id_specifications(idSpecs_path);


%% Progress bars

multiWaitbar('CloseAll');
multiWaitbar('Making steady-state features',0,'Color',ColorsProcessing.Green);
multiWaitbar('Making spectral densities',0,'Color',ColorsProcessing.Green);


%% Clearing of memory and command line

% Make command window empty (but keeping command history in memory)
fprintf(repmat('\n',1,25))
home

% Close all figures
close all;

% Clear function so that persistent variables defined within these are cleared
clear Save_Table Save_Figure


%%

warning('on')
