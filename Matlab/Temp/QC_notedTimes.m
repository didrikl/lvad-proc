T2 = S_parts{2};
plot_vars.sub1_y_var = {'accA_norm'}; %{'accA_norm','accB_norm'}
plot_vars.sub1_yy_var = {};  
plot_vars.sub2_y_var = {'effQ','affQ'};
plot_vars.sub2_yy_var = {'effP'};
search_var = {'accA_norm','effQ'};
feats = make_feature_windows(T2, feats,'Pump speed change', plot_vars, search_var);

% figure
% T2 = calc_moving(T2,{'accA_xz_norm'},{'Std'},sampleRate*10);
%         
% plot(T2.time,T2.accA_xz_norm_movStd)