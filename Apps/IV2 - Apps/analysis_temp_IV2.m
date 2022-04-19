%%  Load previously preprocessed and stored data

Environment_Analysis_IV2
sequences = {
    'IV2_Seq6','Seq6 - LVAD8\Processed'
    'IV2_Seq7','Seq7 - LVAD1\Processed'
    'IV2_Seq9','Seq9 - LVAD6\Processed'
    'IV2_Seq10','Seq10 - LVAD9\Processed'
    'IV2_Seq11','Seq11 - LVAD10\Processed'
    'IV2_Seq12','Seq12 - LVAD11\Processed'
    'IV2_Seq13','Seq13 - LVAD12\Processed'
    'IV2_Seq14','Seq14 - LVAD7\Processed'
    'IV2_Seq18','Seq18 - LVAD14\Processed'
    'IV2_Seq19','Seq19 - LVAD13\Processed'
    };
S_analysis = load_processed_sequences(sequences(:,1),...
    fullfile(data_basePath,sequences(:,2),sequences(:,1)+"_S.mat"));

%% Initialize from raw data, preprocess and store (in memory and to disc)

% Init_IV2_Seq6
% Init_IV2_Seq7
% Init_IV2_Seq9
% Init_IV2_Seq10
% Init_IV2_Seq11
% Init_IV2_Seq12
% Init_IV2_Seq13
% Init_IV2_Seq14
% Init_IV2_Seq18
% Init_IV2_Seq19

%% Calculate features of signal intervals denoted with an analysis ID tag
tic
F = make_stats(S_analysis,...
    {'Q_LVAD','P_LVAD'},...
    {'affP','effP','Q','accA_norm','accA_x','accA_y','accA_z',...
    'accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'},...
    idSpecs);
toc
tic
[F,psds] = make_power_spectra(S_analysis,F,...
    {'accA_norm','accA_x','accA_y','accA_z',...
    'accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'},...
    idSpecs);
toc
F_rel = make_relative_feats(F);

save_table('Features', analysis_path, F, 'spreadsheet');
save_table('Features - Relative', analysis_path, F_rel, 'spreadsheet');
save_table('Features', analysis_path, F, 'matlab');
save_table('Features - Relative', analysis_path, F_rel, 'matlab');
%save(fullfile(analysis_path,'Power spectra densities'), 'psds');

multiWaitbar('CloseAll');

%% Load previously calculated features for analysis

load(fullfile(analysis_path,'Features'))
load(fullfile(analysis_path,'Features - Relative'))

%% Make tables for ROC

F_ROC_PCI1 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated,  4.73 mm' ),:);
save_table('Features - ROC - PCI 1 - All RPM', analysis_path, F_ROC_PCI1, 'spreadsheet');

F_ROC_PCI2 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated,  6.60 mm' ),:);
save_table('Features - ROC - PCI 2 - All RPM', analysis_path, F_ROC_PCI2, 'spreadsheet');

F_ROC_PCI3 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated,  8.52 mm' ),:);
save_table('Features - ROC - PCI 3 - All RPM', analysis_path, F_ROC_PCI3, 'spreadsheet');

F_ROC_RHC = F(( F.interventionType=='Control' | F.levelLabel=='Inflated,  11 mm' ),:);
save_table('Features - ROC - RHC - All RPM', analysis_path, F_ROC_RHC, 'spreadsheet');

%% Calc group means and standard deviations

G = make_group_stats(F,idSpecs);
G_rel = make_group_stats(F_rel,idSpecs);

save_table('Group mean of features',          analysis_path, G.avg, 'spreadsheet');
save_table('Group st.dev. of features',       analysis_path, G.std, 'spreadsheet');
save_table('Group median of features',        analysis_path, G.med, 'spreadsheet');
save_table('Group 25-percentile of features', analysis_path, G.q1, 'spreadsheet');
save_table('Group 75-percentile of features', analysis_path, G.q3, 'spreadsheet');

