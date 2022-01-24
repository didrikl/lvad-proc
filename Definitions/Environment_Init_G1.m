
%% Import definitions
Colors_For_Processing
Constants
Paths_G1


%% Data categories and type

% Categoric overview of data segments to analyse 
idSpecs = init_id_specifications(idSpecs_path);


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
clear save_data
clear h_left_shade_sub1 h_left_shade_sub2 h_left_shade_zoom
clear h_right_shade_sub1 h_right_shade_sub2 h_right_shade_zoom

%%

warning('on')

%%

askToReInit = true;

% How to fuse data
interNoteInclSpec = 'nearest';
outsideNoteInclSpec = 'none';

labChart_varMapFile = 'VarMap_LabChart_G1';
systemM_varMapFile = 'VarMap_SystemM_G1';
notes_varMapFile = 'VarMap_Notes_G1_v1_0_0';

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

notesVer = 'G1_ver1.0.0';

pGradVars = {'pMillar','pGraft'};

US_offsets = {};
US_drifts = {}; 
accChannelToSwap = {};
blocksForAccChannelSwap = [];
pChannelToSwap = {};
pChannelSwapBlocks = [];


