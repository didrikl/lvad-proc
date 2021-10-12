
%% Plot 2b: Median NHA + percentile bars aginst Q red. and D along x
% - One panel for each speed
% - Includes all diameters (incl. intermediate levels) 
% - Non-symmetric errorbars
% - Control and effect interventions
% - D is numerical (unevenly distributed)% - D is numerical (unevenly distributed)

close all

vars = {
    'accA_x_nf_pow', [0,0.011]
	'accA_y_nf_pow', [0,0.011]
%     'accA_norm_nf_pow', [0,0.011]     
%     'accA_x_nf_bpow', [0,0.011]
%     'accA_y_nf_bpow', [0,0.011]
%     'accA_norm_nf_bpow', [0,0.011]     
%     'accA_x_nf_mpf', [90,210]
%     'accA_y_nf_mpf', [90,210]
%     'accA_norm_nf_mpf', [90,210]
    };
plot_effects_against_intervention_categories_in_speed_panels(...
	G.med,vars,{'Absolute','Medians'},G.q1,G.q3,F,'Absolute median effects');

% Relative values
% vars = {
%     'accA_x_nf_pow', [-0.5,5]
%     'accA_y_nf_pow', [-0.5,5]
%     'accA_norm_nf_pow', [-0.5,5]
%     };
% h_figs = plot_effects_in_speed_tiles_with_errorbars_symmetric(G_rel.med,vars,{'Relative','Medians'},G_rel.q1,G_rel.q3);

% save_analysis_plots(h_figs,analysis_path,vars)



