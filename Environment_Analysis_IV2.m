%% Import definitions
Colors_For_Processing
Constants
Paths_IV2


%% Progress bars

multiWaitbar('CloseAll');
multiWaitbar('Loading processed S files',0,'Color',ColorsProcessing.Green);
multiWaitbar('Loading processed S_parts files',0,'Color',ColorsProcessing.Green,'CanCancel','on');
multiWaitbar('Making steady-state features',0,'Color',ColorsProcessing.Green);
multiWaitbar('Making spectral densities',0,'Color',ColorsProcessing.Green);
    

%% Clearing of memory and command line

% Make command window empty (but keeping command history in memory)
fprintf(repmat('\n',1,25))
home

% Close all figures
close all;

% Clear function so that persistent variables defined within these are cleared
clear save_data


%%

warning('on')
