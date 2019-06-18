function feats = make_feature_windows(signal, feats)
    
    
    initial_zoom_in_sec = 60; 
    
    event_type = 'Thrombus injection';
    
    sub1_y_varname =  'acc_length';
    sub2_y_varname = 'movrms';
    sub2_yy_varname = 'movstd';
    pivot_y_varnames = {'movrms','movstd'};
    
    sub1_ylim = [0.8,1.3];
    %sub2_ylim = [0.56, 0.7];
    %sub2_yylim = [0.75,1.5];
    
    % More specified window for the feature, to be adjusted in quality control.
    % Start with using the window to be equal to the precursor window
    feats.window_startTime = feats.precursor_startTime;
    feats.window_endTime = feats.precursor_endTime;
    
    injection_feat = feats(feats.precursor==event_type,:);
    n_inject = height(injection_feat);
    
    %h_fig = gobjects(n_iv,1);
    close all
    for i=1:n_inject
        iv_signal = signal(injection_feat.precursor_timerange{i},:);
        
        t = seconds(iv_signal.timestamp-iv_signal.timestamp(1));
        
        clf
        %h_fig(i) = figure;
        
        h_sub(1) = subplot(2,1,1);
        h_plt_y(1) = plot(t,iv_signal.(sub1_y_varname));
        h_sub(1).YLim = sub1_ylim;
        h_sub(1).XAxisLocation = 'top';
        h_sub(1).XAxis.TickDirection = 'both';
        %h_sub(1).YAxis.TickValues(1) = [];
        h_sub(1).YAxis.TickLength = [0.005,0];
        h_sub(1).XAxis.TickLength = [0.005,0];
        h_sub(1).Position(4) = h_sub(1).Position(4)*1.18;
        h_sub(1).Position(3) = 0.915625;
        h_sub(1).Position(1) = 0.043;
        h_sub(1).XGrid = 'on';
        h_sub(1).XMinorGrid = 'on';
        h_sub(1).Box = 'off';
        set(h_sub(1),'YTick',h_sub(1).YTick(2:end));
        
        
        h_sub(2) = subplot(2,1,2);
        h_plt_y(2) = plot(t,iv_signal.(sub2_y_varname),'Clipping','on');
        xtick_step = 10; %round(t(end)-t(1)/10,-2)/20;
        h_sub(2).XTick = t(1):xtick_step:t(end);
        h_sub(2).XAxis.TickLength = [0.005,0];
        h_sub(2).XAxis.TickDirection = 'both';
        h_sub(2).Position(4) = h_sub(1).Position(4)*1.18;
        h_sub(2).Position(3) = 0.915625;
        h_sub(2).Position(1) = 0.043;
        h_sub(2).XGrid = 'on';
        h_sub(2).XMinorGrid = 'on';
        h_sub(2).Box = 'off';
        
        
    
    
    
