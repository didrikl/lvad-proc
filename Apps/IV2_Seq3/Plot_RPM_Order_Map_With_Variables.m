close all
clear check_var_input_from_table

% Graphics settings
resolution = 300;

% Calculation settings
sampleRate = 700;

orderMapVar = 'accA_norm';

% Filter out harmonics lines in selected variables
notches = [1,2];

parts = {
    %     [34,35,33,36]
    %     [40,41,39,42]
    [39]
    %           [40]
    %           [41]
    %           [42]
    };

% Extract data for these RPM values
rpm = {
    %     [2000,2300,2600,2900]
    %     [2000,2300,2600,2900]
    [2600]
    %     [2000]
    %     [2300]
    %     [2900]
    };

bl_part = [];
for i=1:numel(parts)
    
    T = make_plot_data(parts{i},S_parts,rpm{i},sampleRate,bl_part);
    
    BL = S_parts{parts{i}}(S_parts{parts{i}}.intervType=='Control baseline',:);
    h_fig = plot_ordermap_with_vars(T,orderMapVar,sampleRate,bl_part);
    
    
    figName = make_figure_name(parts{i},orderMapVar,notches);
    h_fig.Name = figName;
    %save_figure([proc_basePath,'\Figures'], figName, resolution)
end



function T = make_plot_data(parts,S_parts,rpm,fs,bl_part)
    % Extract relevant data
        
    T = S_parts(parts);
        
    for j=1:numel(T)
        T{j} = merge_table_blocks(S_parts([bl_part,parts(j)]));
        T{j}.dur = linspace(0,1/fs*height(T{j}),height(T{j}))';
        
        %ss_rows = get_steady_state_rows(T{j});
        %T{j} = T{j}(ss_rows,:);
        
        T{j} = T{j}(T{j}.pumpSpeed==rpm(j),:);
        bline_inds = get_baseline_rows(T{j});
        
        if height(T{j})==0, continue; end
        
        bal_blocks = find_cat_blocks(T{j},{'balloonLevel','intervType'},fs);
        for k=1:numel(bal_blocks.start_inds)
            range = bal_blocks.start_inds(k):bal_blocks.end_inds(k);
            T{j}.accA_xz_norm_std(range) = std(T{j}.accA_xz_norm(range));
            T{j}.accA_xz_norm_rms(range) = rms(T{j}.accA_xz_norm(range));
            T{j}.accA_norm_std(range) = std(T{j}.accA_norm(range));
            T{j}.accA_norm_rms(range) = rms(T{j}.accA_norm(range));
            
            freq{k} = meanfreq(detrend(T{j}.accA_norm(range)),fs);
            T{j}.accA_norm_mpf(range) = freq{k};
            T{j}.accA_norm_mpf_shift(range) = freq{k} - freq{1};
            
            freqxz{k} = meanfreq(detrend(T{j}.accA_xz_norm(range)),fs);
            T{j}.accA_xz_norm_mpf(range) = freqxz{k};
            T{j}.accA_xz_norm_mpf_shift(range) = freqxz{k} - freqxz{1};
            
            Q_ultrasound = mean([T{j}.affQ,T{j}.effQ],2);
            T{j}.Q_ultrasound_shift = 100*(Q_ultrasound-mean(Q_ultrasound(bline_inds)))/mean(Q_ultrasound(bline_inds));
            T{j}.Q_noted_shift = 100*(T{j}.Q_noted-mean(T{j}.Q_noted(bline_inds)))/mean(T{j}.Q_noted(bline_inds));
            T{j}.power_noted_shift = 100*(T{j}.power_noted-mean(T{j}.power_noted(bline_inds)))/mean(T{j}.power_noted(bline_inds));
            
        end
        
        
        
    end
    
    T = merge_table_blocks(T);
    T.Properties.SampleRate = fs;
    
end

