%% Pre-process
% * Data fusion into given frequency
% * Make regularily sampled timetables of each recording segment parts
% * Add derived/filtered variables in the regular timetables
% * Reduce data to rows with given analysis_id
% * Remove columns that can be regenerated as needed

welcome(['Preprocess data ',seq],'module')

US = merge_Q_blocks(US);

PL = resample_signal(PL, Config.fs);
PL = calculate_pressure_gradient(PL, pGradVars);

S = fuse_data(Notes, PL, US, Config.fs, interNoteInclSpec, outsideNoteInclSpec);
S_parts = split_into_parts(S, Config.fs);

S_parts = add_spatial_norms(S_parts, 2, {'accA_x','accA_y','accA_z'}, 'accA_norm');
S_parts = add_spatial_norms(S_parts, 2, {'accA_x','accA_y'}, 'accA_xynorm');
%S_parts = add_spatial_norms(S_parts, 2, {'accB_x','accB_y','accB_z'}, 'accB_norm');

S_parts = add_harmonics_filtered_variables(S_parts,...
    {'accA_norm','accA_x','accA_y','accA_z'},...
	{'accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'});
S_parts = add_highpass_RPM_filter_variables(S_parts,...
	{'accA_x_nf','accA_y_nf','accA_z_nf','accA_norm'},...
	{'accA_x_nf_HP','accA_y_nf_HP','accA_z_nf_HP','accA_norm_nf_HP'},...
	Config.harmCut, 'harm', Config.harmCutFreqShift);
% S_parts = add_highpass_RPM_filter_variables(S_parts,...
% 	{'accA_x_nf','accA_y_nf','accA_z_nf','accA_norm'},...
% 	{'accA_x_nf_HP','accA_y_nf_HP','accA_z_nf_HP','accA_norm_nf_HP'},...
% 	Config.cutFreq, 'freq');

S = merge_table_blocks(S_parts);

S = reduce_to_analysis_G1(S, Notes, Config.idSpecs);
S_parts = remove_unneeded_variables_in_parts(S_parts);