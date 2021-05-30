%%  Read previously preprocessed and stored data

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
load_path = 'D:\Data\IVS\Didrik\IV2 - Data\';
filepaths = fullfile(load_path,sequences(:,2),sequences(:,1)+"_S.mat")
S_analysis = load_processed_sequences(seqs(:,1),filepaths);


%% Initialize from raw data, preprocess and store (in memory and to disc)

Init_IV2_Seq6
Init_IV2_Seq7
Init_IV2_Seq9
Init_IV2_Seq10
Init_IV2_Seq11
Init_IV2_Seq12
Init_IV2_Seq13
Init_IV2_Seq14
Init_IV2_Seq18
Init_IV2_Seq19


%% Calculate features of signal intervals denoted with an analysis ID tag

idSpecs_path = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Notater\Excel spreadsheets\ID_Spefications_IV2.xlsx';
idSpecs = init_id_specifications(idSpecs_path);

noteVars = {'Q_LVAD','P_LVAD'};
contVars = {'affP','effP','Q',...
    'accA_norm','accA_x','accA_y','accA_z',...
    'accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'};
freqVars = {'accA_norm','accA_x','accA_y','accA_z',...
    'accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'};

Colors_For_Processing
multiWaitbar('Making steady-state features',0,'Color',ColorsProcessing.Green);
multiWaitbar('Making spectral densities',0,'Color',ColorsProcessing.Green);
    
F = make_stats(S_analysis,noteVars,contVars,idSpecs);
[psds,f,pows] = make_psds(S_analysis,freqVars,idSpecs);
F = join(F,pows,'Keys',{'id','analysis_id'});

F_rel = make_relative_feats(F,[noteVars,contVars,freqVars]);

analysis_path = 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Data analysis\Stats';
save_table('Features', analysis_path, F, 'spreadsheet');
save_table('Features', analysis_path, F, 'matlab');
save_table('Features - Relative', analysis_path, F_rel, 'spreadsheet');
save_table('Features - Relative', analysis_path, F_rel, 'matlab');

multiWaitbar('CloseAll');


%% Group summary scatter plots

allVars = [...
    [noteVars,contVars]+"_mean",...
    contVars+"_stdev",...
    contVars+"_median",...
    contVars+"_25prct",...
    contVars+"_75prct",...
    freqVars+"_pow",...
    freqVars+"_bpow"...
    ];

eff_inds = F.categoryLabel=='Nominal' | F.effectInterv;
ctrl_inds = not(eff_inds); %& not(F.categoryLabel=='Nominal, control'),:);
eff_rel_inds = F_rel.categoryLabel=='Nominal' | F.effectInterv;
ctrl_rel_inds = not(eff_rel_inds); %& not(F_rel.categoryLabel=='Nominal, control'),:);

G = groupsummary(F,'analysis_id',{'mean','std'},allVars);
G = join(G,idSpecs,'Keys','analysis_id');
G_rel = groupsummary(F_rel,'analysis_id',{'mean','std'},allVars);
G_rel = join(G_rel,idSpecs,'Keys','analysis_id');


%% Group summary scatter plots
close all
vars = {
    %     'accA_x_nf_pow'
         'accA_y_nf_pow'
    %     'accA_z_nf_pow'
    %     'accA_norm_nf_pow'
    %
    %     'accA_x_nf_stdev'
    %     'accA_y_nf_stdev'
    %     'accA_z_nf_stdev'
    %     'accA_norm_nf_stdev'
    
    %     'accA_x_nf_bpow'
    %     'accA_y_nf_bpow'
    %     'accA_z_nf_bpow'
    %     'accA_norm_nf_bpow'
    %    
    %     'accA_x_pow'
    %     'accA_y_pow'
    %     'accA_z_pow'
    %     'accA_norm_pow'
    %
    %     'accA_x_bpow'
    %     'accA_y_bpow'
    %     'accA_z_bpow'
    %     'accA_norm_bpow'
    %
    };

ylims_rel = [-0.1,2.5];
ylims_abs = [-0.0005,0.02];

h_figs = plot_effects(G,vars,ylims_abs,'Absolute');
h_figs = plot_effects(G_rel,vars,ylims_rel,'Relative');

%set(gca, 'YScale', 'log')
%save_figure(h_figs, analysis_path, title_str, 300);

