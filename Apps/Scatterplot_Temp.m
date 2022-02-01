%close all
speeds = [2600];
levels = {
	'Cla'
	'Bal'
	'Nom'
	};
var = 'P_LVAD_mean';
var = 'accA_norm_nf_HP_b2_pow';
% var = 'accA_x_nf_HP_stdev';
% var = 'accA_y_nf_HP_stdev';
%var = 'accA_x_nf_HP_b2_pow';
% var = 'accA_y_nf_HP_b2_pow';
% var = 'Q_LVAD_mean';
% var = 'p_maxArt_mean';
% var = 'SvO2_mean';
%var = 'Q_mean';
% G_rel.med = order_categories(G_rel.med,'levelLabel',idSpecs_stats.levelLabel);
% %F_rel = order_categories(F_rel,'idLabel',idSpecs_stats.idLabel);
G_del.med.idLabel = removecats(G_del.med.idLabel);
F_del.idLabel = removecats(F_del.idLabel);
%figure
for i=1:numel(speeds)
	F_inds = F_del.pumpSpeed==speeds(i) &  contains(string(F_del.idLabel),levels);
	hold on
	G_inds = G_del.med.pumpSpeed==speeds(i);
	h_s = scatter(G_del.med.idLabel(G_inds),G_del.med.(var)(G_inds),250,...
		'Marker','_','LineWidth',1.5);
	scatter(F_del.idLabel(F_inds),F_del.(var)(F_inds),40,'filled',...
 		MarkerFaceColor='flat',MarkerFaceAlpha=0.5)
	G_inds = G_del.med.pumpSpeed==speeds(i);
	title(var,'Interpreter','none')
end

ylim([-1,4])
yline(0,'LineWidth',2,'Alpha',0.2)