save_table('Group mean of features - Relative',          analysis_path, G_rel.avg, 'spreadsheet');
save_table('Group st.dev. of features - Relative',       analysis_path, G_rel.std, 'spreadsheet');
save_table('Group median of features - Relative',        analysis_path, G_rel.med, 'spreadsheet');
save_table('Group 25-percentile of features - Relative', analysis_path, G_rel.q1, 'spreadsheet');
save_table('Group 75-percentile of features - Relative', analysis_path, G_rel.q3, 'spreadsheet');

%% Scatter: Effects with diameter and flow reduction as x, for all RPM

close all
vars = {
    'accA_x_nf_pow', [0,0.011]
    'accA_y_nf_pow', [0,0.011]
    'accA_z_nf_pow', [0,0.011]
    'accA_norm_nf_pow', [0,0.011]%
    
    %           'accA_x_nf_bpow', [0,0.011]
    %           'accA_y_nf_bpow', [0,0.011]
    %           'accA_z_nf_bpow', [0,0.011]
    %           'accA_norm_nf_bpow',[0,0.011]
    
    'accA_x_nf_stdev', [0.01,0.1]
    'accA_y_nf_stdev', [0.01,0.1]
    'accA_z_nf_stdev', [0.01,0.1]
    'accA_norm_nf_stdev', [0.01,0.1]
    
    %          'accA_x_bpow',[0,0.016]
    %          'accA_y_bpow',[0,0.016]
    %          'accA_z_bpow',[0,0.016]
    %          'accA_norm_bpow',[0,0.016]
    
    'accA_x_pow',[0,0.016]
    'accA_y_pow',[0,0.016]
    'accA_z_pow',[0,0.016]
    'accA_norm_pow',[0,0.016]
    
    'accA_x_stdev',[0.02,0.15]
    'accA_y_stdev',[0.02,0.15]
    'accA_z_stdev',[0.02,0.15]
    'accA_norm_stdev',[0.02,0.15]
    };

h_figs = plot_effects(G_avg,vars,'Absolute');

for h=h_figs, save_figure(h, analysis_path, h.Name, 300); end

%% Scatter: Relative effects with diameter and flow reduction as x, for all RPM


close all
vars = {
    
'accA_x_nf_pow', [-0.5,4]
'accA_y_nf_pow', [-0.5,4]
'accA_z_nf_pow', [-0.5,4]
'accA_norm_nf_pow', [-0.5,4]%

%           'accA_x_nf_bpow', [0,0.011]
%           'accA_y_nf_bpow', [0,0.011]
%           'accA_z_nf_bpow', [0,0.011]
%           'accA_norm_nf_bpow',[0,0.011]

'accA_x_nf_stdev', [-0.25,2]
'accA_y_nf_stdev', [-0.25,2]
'accA_z_nf_stdev', [-0.25,2]
'accA_norm_nf_stdev', [-0.25,2]

'accA_x_pow',[-0.5,4]
'accA_y_pow',[-0.5,4]
'accA_z_pow',[-0.5,4]
'accA_norm_pow',[-0.5,4]

%          'accA_x_bpow',[0,0.016]
%          'accA_y_bpow',[0,0.016]
%          'accA_z_bpow',[0,0.016]
%          'accA_norm_bpow',[0,0.016]

'accA_x_stdev',[-0.35,4]
'accA_y_stdev',[-0.35,4]
'accA_z_stdev',[-0.35,4]
'accA_norm_stdev',[-0.35,4]

};
h_figs = plot_effects(G_avg_rel,vars,'Relative');

for h=h_figs, save_figure(h, analysis_path, h.Name, 300); end

%% Scatter: Effects with diameter and flow reduction as x, for each RPM

close all

vars = {
    'accA_x_nf_pow', [0,0.011]
    'accA_y_nf_pow', [0,0.011]
    'accA_z_nf_pow', [0,0.011]
    'accA_norm_nf_pow', [0,0.011]
    
    'accA_x_nf_stdev', [0.01,0.1]
    'accA_y_nf_stdev', [0.01,0.1]
    'accA_z_nf_stdev', [0.01,0.1]
    'accA_norm_nf_stdev', [0.01,0.1]
    
    'accA_x_pow',[0,0.016]
    'accA_y_pow',[0,0.016]
    'accA_z_pow',[0,0.016]
    'accA_norm_pow',[0,0.016]
    
    'accA_x_stdev',[0.02,0.15]
    'accA_y_stdev',[0.02,0.15]
    'accA_z_stdev',[0.02,0.15]
    'accA_norm_stdev',[0.02,0.15]
    };

