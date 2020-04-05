%Init_IV2_Seq3
close all
clear check_var_input_from_table

% Graphics settings
resolution = 300;
catBarColor
barVars = {
    'part',           brewermap(10,'Oranges');
    'pumpSpeed'       pumpSpeedColorSet;%brewermap(20,'Paired');
    'flowReduction'   flowRedColorSet;% brewermap(10,'BuPu');%'YlGnBu');
    'balloonLevel'    balLevColorSet;%brewermap(10,'RdPu');
    'intervType'      intervTypeColorSet;%brewermap(10,'RdPu');
    };

% Calculation settings
sampleRate = 700;

% Filter out harmonics lines in selected variables
notches = [];
notchWidth = 0.5;

% Selections of variables to use
orderMapVar = 'accA_norm';
%orderMapVar = 'accA_xz_norm';
%orderMapVar = 'accA_z';

plotVars = {
    %{'affP','effP'}
    {'affQ','effQ','Q_noted'}
    %{'accA_norm_mpf'}
    {'accA_norm_mpf_shift'}
    %{'accA_norm'}%{'accA_norm'}
    {'accA_norm_movRMS','accA_norm_rms'}
    {'accA_norm_movStd','accA_norm_std'}
    %{'accA_xz_norm_movRMS','accA_xz_norm_rms'}
    %'power_noted'
    };


parts = {
%     [34,35,33,36]
%     [40,41,39,42]
     [39]
     [40]
     [41]
     [42]
    };

% Extract data for these RPM values
rpm = {
%     [2000,2300,2600,2900]
%     [2000,2300,2600,2900]
     [2600]
     [2000]
     [2300]
     [2900]
    };

% % Analysis for clamping
% parts = {
%     1
%     2
%     3
%     4
%     5
%     6
%     7
%     8    
%     };
% rpm = {
%     2600
%     2000
%     2300
%     2900
%     2600
%     2000
%     2300
%     2900
%    };


for i=1:numel(parts)
    T = make_plot_data(parts{i},S_parts,rpm{i},...
        sampleRate,notches,notchWidth);
    %T = rename_parts(T,baseline_parts,parts);
    figName = make_figure_name(parts{i},orderMapVar,notches);
    BL = S_parts{parts{i}}(S_parts{parts{i}}.intervType=='Control baseline',:);
    plot_ordermap_with_vars(T,orderMapVar,plotVars,barVars,sampleRate,figName,BL);
    
    %save_figure([proc_basePath,'\Figures'], figName, resolution)
end



