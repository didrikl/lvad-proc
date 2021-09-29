%% Plot 1: Mean NHA scatter against Q red. and D along x 
% - One panel of all RPMs pooled
% - Includes all diameters (incl. intermediate levels) 
% - No error bars
% - Control and effect interventions
% - D is numerical (unevenly distributed)

close all

% Absolute values
vars = {
    'accA_x_nf_pow', []
%     'accA_y_nf_pow', [0,0.011]
%     'accA_norm_nf_pow', [0,0.011]%
%     'accA_x_nf_bpow', [0,0.011]
%     'accA_y_nf_bpow', [0,0.011]
%     'accA_norm_nf_bpow',[0,0.011]    
    };
h_figs = plot_effects(G_rel.avg,vars,'Absolute');

% Relative values
% vars = {    
%    'accA_x_nf_pow', [-0.5,4]
%    'accA_y_nf_pow', [-0.5,4]
%    'accA_norm_nf_pow', [-0.5,4]%
% };
%h_figs = plot_effects(G_rel.avg,vars,'Relative');

%for h=h_figs, save_figure(h, analysis_path, h.Name, 300); end

%% Plot 2a: Mean NHA + st.dev. bars against Q red. and D along x
% - One panel for each speed
% - Includes all diameters (incl. intermediate levels) 
% - Symmetric errorbars
% - Control and effect interventions
% - D is numerical (unevenly distributed)

close all

vars = {
	'accA_x_nf_pow', [0,0.011]
    'accA_y_nf_pow', [0,0.011]
    'accA_norm_nf_pow', [0,0.011]       
   };

h_figs = plot_effects_in_speed_tiles_with_errorbars_symmetric(G.avg,vars,{'Absolute','Means'},G.std);
%for h=h_figs, save_figure(h, analysis_path, h.Name, 300); end

%% Plot 2b: Median NHA + percentile bars aginst Q red. and D along x
% - One panel for each speed
% - Includes all diameters (incl. intermediate levels) 
% - Non-symmetric errorbars
% - Control and effect interventions
% - D is numerical (unevenly distributed)% - D is numerical (unevenly distributed)

close all

vars = {
    'accA_x_nf_pow', [0,0.011]
%     'accA_y_nf_pow', [0,0.011]
%     'accA_norm_nf_pow', [0,0.011]     
%     'accA_x_nf_bpow', [0,0.011]
%     'accA_y_nf_bpow', [0,0.011]
%     'accA_norm_nf_bpow', [0,0.011]     
%     'accA_x_nf_mpf', [90,210]
%     'accA_y_nf_mpf', [90,210]
%     'accA_norm_nf_mpf', [90,210]
    };
h_figs = plot_effects_in_speed_tiles_with_errorbars_symmetric(G.med,vars,{'Absolute','Medians'},G.q1,G.q3,F);

% Relative values
% vars = {
%     'accA_x_nf_pow', [-0.5,5]
%     'accA_y_nf_pow', [-0.5,5]
%     'accA_norm_nf_pow', [-0.5,5]
%     };
% h_figs = plot_effects_in_speed_tiles_with_errorbars_symmetric(G_rel.med,vars,{'Relative','Medians'},G_rel.q1,G_rel.q3);

% save_analysis_plots(h_figs,analysis_path,vars)



%% Plot 8: ROC curves in 1x4 panels for each pooled diameter states, overlaid for each speed

close all

classifiers = {
 	'accA_y_nf_pow';
	%'accA_norm_nf_pow';
	};
predStates = {
	%'diam_4.30mm_or_more', '>= 4.30mm'
	'diam_4.73mm_or_more', '>= 4.73mm'
	%'diam_6.00mm_or_more', '>= 6.0mm'
	'diam_6.60mm_or_more', '>= 6.6mm'
	%'diam_7.30mm_or_more', '>= 7.30mm'
	'diam_8.52mm_or_more', '>= 8.52mm'
	%'diam_9mm_or_more', '>= 9mm'
	%'diam_10mm_or_more', '>= 10mm'
	'diam_11mm_or_more', '>= 11mm'
	%'diam_12mm', '= 12mm'
	};
titleStr = 'ROC Curves for Pool of Pendulating Mass States';

h_figs = plot_roc_curves_per_pooled_interventions(...
	F_ROC,classifiers,predStates,titleStr);

%% Plot 9: ROC curves in [no of states]x4 panels for each specific diameter states and each speed

close all

classifiers = {
 	'accA_y_nf_pow';
	%'accA_norm_nf_pow';
	};
predStateVar = 'levelLabel';
predStates = {
	%'Inflated, 4.73 mm', 'PCI catheter 1'
	'Inflated, 6.60 mm', 'PCI catheter 2'
	'Inflated, 8.52 mm', 'PCI catheter 3'
	%'Inflated, 9 mm',    'RHC catheter'
	%'Inflated, 10 mm',   'RHC catheter'
	'Inflated, 11 mm',   'RHC catheter'
	};
titleStr = 'ROC Curves for Pendulating Mass States';
h_figs = plot_roc_curves_per_intervention(...
	F_ROC,classifiers,predStateVar,predStates,titleStr,false);