h_figs = plot_effects_in_speed_tiles_with_errorbars_symmetric(G_avg,vars,'',G_std);
for h=h_figs, save_figure(h, analysis_path, h.Name, 300); end

%% Plot 4a: Medians and percentiles of absolute acc against diameter, for control and effect

vars = {
    'accA_x_nf_pow', [0,0.011]
    'accA_y_nf_pow', [0,0.011]
    'accA_norm_nf_pow', [0,0.011]
    
    'accA_x_nf_bpow', [0,0.011]
    'accA_y_nf_bpow', [0,0.011]
    'accA_norm_nf_bpow', [0,0.011]
    
    'accA_x_nf_stdev', [0,0.1]
    'accA_y_nf_stdev', [0,0.1]
    'accA_norm_nf_stdev', [0,0.1]
    
    'accA_y_nf_mpf', [90,210]
    'accA_x_nf_mpf', [90,210]
    'accA_norm_nf_mpf', [90,210]
    };

h_figs = plot_effects_in_speed_tiles_with_errorbars_symmetric(G.med,vars,{'Absolute','Medians'},G.q1,G.q3);
save_analysis_plots(h_figs,analysis_path,vars)

%% Plot 4b: Medians and percentiles of relative acc against diameter, for control and effect

vars = {
    'accA_x_nf_pow', [-0.5,5]
%     'accA_y_nf_pow', [-0.5,5]
%     'accA_norm_nf_pow', [-0.5,5]
%     
%     'accA_x_nf_bpow', [-1,15]
%     'accA_y_nf_bpow', [-1,15]
%     'accA_norm_nf_bpow', [-1,15]
%     
%     'accA_x_nf_stdev', [-0.5,3]
%     'accA_y_nf_stdev', [-0.5,3]
%     'accA_norm_nf_stdev', [-0.5,3]
    };

h_figs = plot_effects_in_speed_tiles_with_errorbars_symmetric(G_rel.med,vars,{'Relative','Medians'},G_rel.q1,G_rel.q3);
% save_analysis_plots(h_figs,analysis_path,vars)

%% Plot 5: Q versus abolute acc + nominal

vars = {
    'accA_x_nf_stdev',[0.01,0.19]
    'accA_y_nf_stdev',[0.01,0.19]
    'accA_norm_nf_stdev',[0.01,0.19]
    
    'accA_x_nf_pow',[0,0.018]
    'accA_y_nf_pow',[0,0.018]
    'accA_norm_nf_pow',[0,0.018]
    
    'accA_y_nf_bpow',[0,0.01]
    'accA_x_nf_bpow',[0,0.01]
    'accA_norm_nf_bpow',[0,0.01]
    };
h_figs = plot_scatter_acc_against_Q(F,vars);
save_analysis_plots(h_figs,analysis_path,vars)

%% Plot 6: Q versus relative acc + relative Q_LVAD + nominal

vars = {
    'accA_x_nf_stdev',[-1,1.2]; ...
    'accA_y_nf_stdev',[-1,1.2]; ...
    'accA_norm_nf_stdev',[-1,1.2]; ...
    
    'accA_x_nf_pow',[-1,5]; ...
    'accA_y_nf_pow',[-1,5]; ...
    'accA_norm_nf_pow',[-1,5]; ...
    
    'accA_x_nf_bpow',[-1,5]; ...
    'accA_y_nf_bpow',[-1,5]; ...
    'accA_norm_nf_bpow',[-1,5]; ...
    };
h_figs = plot_scatter_relative_acc_and_Q_LVAD_against_Q(F,F_rel,vars);
save_analysis_plots(h_figs,analysis_path,vars)

%% Plot 7a: Group medians of absolute acc against diameter at all speeds, with individual background points and lines, split in subplot by cathers

