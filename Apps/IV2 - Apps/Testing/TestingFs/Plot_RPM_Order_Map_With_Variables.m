%Init_IV2_TestingFS
close all
clear check_table_var_input

% Graphics settings
resolution = 300;
catBarColor
barVars = {
    'part',           partBarColorSet;
    'pumpSpeed'       pumpSpeedColorSet;%brewermap(20,'Paired');
    ...'balLev'    balLevColorSet;%brewermap(10,'RdPu');
    ...'thrombusVol'    balLevColorSet;%brewermap(10,'RdPu');
    };

% Calculation settings
notches = [];
notchWidth = 0.5;
rms_winLenSec = 1;
std_winLenSec = 10;

% Selections of variables to use
orderMapVar = 'accA_norm';%,'accA_xz_norm_filt'};
plotVars = {
        {'accA_norm_movStd','accA_norm_std'}
        {'accA_norm_norm_movRMS','accA_norm_norm_rms'}
        };

baseline_parts = [1];
intervention_parts = [2];
rpm = [2600];

IV1S1_TA = make_plot_data([1 3],IV1S1_SA_parts,540,std_winLenSec,rms_winLenSec);
IV1S1_TA{1}.part = renamecats(IV1S1_TA{1}.part,"1","1 (IV1S1 AccA Baseline)");
%IV1S1_TA{2}.part = renamecats(IV1S1_TA{2}.part,"2","3 (IV1S1 AccA Thrombus injections)");
IV1S1_TA{2}.part = renamecats(IV1S1_TA{2}.part,"3","3 (IV1S1) AccA Control Baseline");
IV1S1_TA = merge_table_blocks(IV1S1_TA);
IV1S1_TA.pumpSpeed = categorical(IV1S1_TA.pumpSpeed);
IV1S1_TA.Properties.SampleRate = 540;
make_rpm_order_map(IV1S1_TA, 'accA_norm', 540);
%plot_ordermap_with_vars(IV1S1_TA,orderMapVar,plotVars,barVars,540,figName);

IV1S1_TB = make_plot_data([1 3],IV1S1_SB_parts,540,std_winLenSec,rms_winLenSec);
IV1S1_TB{1}.part = renamecats(IV1S1_TB{1}.part,"1","1 (IV1S1 AccB Baseline)");
%IV1S1_TB{2}.part = renamecats(IV1S1_TB{2}.part,"2","3 (IV1S1 AccB Thrombus injections)");
IV1S1_TB{2}.part = renamecats(IV1S1_TB{2}.part,"3","3 (IV1S1) AccB Control Baseline");
IV1S1_TB = merge_table_blocks(IV1S1_TB);
IV1S1_TB.pumpSpeed = categorical(IV1S1_TB.pumpSpeed);
IV1S1_TB.Properties.SampleRate = 540;
make_rpm_order_map(IV1S1_TB, 'accA_norm', 540);
%plot_ordermap_with_vars(IV1S1_TB,orderMapVar,plotVars,barVars,540,figName);


IV2S1_T = make_plot_data([1 15],S_parts,700,std_winLenSec,rms_winLenSec);
IV2S1_T{1}.part = renamecats(IV1S1_TB{1}.part,"1","1 (IV2S1 AccA Baseline)");
IV2S1_T{2}.part = renamecats(IV1S1_TB{2}.part,"15","15 (IV2S1 AccA Control Baseline)");
IV2S1_T = merge_table_blocks(IV2S1_T);
IV2S1_T.pumpSpeed = categorical(IV2S1_T.pumpSpeed);
IV2S1_T.Properties.SampleRate = 700;
make_rpm_order_map(IV2S1_T, 'accA_norm', 540);
%plot_ordermap_with_vars(IV2S1_T,orderMapVar,plotVars,barVars,700,figName);

figName = make_figure_name(parts,orderMapVar,notches);
%save_figure([proc_basePath,'\Figures'], figName, resolution)




function T = make_plot_data(parts,S_parts,sampleRate,std_winLenSec,rms_winLenSec)
    
    % Extract relevant data
    T = cell(numel(parts),1);
    for j=1:numel(parts)
        T{j} = S_parts{parts(j)};
        T{j}.dur = linspace(0,1/sampleRate*height(T{j}),height(T{j}))';   
        
        % Filter 1st harmonic
        T{j}(isnan(T{j}.pumpSpeed),:) = [];
        rpm_blocks = find_cat_blocks(T{j},'pumpSpeed');

        
        T{j} = calc_moving(T{j},{'accA_xz_norm'},{'Std'},sampleRate*std_winLenSec);
        T{j} = calc_moving(T{j},{'accA_xz_norm'},{'RMS'},sampleRate*rms_winLenSec);
        T{j} = calc_moving(T{j},{'accA_norm'},{'Std'},sampleRate*std_winLenSec);        
        T{j} = calc_moving(T{j},{'accA_norm'},{'RMS'},sampleRate*rms_winLenSec);
        T{j} = calc_moving(T{j},{'accA'},{'RMS'},sampleRate*rms_winLenSec);
        T{j} = calc_moving(T{j},{'accA'},{'Std'},sampleRate*std_winLenSec);
        
        %T{j} = T{j}(get_steady_state_rows(T{j}),:);
        
        
        if height(T{j})==0, continue; end
        
        cat_blocks = find_cat_blocks(T{j},{'thrombusVol','balLev'});
        if numel(cat_blocks.start_inds)==0
            T{j}.accA_xz_norm_std(:) = std(T{j}.accA_xz_norm);
            T{j}.accA_xz_norm_rms(:) = rms(T{j}.accA_xz_norm);
            T{j}.accA_norm_std(:) = std(T{j}.accA_norm);
            T{j}.accA_norm_rms(:) = rms(T{j}.accA_norm);
            freq = meanfreq(detrend(T{j}.accA_norm),sampleRate);
            T{j}.accA_norm_mpf(:) = freq;
        end
        for k=1:numel(cat_blocks.start_inds)
            range = cat_blocks.start_inds(k):cat_blocks.end_inds(k);
            T{j}.accA_xz_norm_std(range) = std(T{j}.accA_xz_norm(range));
            T{j}.accA_xz_norm_rms(range) = rms(T{j}.accA_xz_norm(range));
            T{j}.accA_norm_std(range) = std(T{j}.accA_norm(range));
            T{j}.accA_norm_rms(range) = rms(T{j}.accA_norm(range));
            freq = meanfreq(detrend(T{j}.accA_norm(range)),sampleRate);
            T{j}.accA_norm_mpf(range) = freq;
        end        
    
    end
      
end 

function T = rename_parts(T,baseline_parts,intervention_parts)
    oldCats = string(baseline_parts);
    newCats = oldCats+" (baseline)";
    T.part = renamecats(T.part,oldCats,newCats);
    
    oldCats = string(intervention_parts);
    newCats = oldCats+" (interventions)";
    T.part = renamecats(T.part,oldCats,newCats); 
end

function fig_name = make_figure_name(parts,orderMapVar,notches)
    fig_name = sprintf('IV2_Seq2: Parts=%s - %s order map and time plots',...
        mat2str(parts),orderMapVar);
    if numel(notches)>0
        fig_name = [fig_name,' - filtered order notches ',mat2str(notches)];
    end
end