%% Pre-process
% * Data fusion into given frequency
% * Make regularily sampled timetables of each recording segment parts
% * Add derived/filtered variables in the regular timetables
% * Reduce data to rows with given analysis_id
% * Remove columns that can be regenerated as needed

welcome(['Preprocess data ',Config.seq],'module')

Notes = pre_proc_notes_G1(Notes, Config);

US = merge_Q_blocks(US);

PL = resample_signal(PL, Config.fs);
%PL = calculate_pressure_gradient(PL, Config.pGradVars);

S = fuse_data(Notes, PL, US, Config.fs, Config.interNoteInclSpec, Config.outsideNoteInclSpec);

S_parts = split_into_parts(S, Config.fs);

S_parts = add_spatial_norms(S_parts, 2, {'accB_x','accB_y','accB_z'}, 'accB_norm');
%S_parts = add_spatial_norms(S_parts, 2, {'accB_x','accB_y'}, 'accB_xynorm');
%S_parts = add_spatial_norms(S_parts, 2, {'accB_y','accB_z'}, 'accB_yznorm');
%S_parts = add_spatial_norms(S_parts, 2, {'accB_x','accB_y','accB_z'}, 'accB_norm');

S_parts = add_harmonics_filtered_variables(S_parts,...
    {'accB_norm',   'accB_x',   'accB_y',   'accB_z'},...
	{'accB_norm_NF','accB_x_NF','accB_y_NF','accB_z_NF'},...
	Config.harmonicNotchFreqWidth, Config.fs);
S_parts = add_highpass_RPM_filter_variables(S_parts,...
	{'accB_x_NF',   'accB_y_NF',   'accB_z_NF',   'accB_norm_NF'},...
	{'accB_x_NF_HP','accB_y_NF_HP','accB_z_NF_HP','accB_norm_NF_HP'},...
	Config.harmCut, 'harm', Config.harmCutFreqShift, Config.fs);

S = merge_table_blocks(S_parts);
S = reduce_to_analysis_G1(S, Notes, Config.idSpecs, Config.remEchoRows);

% rpmOrderMap = make_rpm_order_map_per_part(S_parts, ...
% 	{'accB_x','accB_y','accB_z','accB_norm','accB_x_NF_HP','accB_y_NF_HP','accB_z_NF_HP'},...
% 	Config);

S_parts = remove_unneeded_variables_in_parts(S_parts);
