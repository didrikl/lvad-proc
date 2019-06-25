function feats = make_feature_windows(signal, feats)
    
    
    initial_zoom = 90;
    lead_expansion = 30;
    trail_expansion = 30;
    
    event_type = 'Thrombus injection';
    
    sub1_y_varname =  'acc_length';
    sub2_y_varname = 'movrms';
    sub2_yy_varname = 'movstd';
    pivot_y_varnames = {'movstd','movrms'};
    
    sub1_ylim = [0.8,1.2];
    
    % More specified window for the feature, to be adjusted in quality control.
    % Start with using the window to be equal to the precursor window
    feats.lead_window_startTime = feats.precursor_startTime-seconds(lead_expansion);
    feats.lead_window_endTime = feats.precursor_startTime;
    feats.trail_window_startTime = feats.precursor_startTime;
    feats.trail_window_endTime = feats.precursor_endTime+seconds(trail_expansion);
    
    injection_feat = feats(feats.precursor==event_type,:);
    n_inject = height(injection_feat);
    
    %h_fig = gobjects(n_iv,1);
    close all
    for i=1:n_inject
        
        tr = timerange(feats.lead_window_startTime(i),feats.trail_window_endTime(i));
        iv_signal = signal(tr,:);
        t = seconds(iv_signal.timestamp-iv_signal.timestamp(1));
        
        clf
        %h_fig(i) = figure;
        
        % NOTE: 
        % * User MaxNumChanges=2 and take the first of these
        % * Check for all pivot_y_varnames (instead of binary search?)
        %   - Useful to check performance associated with the variable
        %   - Take the fist of these to window split marker
        % * Check if the detection goes outside the feature window
        % * Implement a check that the trail_window does not go into next
        %   intervention, or let the window go all the way to the next
        %   intervention.
        % * Store automatic detection findings
        % * Store the manual quality control detection
        % * Add marker lines with timestamps in notes and automatic detection,
        %   in addition to the cursorbar lines.
        for j=1:numel(pivot_y_varnames)
            varname = pivot_y_varnames{j};
            var = rmmissing(iv_signal.(varname));
            pivot_ind = findchangepts(var,...
                'MaxNumChanges',1 ... 'MinThreshold',2 ...
                );
            if isempty(pivot_ind)
                pivot_ind = refined_search_for_abruptchange(var);
            end
            
            if isempty(pivot_ind)
                abrupt_change_time = t(1)+0.5*t(end);
            else
                abrupt_change_time = t(pivot_ind);
            end
            
            if pivot_ind
                fprintf('\nAbrupt change detected\n\tVariable: %s\n\tTime: %s\n',...
                    varname,num2str(abrupt_change_time))
                %break
            end
            
        end

        
        % Upper panel
        h_sub(1) = subplot(2,1,1);
        h_plt_y(1) = plot(t,iv_signal.(sub1_y_varname));
        common_adjust_panel(h_sub(1),t)
        h_sub(1).Position(4) = h_sub(1).Position(4)*1.18;
        h_sub(1).YLim = sub1_ylim;
        h_sub(1).XAxisLocation = 'top';
        set(h_sub(1),'YTick',h_sub(1).YTick(2:end));
        
        % Lower panel (axis to the left)
        h_sub(2) = subplot(2,1,2);
        h_plt_y(2) = plot(t,iv_signal.(sub2_y_varname),'Clipping','on');
        common_adjust_panel(h_sub(2),t)
        h_sub(2).Position(4) = h_sub(1).Position(4)*1.18;
        
        % Lower panel: Add ekstra plot with separate axis-scale on the right
        yyaxis right
        h_plt_yy(2) = plot(t,iv_signal.(sub2_yy_varname));
        h_sub_yy(2) = gca;
        h_sub_yy(2).YLim = h_sub_yy(2).YLim+0.15*abs((h_sub_yy(2).YLim(2)-h_sub_yy(2).YLim(1)));
        h_sub_yy(2).YLim(1) = min(h_sub_yy(2).YLim(1),min(iv_signal.(sub2_yy_varname)));
        h_sub_yy(2).Box = 'off';
        
        linkaxes(h_sub,'x')
        
        
        
        
        % Add graph annotations
        legend(h_plt_y(1),strrep({sub1_y_varname},'_','\_'),...
            'Orientation','horizontal',...
            'AutoUpdate','off')
        legend([h_plt_y(2),h_plt_yy(2)],strrep({sub2_y_varname,sub2_yy_varname},'_','\_'),...
            'Orientation','horizontal',...
            'AutoUpdate','off')
        disp_t = datestr(injection_feat.timestamp(i),'HH:mm:ss');
        vol = injection_feat.thrombusVolume(i);
        rpm = string(injection_feat.pumpSpeed(i));
        suptitle(sprintf('%s %d/%d (starting %s) - %s ml - %s RPM',...
            event_type,i,n_inject,disp_t,vol,rpm))
        
        % Add zoom functionality, using data from left axis on lower panel
        yyaxis left
        h_zoom = scrollplot(h_sub(2),...
            'WindowSizeX',initial_zoom,...
            'MinX',abrupt_change_time-0.5*initial_zoom);
        adjust_zoom_panel(h_zoom,h_sub(2),sub2_y_varname)
        
        xlabel(h_sub(2),'Time (sec)','Position',[0.5,-0.125,0]);
        
        %         [ampl, phase] = make_fft_plots(iv_signal, qc_varname);
        
        % TODO: make window/plots before abrupt change
        % TODO: Find harmonic max values (also before and after abrupt change)
        
        clear plotted_lines
        cursors.abrupt_change = add_precursor_cursorbars(h_sub, h_zoom, abrupt_change_time);
        cursors.cutoff = add_cutoff_cursorbars(h_sub, h_zoom, t(1)+lead_expansion, t(end)-trail_expansion);
    
        %break
        pause
        
        cursors.abrupt_change.panel_1.Position(1)
        
        
    end
    
