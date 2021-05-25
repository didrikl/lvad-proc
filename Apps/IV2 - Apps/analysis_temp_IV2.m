
sequences = {
    'IV2_Seq6','D:\Data\IVS\Didrik\IV2 - Data\Seq6 - LVAD8\Processed\IV2_Seq6_S.mat'
    'IV2_Seq7','D:\Data\IVS\Didrik\IV2 - Data\Seq7 - LVAD1\Processed\IV2_Seq7_S.mat'
    'IV2_Seq9','D:\Data\IVS\Didrik\IV2 - Data\Seq9 - LVAD6\Processed\IV2_Seq9_S.mat'
    'IV2_Seq10','D:\Data\IVS\Didrik\IV2 - Data\Seq10 - LVAD9\Processed\IV2_Seq10_S.mat'
    'IV2_Seq11','D:\Data\IVS\Didrik\IV2 - Data\Seq11 - LVAD10\Processed\IV2_Seq11_S.mat'
    'IV2_Seq12','D:\Data\IVS\Didrik\IV2 - Data\Seq12 - LVAD11\Processed\IV2_Seq12_S.mat'
    'IV2_Seq13','D:\Data\IVS\Didrik\IV2 - Data\Seq13 - LVAD12\Processed\IV2_Seq13_S.mat'
    'IV2_Seq14','D:\Data\IVS\Didrik\IV2 - Data\Seq14 - LVAD7\Processed\IV2_Seq14_S.mat'
    'IV2_Seq18','D:\Data\IVS\Didrik\IV2 - Data\Seq18 - LVAD14\Processed\IV2_Seq18_S.mat'
    'IV2_Seq19','D:\Data\IVS\Didrik\IV2 - Data\Seq19 - LVAD13\Processed\IV2_Seq19_S.mat'
    };
S_analysis = load_processed_sequences(sequences(:,1),sequences(:,2));

%%

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


%%

id_specs = init_id_specifications(id_specs_path);

note_vars = {...
    'Q_LVAD'
    'P_LVAD'
    };
cont_vars = {...
    'affP','effP',...
    'Q','accA_norm','accA_x','accA_y','accA_z',...
    'accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'
    };
bandPow_vars = {
    'accA_norm','accA_x','accA_y','accA_z',...
    'accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'
    };

stats = make_stats(S_analysis,note_vars,cont_vars,id_specs);
tic
[psds,f,pows] = make_psds(S_analysis,bandPow_vars,id_specs);
toc
% T = join(stats,psds,'Keys',{'id','bl_id','analysis_id'});

%%



T_rpm = groupsummary(T,{'pumpSpeed','BalloonDiameter','Catheter','LevelLabel'},{'mean','std'},'bpow_accA_y_nf');
T_rpm.BalloonDiameter(isnan(T_rpm.BalloonDiameter)) = 0;

h_fig = figure('Name','Scatter of NHA per RPM');
hold on
T2200 = T_rpm(T_rpm.pumpSpeed==2200,:);
T2500 = T_rpm(T_rpm.pumpSpeed==2500,:);
T2800 = T_rpm(T_rpm.pumpSpeed==2800,:);
T3100 = T_rpm(T_rpm.pumpSpeed==3100,:);

h_s(1) = scatter(T2200.BalloonDiameter,T2200.mean_bpow_accA_y_nf,'filled');
h_s(2) = scatter(T2500.BalloonDiameter,T2500.mean_bpow_accA_y_nf,'filled');
h_s(3) = scatter(T2800.BalloonDiameter,T2800.mean_bpow_accA_y_nf,'filled');
h_s(4) = scatter(T3100.BalloonDiameter,T3100.mean_bpow_accA_y_nf,'filled');

set(h_s,'MarkerFaceAlpha',0.75,'Marker','o','LineWidth',2)
legend({'2200','2500','2800','3100'},'Location','northwest');
ylabel('Steady-state bandpower of acc_y_nf');
xlabel('Balloon diameter (mm)');
title('Bandpower mean over experiements')


%%

T_rpm = groupsummary(T,{'pumpSpeed','BalloonDiameter','Catheter','LevelLabel'},{'mean','std'},'mean_P_LVAD');

h_fig = figure('Name','Scatter');
hold on
T2200 = T(T.pumpSpeed==2200,:);
T2500 = T(T.pumpSpeed==2500,:);
T2800 = T(T.pumpSpeed==2800,:);
T3100 = T(T.pumpSpeed==3100,:);

h_s(1) = scatter(T2200.BalloonDiameter,T2200.bpow_accA_y_nf,'filled');
h_s(2) = scatter(T2500.BalloonDiameter,T2500.bpow_accA_y_nf,'filled');
h_s(3) = scatter(T2800.BalloonDiameter,T2800.bpow_accA_y_nf,'filled');
h_s(4) = scatter(T3100.BalloonDiameter,T3100.bpow_accA_y_nf,'filled');

set(h_s,'MarkerFaceAlpha',0.75,'Marker','o','LineWidth',2)
legend({'2200','2500','2800','3100'},'Location','northwest');
ylabel('Steady-state bandpower of acc_y_nf');
xlabel('Balloon diameter (mm)');
title('Bandpower mean over experiements')