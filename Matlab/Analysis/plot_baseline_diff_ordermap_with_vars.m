function h_fig = plot_baseline_diff_ordermap_with_vars(proc_basePath,P,BL,orderMapVar)
    
    part = strjoin(unique(string(P.part)));
    bl_part = strjoin(unique(string(BL.part)));
    fprintf(['\nRPM order map for part %d\n',part]);
    
    if height(P)==0
        warning('No rows for part(s)');
        return
    end
    
    S = merge_table_blocks({BL;P});
    
    fig_name = sprintf('Part=%s (BL=Part%d) - Order map with vars - ',part,bl_part);
    h_fig = figure(...
        'name',fig_name,...
        'WindowState','maximized');
    
    sampleRate = P.Properties.SensorSampleRate('orderMapVar');
    if isnan(sampleRate), sampleRate = check_sampling_frequency(P); end
    
     subplot(2,1,1,'Position',[0.13 0.4589 0.775 0.5411]);
     [map,order,~,time] = make_rpm_order_map(S,'accA_x',acc_sampleRate); %
     order_spec = orderspectrum(map,order,'Amplitude','rms');
    imagesc(time,order,map);
    set(gca,'ydir','normal');
    ylabel('Order');
    hold on
    S.dur = linspace(0,time(end),height(S))';
    S.dur_sec = seconds(linspace(0,time(end),height(S))');
    add_balLev_text_bar(S,order)
    add_flowRed_text_bar(S,order)
    
    subplot(2,1,2,'Position',[0.13,0.04430,0.775,0.4069]);
    add_stacked_plot(S)
    
    
    %caxis([-100,-30]);
    
    % Visualize the map of corrected for baseline
    % TODO: Go value-by-value in RPM and subtract. 
    if height(BL)==0, return; end
    fig_name = sprintf('Spectrogram - Part=%d - BL=Part%d - 2 Energy corrected',part,baseline_part);
    h_fig2 = figure(...
        'name',fig_name,...
        'WindowState','maximized');
    
    subplot(2,1,1,'Position',[0.13 0.4589 0.775 0.5411]);
    BL.accA(1:4,1)
    [bl_map,bl_order] = make_rpm_order_map(BL,'accA_x',acc_sampleRate); %
    bl_orderspec = orderspectrum(bl_map,bl_order,'Amplitude','rms');
    try
        corr_map = map+bl_orderspec;
    catch
        return
    end
    imagesc(time,bl_order,corr_map);
    set(gca,'ydir','normal');
    ylabel('Order');
    hold on
    add_balLev_text_bar(S,order)
    add_flowRed_text_bar(S,order)
    
    subplot(2,1,2,'Position',[0.13,0.04430,0.775,0.4069]);
    add_stacked_plot(S)
    
    fig_filePath = fullfile(proc_basePath,fig_name);
    print(h_fig2,'-dpng','-r300','-opengl',fig_filePath)
    
%  figure
%     plot(order_spec)
    
function add_stacked_plot(P2)
    
    P2.accA_movRMS = P2.accA_movRMS - mean(P2.accA_movRMS,'omitnan');
    P2 = mergevars(P2,{'affP','effP'},'NewVariableName','P');
    P2 = mergevars(P2,{'affQ','effQ'},'NewVariableName','Q');
    
    plotVars = {
        %'P'
        'accA'
        'accA_movRMS'
        %'accA_norm_movRMS'
        %'Power'
        %'gyrA_norm_movRMS'
        'Q'
        };
    T = timetable2table(P2(:,plotVars));
    T = T(:,plotVars);
    T.dur_sec = P2.dur_sec;
    s = stackedplot(T,'XVariable','dur_sec',...
        'GridVisible','on',...
        'LineWidth',1.25...
        );
    xlabel('Time (sec)')
    
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
