%% Pre-process
% * Data fusion into given frequency
% * Make regularily sampled timetables of each recording segment parts
% * Add derived/filtered variables in the regular timetables
% * Reduce data to rows with given analysis_id
% * Remove columns that can be regenerated as needed

welcome(['Preprocess data ',Config.seq],'module')

Notes = pre_proc_notes_IV2(Notes, Config);

US = merge_Q_blocks(US);
US = aggregate_effQ_and_affQ(US);

PL = resample_signal(PL, Config.fs);
PL = calculate_pressure_gradient(PL, Config.pGradVars);

S = fuse_data(Notes, PL, US, Config.fs, Config.interNoteInclSpec, Config.outsideNoteInclSpec);
S_parts = split_into_parts(S, Config.fs);

%S_parts = add_spatial_norms(S_parts,2, {'accB_x','accB_y','accB_z'}, 'accB_norm');

S_parts = add_harmonics_filtered_variables(S_parts,...
    {'accB_x','accB_y','accB_z'},...
	{'accB_x_NF','accB_y_NF','accB_z_NF'},...
	Config.harmonicNotchFreqWidth, Config.fs);

S = merge_table_blocks(S_parts);
S = reduce_to_analysis_IV2(S, Notes, Config.idSpecs);
S_parts = remove_unneeded_variables_in_parts(S_parts, {'affEmboliVol'});