function [h_fig,map,order] = plot_ordermap_with_vars(T,orderMapVar,fs,bl_part)
    
    %[map,order,~,map_time] = make_rpm_order_map(T,orderMapVar,sampleRate); %
    [map,order,rpm,map_time] = make_rpm_order_map(T,orderMapVar,fs,...
        'pumpSpeed', 0.02, 80); %
    T.t = seconds(T.time-T.time(1))+map_time(1);
    
    
    % ------------------------------------------------------------------------
    
    flow_ax = 5;
    acc_ax = 4;
    freqStats_ax = 3;
    orderMap_ax = 2;
    interv_ax = 1;
    
    specs.leg_yGap = 0.007;
    specs.leg_xPos = 0.87;
    specs.mapOrderLim = [0, 6];
    specs.yLab_xPos = -0.056;
    specs.yyLab_xPos = 1.039;
    
    %specs.mapColScale = [-85,-45]; % best for 6mm x 8mm catheter, x,y and z
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
    
    [h_fig,h_ax] = init_axes_layout;
    set(h_ax,'UserData',specs);
    
    add_order_map(h_ax(orderMap_ax),map_time,order,map,rpm)
    add_interv_bar(h_ax(interv_ax),T)
    add_freqStats(h_ax(freqStats_ax),T)
    add_vibrations(h_ax(acc_ax),T)
    add_circulation(h_ax(flow_ax),T);
    
    adjust_axes(h_ax);
    add_baseline_xline(h_ax,T,bl_part);
    xlabel(h_ax(end),'Duration (sec)')
    
end

function [h_fig,h_ax] = init_axes_layout
    
    h_fig = figure(...
        ...'WindowState','maximized',..
        'Position',[50 100 1100 950],...
        'Units','pixels');
    
    ax_xPos = 0.08;
    ax_width = 0.72;
    ax_yGap = 0.009;
    bar_height = 0.06;
    xLab_space = 0.05;
    
    ax_height(5) = 0.145;
    ax_yPos(5) = xLab_space;
    
    ax_height(4) = 0.145;
    ax_yPos(4) = ax_yPos(5)+ax_height(5)+ax_yGap;
    
    ax_height(3) = 0.145;
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
    
end



function add_interv_bar(h,T)
    
    specs = h.UserData;
    axes(h);
    yyaxis right
    hold on
    
    % remove unused categories and given categories of no interest
    ss_inds = get_steady_state_rows(T);
    bl_inds = get_baseline_rows(T);
    
    intervType = removecats(removecats(T.intervType),...
        {'Intervention','-','Steady-state'});
    event = removecats(removecats(T.event),{'-'});
    eventCats = categories(event);
    event = mergecats(event,eventCats,'Hands on');
    
    % Plot hands-on
    plot(T.t(not(bl_inds)),[intervType(not(bl_inds)),event(not(bl_inds))],...
        specs.bar{:},...
        'Color',[.9 .9 .9]);
    
    % Plot baseline as green
    plot(T.t(bl_inds),intervType(bl_inds),specs.bar{:},...
        'Color',[0.47,0.67,0.19]);
    
    balLev = removecats(removecats(T.balloonLevel),{'-'});
    balLevCats = categories(balLev);
    for i=1:numel(balLevCats)
        balLev_ind = balLev==balLevCats{i} & ss_inds;
        plot(T.t(balLev_ind),balLev(balLev_ind),specs.bar{:});
    end
    
    h.YColor = [0 0 0];
    
    yyaxis left
    h.YTickLabel = [];
    h.YColor = [0 0 0];
    h.XAxisLocation = 'top';
    
end

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

function add_bar
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

function add_order_map(h,map_time,order,map,rpm)
    
    specs = h.UserData;
    axes(h);
    
    imagesc(map_time,order,map);
    caxis(specs.mapColScale );
    set(h,'ydir','normal');
    h.YLim = specs.mapOrderLim;
    
    h_leg = add_legend(h,{},'Spectrogram',specs);
    h_leg.Position(2) = 0.6151;
    
    h_col = colorbar(h,...
        'Position',[0.8824, h.Position(2)+specs.leg_yGap, 0.01921, 0.10526],...
        'Box', 'off');
    h_col.Label.String = {'Frequency';'amplitude (dB)'};
    
    add_ylabel('Harmonics',specs);
    
    add_linked_map_yyaxis(h,rpm,specs);
end

