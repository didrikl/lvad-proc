%% Initialze the processing environment and input file structure
% Use package...
init_matlab

welcome('Initializing user-input','module')

% Which experiment
basePath = 'D:\Data\IVS\Didrik';
sequence = 'Seq11 - LVAD13';
experiment_subdir = 'G1 - Simulated pre-pump and in situ thrombosis\Seq11 - LVAD13';

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
ultrasound_subdir = 'Recorded\SystemM';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
powerlab_fileNames = {
    
    % RPM interventions + baseline (incl startup and stablizing)
    %'G1_Seq11 - F1 [accA].mat'      
    %'G1_Seq11 - F1 [accB].mat'      
    %'G1_Seq11 - F1 [pGraft,pLV,ECG].mat'

    % Catheter insertion
    %'G1_Seq11 - F2 [accA].mat'      
    %'G1_Seq11 - F2 [accB].mat'      
    %'G1_Seq11 - F2 [pGraft,pLV,ECG].mat'      
    'G1_Seq11 - F3 [accA].mat'
    'G1_Seq11 - F3 [accB].mat'      
    %'G1_Seq11 - F3 [pGraft,pLV,ECG].mat'      
    
     % Afterload clamping
    'G1_Seq11 - F4 [accA].mat'      
    'G1_Seq11 - F4 [accB].mat'      
    %'G1_Seq11 - F4 [pGraft,pLV,ECG].mat'
    
    % Cather re-insertion
    % Balloon interventions
    'G1_Seq11 - F5 [accA].mat'      
    'G1_Seq11 - F5 [accB].mat'      
    %'G1_Seq11 - F5 [pGraft,pLV,ECG].mat'
    'G1_Seq11 - F7 [accA].mat'      
    'G1_Seq11 - F7 [accB].mat'      
    %'G1_Seq11 - F7 [pGraft,pLV,ECG].mat'
    
    }; 
notes_fileName = 'G1_Seq11 - Notes ver4.13 - Rev3.xlsm';
ultrasound_fileNames = {
    'ECM_2020_12_10__11_07_03.wrf'
};

% Add subdir specification to filename lists
%[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,experiment_subdir,ultrasound_subdir,ultrasound_fileNames);
notes_filePath = fullfile(basePath, experiment_subdir,notes_subdir,notes_fileName);
proc_path = fullfile(basePath,experiment_subdir,'Processed');
powerlab_filePaths = fullfile(basePath,experiment_subdir,powerlab_subdir,powerlab_fileNames);

powerlab_variable_map = {
    % LabChart name  Matlab name  Target fs  Type        Continuity
    'pGraft'         'p_graft'      'single'    'continuous'
    'ECG'            'ecg'         'single'    'continuous'
    'SensorAAccX'    'accA_x'      'single'    'continuous'
    'SensorAAccY'    'accA_y'      'single'    'continuous'
    'SensorAAccZ'    'accA_z'      'single'    'continuous'
      'SensorBAccX'    'accB_x'      'single'    'continuous'
      'SensorBAccY'    'accB_y'      'single'    'continuous'
      'SensorBAccZ'    'accB_z'      'single'    'continuous'
%    'pMillarLV'      'pLV'         'single'    'continuous'
    };

systemM_varMap = {
    % Name in Spectrum   Name in Matlab     SampleRate Type     Continuity   Units
    'VenflowLmin'        'Q_graft'          1          'single' 'continuous' 'L/min'
    };

%% Read data into Matlab
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

welcome('Initializing data','module')
if load_workspace({'S_parts','notes','feats'},proc_path); return; end

% Read PowerLab data in files exported from LabChart
PL = init_labchart_mat_files(powerlab_filePaths,'',powerlab_variable_map);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
US = init_m3_raw_textfile(ultrasound_filePaths,'',systemM_varMap);
secsAhead = 50;
US = adjust_for_linear_time_drift(US,secsAhead);

% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver4(notes_filePath);
notes = qc_notes_ver4(notes);


%% Pre-processing
% Transform and extract data for analysis
% * QC/pre-fixing data
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency

InclInterRowsInFusion = true;
fuse_note_mismatch_handle = {
    'clip'
    'snap to nearest'
    'full'
    };

%feats = init_features_from_notes(notes);

% S = fuse_data_parfor(notes,PL,US);
S = fuse_data(notes,PL,US,InclInterRowsInFusion);

% Lag sjekk: Hvis stor hopp mellom PL-filene, så spør om man vil fortsette
% Pre-clip with boundaries of PL
% S = resample_signal(S, 700);
% 
% Just to visualize signal in RPM order plot also when pump is off. First pump
% speed after turning of LVAD is used as dummy RPM value. It should be clear
% from the plot that the LVAD is off.
% TODO: Move this into plot function. It is misleading to do this as
% preprocessing. It is only for RPM order plotting.
% turnOn_ind = find(diff(S.pumpSpeed==0)==-1)+1;
% turnOff_ind = find(diff(S.pumpSpeed==0)==1)+1;
% 
% If notes starts with LVAD off, then include also this in turnOff_ind
% firstisOff_ind = find(S.pumpSpeed==0,1,'first');
% if not(ismember(firstisOff_ind,turnOff_ind))
%     turnOff_ind = [firstisOff_ind;turnOff_ind];
% end
% 
% Insert dummy RPM values for when LVAD is off in order to create spectrogram
% using RPM order plot. (Dummy value is the first LVAD-on-RPM value.)
% for i=1:numel(turnOn_ind)
%     S.pumpSpeed(turnOff_ind(i):turnOff_ind-1) = S.pumpSpeed(turnOn_ind(i));
% end
% 
% Handle special case if notes ends with LVAD off 
% (Dummy value is the last LVAD-on-RPM value.)
% if numel(turnOff_ind)==numel(turnOn_ind)+1
%     S.pumpSpeed(turnOff_ind(end):end) = turnOff_ind(end)-1;
% end
%    
% Flow though graft before starting LVAD is ignored.
% US(US.time<notes.time(3),:) = [];


S_parts = split_into_parts(S);


S_parts = add_spatial_norms(S_parts,2, {'accA_x','accA_y','accA_z'}, 'accA_norm');
S_parts = add_moving_statistics(S_parts,{'accA_norm','accA_x','accA_y','accA_z'});

S_parts = add_moving_statistics(S_parts,{'p_graft'});

% S_parts = add_spatial_norms(S_parts, 2, {'accB_x','accB_y','accB_z'}, 'accB_norm');
% S_parts = add_moving_statistics(S_parts,{'accB_norm'});


% Fpass = ([2200,2400,1800]/60)-1;
% Fs = 700;
% for i=1:3
%     S_parts{i}.accA_normHighPass = highpass(S_parts{i}.accA_norm,Fpass(i),Fs);
% end
% S_parts = add_moving_statistics(S_parts,{'accA_normHighPass'});

% QC of pressure
% ol_ind = S_parts{5}.p_graft>3*S_parts{5}.p_graft_movAvg;


% TODO:
% Add MPF, std, RMS and other statistics/indices into feats
% Revise categoric blocks, and put into feats

%ask_to_save({'S_parts','notes','feats'},sequence,proc_path);
%ask_to_save({'S_parts','notes'},sequence,proc_path);