vars = {
    'accA_x_nf_stdev',[0.01,0.10]
    'accA_y_nf_stdev',[0.01,0.10]
    'accA_norm_nf_stdev',[0.01,0.10]
    
    'accA_x_nf_bpow',[0,0.012]
    'accA_y_nf_bpow',[0,0.012]
    'accA_norm_nf_bpow',[0,0.012]
    
    'accA_x_nf_pow',[0,0.012]
    'accA_y_nf_pow',[0,0.012]
    'accA_norm_nf_pow',[0,0.012]
    };

h_figs = plot_acc_against_diameter_per_catheter(F,G.med,vars,'Absolute');
save_analysis_plots(h_figs,analysis_path,vars)

%% Plot 7b: Group medians of relative acc against diameter at all speeds, with individual background points and lines, split in subplot by cathers

vars = {
    'accA_x_nf_pow', [-0.5,5]
    'accA_y_nf_pow', [-0.5,5]
    'accA_norm_nf_pow', [-0.5,5]
    
    'accA_x_nf_bpow', [-1,15]
    'accA_y_nf_bpow', [-1,15]
    'accA_norm_nf_bpow', [-1,15]
    
    'accA_x_nf_stdev', [-0.5,3]
    'accA_y_nf_stdev', [-0.5,3]
    'accA_norm_nf_stdev', [-0.5,3]
    };

h_figs = plot_acc_against_diameter_per_catheter(F_rel,G_rel.med,vars,'Relative');
save_analysis_plots(h_figs,analysis_path,vars)

%% Plot 8: Afterload effect on acc, bp, P_LVAD at all speeds

vars = {
%    'accA_x_nf_stdev',[0.01,0.19]; ...
%     'accA_y_nf_stdev',[0.01,0.19]; ...
%     'accA_norm_nf_stdev',[0.01,0.19]; ...
%     
%      'accA_x_nf_pow',[0,0.012]
%      'accA_y_nf_pow',[0,0.012]
%      'accA_norm_nf_pow',[0,0.012]
%      
     'Q_LVAD_mean',[]
     %'Q_LVAD_mean',[]
    };
%h_figs = plot_scatter_acc_and_Q_LVAD_against_flow_reduction(F,vars);
h_figs = plot_boxchart_grouped_by_afterload_flow_reduction(F,vars,'Absolute');
% h_figs = plot_boxchart_grouped_by_preload_flow_reduction(F,vars,'Absolute');

%% Plot 9: RPM baselines

vars = {
%    'accA_x_nf_stdev',[0.01,0.19]; ...
%     'accA_y_nf_stdev',[0.01,0.19]; ...
%     'accA_norm_nf_stdev',[0.01,0.19]; ...
%     
%      'accA_x_nf_pow',[0,0.012]
%      'accA_y_nf_pow',[0,0.012]
%      'accA_norm_nf_pow',[0,0.012]
'Q_LVAD_mean',[]
}
h_figs = plot_acc_baselines_against_pumpspeed(G.med,vars,'Aboslute');


%%

vars = {
    %'accA_x_nf_pow'
    %'accA_y_nf_pow'
    %      'accA_z_nf_pow'
    %      'accA_norm_pow'
    
    %          'accA_x_nf_bpow'
    %          'accA_y_nf_bpow'
    %          'accA_z_nf_bpow'
    %          'accA_norm_nf_bpow'
    
    %     'accA_x_pow'
    %     'accA_y_pow'
    %     'accA_z_pow'
    %     'accA_norm_pow'
    
    %     'accA_x_bpow'
    %     'accA_y_bpow'
    %     'accA_z_bpow'
    %     'accA_norm_bpow'
    
    'accA_x_nf_stdev'
%     'accA_y_nf_stdev'
%     'accA_z_nf_stdev'
%     'accA_norm_nf_stdev'
    
    
    
    };

