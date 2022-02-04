%close all
speeds = [2400];
levels = {
	'Cla'
	'Bal'
	'Nom'
	};
var = 'P_LVAD_mean';
var = 'accA_norm_NF_HP_stdev';
var = 'accA_x_NF_HP_stdev';
%var = 'accA_z_NF_HP_stdev';
 var = 'accA_x_NF_HP_b2_pow';
% var = 'accA_y_NF_HP_b2_pow';
% var = 'Q_LVAD_mean';
% var = 'p_maxArt_mean';
%var = 'SvO2_mean';
var = 'Q_mean';
%var = 'CO_mean'
%var = 'HR_mean'
%var = 'MAP_mean'
% G_rel.med = order_categories(G_rel.med,'levelLabel',idSpecs_stats.levelLabel);
% %F_rel = order_categories(F_rel,'idLabel',idSpecs_stats.idLabel);
G_rel.med.idLabel = removecats(G_rel.med.idLabel);
F_rel.idLabel = removecats(F_rel.idLabel);
close all; figure
for i=1:numel(speeds)
	F_inds = F_rel.pumpSpeed==speeds(i) &  contains(string(F_rel.idLabel),levels);
	hold on
	G_inds = G_rel.med.pumpSpeed==speeds(i);
	h_s = scatter(G_rel.med.idLabel(G_inds),G_rel.med.(var)(G_inds),250,...
		'Marker','_','LineWidth',1.5);
	h_s = scatter(F_rel.idLabel(F_inds),F_rel.(var)(F_inds),40,'filled',...
 		MarkerFaceColor='flat',MarkerFaceAlpha=0.6);
	G_inds = G_rel.med.pumpSpeed==speeds(i);
	title(var,'Interpreter','none')
	
end

ylim([-1,4])
yline(0,'LineWidth',2,'Alpha',0.3)