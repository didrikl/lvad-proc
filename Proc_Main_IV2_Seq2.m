%% Initialze the processing environment and code

% Add all subfolders to path. To be removed as it gives less control compared to importing packages

% Use code in packages with subfolders prefixed with a '+'
% import Initialize.*
% import Calculate.*
% import Analyze.*
% import Tools.*

% Settings for Matlab
init_matlab


%% Initilize file structures

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
      'IV2_Seq2 - B4.mat' 
      'IV2_Seq2 - B5.mat' 
      'IV2_Seq2 - B6.mat' 
    };
notes_fileName = 'IV2_Seq2 - Notes ver3.4 - Rev0.xlsm';
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

[raw_basePath, proc_basePath] = init_io_paths(experiment_subdir);


%% Initialize data tables

% Read experiment notes in Excel file template
notes = init_notes_xlsfile_v3_2(notes_filePath);
notes(isnat(notes.time),:) = [];

PL = init_powerlab_raw_matfiles(powerlab_fileNames,raw_basePath); 

% Read meassured flow and emboli (volume and count) from M3 ultrasound
US = init_m3_raw_textfile(ultrasound_fileNames,raw_basePath); 
US = merge_table_blocks(US);
US = retime(US,'regular','fillwithmissing','SampleRate',1);
US = US(:,[1,2]); % no need for emboli count

features = init_features_from_notes(notes); % --> Interperetations of notes. Should be early in the flow as a quality check of notes / notes format


%% Pre-process signal
% - Data fusion
% - Keep only data rows belonging to a sequence part?

%
% TODO: Move to preproc function, to avoid reading every time
% -----------------------------------------------------------
sampleRate = 500;

%clear PL
S = PL;
for i=1:numel(S)
    
    subBlock_inds = 1:1000000:height(S{i});
    n_subBlocks = numel(subBlock_inds)-1;
    if n_subBlocks>0
        S_subBlocks = cell(n_subBlocks,1);
        for j=1:n_subBlocks
            
            S_subBlocks{j} = S{i}(subBlock_inds(j):subBlock_inds(j+1),:);
            
            % TODO: Move to init function and OO?!
            S_subBlocks{j} = resample_signal(S_subBlocks{j}, sampleRate);
            
            % Merge block-wise with notes and clip to union of the time ranges
            % TODO: Test to use the 'union' keyword in syncronze function to achieve the
            % very same clipping instead, with keyword passed on as arg in the
            % merge_signal-function
            notes_block = notes(notes.time>=S_subBlocks{j}.time(1) & notes.time<=S_subBlocks{j}.time(end),:);
            if isempty(notes_block)
                S_subBlocks{j} = [];
                continue; 
            end
            S_subBlocks{j} = S_subBlocks{j}(S_subBlocks{j}.time>=notes_block.time(1) & S_subBlocks{j}.time<=notes_block.time(end),:);
            S_subBlocks{j} = merge_signal_and_notes(S_subBlocks{j},notes_block);
        end
        S{i} = merge_table_blocks(S_subBlocks);
        S{i}.Properties.SampleRate = sampleRate;
        clear S_subBlocks
    else
        notes_block = notes(notes.time>=S{i}.time(1) & notes.time<=S{i}.time(end),:);
        if isempty(notes_block)
            S{i} = [];
            continue;
        end
        S{i} = merge_signal_and_notes(S{i},notes_block);
    end    
end 


for i=1:numel(S)
    % Ultrasound is clipped to time range of B and notes, only (i.e. not
    % clipping of B to achive a union of the two time ranges)
    US_block = US(US.time>=S{i}.time(1) & US.time<=S{i}.time(end),:);
    S{i} = merge_signal_and_notes(S{i},US_block);
end
%clear US


%% Derive variables (before merging blocks)

% Add derived variables (after data fusion for efficiency)
for i=1:numel(S)
    
    % Spatial component vector Euclidian length
    S{i} = calc_norm(S{i}, 'accA');
    %S{i} = calc_norm(S{i}, 'gyrA');
    
    % Moving RMS, variance and standard deviation for 3 comp. length
    S{i} = calc_moving(S{i}, 'accA_norm');
    %S{i} = calc_moving(S{i}, 'gyrA_norm');
    
end


%% Merge blocks and split into parts instead

S = merge_table_blocks(S_blocks);
S.Properties.SampleRate = 500;
%save_table('signal_preproc.mat', proc_basePath, S, 'matlab'); 

parts = sort_nat(categories(S.part));
n_parts = numel(parts);
S_parts = cell(n_parts,1);
for i=1:n_parts
    fprintf('\tPart %s\n',parts{i})
    S_parts{i} = S(S.part==parts(i),:);
    S_parts{i}.Properties.SampleRate = sampleRate;
end


%% Manual assessment of specific intervention type segments

features = make_feature_windows2(S, features,'Balloon volume change'); 


%% RPM order plots of whole sequence parts

for i=6:numel(S_parts)
    make_rpm_order_map(S_parts{i},'accA_norm') %
    pause
end


%% Testing of part 6

S_part6 = S_parts{6};
%S_part6(S_part6.event=='Hands on',:) = [];
%S_part6(S_part6.event=='Pause',:) = [];
S_part6(S_part6.event=='Pause',:) = nan;
make_rpm_order_map(S_part6,'accA_norm') %


%% Make average order spectrogram and extract relevant features

Average_Order_Spectrum_For_Intervention_Segments


%%

figure
hold on
make_average_order_spectrum(lvad_signal(lvad_signal.part=='1',:));
make_average_order_spectrum(lead_signal(lead_signal.part=='1',:));
make_average_order_spectrum(lvad_signal(lvad_signal.part=='3',:));
spec = make_average_order_spectrum(lead_signal(lead_signal.part=='3',:));
legend({'LVAD, before injections','Driveline, before injections','LVAD, after injections','Driveline, after injections'})


%% Estimate the spectrum using the short-time Fourier transform

%make_spectrogram(signal_parts.part2_iv,'accNorm')


%% Make time domain plots

%make_time_plots(signal_parts.part2_iv,'accNorm')


%% Calc FFT
% Remove the static effect of gravity in the in vitro setup?
%   - no need for accNorm
%   - perhaps requiured when looking at a 2-D plane
% Adjust time to comparable intervention windows

%make_fft_plots(signal_parts.part2)