G_eff_ij = F_rel;
ylims = [-0.25,4];
close all
for i=1:numel(vars)
    
    var = vars{i};
    title_str = ['Relative Balloon Intervention Changes in ',var];
    
    F_eff_inds = G_eff_ij.categoryLabel=='Nominal' | G_eff_ij.interventionType=='Effect';
    T_eff = G_eff_ij(F_eff_inds,:);
    T_eff = sortrows(T_eff,'balloonDiam');
    T2200 = T_eff(T_eff.pumpSpeed=='2200',:);
    T2500 = T_eff(T_eff.pumpSpeed=='2500',:);
    T2800 = T_eff(T_eff.pumpSpeed=='2800',:);
    T3100 = T_eff(T_eff.pumpSpeed=='3100',:);
    
    
    h = figure('Name',[title_str,'2200'],'Position',[10,50,800,800]);
    hold on
    for j=1:numel(sequences(:,1))
        h_ax = gca;
        T2200_j = T2200(T2200.seq==sequences(j,1),:);
        h_ax.ColorOrderIndex=1;
        h_s(1) = scatter(T2200_j.balloonDiam,T2200_j.(var),'filled');
        h_line = line(T2200_j.balloonDiam,T2200_j.(var));
        plot(T2200_j.balloonDiam,-T2200_j.Q_mean,'o:')
        h_ax.ColorOrderIndex = 1;
        legend({var,'','Q'},'Location','northwest','Interpreter','none')
        h_tit = title([title_str,'2200']);
        h_tit.Interpreter = 'none';
        ylim(ylims)
    end
    %save_figure(h, analysis_path, [title_str,'2200'], 300);
    
end  
%     h = figure('Name',[title_str,'2500'],'Position',[10,50,800,800]);
%     hold on
%     for j=1:numel(seqs)
%         h_ax = gca;
%         T2500_j = T2500(T2500.seq==seqs{j},:);
%         h_ax.ColorOrderIndex=1;
%         h_s(1) = scatter(T2500_j.balloonDiam,T2500_j.(var),'filled');
%         h_line = line(T2500_j.balloonDiam,T2500_j.(var));
%         plot(T2500_j.balloonDiam,-T2500_j.Q_mean,'o:')
%         h_ax.ColorOrderIndex = 1;
%         legend({var,'','Q'},'Location','northwest','Interpreter','none')
%         h_tit = title([title_str,'2500']);
%         h_tit.Interpreter = 'none';
%         ylim(ylims)
%     end
%     %save_figure(h, analysis_path, [title_str,'2500'], 300);
%     
%     h = figure('Name',[title_str,'2800'],'Position',[10,50,800,800]);
%     hold on
%     for j=1:numel(sequences(:,1))
%         h_ax = gca;
%         T2800_j = T2800(T2800.seq==sequences(j,1),:);
%         h_ax.ColorOrderIndex=1;
%         h_s(1) = scatter(T2800_j.balloonDiam,T2800_j.(var),'filled');
%         h_line = line(T2800_j.balloonDiam,T2800_j.(var));
%         plot(T2800_j.balloonDiam,-T2800_j.Q_mean,'o:')
%         h_ax.ColorOrderIndex = 1;
%         legend({var,'','Q'},'Location','northwest','Interpreter','none')
%         h_tit = title([title_str,'2800']);
%         h_tit.Interpreter = 'none';
%         ylim(ylims)
%     end
%     
%     %save_figure(h, analysis_path, [title_str,'2800'], 300);
%     
%     
%     h = figure('Name',[title_str,'3100'],'Position',[10,50,800,800]);
%     hold on
%     for j=1:numel(seqs)
%         h_ax = gca;
%         T3100_j = T3100(T3100.seq==seqs{j},:);
%         h_ax.ColorOrderIndex=1;
%         h_s(1) = scatter(T3100_j.balloonDiam,T3100_j.(var),'filled');
%         h_line = line(T3100_j.balloonDiam,T3100_j.(var));
%         plot(T3100_j.balloonDiam,-T3100_j.Q_mean,'o:')
%         h_ax.ColorOrderIndex = 1;
%         legend({var,'','Q'},'Location','northwest','Interpreter','none')
%         h_tit = title([title_str,'3100']);
%         h_tit.Interpreter = 'none';
%         ylim(ylims)
%     end
%     %save_figure(h, analysis_path, [title_str,'3100'], 300);
%     
% end

