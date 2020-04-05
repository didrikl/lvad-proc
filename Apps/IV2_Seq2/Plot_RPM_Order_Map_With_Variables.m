%Init_IV2_Seq2
close all
clear check_var_input_from_table

% Graphics settings
resolution = 300;
catBarColor
barVars = {
    %'part',           partBarColorSet;
    'pumpSpeed'       pumpSpeedColorSet;%brewermap(20,'Paired');
    'flowReduction'   flowRedColorSet;% brewermap(10,'BuPu');%'YlGnBu');
    'balloonLevel'    balLevColorSet;%brewermap(10,'RdPu');
    'intervType'      intervTypeColorSet;%brewermap(10,'RdPu');
    };

% Calculation settings
notches = [];
notchWidth = 0.5;
rms_winLenSec = 1;
std_winLenSec = 10;

% Selections of variables to use
orderMapVar = 'accA_norm';%,'accA_xz_norm_filt'};
%orderMapVar = 'accA_x';%,'accA_xz_norm_filt'};
plotVars = {
        %{'affP','effP'}
        %{'affQ','effQ','Q_noted'}
        %{'accA_norm_mpf'}
        {'accA_norm_movStd','accA_norm_std'}
        %{'accA_xz_norm_movRMS','accA_xz_norm_rms'}
        %'power_noted'
        };

baseline_parts = [15];
intervention_parts = [8];
rpm = [2600,2600];

% baseline_parts = [1];
% intervention_parts = [8,9,10,11,12];
% rpm = [2600,2000,2300,2900,3200];

for i=1:numel(intervention_parts)
    parts = sort([baseline_parts,intervention_parts(i)]);
    T = make_plot_data(parts,S_parts,rpm(i),...
        700,notches,notchWidth,std_winLenSec,rms_winLenSec);
    T.accA_z = T.accA(:,3);
    T.accA_x = T.accA(:,1);
    T = rename_parts(T,baseline_parts,intervention_parts);
    
    figName = make_figure_name(parts,orderMapVar,notches);
    plot_ordermap_with_vars(T,orderMapVar,plotVars,barVars,sampleRate,figName);
    save_figure([proc_basePath,'\Figures'], figName, resolution)
end

% parts = sort([baseline_parts,intervention_parts]);
% T1 = make_plot_data(parts,S_parts,2600,...
%     sampleRate,notches,notchWidth,std_winLenSec,rms_winLenSec);
% 
% figName = make_figure_name(parts,orderMapVar,notches);
% plot_ordermap_with_vars(T1,orderMapVar,plotVars,barVars,sampleRate,figName);
% save_figure([proc_basePath,'\Figures'], figName, resolution)


function T = make_plot_data(parts,S_parts,rpm,...
        sampleRate,notches,notchWidth,std_winLenSec,rms_winLenSec)
    
    % Extract relevant data
    T = cell(numel(parts),1);
    for j=1:numel(parts)
        T{j} = S_parts{parts(j)};
        T{j}.dur = linspace(0,1/sampleRate*height(T{j}),height(T{j}))';   
        
        % Filter 1st harmonic
        T{j}(isnan(T{j}.pumpSpeed),:) = [];
        rpm_blocks = find_cat_blocks(T{j},'pumpSpeed');
        speeds = rpm;%double(string(get_cats(T{j},'pumpSpeed')));
        for k=1:numel(speeds)
            
            if isnan(speeds(k)), continue; end
            
            range = rpm_blocks.start_inds(k):rpm_blocks.end_inds(k);
            T{j}(range,:) = filter_notches(T{j}(range,:),'accA_xz_norm',notches*(speeds(k)/60),notchWidth);
            T{j}(range,:) = filter_notches(T{j}(range,:),'accA_norm',notches*(speeds(k)/60),notchWidth);
            T{j}(range,:) = filter_notches(T{j}(range,:),'accA',notches*(speeds(k)/60),notchWidth);
        end
        
        T{j} = calc_moving(T{j},{'accA_xz_norm'},{'Std'},sampleRate*std_winLenSec);
        T{j} = calc_moving(T{j},{'accA_xz_norm'},{'RMS'},sampleRate*rms_winLenSec);
        T{j} = calc_moving(T{j},{'accA_norm'},{'Std'},sampleRate*std_winLenSec);        
        T{j} = calc_moving(T{j},{'accA_norm'},{'RMS'},sampleRate*rms_winLenSec);
        T{j} = calc_moving(T{j},{'accA'},{'RMS'},sampleRate*rms_winLenSec);
        T{j} = calc_moving(T{j},{'accA'},{'Std'},sampleRate*std_winLenSec);
        
        %T{j} = T{j}(get_steady_state_rows(T{j}),:);
        
        
        if height(T{j})==0, continue; end
        
        bal_blocks = find_cat_blocks(T{j},{'balloonLevel'});
        for k=1:numel(bal_blocks.start_inds)
            range = bal_blocks.start_inds(k):bal_blocks.end_inds(k);
            T{j}.accA_xz_norm_std(range) = std(T{j}.accA_xz_norm(range));
            T{j}.accA_xz_norm_rms(range) = rms(T{j}.accA_xz_norm(range));
            T{j}.accA_norm_std(range) = std(T{j}.accA_norm(range));
            T{j}.accA_norm_rms(range) = rms(T{j}.accA_norm(range));
            freq = meanfreq(detrend(T{j}.accA_norm(range)),sampleRate);
            T{j}.accA_norm_mpf(range) = freq;
        end
        
        % Clip long intervals to max 10 minutes
        %T{j} = T{j}(1:min(sampleRate*10*60,height(T{j})),:);
        
        % Ignore balloon level 0 (same as level 1)
        T{j} = T{j}(T{j}.pumpSpeed==rpm,:);
        T{j} = T{j}(T{j}.balloonLevel~='0',:);
        
    end
    
    T = merge_table_blocks(T);
    T.pumpSpeed = categorical(T.pumpSpeed);
    T.Properties.SampleRate = sampleRate;
  
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