close all
speeds = [2400];
levels = {
	'Deflated, Lev0'
	'Inflated, Lev1'
	'Inflated, Lev2'
	'Inflated, Lev3'
	'Inflated, Lev4'
% 	'Nominal'
% 	'Nominal #2'
% 	'Nominal, Clamp'
% 	'Q red., 25%, Clamp'
% 	'Q red., 50%, Clamp'
% 	'Q red., 75%, Clamp'
	};

%close all; figure
vars = {
	'accA_x_NF_HP_b2_pow'
 	'P_LVAD_mean'
 	'Q_mean'
	};

% var = 'accA_norm_NF_HP_b2_pow';
% var = 'accA_yznorm_NF_HP_b2_pow';
% var = 'accA_xynorm_NF_HP_b2_pow';
%var = 'P_LVAD_mean';
%var = 'P_LVAD_drop';
% var = 'Q_LVAD_mean';

%var = 'accA_norm_NF_HP_stdev';
%var = 'accA_x_NF_HP_stdev';
%var = 'accA_z_NF_HP_stdev';
% var = 'accA_x_NF_HP_b2_pow';
% var = 'p_maxArt_mean';
%var = 'SvO2_mean';
%var = 'Q_mean';
%var = 'CO_mean'
%var = 'HR_mean'
%var = 'MAP_mean'
% G_rel.med = order_categories(G_rel.med,'levelLabel',idSpecs_stats.levelLabel);
% %F_rel = order_categories(F_rel,'idLabel',idSpecs_stats.idLabel);
make_plot(G_rel.med, F_rel, speeds, levels, vars);

function make_plot(G,F,speeds, levels, vars)
	G.idLabel = removecats(G.idLabel);
	F.idLabel = removecats(F.idLabel);

	for j=1:numel(vars)
		var = vars{j};
		for i=1:numel(speeds)
			F_inds = F.pumpSpeed==speeds(i) &  contains(string(F.levelLabel),levels);
			hold on
			G_inds = G.pumpSpeed==speeds(i);
			% 	h_s = scatter(G_rel.med.balDiamEst_mean(G_inds),G_rel.med.(var)(G_inds),250,...
			% 		'Marker','_','LineWidth',1.5);
			scatter(F.balDiamEst_mean(F_inds),F.(var)(F_inds),70,'filled',...
				MarkerFaceColor='flat',MarkerFaceAlpha=0.6)
			G_inds = G.pumpSpeed==speeds(i);
			title(vars{1},'Interpreter','none')
		end
	end

	%ylim([-1,4])
	yline(0,'LineWidth',2,'Alpha',0.3)
	legend(vars)
end