function add_baseline_xline(h_ax,T)
    
    find_cat_blocks('intervType')
    bl_rows = contains(lower(string(T.intervType)),'baseline')
    
    if bl_part
    start_ind = find(T.part==string(bl_part),1,'first');
    end_ind = find(T.part==string(bl_part),1,'last');
    
    if start_ind>1
        start_pos = T.t(start_ind);
        for i=1:numel(h_ax)
            xline(h_ax(i),start_pos,'LineWidth',3,'Color',[1 1 1 0]);
            xline(h_ax(i),start_pos,'LineWidth',0.5,'Color',[1 0 0 0]);
        end
    end
    
    if end_ind<height(T)
        end_pos = T.t(end_ind);
        for i=1:numel(h_ax)
            xline(h_ax(i),end_pos,'LineWidth',3,'Color',[1 1 1 0]);
            xline(h_ax(i),end_pos,'LineWidth',0.5,'Color',[1 0 0 0]);
        end
    end
    
end

function add_ylabel(text_str,specs)
    h_yLab = ylabel(text_str,specs.yLab{:});
    h_yLab.Position(1) = specs.yLab_xPos;
end

function add_linked_map_yyaxis(h,rpm,specs)
    orderTicks = h.YTick;
    rpm = unique(rpm);
    if numel(rpm)==1
        yyaxis right
        yyLab = ylabel('(Hz)',specs.yLab{:});
        yyLab.Position(1) = specs.yyLab_xPos;
        linkprop(h.YAxis, 'Limits');
        strsplit(num2str(orderTicks*(rpm/60),'%2.0f '));
        set(h,'YTickLabel',strsplit(num2str(orderTicks*(rpm/60),'%2.1f ')));
    end
end

function add_freqStats(h,T)
    
    specs = h.UserData;
    axes(h);
    hold on

    ss_rows = get_steady_state_rows(T);
    
    green_solid = [0.39,0.60,0.12,0.8];
    plot(T.t,T.accA_xz_norm_mpf_shift,...
        'LineWidth',1.5,...
        'LineStyle',':',...
        'Color',[0 0 0,0.8],...
        'HandleVisibility','off');
    T.accA_xz_norm_mpf_shift(not(ss_rows)) = nan;
    plot(T.t,T.accA_xz_norm_mpf_shift,...
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0 0 0,0.8]);
    %     plot(t,T.accA_norm_movMPF,...
    %         'LineWidth',0.5,...
    %         'LineStyle','-',...
    %         'Color',[0.6 0.6 0.6]);
    
    add_ylabel('Shift (Hz)',specs);
    
    yyaxis right
    % NOTE: Only each plot line has the same baseline....
    h_yyLab = ylabel('(Hz)',specs.yLab{:});
    h_yyLab.Position(1) = specs.yyLab_xPos;
    linkprop(h.YAxis, 'Limits');
    
    add_legend(h,{'MPF'},'Frequency energy',specs);
  
end

function add_vibrations(h,T)
    
    specs = h.UserData;
    axes(h);
    hold on
    
    %     plot(T.t,T.accA_xz_norm_movRMS,...
    %         'LineWidth',1,...
    %         'LineStyle',':',...
    %         'Color',[0.46,0.66,0.79,0.4]);
    %     plot(t,T.accA_norm_rms,....
    %         'LineWidth',2.25,...
    %         'LineStyle','-',...
    %         'Color',[0.10,0.45,0.69])
    
    h_yLab = ylabel('RMS (g)',specs.yLab{:});
    h_yLab.Position(1) = specs.yLab_xPos;
    
    ss_rows = get_steady_state_rows(T);
    
%     blue_solid = [0.0156,0.3555, 0.7188]; %[0.10,0.45,0.69]
%     plot(T.t,T.accA_norm_movRMS,...
%         'LineWidth',0.5,...
%         'LineStyle','-',...
%         'Color',[0.46,0.66,0.79,0.3]);
%     accA_norm_rms_ss = T.accA_norm_rms;
%     accA_norm_rms_ss(not(ss_rows)) = nan;
%     plot(T.t,accA_norm_rms_ss,....
%         'LineWidth',2,...
%         'LineStyle','-',...
%         'Color',blue_solid);
    
    yyaxis right
    plot(T.t,T.accA_norm_movStd,...
        'LineWidth',1.25,...
        'LineStyle',':',...
        'Color',[0.98,0.40,0.36,0.8]);
    accA_norm_std_ss = T.accA_norm_std;
    accA_norm_std_ss(not(ss_rows)) = nan;
    plot(T.t,accA_norm_std_ss,....
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0.74,0.04,0.17]);
    
    h.YTickLabel = string(h.YTick*1000);

    h_yyLab = ylabel('SD (10^{-3} g)',specs.yLab{:});
    h_yyLab.Position(1) = specs.yyLab_xPos;
    
    add_legend(h,{'mov. xz-SD, Xsec','interval xz-SD','mov. SD, Xsec','interval SD'},...
        'Vibration Intensity',specs);
    
    %     add_legend(h,{'moving RMS, X sec','interval RMS','moving SD, X sec','interval SD'},...
    %         'Vibration Intensity',specs);
    
