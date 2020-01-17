function feats = make_feature_windows(signal, feats, plot_vars)
    % make_feature_windows
    %   Quality control mainly used to check when thrombus enters LVAD (not to
    %   analyse features or to find features).
    
    % Definitios to allow user to search though more data
    lead_expansion = 30;
    trail_expansion = 30;
    
    % Event type for window quality control (qc)
    qc_event_type = {'Thrombus injection'};
    
    sub1_y_var = {'accNorm_lvad_signal','accNorm_lead_signal'};
    sub1_yy_var = {};
    
    sub2_y_var = {'accNorm_movRMS_lvad_signal','accNorm_movRMS_lead_signal'};
    sub2_yy_var = {};
    %sub2_yy_var = {'acc_movStdNorm_lvad_signal','acc_movStdNorm_lead_signal'};
    
    search_var = {'accNorm_movStd_lvad_signal','accNorm_movRMS_lvad_signal'};
    
    % TODO: Check if variable names exist...
    
    % More specified window for the feature, to be adjusted in quality control.
    % Start with using the window to be equal to the precursor window
    feats.leadWinStart = feats.precursor_startTime-seconds(lead_expansion);
    feats.leadTrailSplit = feats.precursor_startTime;
    feats.trailWinEnd = feats.precursor_endTime+seconds(trail_expansion); 
    feats.leadWin_timerange = cell(height(feats),1);
    feats.trailWin_timerange = cell(height(feats),1);
    
    % Clip trail window if it goes into the next intervention window
    feats.trailWinEnd(1:end-1) = min(feats.trailWinEnd(1:end-1),feats.precursor_startTime(2:end));
       
    %h_fig = gobjects(n_iv,1);
    close all
    qc_feat_inds = find(contains(string(feats.precursor),qc_event_type));
    n_qc_feats = numel(qc_feat_inds);
    for i=1:n_qc_feats
        
        % Look up in feature table to find which data to plot
        feat_ind = qc_feat_inds(i);
        qc_event_feat = feats(feat_ind,:);
        
        plot_range = timerange(qc_event_feat.leadTrailSplit,qc_event_feat.trailWinEnd);
        plot_data = signal(plot_range,:);
        search_range = timerange(feats.precursor_startTime(feat_ind),feats.precursor_endTime(feat_ind));
        t = seconds(plot_data.time-plot_data.time(1));%feats.precursor_startTime(1))
        t = t-lead_expansion;
        
        h_fig = figure('Position',[35.4,69,1226.4,679.2]); %clf
        
        % NOTE: 
        % * Let the window go all the way to the next intervention?
        % * Store automatic detection findings
        
        abrupt_change_time = find_abrupt_change(t,signal(search_range,:),search_var);
        
        % Handling of no automatic detection.
        if all(isnan(abrupt_change_time))
            fprintf('\nNo change detections made. Window split is set at midtime')
            win_split_time = mid_time;
        else
            win_split_time = min(abrupt_change_time);
        end
        
        % TODO: FACTORIZE THE FOLLWING TO SEPARATE FUNCTION FILE
        %*******************************************************
        % Make plots
        if not(iscell(sub1_y_var)), sub1_y_var = {sub1_y_var}; end
        if not(iscell(sub1_yy_var)), sub1_yy_var = {sub1_yy_var}; end
        if not(iscell(sub2_y_var)), sub2_y_var = {sub2_y_var}; end
        if not(iscell(sub2_yy_var)), sub2_yy_var = {sub2_yy_var}; end
        
        h_sub(1) = plot_in_upper_panel(t,plot_data,sub1_y_var);
        h_sub(2) = plot_in_lower_panel(t,plot_data,sub2_y_var,sub2_yy_var);        
        
        % Add title
        make_annotations(h_sub, qc_event_feat, i, n_qc_feats);
        
        % Axis relation control
        h_sub(2).Position(4) = h_sub(1).Position(4)*1.18;
        linkaxes(h_sub,'x')
        h_zoom = make_zoom_panel(h_sub(2),win_split_time,sub2_y_var);
        %*********************************************************
        
        % Add dragable cursorbars, that defines lead and trail windows
        cursors_handles.split = add_window_split_cursorbar(h_sub, h_zoom, win_split_time);
        cursors_handles.cutoff = add_cutoff_cursorbars(h_sub, h_zoom, ...
            -lead_expansion, t(end)-trail_expansion);
    
        % Pause to allow for cursorbar adjustments by user
        pause
        
        % Store quality controlled window definitions
        split_ind = find(t>=cursors_handles.split.panel_1.TopHandle.XData,1,'first');
        start_ind = find(t>cursors_handles.cutoff.left_cutoff.panel_1.TopHandle.XData,1,'first');
        end_ind = find(t>=cursors_handles.cutoff.right_cutoff.panel_1.TopHandle.XData,1,'first');
        feats.leadWinStart(feat_ind) = plot_data.time(start_ind);
        feats.leadTrailSplit(feat_ind) = plot_data.time(split_ind);
        feats.trailWinEnd(feat_ind) = plot_data.time(end_ind);
        
        feats.leadWin_timerange{feat_ind} = timerange(feats.leadWinStart(feat_ind),feats.leadTrailSplit(feat_ind));
        feats.trailWin_timerange{feat_ind} = timerange(feats.leadTrailSplit(feat_ind),feats.trailWinEnd(feat_ind));

        close(h_fig)
    end
    
