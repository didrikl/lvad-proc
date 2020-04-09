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

plotVars = {
    %{'affP','effP'}
    {'affQ','effQ','Q_noted'}
    %{'accA_norm_mpf'}
    %{'accA_norm_mpf_shift'}
    %{'accA_norm'}%{'accA_norm'}
    {{'accA_norm_movRMS','accA_norm_rms'},{'accA_norm_movStd','accA_norm_std'}}
    %{'accA_xz_norm_movRMS','accA_xz_norm_rms'}
    %'power_noted'
    };


parts = {
    %     [34,35,33,36]
    %     [40,41,39,42]
    [39]
    %      [40]
    %      [41]
    %      [42]
    };

% Extract data for these RPM values
rpm = {
    %     [2000,2300,2600,2900]
    %     [2000,2300,2600,2900]
    [2600]
    %      [2000]
    %      [2300]
    %      [2900]
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

    figName = make_figure_name(parts{i},orderMapVar,notches);
    BL = S_parts{parts{i}}(S_parts{parts{i}}.intervType=='Control baseline',:);
    plot_ordermap_with_vars(T,orderMapVar,plotVars,sampleRate,figName);
    
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
        rpm_blocks = find_cat_blocks(T{j},'pumpSpeed');
        speeds = rpm(j);%double(string(get_cats(T{j},'pumpSpeed')));
        for k=1:numel(speeds)
            
            if isnan(speeds(k)), continue; end
            range = rpm_blocks.start_inds(k):rpm_blocks.end_inds(k);
            T{j}(range,:) = filter_notches(T{j}(range,:),'accA_xz_norm',notches*(speeds(k)/60),notchWidth);
            T{j}(range,:) = filter_notches(T{j}(range,:),'accA_norm',notches*(speeds(k)/60),notchWidth);
            %T{j}(range,:) = filter_notches(T{j}(range,:),'accA',notches*(speeds(k)/60),notchWidth);
        end
        
        %T{j} = T{j}(get_steady_state_rows(T{j}),:);
        
        
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

function [h_fig,map,order] = plot_ordermap_with_vars(...
        T,orderMapVar,plotVars,sampleRate,figName)
    
    % ------------------------------------------------------------------------

    %[map,order,~,map_time] = make_rpm_order_map(T,orderMapVar,sampleRate); %
    [map,order,~,map_time] = make_rpm_order_map(T,orderMapVar,sampleRate,...
        'pumpSpeed', 0.1, 50); %
    t = seconds(T.time-T.time(1))+map_time(1);
    
    % ------------------------------------------------------------------------

    h_fig = figure(...
        ...'WindowState','maximized',..
        'Position',[50 100 1100 950],...
        'Units','pixels',...
        'Name',figName);
    
    ax_xPos = 0.08;
    ax_width = 0.75;
    ax_yGap = 0.009;
    bar_height = 0.06;
    xlab_space = 0.05;
    
    intervalBar_ax = 1;
    orderMap_ax = 2;
    accFreqStats_ax = 3;
    accStats_ax = 4;
    flowVars_ax = 5;
    
    ax_height(5) = 0.15;
    ax_yPos(5) = xlab_space;
    
    ax_height(4) = 0.15;
    ax_yPos(4) = ax_yPos(5)+ax_height(5)+ax_yGap;
    
    ax_height(3) = 0.15;
    ax_yPos(3) = ax_yPos(4)+ax_height(4)+ax_yGap;
    
    ax_height(2) = 1-ax_yPos(3)-ax_height(3)-ax_yGap-bar_height;
    ax_yPos(2) = ax_yPos(3)+ax_height(3)+ax_yGap;
    
    ax_height(1) = bar_height; 
    ax_yPos(1) = ax_yPos(2)+ax_height(2);
    
    h_ax(1) = axes('Position', [ax_xPos ax_yPos(1) ax_width ax_height(1)]);
    h_ax(2) = axes('Position', [ax_xPos ax_yPos(2) ax_width ax_height(2)]);
    h_ax(3) = axes('Position', [ax_xPos ax_yPos(3) ax_width ax_height(3)]);
    h_ax(4) = axes('Position', [ax_xPos ax_yPos(4) ax_width ax_height(4)]);
    h_ax(5) = axes('Position', [ax_xPos ax_yPos(5) ax_width ax_height(5)]);
    
    
    leg_xPos = 0.895;
    yLab_xPos = -0.055;
    
    specs.mapOrderLim = [0, 6];
    specs.yLab_xPos = -0.055;
    %userdata.mapColScale = [-85,-45]; % best for 6mm x 8mm catheter, x,y and z
    specs.mapColScale = [-80,-40]; % best for 6mm x 8mm catheter, x and z, filtered
    specs.bar = {
        'LineStyle','-',...
        'LineWidth',8,...
        'Marker','none'
        };
    specs.leg = {
        'EdgeColor','none',...
        'Box','off'...
        };
    specs.yLab = {
        'Interpreter','tex',...
        'Units','normalized',...
        'FontSize',9 ...
        };
    
    set(h_ax,'UserData',specs);
    
    % ------------------------------------
    
    add_order_map(h_ax(orderMap_ax),map_time,order,map)
    
    % -----------------------------
    
    ax = intervalBar_ax;
    axes(h_ax(ax));
    yyaxis right
    hold on
    
    
    % remove unused categories and given categories of no interest
    steady_inds = get_steady_state_rows(T);
    bline_inds = get_baseline_rows(T);
    
    intervType = removecats(removecats(T.intervType),...
        {'Intervention','-','Steady-state'});
    event = removecats(removecats(T.event),{'-'});
    eventCats = categories(event);
    event = mergecats(event,eventCats,'Hands on');
    
    % Plot hands-on
    plot(t(not(bline_inds)),[intervType(not(bline_inds)),event(not(bline_inds))],...
        specs.bar{:},...
        'Color',[.9 .9 .9]);
    
    % Plot baseline as green
    plot(t(bline_inds),intervType(bline_inds),specs.bar{:},...
        'Color',[0.47,0.67,0.19]);
    
    balLev = removecats(removecats(T.balloonLevel),{'-'});
    balLevCats = categories(balLev);
    for i=1:numel(balLevCats)
        balLev_ind = balLev==balLevCats{i} & steady_inds;
        plot(t(balLev_ind),balLev(balLev_ind),specs.bar{:});
    end
    
    h_ax(ax).YColor = [0 0 0];
    
    yyaxis left
    h_ax(ax).YTickLabel = [];
    h_ax(ax).YColor = [0 0 0];
    h_ax(ax).XAxisLocation = 'top';
    
    
    % ------------------------------------------
    
    ax = flowVars_ax;
    axes(h_ax(ax));
    hold on
    
    Q_ultrasound = mean([T.affQ,T.effQ],2);
    Q_ultrasound_shift = 100*(Q_ultrasound-mean(Q_ultrasound(bline_inds)))/mean(Q_ultrasound(bline_inds));
    Q_noted_shift = 100*(T.Q_noted-mean(T.Q_noted(bline_inds)))/mean(T.Q_noted(bline_inds));
    
    plot(t,Q_ultrasound_shift,...
        'LineWidth',1,...
        'Color',[0.47,0.24,0.66]);
    plot(t,Q_noted_shift,...
        'LineWidth',1.75,...
        'LineStyle','-.',...
        'Color',[0.47,0.24,0.66]);
    h_yLab = ylabel('Relative \it{Q}\rm{ change}',specs.yLab{:});
    
    h_yLab.Position(1) = yLab_xPos;
    %h_ax(ax).YTick(end) = [];
    h_ax(ax).YTickLabel = cellstr(string(str2double( h_ax(ax).YTickLabel))+"%");
    
    yyaxis right
    
    plot(t,T.power_noted,...
        'LineWidth',1.75,...
        'LineStyle','-.',...
        'Color',[0.93,0.69,0.13])
    h_yyLab(ax) = ylabel('\it{P}\rm{ (W)}',specs.yLab{:});
    
    h_leg(ax) = legend({'Q, ultrasound','Q, monitor','P, monitor'},specs.leg{:});
    title(h_leg(ax),'Flow Rate and Power')
    h_leg(ax).Position(2) = h_ax(ax).Position(2)+ax_yGap;
    h_leg(ax).Position(1) = leg_xPos;
    h_ax(ax).YTick(end) = [];
    h_ax(ax).YColor = [0 0 0];
    
    % ------------------------------------------
    
    % NOTE: Make a flow predictors panel, with Power, ballon volume, balloon
    % area percentage of tube area ???
    
    % ------------------------------------------
    
    ax = accStats_ax;
    axes(h_ax(ax));
    hold on

%     yyaxis left
%     plot(t,T.accA_xz_norm_movStd,...
%         'LineWidth',1,...
%         'LineStyle',':',...
%         'Color',[0.46,0.66,0.79,0.4]);
%     h_yLab(ax) = ylabel('RMS (g)',specs.yLab{:});
%     yyaxis right
%     plot(t,T.accA_norm_movStd,...
%         'LineWidth',1,...
%         'LineStyle',':',...
%         'Color',[0.98,0.40,0.36,0.4]);
%     h_yyLab(ax) = ylabel('SD (10^{-3} g)',specs.yLab{:});
%     
%     yyaxis left 
%     plot(t,T.accA_xz_norm_std,....
%         'LineWidth',2.25,...
%         'LineStyle','-',...
%         'Color',[0.10,0.45,0.69])
%     yyaxis right
%     plot(t,T.accA_norm_std,....
%         'LineWidth',2.25,...
%         'LineStyle','-',...
%         'Color',[0.74,0.04,0.17]);
  
    yyaxis left
    plot(t,T.accA_xz_1norm_movRMS,...
        'LineWidth',1,...
        'LineStyle',':',...
        'Color',[0.46,0.66,0.79,0.4]);
%     plot(t,T.accA_norm_rms,....
%         'LineWidth',2.25,...
%         'LineStyle','-',...
%         'Color',[0.10,0.45,0.69])
    h_yLab(ax) = ylabel('RMS (g)',specs.yLab{:});
    h_ax(ax).YColor = [0 0 0];
    h_yLab(ax).Position(1) = yLab_xPos;
    
    yyaxis right
    plot(t,T.accA_norm_movStd,...
        'LineWidth',1,...
        'LineStyle',':',...
        'Color',[0.98,0.40,0.36,0.4]);
    plot(t,T.accA_norm_std,....
        'LineWidth',2.25,...
        'LineStyle','-',...
        'Color',[0.74,0.04,0.17]);
    h_yyLab(ax) = ylabel('SD (10^{-3} g)',specs.yLab{:});
    h_ax(ax).YTickLabel = string(h_ax(ax).YTick*1000);
    
    h_leg(ax) = legend({'moving RMS, X sec','interval RMS','moving SD, X sec','interval SD'},...
        specs.leg{:});
    
    title(h_leg(ax),'Vibration Intensity')
    
    h_leg(ax).Position(2) = h_ax(ax).Position(2)+ax_yGap;
    h_leg(ax).Position(1) = leg_xPos;
    
    h_ax(ax).YTick(end) = [];
    h_ax(ax).YColor = [0 0 0];
    
    
    % ------------------------------------------
    
    
    
    % -------------------
    
    
    % Must convert to same time representation type
    set(h_ax,'xlim',h_ax(orderMap_ax).XLim)
    linkaxes(h_ax,'x')
    set(h_ax,'TickDir','both')
    set(h_ax,'TickLength',[0.005,0.025])
    set(h_ax(intervalBar_ax),'TickLength',[0,0])
    set(h_ax(1:end-1),'XTickLabel',{});
    set(h_ax(1:end-1),'XTick',[]);
    
    xlabel(h_ax(end),'Duration (sec)')
    
    
   
    %     for i=1:numel(blocks.end_inds)-1
    %         line_pos = T.dur(blocks.end_inds(i));
    %         xline(T.dur(blocks.end_inds(i)),':','Color',[255, 18, 18]/256,'LineWidth',1.5);
    %
    %         % Make a thick white stripe between each part (indicating a possible
    %         % break)
    %         %xline(T.dur(blocks.end_inds(i)),'-','Color',[1, 1, 1],'LineWidth',2);
    %     end
    %
    
end

function add_order_map(h,map_time,order,map)

    specs = h.UserData;
    
    axes(h);
    imagesc(map_time,order,map);
    caxis(specs.mapColScale );
    set(h,'ydir','normal');
    h.YLim = specs.mapOrderLim;
    
    h_yLab = ylabel('Harmonics',...
        specs.yLab{:});
    h_yLab.Position(1) = specs.yLab_xPos;
        
    %     barHeight = 0.02;
    %     bar_xpos = hAx(ax).Position(1);
    %     bar_ypos = sum(hAx(ax).Position([2,4]))+0.002;
    %     annotation('textbox',[bar_xpos,bar_ypos,0.2,barHeight],'String','Part ',...
    %         'BackgroundColor',[1 1 1 1],...
    %         'EdgeColor',[0 0 0],...
    %         'LineWidth',0.5,...
    %         'HorizontalAlignment','center',...
    %         'VerticalAlignment','middle',...
    %         'SelectionHighlight','on',...
    %         'FontSize',8);
    
end
       
function add_freqStats(h)
    add_freqStats(accFreqStats_ax)
    
    axes(h);
    hold on
    plot(t,T.accA_norm_mpf_shift,...
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0 0 0,0.8]);
%     plot(t,T.accA_norm_movMPF,...
%         'LineWidth',0.5,...
%         'LineStyle','-',...
%         'Color',[0.6 0.6 0.6]);
    h_yLab(ax) = ylabel('MPF shift (Hz)',specs.yLab{:});
    
    yyaxis right
    plot(t,T.accA_norm_xz_mpf,...
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0.39,0.60,0.12]);
    h_yyLab(ax) = ylabel('MPF (Hz)',specs.yLab{:});
    
    h_leg(ax) = legend({'x,y and z','x and z'},specs.leg{:});
    title(h_leg(ax),'Acc. Frequency')
    
    h_yLab(ax).Position(1) = yLab_xPos;
    h_leg(ax).Position(2) = h_ax(ax).Position(2)+ax_yGap;
    h_leg(ax).Position(1) = leg_xPos;
    h_ax(ax).YColor = [0 0 0];
    


