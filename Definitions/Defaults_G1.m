%% Defaults settings

experimentType = 'G1';

% How to fuse data
interNoteInclSpec = 'nearest';
outsideNoteInclSpec = 'none';

labChart_varMapFile = 'VarMap_LabChart_G1';
systemM_varMapFile = 'VarMap_SystemM_G1';
notes_varMapFile = 'VarMap_Notes_G1_v1_0_0';

pGradVars = {'pMillar','pGraft'};

US_offsets = {};
US_drifts = {}; 
accChannelToSwap = {};
blocksForAccChannelSwap = [];
pChannelToSwap = {};
pChannelSwapBlocks = [];
