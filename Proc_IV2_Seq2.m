%% Initialze the processing environment and input file structure
% Add all subfolders to path. To be removed as it gives less control compared to importing packages

% Use code in packages with subfolders prefixed with a '+'
% import Initialize.*
% import Calculate.*
% import Analyze.*
% import Tools.*

% Which experiment
experiment_subdir    = 'IV2_Seq2 - Water simulated HVAD thrombosis - Pre-pump';

% Directory structure
powerlab_subdir = 'PowerLab';
spectrum_subdir = 'Spectrum\Blocks';
notes_subdir = 'Noted';

% Which files to input from input directory 
% NOTE: Could be implemented to be selected interactively using uigetfiles
powerlab_fileNames = {
    'IV2_Seq2 - B1.mat'
     'IV2_Seq2 - B2.mat' 
      'IV2_Seq2 - B3.mat' 
      %'IV2_Seq2 - B4.mat' % included in B5 by mistake 
      'IV2_Seq2 - B5.mat' 
      'IV2_Seq2 - B6.mat' 
    };
notes_fileName = 'IV2_Seq2 - Notes ver3.4 - Rev4.xlsm';
ultrasound_fileNames = {
    'ECM_2020_01_08__11_06_21.wrf'
    'ECM_2020_01_09__16_14_36.wrf'
    'ECM_2020_01_09__17_05_19.wrf'
    'ECM_2020_01_14__11_41_39.wrf'
    'ECM_2020_01_14__13_34_12.wrf'
    };

% Add subdir specification to filename lists
ultrasound_fileNames  = fullfile(spectrum_subdir,ultrasound_fileNames);
powerlab_fileNames = fullfile(powerlab_subdir,powerlab_fileNames);
notes_filePath = fullfile(experiment_subdir,notes_subdir,notes_fileName);

% Settings for Matlab
init_matlab
[raw_basePath, proc_basePath] = init_io_paths(experiment_subdir);

% TODO: Make OO, list files and ask for which version to use
% [notes_filePath] = init_notes(experiment_subdir);
% [pl_filePath] = init_powerlab(experiment_subdir);
% [ul_filePath] = init_spectrum(experiment_subdir);
% [cardiaccs_filePath] = init_cardiaccs(experiment_subdir);

%% Initialize and preprocessing data
% * Read PowerLab data (PL) and ultrasound (US) files as blocks, stored as into
%   cell arrays
% * Read notes from Excel file
% * Block-wise fusion of notes into PL, and then US into PL, followed by merging
%   of blocks into one table S
% * Splitting into parts, each resampling to regular sampling intervals of given frequency
% * Deriving new variables of:
%      part duration, moving RMS and moving standard deviation

sampleRate = 500;

% Read PowerLab data in files exported from LabChart
PL = init_powerlab_raw_matfiles(powerlab_fileNames,raw_basePath);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
US = init_m3_raw_textfile(ultrasound_fileNames,raw_basePath);
    
% Read sequence notes made with Excel file template
notes = init_notes_xlsfile_v3_2(notes_filePath);
feats = init_features_from_notes(notes);
S = fuse_data(notes,PL,US);

S_parts = preprocess_sequence_parts(S, sampleRate);

%% Time analysis: 

Plot_RPM_Order_Map_With_Variables_Part_By_Part_Raw_Acc



%% Frequency analysis: 

% Make average order spectrogram and extract relevant features
Average_Order_Spectrum_For_Intervention_Segments

part = 8;
rpm = 2600;
S_part = S_parts{part};
S_part = S_part(S_part.pumpSpeed=='2600',:);

h_fft = figure(...
    'units','normalized',...
    'outerposition',[0 0 1 1],...
    'Name',['Frequency amplitudes - Part', num2str(part)]);
h_sub(1) = subplot(3,1,1);
make_fft_plots(S_part(S_part.balloonLevel=='1',:),'accA_norm',rpm);
title('Level 1')
h_sub(2) = subplot(3,1,2);
make_fft_plots(S_part(S_part.balloonLevel=='2',:),'accA_norm',rpm);
title('Level 2')
h_sub(3) = subplot(3,1,3);
make_fft_plots(S_part(S_part.balloonLevel=='3',:),'accA_norm',rpm);
title('Level 3')
% h_sub(4) = subplot(3,2,4);
% make_fft_plots(S_part(S_part.balloonLevel=='3',:),'accA_norm',rpm);
% title('Level 3')
% h_sub(5) = subplot(3,2,5);
% make_fft_plots(S_part(S_part.balloonLevel=='4',:),'accA_norm',rpm);
% title('Level 4')
% h_sub(6) = subplot(3,2,6);
% make_fft_plots(S_part(S_part.balloonLevel=='5',:),'accA_norm',rpm);
% title('Level 5')

set(h_sub,'Ylim',[0,0.0006])

fig_filePath = fullfile(proc_basePath,['Frequency amplitudes - Part ',num2str(part)]);
print(h_fft,'-dpng','-r600','-opengl',fig_filePath)


%% Calculate and analyse features

% Manual assessment of specific intervention type segments
feats = make_feature_windows2(S, feats,'Balloon volume change'); 


%% Spectrogram

part = 8;

%suptitle('Part 8 - Angio catheter - 2600 RPM')
h_spectrogram = figure(...
    'WindowState','maximized',...
    'name',['Spectrogram - Part', num2str(part)]);

make_spectrogram(S_parts{part},'accA_norm')

%print(h_spectrogram,'-dpng','-r600','-opengl',fig_filePath)


%% Time analysis
% Acceleration plot of part 8

figure(...
    'units','normalized',...
    'outerposition',[0 0 1 1],...
    'name','Accelerations of part 8')

% subplot(2,1,1)
yyaxis left
%plot(S_parts{8}.time, S_parts{8}.accA_norm_movRMS)
plot(S_parts{8}.time, S_parts{8}.accA_norm)
yyaxis right
plot(S_parts{8}.time, S_parts{8}.accA_norm_movStd)


%% Sound analysis

part = 12;
baseline = 1;
varName = 'accA_norm';
dur_sec = 12;
speedUp = 4;

P = S_parts{part};
B = S_parts{baseline};
B = B(get_steady_state_rows(B) & B.pumpSpeed=='3200',:);

fs = get_sampling_rate(P);
notches = (2600/60)*[1,4];
n_levels = 5;

B.(varName) = detrend(B.(varName));
P.(varName) = detrend(P.(varName));
%B.(varName) = highpass(B.(varName),0.20*notches(1)+2,fs);
%P.(varName) = highpass(P.(varName),0.20*notches(1)+2,fs);
% B.(varName) = lowpass(B.(varName),540/2,fs);
% P.(varName) = lowpass(P.(varName),540/2,fs);
% P = filter_notches(P,varName,notches,1);
% B = filter_notches(B,varName,notches,1);
% varName = [varName,'_hFilt'];

s = cell(1,n_levels+1);
s{1} = B.(varName);
for i=1:5   
    s{i+1} = P.(varName)(P.balloonLevel==num2str(i));
end

% Amplifying and clipping in time
n_samps = dur_sec*fs;
for i=1:numel(s)
    i-1
    s{i} = 2*(s{i}(1:n_samps));       
    sound(s{i},speedUp*540)
    pause(dur_sec/speedUp+0.1) 
end