function T = make_plot_data(parts,S_parts,rpm,sampleRate,notches,notchWidth)
    
    % Extract relevant data
    T = cell(numel(parts),1);
    for j=1:numel(parts)
        T{j} = S_parts{parts(j)};
        T{j}.dur = linspace(0,1/sampleRate*height(T{j}),height(T{j}))';
        
        % Filter 1st harmonic
        T{j}(isnan(T{j}.pumpSpeed),:) = [];
        %height(T{j})==0, ... end
        rpm_blocks = find_cat_blocks(T{j},'pumpSpeed');
        speeds = rpm(j);%double(string(get_cats(T{j},'pumpSpeed')));
        for k=1:numel(speeds)
            
            if isnan(speeds(k)), continue; end
            range = rpm_blocks.start_inds(k):rpm_blocks.end_inds(k);
            T{j}(range,:) = filter_notches(T{j}(range,:),'accA_xz_norm',notches*(speeds(k)/60),notchWidth);
            T{j}(range,:) = filter_notches(T{j}(range,:),'accA_norm',notches*(speeds(k)/60),notchWidth);
            %T{j}(range,:) = filter_notches(T{j}(range,:),'accA',notches*(speeds(k)/60),notchWidth);
        end
        
        T{j} = T{j}(get_steady_state_rows(T{j}),:);
        
        
        if height(T{j})==0, continue; end
        
        bal_blocks = find_cat_blocks(T{j},{'balloonLevel'});
        for k=1:numel(bal_blocks.start_inds)
            range = bal_blocks.start_inds(k):bal_blocks.end_inds(k);
            T{j}.accA_xz_norm_std(range) = std(T{j}.accA_xz_norm(range));
            T{j}.accA_xz_norm_rms(range) = rms(T{j}.accA_xz_norm(range));
            T{j}.accA_norm_std(range) = std(T{j}.accA_norm(range));
            T{j}.accA_norm_rms(range) = rms(T{j}.accA_norm(range));
            
            freq{k} = meanfreq(detrend(T{j}.accA_norm(range)),sampleRate);
            T{j}.accA_norm_mpf(range) = freq{k};
            T{j}.accA_norm_mpf_shift(range) = freq{k} - freq{1};
            
            % For testing
            T{j}.accA_1norm_std(range) = std(T{j}.accA_1norm(range));
            T{j}.accA_1norm_rms(range) = rms(T{j}.accA_1norm(range));
            freq1{k} = meanfreq(detrend(T{j}.accA_1norm(range)),sampleRate);
            T{j}.accA_1norm_mpf(range) = freq1{k};
            T{j}.accA_1norm_mpf_shift(range) = freq1{k} - freq1{1};
            
            freqxz{k} = meanfreq(detrend(T{j}.accA_xz_norm(range)),sampleRate);
            T{j}.accA_norm_xz_mpf(range) = freqxz{k};
            T{j}.accA_norm_xz_mpf_shift(range) = freqxz{k} - freqxz{1};
            
            % For testing
            T{j}.accA_1norm_std(range) = std(T{j}.accA_1norm(range));
            T{j}.accA_1norm_rms(range) = rms(T{j}.accA_1norm(range));
            freqxz1{k} = meanfreq(detrend(T{j}.accA_xz_1norm(range)),sampleRate);
            T{j}.accA_1norm_xz_mpf(range) = freqxz1{k};
            T{j}.accA_1norm_xz_mpf_shift(range) = freqxz1{k} - freqxz1{1};
            
        end
        
        % Ignore balloon level 0 (same as level 1)
        T{j} = T{j}(T{j}.pumpSpeed==rpm(j),:);
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
        fig_name = [fig_name,' - filtered ',mat2str(notches),' harmonics'];
    end
end

function add_balLev_text_bar(P2,order)
    barWidth=18;
    balLevCats = categories(P2.balloonLevel);
    barYPos = max(order)-0.2;
    for i=1:numel(balLevCats)
        balLev_time = P2.dur(P2.balloonLevel==balLevCats(i));
        if numel(balLev_time)==0, continue; end
        balLev_line = repmat(barYPos,1,numel(balLev_time));
        h_plot = plot(balLev_time,balLev_line,'LineWidth',barWidth);
        h_plot.Color = [h_plot.Color,0.9];
        if string(balLevCats(i))=="-"
            text(balLev_time(1)+1,barYPos,"No catheter",...
                'HorizontalAlignment','left');
        else
            text(balLev_time(1)+1,barYPos,"Balloon level "+string(balLevCats(i)),...
                'HorizontalAlignment','left');
        end
    end
end

function add_flowRed_text_bar(P2,order)
    flowRedCats = categories(P2.flowReduction);
    barYPos = max(order)-0.55;
    barWidth=18;
    
    for i=1:numel(flowRedCats)
        flowRed_time = P2.dur(P2.flowReduction==flowRedCats(i));
        if numel(flowRed_time)==0, continue; end
        flowRed_line = repmat(barYPos,1,numel(flowRed_time));
        h_plot = plot(flowRed_time,flowRed_line,'LineWidth',barWidth);
        h_plot.Color = [h_plot.Color,1];
        if string(flowRedCats(i))=="-"
            text(flowRed_time(1)+1,barYPos,"No clamping",...
                'HorizontalAlignment','left');
        else
            text(flowRed_time(1)+1,barYPos,"Flow reduction "+string(flowRedCats(i)),...
                'HorizontalAlignment','left');
        end
    end
end
