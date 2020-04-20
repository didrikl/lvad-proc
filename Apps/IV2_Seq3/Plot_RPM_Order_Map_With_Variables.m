close all
clear check_var_input_from_table

% Calculation settings
sampleRate = 700;

orderMapVar = 'accA_norm';
%mapColScale = [-80,-40];  % best for 6mm x 8mm catheter, x and z, filtered
mapColScale = [-85,-45]; % best for 6mm x 8mm catheter, x,y and z

parts = {
    %     [34,35,33,36]
    %     [40,41,39,42]
    [28]
    %           [40]
    %           [41]
    %           [42]
    };

% Extract data for these RPM values
rpm = {
    %     [2000,2300,2600,2900]
    %     [2000,2300,2600,2900]
    [3200]
    %     [2000]
    %     [2300]
    %     [2900]
    };

bl_part = [];

for i=1:numel(parts)
    
    T = make_plot_data(parts{i},S_parts,rpm{i},sampleRate,bl_part);
   
    h_fig = plot_ordermap_with_vars(T,orderMapVar,sampleRate,bl_part,mapColScale);
    %save_figure(h_fig,parts,orderMapVar,notches)
    
end

function save_figure(h_fig,parts,orderMapVar)
    resolution = 300;
    figName = make_figure_name(parts,orderMapVar);
    h_fig.Name = figName;
    save_figure([proc_basePath,'\Figures'], figName, resolution)
end

function T = make_plot_data(parts,S_parts,rpm,fs,bl_part)
    % Extract relevant data
        
    T = S_parts(parts);
        
    for j=1:numel(T)
        T{j} = merge_table_blocks(S_parts([bl_part,parts(j)]));
        T{j}.dur = linspace(0,1/fs*height(T{j}),height(T{j}))';
        
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
            
            freqfilt{k} = meanfreq(detrend(T{j}.("accA_norm_[1]hFilt")(range)),fs);
            T{j}.accA_norm_filt_mpf(range) = freqfilt{k};
            T{j}.accA_norm_filt_mpf_shift(range) = freqfilt{k} - freqfilt{1};
            
            Q_ultrasound = mean([T{j}.affQ,T{j}.effQ],2);
            T{j}.Q_ultrasound_shift = 100*(Q_ultrasound-mean(Q_ultrasound(bline_inds)))/mean(Q_ultrasound(bline_inds));
            T{j}.Q_noted_shift = 100*(T{j}.Q_noted-mean(T{j}.Q_noted(bline_inds)))/mean(T{j}.Q_noted(bline_inds));
            T{j}.power_noted_shift = 100*(T{j}.power_noted-mean(T{j}.power_noted(bline_inds)))/mean(T{j}.power_noted(bline_inds));
            
            T{j}.accA_norm_std_shift = -100*(T{j}.accA_norm_std-mean(T{j}.accA_norm_std(bline_inds)))/mean(T{j}.accA_norm_std(bline_inds));
            T{j}.accA_norm_movStd_shift = -100*(T{j}.accA_norm_movStd-mean(T{j}.accA_norm_movStd(bline_inds),'omitnan'))/mean(T{j}.accA_norm_movStd(bline_inds),'omitnan');
            
        end
        
    end
    
    T = merge_table_blocks(T);
    %T = T(get_steady_state_rows(T),:);
    T.Properties.SampleRate = fs;
    
end