end


% Functions to populate panels with plots
% ---------------------------------------

function h_sub = plot_in_upper_panel(t,iv_signal,sub1_y_varname)
    
    overlay_color_alpha = 0.4;
    sub1_ylim = [0.8,1.2];
    
    h_sub = subplot(2,1,1);
    
    hold on
    for i=1:numel(sub1_y_varname)
        h_plt = plot(t,iv_signal.(sub1_y_varname{i}));
        if i>1
            h_plt.Color(4) = overlay_color_alpha;
        end
    end
    
    common_adjust_panel(h_sub(1),t)
    h_sub(1).Position(4) = h_sub(1).Position(4)*1.18;
    h_sub(1).YLim = sub1_ylim;
    h_sub(1).XAxisLocation = 'top';
    set(h_sub(1),'YTick',h_sub(1).YTick(2:end));        
    
    if numel(sub1_y_varname)>1
    
    end
    
    legend(gca,{'Housing','Driveline'},...
            ...'Orientation','horizontal',...
            'AutoUpdate','off')       
%         legend(gca,strrep(sub1_y_varname,'_','\_'),...
%             ...'Orientation','horizontal',...
%             'AutoUpdate','off')       
end

function h_sub2 = plot_in_lower_panel(t,iv_signal,sub2_y_varname,sub2_yy_varname)
    
    % NOTE: Plot panels could be object oriented
    
    yy_axis_shift_factor = 0.20;
    
    % Plot lines with y-axis to the left
    h_sub2 = subplot(2,1,2);
%    h_sub2.ColorOrderIndex = 3;
    
    hold on
    for i=1:numel(sub2_y_varname)
        h_plt_y(i) = plot(t,iv_signal.(sub2_y_varname{i}),'Clipping','on');
    end
    
    common_adjust_panel(h_sub2,t)
    
    % Lower panel: Add ekstra plot with separate axis-scale on the right
    if numel(sub2_yy_varname)>0
        yyaxis right
        h_sub2_yy = gca;
        hold on
        for i=1:numel(sub2_yy_varname)
            h_plt_y(end+1) = plot(t,iv_signal.(sub2_yy_varname{i}));
            %         if i>1
            %             h_plt_yy.Color(4) = overlay_color_alpha;
            %         end
        end
        
        
        h_sub2_yy.YLim = h_sub2_yy.YLim+yy_axis_shift_factor*abs((h_sub2_yy.YLim(2)-h_sub2_yy.YLim(1)));
        h_sub2_yy.YLim(1) = min(h_sub2_yy.YLim(1),min(iv_signal.(sub2_yy_varname{1})));
        h_sub2_yy.Box = 'off';
    end
    
    
    legend(h_plt_y,strrep([sub2_y_varname,sub2_yy_varname],'_','\_'),...
            ...'Orientation','horizontal',...
            'AutoUpdate','off')       
end