%     for j=1:numel(pivot_y_varnames)
%         var = rmmissing(iv_signal.(pivot_y_varnames{j}));
%         pivot_ind = findchangepts(var,...
%             'MaxNumChanges',1 ... 'MinThreshold',2 ...
%             );
%         if isempty(pivot_ind)
%             disp search
%             pivot_ind = search_for_abruptchange(var);
%         end
%         
%         if isempty(pivot_ind)
%             abrupt_change_time = 100;
%         else
%             abrupt_change_time = t(pivot_ind);
%         end
%         
%     end
    abrupt_change_time = 100;
    
    % Add ekstra plot line(s) with separate axis-scale on the right
    yyaxis right
    h_plt_yy(2) = plot(t,iv_signal.(sub2_yy_varname));
    h_sub_yy(2) = gca;
    h_sub_yy(2).YLim = h_sub_yy(2).YLim+0.25*abs((h_sub_yy(2).YLim(2)-h_sub_yy(2).YLim(1)));
    h_sub_yy(2).Box = 'off';
    
    
    linkaxes(h_sub,'x')
    h_sub(2).XLim(2) = t(end);
    
    % Add annotations
    legend(h_plt_y(1),strrep({sub1_y_varname},'_','\_'),...
            'Orientation','horizontal',...
            'AutoUpdate','off')
    legend([h_plt_y(2),h_plt_yy(2)],strrep({sub2_y_varname,sub2_yy_varname},'_','\_'),...
        'Orientation','horizontal',...
        'AutoUpdate','off')        
    disp_t = datestr(injection_feat.timestamp(i),'HH:mm:ss');
    vol = injection_feat.thrombusVolume(i);
    suptitle(sprintf('%s %d/%d (starting %s) - %s ml',...
        event_type,i,n_inject,disp_t,vol))
    h_xlab = xlabel(h_sub(2),'Time (sec)');
    %h_xlab_position = h_xlab.Position
    
    % Add zoom functionality
    yyaxis left
    h_zoom = scrollplot(h_sub(2),...
        'WindowSizeX',initial_zoom_in_sec,...
        'MinX',abrupt_change_time-0.5*initial_zoom_in_sec);
    h_zoom_leg = legend(h_zoom,sub2_y_varname,...
        'EdgeColor','none',...
        'Color','none',...
        'Location','eastoutside');
    
    h_zoom_leg.Title.String = 'Zoom tool data';
    h_zoom.XTick = h_sub(2).XTick;
    h_zoom.XLim = [t(1),t(end)];
    h_zoom_plt = findall(h_zoom,'Tag','scrollDataLine');
    h_zoom_plt.Color = [.67 .79 .87];   
    h_zoom_hlp = findall(h_zoom,'Tag','scrollHelp');
    h_zoom_hlp.Color = [.5 .5 .5];
    h_zoom.Position(1) = 0.2;
    h_zoom.Position(2) = h_zoom.Position(2)-0.05;
    h_zoom.Position(3) = 0.6;
    h_xlab.Position = [0.5,-0.125,0];
    
    %         [ampl, phase] = make_fft_plots(iv_signal, qc_varname);
    
    % TODO: add text info for volume and rpm
    % TODO: make window/plots before abrupt change
    % TODO: Find harmonic max values (also before and after abrupt change)
    
        cursor_color = [0.9 0.1 0.9];
        h_cur1 = cursorbar(h_sub(1),...
            'Location',abrupt_change_time,...
            'CursorLineWidth',1,...
            'BottomMarker','+',...
            'TopMarker','.',...
            'CursorLineColor',cursor_color);
        h_cur2 = cursorbar(h_sub_yy(2),...
            'Location',abrupt_change_time,...
            'CursorLineWidth',1,...
            'BottomMarker','+',...
            'TopMarker','.',...
            'CursorLineColor',cursor_color);
        h_curzoom = cursorbar(h_zoom,...
            'Location',abrupt_change_time,...
            'CursorLineWidth',1,...
            'BottomMarker','+',...
            'TopMarker','.',...
            'CursorLineColor',cursor_color);
        
        h_curlab=text(h_cur1.TopHandle.XData,0.98*h_cur1.TopHandle.YData,'Precursor start',...
            'FontWeight','bold','FontSize',9.5,'HorizontalAlignment','left');
        
        % When moving cursor on panel 1, other corresponding cursor positions
        addlistener ( h_cur1,'Location','PostSet', ...
            @(~,~)set([h_cur2,h_curzoom],'Location',h_cur1.Location) );
        
        % When moving cursor on panel 2, other corresponding cursor positions
        addlistener ( h_cur2,'Location','PostSet', ...
             @(~,~)set([h_cur1,h_curzoom],'Location',h_cur2.Location) );
        
        % When moving cursor on zoom panel, other corresponding cursor positions
        addlistener ( h_curzoom,'Location','PostSet', ...
             @(~,~)set([h_cur1,h_cur2],'Location',h_curzoom.Location) );
                  
         cursorbar_update_fun = @(~,~)move_cursorbar_callback(...
             h_cur1, h_curlab, cursor_pos, 'Abrupt change detection', h_sub);
         addlistener(h_cur2,'UpdateCursorBar', cursorbar_update_fun);
         addlistener(h_cur1,'UpdateCursorBar', cursorbar_update_fun);
        
    break
    pause
    
end

end

function pivot_ind = search_for_abruptchange(var, recur_no)
    
    if nargin<2, recur_no = 0; end
    %recur_no
    if recur_no > 2
        pivot_ind = [];
        return
    end
    
    mid_ind = floor(numel(var)/2);
    
    % Check first the first half
    pivot_ind = findchangepts(var(1:mid_ind,:),'MaxNumChanges',1);
    
    % Check the second half if not success with the first half
    if isempty(pivot_ind)
        pivot_ind = findchangepts(var(mid_ind:end,:),'MaxNumChanges',1);
        if not(isempty(pivot_ind))
            pivot_ind = mid_ind+pivot_ind;
        end
        
    end
    
    if isempty(pivot_ind)
        %disp('trying_again - first half')
        pivot_ind = search_for_abruptchange(var(1:mid_ind,:), recur_no+1);
    end
    if isempty(pivot_ind)
        %disp('trying_again - second half')
        pivot_ind = search_for_abruptchange(var(mid_ind:end,:), recur_no+1);
    end
    
end

function plot_old_flags(h_ax,flag_time,flag_label,color)
    for k=1:numel(flag_time)
        xline(h_ax,flag_time(k),...
            'LineStyle','--',...
            'LineWidth',0.75,...
            'Label',flag_label,...
            'DisplayName','Original fl',...
            'LabelHorizontalAlignment','left',...
            ...'FontWeight','bold',...
            'Color',color...
            );
    end
    
end

function move_cursorbar_callback(h_cur, h_curlab, cur_time, line_id, h_ax)
    
    persistent plotted_lines
    
    % Move cursor label 
    h_curlab.Position(1) = h_cur.TopHandle.XData;
    
    % Plot original line (as before moving)
    if isempty(plotted_lines) || strcmp(plotted_lines(end),line_id)
        
        color = [.5 .5 .5];
        plot_old_flags(h_ax(1), cur_time, line_id, color)
        plot_old_flags(h_ax(2), cur_time, '', color)
        
        plotted_lines(end+1) = line_id;
        
    end
    
end

    