function [h_fig,map,order] = plot_ordermap_with_vars(T,orderMapVar,fs,bl_part,mapColScale)
    
    if nargin<4, bl_part = []; end
    if nargin<5, mapColScale = []; end
    
    %[map,order,~,map_time] = make_rpm_order_map(T,orderMapVar,sampleRate); %
    [map,order,rpm,map_time] = make_rpm_order_map(T,orderMapVar,fs,...
        'pumpSpeed', 0.02, 80); %
    T.t = seconds(T.time-T.time(1))+map_time(1);
    
    flow_ax = 5;
    acc_ax = 4;
    freqStats_ax = 3;
    
    specs.leg_yGap = 0.006;
    specs.leg_xPos = 0.85;
    specs.yLab_xPos = -0.058;
    specs.yyLab_xPos = 1.039;
    specs.circ_ylim = [-60,5];
    specs.mapOrderLim = [0, 5.15];
    specs.mapColScale = mapColScale;
    specs.baseline_title = {
        'Units','data',...
        'HorizontalAlignment','center',...
        'FontSize',8.5,...
        'FontWeight','bold'};
    specs.event_bar = {
        'LineStyle','-',...
        'LineWidth',6.5,...
        'Marker','none',...
        'Color', [.8 .8 .8]};
    specs.bal_lev_bar = {
        'LineStyle','-',...
        'LineWidth',6,...
        'Marker','none',...
        'Color', [.8 .8 .8]}; %'Color',[0.91,0.56,0.56]
    specs.leg = {
        'EdgeColor','none',...
        'Box','off',...
        'FontSize',8};
    specs.leg_title = {
        'FontSize',8.5};
    specs.yLab = {
        'Interpreter','tex',...
        'Units','normalized',...
        'FontSize',8};
    
    [h_fig,h_ax] = init_axes_layout;
    set(h_ax,'UserData',specs);
    
    add_interv_bar(h_ax(1),T)
    add_order_map(h_ax(2),map_time,order,map,rpm)
    add_freqStats(h_ax(freqStats_ax),T)
    add_vibrations(h_ax(acc_ax),T)
    add_circulation(h_ax(flow_ax),T);
    add_baseline_xlines(h_ax,T,bl_part);
    
    xlabel(h_ax(end),'Duration (sec)')
    adjust_axes(h_ax);
    
end

function [h_fig,h_ax] = init_axes_layout
    
    h_fig = figure(...
        ...'WindowState','maximized',...
        ...'Position',[0 70 1100 950],...
        'Units','pixels');
    fig_pos = get(0, 'MonitorPositions');
    win_taskbar_height = 31;
    fig_pos(3) = 0.5*fig_pos(3);
    fig_pos(2) = win_taskbar_height;
    fig_pos(4) = fig_pos(4) - win_taskbar_height;
    h_fig.OuterPosition = fig_pos;
    
    ax_xPos = 0.075;
    ax_width = 0.72;
    ax_yGap = 0.009;
    bar_height = 0.0335;
    xLab_space = 0.05;
    
    ax_height(5) = 0.155;
    ax_yPos(5) = xLab_space;
    
    ax_height(4) = 0.14;
    ax_yPos(4) = ax_yPos(5)+ax_height(5)+ax_yGap;
    
    ax_height(3) = 0.14;
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
    
    event = removecats(removecats(T.event),{'-'});
    %event = mergecats(event,categories(event),'Hands on');
    plot(T.t,event,specs.event_bar{:})
    
    T.balloonLevel = removecats(removecats(T.balloonLevel),{'-'});
    T.balloonLevel = mergecats(T.balloonLevel,{'2','3','4','5'},'Inflated balloon');
    T.balloonLevel = renamecats(T.balloonLevel,'1','Empty balloon');
    
    blocks = find_cat_blocks(T,{'balloonLevel','event'},700);
    for i=1:numel(blocks.start_inds)
       inds = false(height(T),1);
       inds(blocks.start_inds(i):blocks.end_inds(i)) = true;
       inds = inds & ss_inds;
       plot(T.t(inds),T.balloonLevel(inds),specs.bal_lev_bar{:})
    end
    