function make_annotations(h_sub, qc_event_feat, qc_event_no, n_qc_events)
    % Adding time label/annotation after zoom tool (which would reposition it)
    xlabel('Time (sec)','Position',[0.5,-0.11,0]);
    
    event_type = string(qc_event_feat.precursor);
    vol = qc_event_feat.thrombusVolume;
    rpm = string(qc_event_feat.pumpSpeed);
    
    h_tit = suptitle(sprintf('Signal for %s %d of %d: %s ml Thrombus at %s RPM',...
        event_type,qc_event_no,n_qc_events,vol,rpm));
    h_tit.FontWeight = 'bold';
    h_tit.FontSize = 16;
    
    % Add extra info about the time axis, for user to look up info in notes
    text_arr = {
        '\bfTime = 0\rm'
        datestr(qc_event_feat.precursor_startTime)
        "Intervention start in notes"%+event_type
        };
    text(gca,-0.005,-0.19,text_arr,...
        'Units','normalized',...
        'FontSize',9);
        
    % Adding an extra invisible axes that spans over the subplots, and will
    % therefore have a superlabel for the y-axis. NB: add this after the text
    % box with info, otherwise would the text box be invisible.
    p1=get(h_sub(1),'position');
    p2=get(h_sub(2),'position');
    height=p1(2)+p1(4)-p2(2);
    axes('position',[p2(1)-0.008*p2(3) p2(2) p2(3) height],'visible','off');
    ylabel('Acceleration (g)','visible','on');
    
    
    
end 

function common_adjust_panel(ax,t)
    
    ax.XAxis.TickDirection = 'both';
    ax.XAxis.TickLength = [0.003,0];
    ax.YAxis.TickLength = [0.005,0];
    ax.XGrid = 'on';
    ax.XMinorGrid = 'on';
    ax.Box = 'off';
    ax.FontSize = 11.5;

    % Stretch in y-dir
    %ax.Position(4) = ax.Position(4)*1.18;
    
    xtick_step = 10; %round(t(end)-t(1)/10,-2)/20;
    ax.XTick = t(1):xtick_step:t(end);
    ax.XLim(2) = t(end);
    
    % Fix start and width in x-position
    ax.Position(1) = 0.043;
    ax.Position(3) = 0.915625;
    
end

function h_zoom = make_zoom_panel(h_sub,mid_pos,varname)
    % Add zoom functionality, using data from the given axis
    
    yyaxis_selection = 'left';
    initial_zoom = 90;    
    
    if size(h_sub.YAxis,1)>1
        yyaxis(h_sub,yyaxis_selection)
    end
    
    h_zoom = scrollplot(h_sub,...
        'WindowSizeX',initial_zoom,...
        'MinX',0 ...'MinX',mid_pos-0.5*initial_zoom
    );
    adjust_zoom_panel(h_zoom,h_sub,varname)

end

function adjust_zoom_panel(h_zoom,h_sub2,sub2_y_varname)
    
    h_zoom_leg = legend(h_zoom,strrep(sub2_y_varname,'_','\_'),...
        'AutoUpdate','off',...
        'EdgeColor','none',...
        'FontSize',9,...
        'Color','none',...
        'Location','eastoutside');
    h_zoom_leg.Title.String = 'Zoom variable';
    h_zoom_leg.Title.FontSize = 8;   
    h_zoom.XTick = h_sub2.XTick;
    
    % TODO: Set color equal to subplot-color?
    % h_zoom_plt = findall(h_zoom,'Tag','scrollDataLine');
    %h_zoom_plt.Color = [.67 .79 .87];
    
    h_zoom_hlp = findall(h_zoom,'Tag','scrollHelp');
    h_zoom_hlp.Color = [.5 .5 .5];
    h_zoom.Position(1) = 0.2;
    h_zoom.Position(2) = h_zoom.Position(2)-0.055;
    h_zoom.Position(3) = 0.6;    
    
end

% Functions to define feature windows
% -----------------------------------

