% %% NHA, Q and P, per catheter type
% % Pendulating Mass in Inlet Conduit
% % [3 X nLevels] panels
% % Figure 3 in submission for ASAIO
% 
% %close all
% 
% nhaVars = {
%      'accA_x_nf_pow',[0,0.008]
%      'accA_y_nf_pow',[0,0.008]
%      %'accA_x_nf_bpow',[0,0.008]
%      %'accA_xynorm_nf_pow',[0,0.008]
%      %'accA_xynorm_nf_bpow',[0,0.008]
%      %'accA_norm_nf_pow',[0,0.008]
%      %'accA_norm_nf_bpow',[0,0.008]
%  };
% levelLabels = {
% 	'Inflated, 4.73 mm', 'Catheter 1'
% 	'Inflated, 6.60 mm', 'Catheter 2'
% 	'Inflated, 8.52 mm', 'Catheter 3'
% 	%'Inflated, 9 mm',    'Catheter 4'
% 	%'Inflated, 10 mm',   'Catheter 4'
% 	'Inflated, 11 mm',   'Catheter 4'
% 	};
% xVar = 'arealOccl_pst';
% xLims = [0,100];
% titleStr = 'Pendulating Mass in Inlet Conduit';
% xLab = 'Areal occlusion (%)';
% figWidth = 275*size(levelLabels,1);
% 
% h_figs = plot_nha_power_and_flow_per_intervention(...
% 	F,G.med,R,nhaVars,levelLabels,xVar,xLims,xLab,titleStr,figWidth);
% 
% 
% %% NHA, Q and P for afterload and prelod side by side 
% % Control intervention
% % [3 X 2] panels
% % Figure 2 in submission for ASAIO
% 
% close all
% 
% nhaVars = {
%      'accA_x_nf_bpow',[0,0.008]
%      'accA_y_nf_bpow',[0,0.008]
%      %'accA_z_nf_pow',[0,0.008]
%      %'accA_norm_nf_pow',[0,0.008]
% 	 %'accA_norm_nf_bpow',[0,0.008]
% 	 };
%  
% % Level categories plotted together
% levelLabels = {
% 	'Afterload', 'Outflow tube clamp'
% 	'Preload',   'Inflow tube clamp'
% 	};
% 
% % Levels in separate panels 
% %{
% levelLabels = {
% 	'Preload Q red., 10%', 'Q reduced 10%'
% 	'Preload Q red., 20%', 'Q reduced 20%'
% 	'Preload Q red., 40%', 'Q reduced 40%'
% 	'Preload Q red., 60%', 'Q reduced 60%'
% 	'Preload Q red., 80%', 'Q reduced 80%'
% };
% 	%}
% 	
% xVar = 'QRedTarget_pst';
% xLims = [0,100];
% figWidth = 950;
% xLab = 'Flow rate reduction targets (%)';
% titleStr = 'Control intervensions';
% 
% plot_nha_power_and_flow_per_intervention(...
%  	F,G.med,R,nhaVars,levelLabels,xVar,xLims,xLab,titleStr,figWidth);
% 

%% ROC curves in [no of states]x4 panels for each pooled diameter states and each speed

close all

classifiers = {
 	'accA_y_nf_pow';
	'accA_x_nf_pow';
	'accA_z_nf_pow';
	%'accA_xynorm_nf_pow';
	};

% Input for states of pooled occlusions above a threshold
%{
predStateVar = 'pooledDiam';
predStates = {
	%2, '>= 4.73mm'
	4, '>= 6.6mm'
	6, '>= 8.52mm'
	%7, '>= 9mm'
	%8, '>= 10mm'
	9, '>= 11mm'
	};
pooled = true;
%}
	
% Input for states of concrete occlusions 
predStateVar = 'levelLabel';
predStates = {
	%'Inflated, 4.73 mm', 'Catheter 1'
	'Inflated, 6.60 mm', 'Catheter 2'
	'Inflated, 8.52 mm', 'Catheter 3'
	%'Inflated, 9 mm',    'Catheter 4'
	%'Inflated, 10 mm',   'catheter 4'
	'Inflated, 11 mm',   'Catheter 4'
	};
pooled = false;

titleStr = 'ROC Curves for Pooled Pendulating Mass States';

% h_figs = plot_roc_curves_per_intervention(...
%  	F_ROC,classifiers,predStateVar,predStates,titleStr,pooled);

 h_figs = plot_roc_curve_matrix_per_intervention_and_speed(...
 		F_ROC,classifiers,predStateVar,predStates,titleStr,pooled);
	
%% Absolute NHA versus flow scatter
% Intervention type grouping by color
% 2x2 panels, one panel per speed setting
%
% close all
% 
% vars = {
% %     'accA_x_nf_stdev',[0.01,0.19]
% %     'accA_y_nf_stdev',[0.01,0.19]
%     'accA_x_nf_pow',[0,0.018]
%     'accA_y_nf_pow',[0,0.018]
%    };
% 
% h_figs = plot_scatter_acc_against_Q(F,vars);