%     clamp = removecats(removecats(T.flowReduction),{'-'});
%     %if numel(categories(clamp))>1
%     plot(
    
    h.YColor = [0 0 0];
    
    yyaxis left
    [start_ind, end_ind] = get_baseline_block(T);
    text(double(T.t( floor(mean([start_ind(1),end_ind(1)])) )),0.5,'Baseline',...
        specs.baseline_title{:})
   
    h.YTickLabel = [];
    h.YColor = [0 0 0];
    h.XAxisLocation = 'top';
    
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
    if not(isnan(specs.mapColScale)) & not(isempty(specs.mapColScale)) %#ok<AND2>
        caxis(specs.mapColScale);
    end
    set(h,'ydir','normal');
    h.YLim = specs.mapOrderLim;
 
    add_colorbar(h,specs)
    add_ylabel('Harmonics',specs);
    add_linked_map_yyaxis(h,rpm,specs);
end

function [start_ind, end_ind] = get_baseline_block(T,bl_part)
    
    if nargin<2, bl_part = []; end
    
    if not(isempty(bl_part))
        start_ind = find(T.part==string(bl_part),1,'first');
        end_ind = find(T.part==string(bl_part),1,'last');
    else
        block = find_cat_blocks(T,'intervType');
        start_ind = block.start_inds(ismember(lower(string(...
            T.intervType(block.start_inds))),'baseline'));
        end_ind = block.end_inds(ismember(lower(string(...
            T.intervType(block.end_inds))),'baseline'));
        if numel(start_ind)>1
            fprintf('\nMultiple baseline intervals in signal part.\n')
        end
    end
    
    if numel(start_ind)==0
        fprintf('\nNo baseline intervals in signal part.\n')
    end
    
end

function add_colorbar(h,specs)
    h_col = colorbar(h,...
        'Position',[0.881607, h.Position(2), 0.01921, 0.10526],...
        'Box', 'off',...
        'FontSize',8);
    h_col.Position(2) = h.Position(2)+0.5*h.Position(4)-0.5*h_col.Position(4);
    h_col.Label.String = {'Frequency';'amplitude (dB)'};
    h_leg = add_legend(h,{},'Spectrogram',specs);
    h_leg.Position = [0.8549524,0.77852534,0.1127575,0.043817];
end    
    
function add_baseline_xlines(h_ax,T,bl_part)
    
    if nargin<3, bl_part = []; end
    
    [start_ind, end_ind] = get_baseline_block(T,bl_part);
    
    start_ind = start_ind(start_ind>1);
    for i=1:numel(start_ind)
        draw_xline_for_all_axes(h_ax,T.t(start_ind(i)))
    end
    end_ind = end_ind(end_ind<height(T));
    for i=1:numel(end_ind)
        draw_xline_for_all_axes(h_ax,T.t(end_ind))
    end
    
    
end

function draw_xline_for_all_axes(h_ax,pos)
    for j=1:numel(h_ax)
        xline(h_ax(j),pos,'LineWidth',3,'Color',[1 1 1 0]);
        xline(h_ax(j),pos,'LineWidth',0.5,'Color',[1 0 0 0]);
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
        set(h,'YTickLabel',strsplit(num2str(orderTicks*(rpm/60),'%2.0f ')));
    end
end

function add_freqStats(h,T)
    
    specs = h.UserData;
    axes(h);
    hold on

    ss_rows = get_steady_state_rows(T);
    
    green_solid = [0.39,0.60,0.12];
    plot(T.t,T.accA_norm_mpf_shift,...
        'LineWidth',1.5,...
        'LineStyle',':',...
        'Color',[0 0 0,0.8],...
        'HandleVisibility','off');
    T.accA_norm_mpf_shift(not(ss_rows)) = nan;
    plot(T.t,T.accA_norm_mpf_shift,...
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0 0 0,0.8]);
    
    add_ylabel('MPF Shift  (Hz)',specs);
    
    plot(T.t,T.accA_norm_filt_mpf_shift,...
        'LineWidth',1.5,...
        'LineStyle',':',...
        'Color',green_solid,...
        'HandleVisibility','off');
    T.accA_norm_filt_mpf_shift(not(ss_rows)) = nan;
    plot(T.t,T.accA_norm_filt_mpf_shift,...
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',green_solid);
    
%     h_yyLab = ylabel({'Rectangular';'Window RMS'},specs.yLab{:});
%     h_yyLab.Position(1) = specs.yyLab_xPos;

    h.YLim = [-15, 10];
    h.YTick(end) = [];
    h.Clipping = 'off';
    
    add_legend(h,{'MPF','MPF, 1st harm. filt.'},'Frequency energy',specs);
  
end

function add_vibrations(h,T)
    
    specs = h.UserData;
    axes(h);
    hold on
    
    h_yLab = ylabel('RMS  (g)',specs.yLab{:});
    h_yLab.Position(1) = specs.yLab_xPos;
    
    ss_rows = get_steady_state_rows(T);
    
    blue_solid = [0.0156,0.3555, 0.7188];
    plot(T.t,T.accA_norm_movRMS,...
        'LineWidth',0.5,...
        'LineStyle','-',...
        'Color',[0.46,0.66,0.79,0.3]);
    accA_norm_rms_ss = T.accA_norm_rms;
    accA_norm_rms_ss(not(ss_rows)) = nan;
    plot(T.t,accA_norm_rms_ss,....
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',blue_solid);
    
    yrange = h.YLim(2)-h.YLim(1);
    h.YLim = [h.YLim(1)-0.1*yrange, h.YLim(2)+0.1*yrange,];
    h.YTick([1,end]) = []; 
    
    yyaxis right
    plot(T.t,T.accA_norm_movStd,...
        'LineWidth',.5,...
        'LineStyle','-',...
        'Color',[0.96,0.39,0.35,0.85]);
    accA_norm_std_ss = T.accA_norm_std;
    accA_norm_std_ss(not(ss_rows)) = nan;
    plot(T.t,accA_norm_std_ss,....
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0.74,0.04,0.17]);
    
    h.YTickLabel = string(h.YTick*1000);
    h.YTick([1,end]) = []; 
    
    %add_yylabel('SD (10^{-3} g)',specs.yLab{:});
    h_yyLab = ylabel('SD  (10^{-3} g)',specs.yLab{:});
    h_yyLab.Position(1) = specs.yyLab_xPos;
    
    add_legend(h,{'RMS, moving win.','RMS, steady-state','SD, moving win.', 'SD, steady-state'},...
        'Vibration Intensity',specs);
    
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
        'Color',[0.5781,0.5117,0.9453]);%[0.7188,0.6289,0.9297]);%[0.6055,0.1406, 0.4414, 0.85]);
    plot(T.t(ss_rows),area_red(ss_rows),...
        'LineWidth',1.25,...
        'LineStyle',':',...
        'Color',[0.5781,0.5117,0.9453],...[0.7188,0.6289,0.9297,0.7],...[0.6055,0.1406, 0.4414,0.6],...
        'HandleVisibility','off');
    
    plot(T.t,T.Q_ultrasound_shift,...
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0 0 0, 0.6]);
    
    
    accA_norm_std_shift_ss = T.accA_norm_std_shift;
    accA_norm_std_shift_ss(not(ss_rows)) = nan;