function abrupt_change_time = find_abrupt_change(t,plot_data,pivot_y_varnames)
    
    max_no_changes = 2; % =2 take more time to run
    
    fprintf('\n\nSearching for abrupt signal changes\n');
    
    n_search_vars = numel(pivot_y_varnames);
    abrupt_change_time = nan(n_search_vars,1);
    
    for j=1:n_search_vars
        
        t0_ind = find(t==0,1,'first');
        iv_var = rmmissing(plot_data.(pivot_y_varnames{j})(t0_ind:end,:));
        pivot_ind = findchangepts(iv_var,...
            'MaxNumChanges',max_no_changes ); %'MinThreshold' );
        
        if isempty(pivot_ind)
            pivot_ind = search_refined_abrupt_changes(iv_var);
        end
        
        if not(isempty(pivot_ind))
            abrupt_change_time(j) = t(t0_ind+pivot_ind(1));
            fprintf('\nSearching in %s\n\tDetection time: %s\n',...
                pivot_y_varnames{j},num2str(abrupt_change_time(j)))
        else
            fprintf('\nSearching in %s\n\tNo detection\n',...
                pivot_y_varnames{j})
        end
        
    end
    
end

function pivot_ind = search_refined_abrupt_changes(var, recur_no)
    
    % Recur is used for keeping track of number of refinements, for which the 
    % function is called recursively
    if nargin<2
        recur_no = 0; 
    end
    
    % We are happy if we can find just one change when using this function 
    refined_max_no_changes = 1;
    
    % Give up if no detection after 2 refinements
    if recur_no > 2
        pivot_ind = [];
        return
    end
    
    mid_ind = floor(numel(var)/2);
    
    % Check first the first half
    pivot_ind = findchangepts(var(1:mid_ind,:),'MaxNumChanges',refined_max_no_changes);
    
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
        pivot_ind = search_refined_abrupt_changes(var(1:mid_ind,:), recur_no+1);
    end
    if isempty(pivot_ind)
        pivot_ind = search_refined_abrupt_changes(var(mid_ind:end,:), recur_no+1);
    end
    
end

function plot_init_pos(h_ax,flag_time,label,color)
    
    for k=1:numel(flag_time)
        xline(h_ax,flag_time(k),...
            'LineStyle',':',...
            'Alpha',0.6,...
            'LineWidth',1.4,...
            'Label',label,...
            'LabelHorizontalAlignment','left',...
            'LabelVerticalAlignment','bottom',...
            'FontSize', 7,...
            'FontWeight','bold',...
            'Color',color );
    end
    
end

function cursors = add_window_split_cursorbar(h_sub, h_zoom, pos)
    
    color = [0.00,0.94,0.00];%[0.80,0.00,0.40];%[0.67,0.15,0.31];%[0.9 0.1 0.9];
    width = 2;
    label = ' Signal change ';
    init_label = '';%' Automatic detection ';
    [h_cur1,h_cur2,h_curzoom,h_curlab] = add_panel_linked_cursors(...
        h_sub,h_zoom,pos,label,width,color);
    callback_fun = @(~,~)move_from_init_pos_callback(...
        h_cur1, h_curlab, pos, init_label, h_sub, h_zoom);
    addlistener(h_cur2,'UpdateCursorBar', callback_fun);
    addlistener(h_cur1,'UpdateCursorBar', callback_fun);
    addlistener(h_curzoom,'UpdateCursorBar', callback_fun);
    
    % Save handles to struct container of cursor handles (can be object-oriented)
    cursors.panel_1 = h_cur1;
    cursors.panel_2= h_cur2;
    cursors.panel_zoom = h_curzoom;
    
end

function cursors = add_cutoff_cursorbars(h_sub, h_zoom,win_start,win_end)
    % NOTE: Object orientation is perhaps better structure of this code, which
    % may then be included in the add_panel_linked_cursor function
    
    color = [0.3 0.3 0.3];
    width = 2;
    left_label = 'Lead win. start';
    end_label = 'Trail win. end';
    
    [h_cur1,h_cur2,h_curzoom,h_curlab] = add_panel_linked_cursors(h_sub,h_zoom,...
        win_start,left_label,width,color);
    
    addlistener([h_cur1,h_cur2,h_curzoom],...
        'UpdateCursorBar',@(~,~)left_cutoff_callback(h_cur1,h_curlab,h_sub,h_zoom));
    left_cutoff_callback(h_cur1,h_curlab,h_sub,h_zoom)
    
    cursors.left_cutoff.panel_1 = h_cur1;
    cursors.left_cutoff.panel_2= h_cur2;
    cursors.left_cutoff.panel_zoom = h_curzoom;
    
    [h_cur1,h_cur2,h_curzoom,h_curlab] = add_panel_linked_cursors(h_sub,h_zoom,...
        win_end,end_label,width,color);
    
    addlistener([h_cur1,h_cur2,h_curzoom],...
        'UpdateCursorBar',@(~,~)right_cutoff_callback(h_cur1,h_curlab,h_sub,h_zoom));
    right_cutoff_callback(h_cur1,h_curlab,h_sub,h_zoom)

    cursors.right_cutoff.panel_1 = h_cur1;
    cursors.right_cutoff.panel_2= h_cur2;
    cursors.right_cutoff.panel_zoom = h_curzoom;
    
