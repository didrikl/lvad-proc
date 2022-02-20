%% Initialize
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

welcome(['Initialize ',Config.seq],'module')

Config.proc_path = make_save_path(Config);
Config.pl_filePaths = init_pl_filepaths(Config);
Config.us_filePaths = init_us_filepaths(Config);
Config.notes_filePath = init_notes_filepath(Config);

% Read PowerLab data in files exported from LabChart
PL = init_labchart_mat_files(Config.pl_filePaths, '', Config.labChart_varMapFile);

% Read meassured flow and emboli (volume and count) from System M4 ultrasound
US = init_system_m_text_files(Config.us_filePaths, '', Config.systemM_varMapFile);

% Read sequence notes made with Excel file template
Notes = init_notes_xls(Config.notes_filePath, '', Config.notes_varMapFile);

Config.idSpecs = init_id_specifications(Config.idSpecs_path);

%% Quality control and fixes

welcome(['Quality control and fixes ',Config.seq],'module')

Notes = qc_notes_IV2(Notes, Config.idSpecs, Config.askToReInit);

US = adjust_for_system_m_time_drift(US, Config.US_drifts);
US = adjust_for_system_m_time_offset(US, Config.US_offsets);

PL = adjust_for_constant_time_offset_for_filenames(PL, Config.PL_offset_files, Config.PL_offset);
PL = swap_channel_names(PL, Config.accChannelToSwap, Config.blocksForAccChannelSwap);
PL = swap_channel_names(PL, Config.pChannelToSwap, Config.pChannelSwapBlocks);
check_lvad_pressure_gradient_channels(PL, Config.pGradVars);
