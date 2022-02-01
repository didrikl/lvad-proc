%% Import definitions
Colors_For_Processing
Paths_IV2


%% Progress bars

multiWaitbar('CloseAll');

    

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