%     plot(T.t(ss_rows),T.accA_norm_std_shift(ss_rows),...
%         'LineWidth',1.25,...
%         'LineStyle',':',...
%         'Color',[0.74,0.04,0.17,0.6],...
%         'HandleVisibility','off');   
    plot(T.t,T.accA_norm_movStd_shift,...
        'LineWidth',0.5,...
        'LineStyle','-',...
        'Color',[0.96,0.39,0.35,0.6]);
    plot(T.t,accA_norm_std_shift_ss,...
        'LineWidth',2,...
        'LineStyle','-',...
        'Color',[0.74,0.04,0.17,0.7]);
    
    h.YLim = specs.circ_ylim;
    h_yLab = ylabel('Relative Change',specs.yLab{:});
    h_yLab.Position(1) = specs.yLab_xPos;
    h.Clipping = 'off';
    leg_entries = {
        'Power, monitor'
        '\itQ\rm, monitor'
        'Inlet reduction'
        '\itQ\rm, ultrasound'
        'SD*, moving win.'
        'SD*, steady-state'
        };
    add_legend(h,leg_entries,'Circulation',specs);

end

function h_leg = add_legend(h_ax,entries,titleString,specs)
    h_leg = legend(entries,specs.leg{:},...
        'AutoUpdate','off');
    title(h_leg,titleString,...
        specs.leg_title{:});
    h_leg.Position(2) = h_ax.Position(2)+0.5*h_ax.Position(4)-0.5*h_leg.Position(4);
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
    set(h_ax,'FontSize',8)
    set(h_ax,'YColor',[0 0 0]); 
    h_ax(5).YTickLabel = cellstr(string(h_ax(5).YTick)+"%");
end

function fig_name = make_figure_name(parts,orderMapVar,notches)
    fig_name = sprintf('IV2_Seq2: Parts=%s - %s order map and time plots',...
        mat2str(parts),orderMapVar);
    if numel(notches)>0
        fig_name = [fig_name,' - filtered ',mat2str(notches),' harmonics'];
    end
end
