%% Import definitions
Colors_For_Processing
Constants
Paths


%% Progress bars

multiWaitbar('CloseAll');
multiWaitbar('Making steady-state features',0,'Color',ColorsProcessing.Green);
multiWaitbar('Making spectral densities',0,'Color',ColorsProcessing.Green);
multiWaitbar('Loading processed S files',0,'Color',ColorsProcessing.Green);
multiWaitbar('Loading processed S_parts files',0,'Color',ColorsProcessing.Green,'CanCancel','on');
    

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
