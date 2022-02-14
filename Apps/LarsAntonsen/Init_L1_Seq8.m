%% User inputs
% -------------

Environment_Init_L1
fs_new = 1000;

% Which experiment
data_basePath = 'D:\Data\IVS\Lars\L1 - Data';
pc.seq_subdir = 'Seq8';

% Input directory structure
powerlab_subdir = 'Recorded\PowerLab';
notes_subdir = 'Noted';

% Files to use
pc.labChart_fileNames = {
    
    'Pig8BaselineECMOStart [ECG,X].mat'
	'Pig8BaselineECMOStart [Y].mat'
	
	'Pig8Flow [ECG,X].mat'
    'Pig8Flow [Y].mat'
    
	};
pc.notes_fileName = 'IV2_Seq19 - Notes IVS v1.0 - Rev4.xlsm';

% Correction input
pc.accChannelToSwap = {};
pc.blocksForAccChannelSwap = [];
pc.pChannelToSwap = {'p_eff','p_aff'};
pc.pChannelSwapBlocks = [];


%% Preprossesring
% ----------------

% Read PowerLab data in files exported from LabChart
pl_filePaths = fullfile(data_basePath,pc.seq_subdir,powerlab_subdir,pc.labChart_fileNames);
PL = init_labchart_mat_files(pl_filePaths,'',pc.labChart_varMapFile);

PL = resample_signal(PL, fs_new);

% Derive new variables. Edit according to needs
PL = add_spatial_norms(PL,2,{'accA_x','accA_y'},'accA_xynorm');
PL = add_moving_statistics(PL, {'accA_x','accA_xynorm'}, {'std','avg'});

% Fill LabChart comments into categoric colum
PL = fill_PL_comments(PL);

% All LabChart files/blocks gathered in one large timetable
T = merge_table_blocks(PL);

% examples of data extractions
T2 = T(T.time.Hour>14,:);
T2 = T(timerange('11/04/2021 14:00:00','11/04/2021 14:10:00'),:);
T2 = T(T.comments=='Blodprøver',:);
T2 = T(T.comments=="Flow3,5" | T.comments=="Flow4 lit",:);
