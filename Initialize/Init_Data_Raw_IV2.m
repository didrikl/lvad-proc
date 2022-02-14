%% Initialize
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

welcome(['Initialize ',pc.seq],'module')

pc.proc_path = make_save_path(pc);
pc.pl_filePaths = init_pl_filepaths(pc);
pc.us_filePaths = init_us_filepaths(pc);
pc.notes_filePath = init_notes_filepath(pc);

% Read PowerLab data in files exported from LabChart
PL = init_labchart_mat_files(pc.pl_filePaths, '', pc.labChart_varMapFile);

% Read meassured flow and emboli (volume and count) from System M4 ultrasound
US = init_system_m_text_files(pc.us_filePaths, '', pc.systemM_varMapFile);

% Read sequence notes made with Excel file template
Notes = init_notes_xls(pc.notes_filePath, '', pc.notes_varMapFile);

pc.idSpecs = init_id_specifications(pc.idSpecs_path);

%% Quality control and fixes

welcome(['Quality control and fixes ',pc.seq],'module')

Notes = qc_notes_IV2(Notes, pc.idSpecs, pc.askToReInit);

US = adjust_for_system_m_time_drift(US, pc.US_drifts);
US = adjust_for_system_m_time_offset(US, pc.US_offsets);

PL = adjust_for_constant_time_offset_for_filenames(PL, pc.PL_offset_files, pc.PL_offset);
PL = swap_channel_names(PL, pc.accChannelToSwap, pc.blocksForAccChannelSwap);
PL = swap_channel_names(PL, pc.pChannelToSwap, pc.pChannelSwapBlocks);
check_lvad_pressure_gradient_channels(PL, pc.pGradVars);