%%
close all
figure
catheters = unique(F_eff_rel.catheter);
catheters = catheters(catheters~='-');
h_tiles = tiledlayout(2, 2);
for i=1:numel(catheters)
%subplot(2,2,i)
nexttile;
    inds = F_eff_rel.catheter==catheters(i);
    h_box = boxchart(double(string(F_eff_rel.balloonDiam(inds))) ,F_eff_rel.accA_x_nf_bpow(inds),...
        ....'Colors',colors,...
        ...'Notch','on',...
        'MarkerStyle','+',...
        'GroupByColor',F_eff_rel.pumpSpeed(inds),...
        'BoxWidth',0.5...
        ...'PlotStyle','compact'...
        );
    if i==1
    h_leg = legend;
    h_leg.Title.String='Pump speed';
    h_leg.Location = 'northwest';
    h_leg.Box = 'off';
    end
    ylim([-0.00025,0.005])
    xlim([1,12.5])
    %title(catheters(i))
    grid on
end
h_tiles.TileSpacing="tight";

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
    'accA_y_nf_stdev'
    'accA_z_nf_stdev'
    'accA_norm_nf_stdev'
    
    
    
    };

G_eff_ij = F_rel;
ylims = [-0.25,4];
close all
for i=1:numel(vars)
    
    var = vars{i};
    title_str = ['Relative Balloon Intervention Changes in ',var];
    
    eff_inds = G_eff_ij.categoryLabel=='Nominal' | G_eff_ij.effectInterv;
    T_eff = G_eff_ij(eff_inds,:);
    T_eff = sortrows(T_eff,'balloonDiam');
    T2200 = T_eff(T_eff.pumpSpeed==2200,:);
    T2500 = T_eff(T_eff.pumpSpeed==2500,:);
    T2800 = T_eff(T_eff.pumpSpeed==2800,:);
    T3100 = T_eff(T_eff.pumpSpeed==3100,:);
    
    
    h_fig = figure('Name',[title_str,'2200'],'Position',[10,50,800,800]);
    hold on
    for j=1:numel(seqs)
        h_ax = gca;
        T2200_j = T2200(T2200.seq==seqs{j},:);
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
    save_figure(h_fig, analysis_path, [title_str,'2200'], 300);
    
    
    h_fig = figure('Name',[title_str,'2500'],'Position',[10,50,800,800]);
    hold on
    for j=1:numel(seqs)
        h_ax = gca;
        T2500_j = T2500(T2500.seq==seqs{j},:);
        h_ax.ColorOrderIndex=1;
        h_s(1) = scatter(T2500_j.balloonDiam,T2500_j.(var),'filled');
        h_line = line(T2500_j.balloonDiam,T2500_j.(var));
        plot(T2500_j.balloonDiam,-T2500_j.Q_mean,'o:')
        h_ax.ColorOrderIndex = 1;
        legend({var,'','Q'},'Location','northwest','Interpreter','none')
        h_tit = title([title_str,'2500']);
        h_tit.Interpreter = 'none';
        ylim(ylims)
    end
    save_figure(h_fig, analysis_path, [title_str,'2500'], 300);
    
    h_fig = figure('Name',[title_str,'2800'],'Position',[10,50,800,800]);
    hold on
    for j=1:numel(seqs)
        h_ax = gca;
        T2800_j = T2800(T2800.seq==seqs{j},:);
        h_ax.ColorOrderIndex=1;
        h_s(1) = scatter(T2800_j.balloonDiam,T2800_j.(var),'filled');
        h_line = line(T2800_j.balloonDiam,T2800_j.(var));
        plot(T2800_j.balloonDiam,-T2800_j.Q_mean,'o:')
        h_ax.ColorOrderIndex = 1;
        legend({var,'','Q'},'Location','northwest','Interpreter','none')
        h_tit = title([title_str,'2800']);
        h_tit.Interpreter = 'none';
        ylim(ylims)
    end
    save_figure(h_fig, analysis_path, [title_str,'2800'], 300);
    
    
    h_fig = figure('Name',[title_str,'3100'],'Position',[10,50,800,800]);
    hold on
    for j=1:numel(seqs)
        h_ax = gca;
        T3100_j = T3100(T3100.seq==seqs{j},:);
        h_ax.ColorOrderIndex=1;
        h_s(1) = scatter(T3100_j.balloonDiam,T3100_j.(var),'filled');
        h_line = line(T3100_j.balloonDiam,T3100_j.(var));
        plot(T3100_j.balloonDiam,-T3100_j.Q_mean,'o:')
        h_ax.ColorOrderIndex = 1;
        legend({var,'','Q'},'Location','northwest','Interpreter','none')
        h_tit = title([title_str,'3100']);
        h_tit.Interpreter = 'none';
        ylim(ylims)
    end
    save_figure(h_fig, analysis_path, [title_str,'3100'], 300);
    
end


%%

