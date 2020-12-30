%% Initialze the processing environment and input file structure

% Which experiment
basePath = 'C:\Data\IVS\Didrik';
sequence = 'IV3_Seq1';
experiment_subdir = ['IV3 - Chronic pump thrombosis formation\Seq1 - LVAD2 - Pilot'];
% TODO: look up all subdirs that contains the sequence in the dirname. 

% Directory structure
powerlab_subdir = 'Recorded\PowerLab';
driveline_subdir = 'Recorded\Teguar';
ultrasound_subdir = 'Recorded\M3';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
powerlab_fileNames = {
    'IV3_Seq1 - F1_Sel1_ch1-5.mat'
    };
driveline_fileNames = {
    };
notes_fileName = 'IV3_Seq1 - Notes ver3.10 - Rev1.xlsm';
ultrasound_fileNames = {
    'ECM_2020_06_18__10_46_24.wrf'
    'ECM_2020_06_18__11_32_16.wrf'
};

% Add subdir specification to filename lists
%[read_path, save_path] = init_io_paths('Seq1 - LVAD2 - Pilot',basePath);
read_path = 'C:\Data\IVS\Didrik\IV3 - Chronic pump thrombosis formation\Seq1 - LVAD2 - Pilot\Recorded\';
save_path = 'C:\Data\IVS\Didrik\IV3 - Chronic pump thrombosis formation\Seq1 - LVAD2 - Pilot\Processed';
ultrasound_filePaths  = fullfile(basePath,experiment_subdir,ultrasound_subdir,ultrasound_fileNames);
powerlab_filePaths = fullfile(basePath,experiment_subdir,powerlab_subdir,powerlab_fileNames);
driveline_filePaths = fullfile(basePath,experiment_subdir,driveline_subdir,driveline_fileNames);
notes_filePath = fullfile(basePath, experiment_subdir,notes_subdir,notes_fileName);

powerlab_variable_map = {
    % LabChart name  Matlab name  Max frequency  Type        Continuity
    'Trykk1'         'affP'       1000           'single'    'continuous'
    'Trykk2'         'effP'       1000           'single'    'continuous'
    'SensorAAccX'    'accA_x'     700            'numeric'   'continuous'
    'SensorAAccY'    'accA_y'     700            'numeric'   'continuous'
    'SensorAAccZ'    'accA_z'     700            'numeric'   'continuous'
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

% Read meassured flow and emboli (volume and count) from M3 ultrasound
US = init_system_m_text_files(ultrasound_filePaths);

% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_ver3_9(notes_filePath);




%% Pre-processing

notes = qc_notes(notes);

S_parts = add_spatial_norms(S_parts,2);

ask_to_save({'S_parts','notes','feats'},sequence);


%%

PL = add_spatial_norms(PL,2);
T = PL{1};
T = resample_signal(T, 350);
T.pumpSpeed = 2500*ones(height(T),1);

% cut off where RPM is not actually 2500
T.dur = T.time - T.time(1);
T = T(T.dur>minutes(0.84),:);

%make_rpm_order_map(S_parts, 'accA_norm', 700, 'pumpSpeed', 0.02, 80)

rpm = 2500;
s = T.accA_norm;
%s = detrend(s);
Fs = 350;

L = numel(s);                                   % Signal Length
Fn = Fs/2;                                      % Nyquist Frequency
FTvr = fft(s)/L;                                % Fourier Transform
freq = linspace(0, 1, fix(L/2)+1)*Fn;           % Frequency Vector
Iv = 1:length(freq);                            % Index Vector

ampl = abs(FTvr(Iv))*2;
phase = angle(FTvr(Iv));

plot(freq, ampl);
title('Frequency amplitude plot')

% Add harmonics lines
harmonics = (1:4)*(rpm/60);
for i=1:numel(harmonics)
    xline(gca,harmonics(i),':',...
        'Color',[0.9290 0.740 0.1250,0.5],...
        'LineWidth',1.5,...
        'FontWeight','bold',...
        'LabelHorizontalAlignment','left',...
        'LabelVerticalAlignment','middle',...
        'Label',['harmonic ',num2str(i)]);
end

%ylim([0 prctile(ampl,99.9)])
xlim([1 200])
grid off