function blocks = add_cats_bar(h_ax,T,bars)
    
    font_size = 8;
    font_weight = 'normal';
    alpha=1;
    
    hold on
    
    bar_no=0;
    annot_str = {};
    vars = bars(:,1);
    Cmaps = bars(:,2);
    [blocks,vars] = find_cat_blocks(T,vars);
    
    h_ax.YLim(1) = h_ax.YLim(1)-0.005;
    h_ax.XAxis.Visible = 'off';
    for i=1:numel(vars)
        
        % Fixed list of categories (useful for keeping category color order)
        cats = get_cats(T,vars{i});
        
        % If there is only one categoric value: use text box instead.
        if numel(unique(string(T.(vars{i}))))<2
            annot_str{i-bar_no+1} = vars{i}+" = "+string(T.(vars{i})(1));
            continue
        end
        
        % use 4 percent of height of subfigure for each bar
        h_ax.Units = 'points';
        barWidth = 0.074*h_ax.Position(4);
        h_ax.Units = 'normalized';
        
        bar_no=bar_no+1;
        h_ax.YLim(1) = h_ax.YLim(1)-0.21;
        yPos = h_ax.YLim(1)+0.13;
        
        h_ax.ColorOrder = Cmaps{i};
        h_ax.ColorOrderIndex=1;
        
        for j=1:numel(cats)
            
            barTime = T.dur(T.(vars{i})==cats(j));
            if numel(barTime)==0, continue; end
            n_blocks = numel([blocks.start_durSec{i,j,:}]);
            barVal = repmat(yPos,1,numel(barTime));
            h_bar = plot(h_ax,barTime,barVal,'LineWidth',barWidth);
            h_bar.Color = [h_bar.Color,alpha];
            
            barText = cats{j};
            if barText=="-"
                barText = "NA";
                h_bar.Color = [.85, .85, .85, alpha];
            end
            
            for k=1:n_blocks
                xPos = (blocks.start_durSec{i,j,k}+blocks.end_durSec{i,j,k})/2;
                text(xPos,yPos,""+barText,...
                    'HorizontalAlignment','center',...
                    'FontSize',font_size,...
                    'FontWeight',font_weight);
            end
            
        end
        
        % Add bar annotation outside the plot
        text(0,yPos,vars{i}+" ",...
            'HorizontalAlignment','right',...
            'FontSize',font_size)
        
    end
    
    if numel(annot_str)>0
        text(1.013,0.95,annot_str,...
            'Units','normalized',...
            'EdgeColor',[0 0 0],...
            'FontSize',font_size,...
            'FontWeight',font_weight)
    end
    
    h_ax.YTick(h_ax.YTick<0) = [];
end

function fig_name = make_figure_name(parts,orderMapVar,notches)
    fig_name = sprintf('IV2_Seq2: Parts=%s - %s order map and time plots',...
        mat2str(parts),orderMapVar);
    if numel(notches)>0
        fig_name = [fig_name,' - filtered ',mat2str(notches),' harmonics'];
    end
end
