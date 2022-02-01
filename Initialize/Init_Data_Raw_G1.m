%% Initialize
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

welcome(['Initialize ',seq],'module')

% Read PowerLab data in files exported from LabChart
pl_filePaths = init_pl_filepaths(Config, experiment_subdir, labChart_fileNames);
PL = init_labchart_mat_files(pl_filePaths, '', labChart_varMapFile);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
us_filePaths = init_us_filepaths(Config, experiment_subdir, ultrasound_fileNames);
US = init_system_m_text_files(us_filePaths, '', systemM_varMapFile);

% Read sequence notes made with Excel file template
notes_filePath = init_notes_filepaths(Config, experiment_subdir, notes_fileName);
Notes = init_notes_xls(notes_filePath, '', notes_varMapFile);


%% Quality control and fixes

welcome(['Quality control and fixes ',seq],'module')

Notes = qc_notes_G1(Notes, Config.idSpecs, askToReInit);

US = adjust_for_system_m_time_drift(US, US_drifts);
US = adjust_for_system_m_time_offset(US, US_offsets);

PL = adjust_for_constant_time_offset_for_filenames(PL, PL_offset_files, PL_offset);
PL = swap_channel_names(PL, accChannelToSwap, blocksForAccChannelSwap);
PL = swap_channel_names(PL, pChannelToSwap, pChannelSwapBlocks);
check_lvad_pressure_gradient_channels(PL, pGradVars);