end

function pivot_ind = refined_search_for_abruptchange(var, recur_no)
    
    % Recur is used for keeping track of number of refinements, for which the 
    % function is called recursively
    if nargin<2
        recur_no = 0; 
    end
    
    % Give up if no detection after 2 refinements
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

    % If no success, try again recursively (a new search with refining into 
    % 1st half, followed by 2nd half if no finding in first half)
    if isempty(pivot_ind)
        pivot_ind = refined_search_for_abruptchange(var(1:mid_ind,:), recur_no+1);
    end
    if isempty(pivot_ind)
        pivot_ind = refined_search_for_abruptchange(var(mid_ind:end,:), recur_no+1);
    end
    
end

function plot_init_pos(h_ax,flag_time,label,color)
    for k=1:numel(flag_time)
        xline(h_ax,flag_time(k),...
            'LineStyle',':',...
            'LineWidth',1.1,...
            'Label',label,...
            ...'DisplayName','',...
            'LabelHorizontalAlignment','left',...
            'LabelVerticalAlignment','bottom',...
            'FontSize', 7,...
            'FontWeight','bold',...
            'Color',color...
            );
    end
    
end

function common_adjust_panel(ax,t)
    
    ax.XAxis.TickDirection = 'both';
    ax.YAxis.TickLength = [0.005,0];
    
    % Stretch in y-dir
    %ax.Position(4) = ax.Position(4)*1.18;
    
    xtick_step = 10; %round(t(end)-t(1)/10,-2)/20;
    ax.XTick = t(1):xtick_step:t(end);
    ax.XLim(2) = t(end);
    
    % Fix startm in x-position
    ax.Position(1) = 0.043;
    
    % Fix widthm in x-direction
    ax.Position(3) = 0.915625;
    
    ax.XGrid = 'on';
    ax.XMinorGrid = 'on';
    ax.Box = 'off';
    
end

function adjust_zoom_panel(h_zoom,h_sub2,sub2_y_varname)
    
    h_zoom_leg = legend(h_zoom,sub2_y_varname,...
        'AutoUpdate','off',...
        'EdgeColor','none',...
        'Color','none',...
        'Location','eastoutside');
    h_zoom_leg.Title.String = 'Zoom tool data';
    
    h_zoom.XTick = h_sub2.XTick;
    
    h_zoom_plt = findall(h_zoom,'Tag','scrollDataLine');
    h_zoom_plt.Color = [.67 .79 .87];
    h_zoom_hlp = findall(h_zoom,'Tag','scrollHelp');
    h_zoom_hlp.Color = [.5 .5 .5];
    h_zoom.Position(1) = 0.2;
    h_zoom.Position(2) = h_zoom.Position(2)-0.05;
    h_zoom.Position(3) = 0.6;
    
end

