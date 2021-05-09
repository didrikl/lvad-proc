%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'C:\Data\IVS\Didrik';
sequence = 'IV2_Seq3';
experiment_subdir = 'Testing\IV2_StandVsFloorTest';
% TODO: look up all subdirs that contains the sequence in the dirname. 

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
spectrum_subdir = 'Recorded\Spectrum\Blocks';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
labChart_fileNames = {
    'IV2_Seq3 - StandVsFloorTest.mat'
    };
notes_fileName = 'IV2_StandVsFloorTest - Notes ver3.7 - Rev0.xlsm';
ultrasound_fileNames = {                         
    };

% Add subdir specification to filename lists
[read_path, save_path] = init_io_paths(sequence,basePath);
ultrasound_filePaths  = fullfile(basePath,experiment_subdir,spectrum_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,experiment_subdir,powerlab_subdir,labChart_fileNames);
notes_filePath = fullfile(basePath, experiment_subdir,notes_subdir,notes_fileName);

powerlab_variable_map = {
    % LabChart name  Matlab name  Max frequency  Type        Continuity
    'Trykk1'         'affP'       1000           'single'    'continuous'
    'Trykk2'         'effP'       1000           'single'    'continuous'
    'SensorAAccX'    'accA_x'     700            'numeric'   'continuous'
    'SensorAAccY'    'accA_y'     700            'numeric'   'continuous'
    'SensorAAccZ'    'accA_z'     700            'numeric'   'continuous'
    'SensorBAccX'    'gyrA_x'     700            'numeric'   'continuous'
    'SensorBAccY'    'gyrA_y'     700            'numeric'   'continuous'
    'SensorBAccZ'    'gyrA_z'     700            'numeric'   'continuous'
    };

%% Read data into Matlab
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

init_matlab
welcome('Initializing data','module')
if load_workspace({'S_parts','notes','feats'}); return; end

% Read PowerLab data in files exported from LabChart
PL = init_labchart_mat_files(powerlab_filePaths,'',powerlab_variable_map);
    
% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver3_9(notes_filePath);


%% Pre-processing
% Transform and extract data for analysis
% * QC/pre-fixing data
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency

notes = qc_notes(notes);
S = fuse_data(notes,PL);
S_parts = split_into_parts(S);
S_parts = add_spatial_norms(S_parts,2);
S_parts = add_moving_statistics(S_parts);
S_parts = add_moving_statistics(S_parts,{'accA_x'});
S_parts = add_harmonics_filtered_variables(S_parts);


%%

make_rpm_order_map(S_parts{1},'accA_norm',700,'pumpSpeed', 0.02, 90); %
make_rpm_order_map(S_parts{2},'accA_norm',700,'pumpSpeed', 0.02, 90); %
make_rpm_order_map(S_parts{1},'accA_x',700,'pumpSpeed', 0.02, 90); %
make_rpm_order_map(S_parts{2},'accA_x',700,'pumpSpeed', 0.02, 90); %


%%

[map_s,order_s,rpm_s,time_s] = make_rpm_order_map(S_parts{1},'accA_norm',700,'pumpSpeed', 0.02, 90);
[map_f,order_f,rpm_f,time_f] = make_rpm_order_map(S_parts{2},'accA_norm',700,'pumpSpeed', 0.02, 90);
rpms = unique(rpm_f);
map_diff = nan(size(map_s));

for i=1:numel(rpms)
    f_inds = rpm_f==rpms(i);
    s_inds = rpm_s==rpms(i);
    spec = orderspectrum(map_f(:,f_inds),order_f);
    map_diff(:,s_inds) = map_s(:,s_inds)+spec;
end

imagesc(time_s,order_s,map_diff);
caxis([-15,15]);
h = gca;
set(h,'ydir','normal');
colorbar


%%

[map_s,order_s,rpm_s,time_s] = make_rpm_order_map(S_parts{1},'accA_x',700,'pumpSpeed', 0.01, 99);
[map_f,order_f,rpm_f,time_f] = make_rpm_order_map(S_parts{2},'accA_x',700,'pumpSpeed', 0.01, 99);
rpms = unique(rpm_f);
map_diff = nan(size(map_s));

for i=1:numel(rpms)
    f_inds = rpm_f==rpms(i);
    s_inds = rpm_s==rpms(i);
    spec = orderspectrum(map_f(:,f_inds),order_f);
    map_diff(:,s_inds) = map_s(:,s_inds)+spec;
end

imagesc(time_s,order_s,map_diff);
caxis([-15,15]);
h = gca;
set(h,'ydir','normal');
colorbar

