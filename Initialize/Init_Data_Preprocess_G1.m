%% Pre-process
% * Data fusion into given frequency
% * Make regularily sampled timetables of each recording segment parts
% * Add derived/filtered variables in the regular timetables

welcome(['Preprocess data',seq],'module')

US = merge_Q_blocks(US);

PL = resample_signal(PL, fs_new);
PL = calculate_pressure_gradient(PL,pGradVars);

S = fuse_data(Notes,PL,US,fs_new,interNoteInclSpec,outsideNoteInclSpec);
S_parts = split_into_parts(S,fs_new);

S_parts = add_spatial_norms(S_parts,2,{'accA_x','accA_y','accA_z'},'accA_norm');
S_parts = add_spatial_norms(S_parts,2,{'accA_x','accA_y'},'accA_xynorm');
%S_parts = add_spatial_norms(S_parts,2,{'accB_x','accB_y','accB_z'},'accB_norm');

S_parts = add_harmonics_filtered_variables(S_parts,...
    {'accA_norm','accA_xynorm','accA_x','accA_y','accA_z'},fs_new);
% NOTE: Alternatively, harmonics and highpass filter

% S_parts = add_filtered_variables(S_parts,...
%     {'accA_norm','accA_xynorm','accA_x','accA_y','accA_z'},fs_new);

%S_parts = add_moving_statistics(S_parts , varNames, statistics, newVarsNames)

% Add moving 3rd harmonic using trackorder?
% ...

S = merge_table_blocks(S_parts);
S = reduce_to_analysis_G1(S,Notes,idSpecs);
