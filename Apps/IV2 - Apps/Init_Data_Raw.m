%% Initialize
% Initialize data into Matlab timetable format
% * Read PowerLab data (PL) and ultrasound (US) files stored as into cell arrays
% * Read notes from Excel file

welcome(['Initialize ',seq],'module')

% Read PowerLab data in files exported from LabChart
pl_filePaths = fullfile(data_basePath,experiment_subdir,powerlab_subdir,labChart_fileNames);
PL = init_labchart_mat_files(pl_filePaths,'',labChart_varMapFile);

% Read meassured flow and emboli (volume and count) from M3 ultrasound
us_filePaths  = fullfile(data_basePath,experiment_subdir,ultrasound_subdir,ultrasound_fileNames);
US = init_system_m_text_files(us_filePaths,'',systemM_varMapFile);

% Read sequence notes made with Excel file template
notes_filePath = fullfile(data_basePath,experiment_subdir,notes_subdir,notes_fileName);
Notes = init_notes_xlsfile_ver4(notes_filePath,'',notes_varMapFile);


%% Quality control and fixes

Notes = qc_notes_ver4(Notes,id_specs);

US = adjust_for_system_m_time_drift(US,US_drifts);