function cursors = add_precursor_cursorbars(h_sub, h_zoom, abrupt_change_time)
    
    color = [0.9 0.1 0.9];
    width = 2;
    label = ' Abrupt signal change ';
    
    [h_cur1,h_cur2,h_curzoom,h_curlab] = add_panel_linked_cursors(...
        h_sub,h_zoom,abrupt_change_time,label,width,color);
        
    callback_fun = @(~,~)move_from_init_pos_callback(...
        h_cur1, h_curlab, abrupt_change_time, label, h_sub, h_zoom);
    addlistener(h_cur2,'UpdateCursorBar', callback_fun);
    addlistener(h_cur1,'UpdateCursorBar', callback_fun);
    addlistener(h_curzoom,'UpdateCursorBar', callback_fun);
    
    % Save handles to struct container of cursor handles (can be object-oriented)
    cursors.panel_1 = h_cur1;
    cursors.panel_1= h_curlab;
    cursors.panel_2= h_cur2;
    cursors.panel_zoom = h_curzoom;
    
end

function cursors = add_cutoff_cursorbars(h_sub, h_zoom,win_start,win_end)
    % NOTE: Object orientation is perhaps better structure of this code, which
    % may then be included in the add_panel_linked_cursor function
    
    color = [0.3 0.3 0.3];
    width = 2;
    left_label = 'window start  ';
    end_label = '  window end';
    
    [h_cur1,h_cur2,h_curzoom,h_curlab] = add_panel_linked_cursors(h_sub,h_zoom,...
        win_start,left_label,width,color);
    
    addlistener([h_cur1,h_cur2,h_curzoom],...
        'UpdateCursorBar',@(~,~)left_cutoff_callback(h_cur1,h_curlab,h_sub,h_zoom));
    
    cursors.left_cutoff.panel_1 = h_cur1;
    cursors.left_cutoff.panel_1= h_curlab;
    cursors.left_cutoff.panel_2= h_cur2;
    cursors.left_cutoff.panel_zoom = h_curzoom;
    
    [h_cur1,h_cur2,h_curzoom,h_curlab] = add_panel_linked_cursors(h_sub,h_zoom,...
        win_end,end_label,width,color);
    h_curlab.HorizontalAlignment = 'left';

    addlistener([h_cur1,h_cur2,h_curzoom],...
        'UpdateCursorBar',@(~,~)right_cutoff_callback(h_cur1,h_curlab,h_sub,h_zoom));
    
    cursors.right_cutoff.panel_1 = h_cur1;
    cursors.right_cutoff.panel_1= h_curlab;
    cursors.right_cutoff.panel_2= h_cur2;
    cursors.right_cutoff.panel_zoom = h_curzoom;

    
end

function [h_cur1,h_cur2,h_curzoom,h_curlab] = add_panel_linked_cursors(...
        h_sub,h_zoom,pos,label,width,color)
    
    h_cur1 = cursorbar(h_sub(1),...
        'Location',pos,...
        'CursorLineWidth',width,...
        'BottomMarker','+',...
        'TopMarker','.',...
        'CursorLineColor',color);
    
    % hack/fix in case multiple y axis are in use
    if size(h_sub(2).YAxis,1)>1
        yyaxis(h_sub(2),'right')
    end
    h_cur2 = cursorbar(gca,...
        'Location',pos,...
        'CursorLineWidth',width,...
        'BottomMarker','+',...
        'TopMarker','.',...
        'CursorLineColor',color);
    
    h_curzoom = cursorbar(h_zoom,...
        'Location',pos,...
        'CursorLineWidth',width,...
        'BottomMarker','.',...
        'TopMarker','.',...
        'CursorLineColor',color);
    
    lab_ypos = h_cur1.TopHandle.YData-0.1*abs(...
        h_cur1.TopHandle.YData-h_cur1.BottomHandle.YData);
    h_curlab=text(h_sub(1),pos,lab_ypos,[label,' '],...
        'FontWeight','bold','FontSize',8.5,'HorizontalAlignment','right');
    
    % When moving cursor on panel 1, other corresponding cursor positions
    addlistener ( h_cur1,'Location','PostSet', ...
        @(~,~)set([h_cur2,h_curzoom],'Location',h_cur1.Location) );
    
    % When moving cursor on panel 2, other corresponding cursor positions
    addlistener ( h_cur2,'Location','PostSet', ...
        @(~,~)set([h_cur1,h_curzoom],'Location',h_cur2.Location) );
    
    % When moving cursor on zoom panel, other corresponding cursor positions
    addlistener ( h_curzoom,'Location','PostSet', ...
        @(~,~)set([h_cur1,h_cur2],'Location',h_curzoom.Location) );
    
