% Liste med filnavn
path = 'C:\yourPath'; % Du m� kanskje bytte ut '\' med '/'
powerlab_fileNames = {
     'filename1.mat'
     'filename2.mat'
    };

% Oversikt over kanalene som finnes i filen, hva som man faktisk �nsker � bruke,
% og litt til. (Rekkef�lgen av opplistingen burde ikke spille noen rolle)
powerlab_variable_map = {
    % LabChart name  Matlab name  Target fs  Type        Continuity
    %'pGraft'         'p_graft'     'single'    'continuous'
    'SensorAAccX'    'accA_x'      'single'    'continuous'
    'SensorAAccY'    'accA_y'      'single'    'continuous'
    'SensorAAccZ'    'accA_z'      'single'    'continuous'
    'SensorBAccX'    'accB_x'      'single'    'continuous'
    'SensorBAccY'    'accB_y'      'single'    'continuous'
    'SensorBAccZ'    'accB_z'      'single'    'continuous'
    %'ECG'            'ecg'         'single'    'continuous'
    %'pMillarLV'      'pLV'         'single'    'continuous'
    };

% Les inn filene som cell array to timetables, en celle per filenavn
PL = init_labchart_mat_files(powerlab_filePaths,path,powerlab_variable_map);