%     callback_fun = @(~,~)move_from_init_pos_callback(...
%         h_cur1, h_curlab, win_end, 'end of win', h_sub, h_zoom);
%     addlistener(h_cur2,'UpdateCursorBar', callback_fun);
%     addlistener(h_cur1,'UpdateCursorBar', callback_fun);
%     addlistener(h_curzoom,'UpdateCursorBar', callback_fun);
    
end

function [h_cur1,h_cur2,h_curzoom,h_curlab] = add_panel_linked_cursors(...
        h_sub,h_zoom,pos,label,width,color)
    
    h_cur1 = cursorbar(h_sub(1),...
        'Location',pos,...
        'CursorLineWidth',width,...
        ...'BottomMarker','.',...
        ...'TopMarker','+',...
        'CursorLineColor',color);
    
    % hack/fix in case multiple y axis are in use
    if size(h_sub(2).YAxis,1)>1
        yyaxis(h_sub(2),'right')
    end
    h_cur2 = cursorbar(gca,...
        'Location',pos,...
        'CursorLineWidth',width,...
        'CursorLineColor',color);
   
    h_curzoom = cursorbar(h_zoom,...
        'Location',pos,...
        'CursorLineWidth',width,...
        'CursorLineColor',color);
    
    % Add a label next to the upper panel cursorbar
    lab_ypos = h_cur1.TopHandle.YData-0.1*abs(...
        h_cur1.TopHandle.YData-h_cur1.BottomHandle.YData);
    h_curlab=text(h_sub(1), pos, lab_ypos, label,...
        'FontWeight','bold',...
        'FontSize',8.5,...
        'HorizontalAlignment','center',...
        'BackgroundColor',[1 1 1]);...'right',...
     
    
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

    % Let shade handles be persistent, so so they can be delete before creating 
    % new ones (preventing a stack up of old shades)
    persistent h_right_shade_sub1
    persistent h_right_shade_sub2
    persistent h_right_shade_zoom
    delete([h_right_shade_sub1,h_right_shade_sub2,h_right_shade_zoom])
    
    % Move cursor label
    h_curlab.Position(1) = h_cur.TopHandle.XData;
    
    % NOTE: Searching for objects may be sub-optimal (less efficient and less
    % robust).
    h_plot_line = findobj(h_sub(1),'Type','line');
    if numel(h_plot_line)>1, h_plot_line = h_plot_line(1); end
    
    % Defining shade area. NB: For x axis, the shade can not overlay the
    % cursorbar due to technical difficulties with uistack, hence the addition.
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

function left_cutoff_callback(h_cur1,h_curlab,h_sub,h_zoom)
    % Very similar function to right cutoff_callback. It needs to be a separate
    % function to handles separate persistent variables.
    
    persistent h_left_shade_sub1
    persistent h_left_shade_sub2
    persistent h_left_shade_zoom
    delete([h_left_shade_sub1, h_left_shade_sub2, h_left_shade_zoom])
    
    % Move cursor label
    h_curlab.Position(1) = h_cur1.TopHandle.XData;
    
    h_plot_line = findobj(h_sub(1),'Type','line');
    if numel(h_plot_line)>1, h_plot_line = h_plot_line(1); end
    shade_xmin = h_plot_line.XData(1);
    shade_xmax = h_cur1.TopHandle.XData(1)-0.4;
   
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
        plot_init_pos(h_sub(1), pos, line_id, color)
        plot_init_pos(h_sub(2), pos, '', color)
        plot_init_pos(h_zoom, pos, '', color)
        
        plotted_lines{end+1} = line_id;
        
    end
    
end