end


% Callback functions
% ------------------

function right_cutoff_callback(h_cur,h_curlab,h_sub,h_zoom)

    persistent h_right_shade_sub1
    persistent h_right_shade_sub2
    persistent h_right_shade_zoom
    
    delete([h_right_shade_sub1,h_right_shade_sub2,h_right_shade_zoom])
    
    % Move cursor label
    h_curlab.Position(1) = h_cur.TopHandle.XData;
    
    h_plot_line = findobj(h_sub(1),'Type','line');
    shade_xmax = h_plot_line.XData(end);
    shade_xmin = h_cur.TopHandle.XData(1)+0.4;
   
    h_right_shade_sub1 = patch(h_sub(1),...
        [repmat( shade_xmin,1,2) repmat( shade_xmax,1,2)], ...
        [h_sub(1).YLim fliplr(h_sub(1).YLim)], [0 0 0 0], [.5 .5 .5],...
        'FaceAlpha',0.2,...
        'EdgeColor','None');
    h_right_shade_sub2 = patch(h_sub(2),...
        [repmat( shade_xmin,1,2) repmat( shade_xmax,1,2)], ...
        [h_sub(2).YLim fliplr(h_sub(2).YLim)], [0 0 0 0], [.5 .5 .5],...
        'FaceAlpha',0.2,...
        'EdgeColor','None');
    h_right_shade_zoom = patch(h_zoom,...
        [repmat( shade_xmin,1,2) repmat( shade_xmax,1,2)], ...
        [h_zoom.YLim fliplr(h_zoom.YLim)], [0 0 0 0], [.5 .5 .5],...
        'FaceAlpha',0.2,...
        'EdgeColor','None');
    
end

function left_cutoff_callback(h_cur,h_curlab,h_sub,h_zoom)

    persistent h_left_shade_sub1
    persistent h_left_shade_sub2
    persistent h_left_shade_zoom
    
    delete(h_left_shade_sub1)
    delete(h_left_shade_sub2)
    delete(h_left_shade_zoom)
    
    % Move cursor label
    h_curlab.Position(1) = h_cur.TopHandle.XData;
    
    h_plot_line = findobj(h_sub(1),'Type','line');
    shade_xmin = h_plot_line.XData(1);
    shade_xmax = h_cur.TopHandle.XData(1)-0.4;
   
    h_left_shade_sub1 = patch(h_sub(1),...
        [repmat( shade_xmin,1,2) repmat( shade_xmax,1,2)], ...
        [h_sub(1).YLim fliplr(h_sub(1).YLim)], [0 0 0 0], [.5 .5 .5],...
        'FaceAlpha',0.2,...
        'EdgeColor','None');
     
    h_left_shade_sub2 = patch(h_sub(2),...
        [repmat( shade_xmin,1,2) repmat( shade_xmax,1,2)], ...
        [h_sub(2).YLim fliplr(h_sub(2).YLim)], [0 0 0 0], [.5 .5 .5],...
        'FaceAlpha',0.2,...
        'EdgeColor','None');
     
    h_left_shade_zoom = patch(h_zoom,...
        [repmat( shade_xmin,1,2) repmat( shade_xmax,1,2)], ...
        [h_zoom.YLim fliplr(h_zoom.YLim)], [0 0 0 0], [.5 .5 .5],...
        'FaceAlpha',0.2,...
        'EdgeColor','None');
    
end

function move_from_init_pos_callback(h_cur, h_curlab, pos, line_id, h_sub, h_zoom)
    
    persistent plotted_lines
    
    % Move cursor label
    h_curlab.Position(1) = h_cur.TopHandle.XData;
    
    % Plot original line (as before moving)
    if isempty(plotted_lines) || not(strcmp(plotted_lines{end},line_id))
        
        color = h_cur.CursorLineColor;%[.5 .5 .5];
        plot_init_pos(h_sub(1), pos, '', color)
        plot_init_pos(h_sub(2), pos, '', color)
        plot_init_pos(h_zoom, pos, '', color)
        
        plotted_lines{end+1} = line_id;
        
    end
    
end