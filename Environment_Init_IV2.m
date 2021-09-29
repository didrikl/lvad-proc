
%% Import definitions
Colors_For_Processing
Constants
Paths


%% Data categories and type

% Categoric overview of data segments to analyse 
idSpecs = init_id_specifications(idSpecs_path);

% Input file structure map, store in folder named Definitions
labChart_varMapFile = 'VarMap_LabChart_IV2';
systemM_varMapFile = 'VarMap_SystemM_IV2';
notes_varMapFile = 'VarMap_Notes_IV2_v1';


%% Progress bars

multiWaitbar('CloseAll');
[~,hWait] = multiWaitbar('Reading .mat files', 0,'CanCancel','on','Color',ColorsProcessing.Green);
if exist('seq','var')
    hWait.Name = ['Progress, ',seq]; 
end
multiWaitbar('Resample/retime signal',0,'Color',ColorsProcessing.Green);
multiWaitbar('Data fusion',0,'Color',ColorsProcessing.Green);
multiWaitbar('Splitting into parts',0,'Color',ColorsProcessing.Green);
multiWaitbar('Reducing to analysis ID segments',0,'Color',ColorsProcessing.Green);


%% Clearing of memory and command line

% Make command window empty (but keeping command history in memory)
fprintf(repmat('\n',1,25))
%home

% Close all figures
%close all;

% Clear function so that persistent variables defined within these are cleared
clear Save_Table Save_Figure
clear h_left_shade_sub1 h_left_shade_sub2 h_left_shade_zoom
clear h_right_shade_sub1 h_right_shade_sub2 h_right_shade_zoom

%%

warning('on')
