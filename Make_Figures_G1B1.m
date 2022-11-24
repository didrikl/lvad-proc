Config =  get_processing_config_defaults_G1B;
cd 'C:\Users\Didrik\Dropbox\Arbeid\OUS\Proc\Matlab\Visualize\Article3'

%%

%save_figure(hFig, fullfile(Config.fig_path,'Accelerometer comparisons'), hFig.Name, 'pdf');
%save_figure(hFig, fullfile(Config.fig_path,'Accelerometer comparisons'), hFig.Name, 'png', 300);

%% Bland-Altmann plots

seq = 'Seq6';
varA = 'accA_z';
varB = 'accB_y';
partSpecNo = 1;
[hFig, mapA, mapB, T] = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo);

seq = 'Seq8';
varA = 'accA_y';
varB = 'accB_x';
partSpecNo = 1;
[hFig, mapA, mapB, T] = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo);

seq = 'Seq11';
varA = 'accA_y';
varB = 'accB_y';
partSpecNo = 1;
[hFig, mapA, mapB, T] = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo);

seq = 'Seq12';
varA = 'accA_y';
varB = 'accB_y';
partSpecNo = 1;
[hFig, mapA, mapB, T] = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo);

seq = 'Seq13';
varA = 'accA_y';
varB = 'accB_x';
partSpecNo = 1;
[hFig, mapA, mapB, T] = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo);

%hFig = make_h3_bland_altmann(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);
%save_figure(hFig, fullfile(Config.fig_path,'Bland-Altmann'), hFig.Name, 'png', 600);


%% Spectrogram comparisons - 4 panels with PLVAD, Q and S3H

seq = 'Seq6';
varA = 'accA_z';
varB = 'accB_y';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);

%%

seq = 'Seq7';
varA = 'accA_y';
varB = 'accB_y';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
% hFig = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);

%%

seq = 'Seq8';
varA = 'accA_y';
varB = 'accB_x';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);


%%

seq = 'Seq11';
varA = 'accA_y';
varB = 'accB_y';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);
				

%%

seq = 'Seq12';
varA = 'accA_y';
varB = 'accB_y';
partSpecNo = 1;

[hFig, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
%hFig = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);
				
%%

seq = 'Seq13';
varA = 'accA_y';
varB = 'accB_x';
partSpecNo = 1;

[~, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo);
%[~, mapA, mapB, T] = make_injection_parts_figure_with_h3(Data.G1B, seq, varA, varB, partSpecNo, mapA, mapB, T);

%% ROC for driveline S3H to classify pump house S3H elevations

[hFig, hAx] = plot_roc_for_3h(ROC);