end

function add_circulation(h,T)
    
    specs = h.UserData;
    axes(h);
    hold on
    
    ss_rows = get_steady_state_rows(T);
    
    
    power_noted_shift_ss = T.power_noted_shift;
    power_noted_shift_ss(not(ss_rows)) = nan;
    plot(T.t,power_noted_shift_ss,...
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0.9961,0.4961,0,0.95])
    plot(T.t(ss_rows),T.power_noted_shift(ss_rows),...
        'LineWidth',1.25,...
        'LineStyle',':',...
        'Color',[0.9961,0.4961,0,0.7],...
        'HandleVisibility','off')
    
    Q_noted_shift_ss = T.Q_noted_shift;
    Q_noted_shift_ss(not(ss_rows)) = nan;
    plot(T.t,Q_noted_shift_ss,...
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0.39,0.60,0.12,0.75]);
    plot(T.t(ss_rows),T.Q_noted_shift(ss_rows),...
        'LineWidth',1.25,...
        'LineStyle',':',...
        'Color',[0.39,0.60,0.12,0.6],...
        'HandleVisibility','off');
     
    area_bal = pi*((double(string(T.balloonDiam))/2).^2);
    area_inlet = pi*(13.0/2)^2;
    area_red = 100*((area_inlet-area_bal)/area_inlet - 1);
    area_red_ss = area_red;
    area_red_ss(not(ss_rows)) = nan;
    plot(T.t,area_red_ss,...
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0.6055,0.1406, 0.4414, 0.85]);
    plot(T.t(ss_rows),area_red(ss_rows),...
        'LineWidth',1.25,...
        'LineStyle',':',...
        'Color',[0.6055,0.1406, 0.4414,0.6],...
        'HandleVisibility','off');
    
    plot(T.t,T.Q_ultrasound_shift,...
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0 0 0, 0.65]);
    
    h.YTickLabel = cellstr(string(str2double( h.YTickLabel))+"%");
    h_yLab = ylabel('Relative change',specs.yLab{:});
    h_yLab.Position(1) = specs.yLab_xPos;
    
    %     yyaxis right
    %     h_yyLab = ylabel('Power\rm{ (W)}',specs.yLab{:});
    %     h_yyLab.Position(1) = specs.yyLab_xPos;
    %     linkprop(h.YAxis, 'Limits');
    %     adjust_yyaxis(h)
    leg_entries = {
        'Power, monitor'
        '\itQ\rm, monitor'
        'Inlet reduction'
        '\itQ\rm, ultrasound'
        };
    add_legend(h,leg_entries,'Circulation',specs);
    
end

function h_leg = add_legend(h_ax,entries,titleString,specs)
    h_leg = legend(entries,specs.leg{:},...
        'AutoUpdate','off');
    title(h_leg,titleString);
    h_leg.Position(2) = h_ax.Position(2)+specs.leg_yGap;
    h_leg.Position(1) = specs.leg_xPos;
end

function adjust_axes(h_ax)
    set(h_ax,'xlim',h_ax(2).XLim)
    linkaxes(h_ax,'x')
    set(h_ax,'TickDir','both')
    set(h_ax,'TickLength',[0.005,0.025])
    set(h_ax(1),'TickLength',[0,0])
    set(h_ax(1:end-1),'XTickLabel',{});
    set(h_ax(1:end-1),'XTick',[]);
    set(h_ax,'FontSize',8.5)
    h_ax(2).YTick(1) = [];
    set(h_ax,'YColor',[0 0 0]); 
end

function fig_name = make_figure_name(parts,orderMapVar,notches)
    fig_name = sprintf('IV2_Seq2: Parts=%s - %s order map and time plots',...
        mat2str(parts),orderMapVar);
    if numel(notches)>0
        fig_name = [fig_name,' - filtered ',mat2str(notches),' harmonics'];
    end
end
