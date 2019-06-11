function feats = make_feature_windows(signal, feats)
    
    % More specified window for the feature, to be adjusted in quality control.
    % Start with using the window to be equal to the precursor window
    feats.window_startTime = feats.precursor_startTime;
    feats.window_endTime = feats.precursor_endTime;
    
    event_type = 'Thrombus injection';
    
    sub1_y_varname =  'acc_length';
    sub2_y_varname = 'movrms';
    sub2_yy_varname = 'movstd';
    pivot_y_varnames = {'movrms','movstd'};
    
    sub1_ylim = [0.8,1.3];
    %sub2_ylim = [0.56, 0.7];
    %sub2_yylim = [0.75,1.5];
    
    injection_feat = feats(feats.precursor==event_type,:);
    n_inject = height(injection_feat);
    
    %h_fig = gobjects(n_iv,1);
    close all
    for i=1:n_inject
        iv_signal = signal(injection_feat.timerange{i},:);
        
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
        legend(h_plt_y(1),{sub1_y_varname},'Orientation','horizontal')
        
        
        h_sub(2) = subplot(2,1,2);
        h_plt_y(2) = plot(t,iv_signal.(sub2_y_varname),'Clipping','on');
        %h_sub(2).YLim = sub2_ylim;
        %         h_ax = gca;
        %         set(h_ax,'YTick',h_ax.YTick(1:end-1));
        %h_sub(2).YAxis.TickLength = [0.005,0];
        h_sub(2).XAxis.TickLength = [0.005,0];
        h_sub(2).XAxis.TickDirection = 'both';
        h_sub(2).Position(4) = h_sub(1).Position(4)*1.18;
        h_sub(2).Position(3) = 0.915625;
        h_sub(2).Position(1) = 0.043;
        h_sub(2).XGrid = 'on';
        h_sub(2).XMinorGrid = 'on';
        h_sub(2).Box = 'off';
        
        h_cur=CreateCursor(gcf);
        
        for j=1:numel(pivot_y_varnames)
            var = rmmissing(iv_signal.(pivot_y_varnames{j}));
            pivot_ind = findchangepts(var,...
                'MaxNumChanges',1 ... 'MinThreshold',2 ...
                )
            if isempty(pivot_ind)
                disp search
                pivot_ind = search_for_abruptchange(var)
            end
            
            if not(isempty(pivot_ind))
                SetCursorLocation(h_cur, t(pivot_ind));
                %vertical_guideline(h_sub)
                break
            end
            
        end
        
        h_zoomscr = scrollplot;
        h_zoomscr.Position(2) = h_zoomscr.Position(2)-0.005;
        
        yyaxis right
        h_plt_yy(2) = plot(t,iv_signal.(sub2_yy_varname));
        h_sub_yy(2) = gca;
        %h_sub_yy(2).YLim = h_sub_yy.YLim+0.01;
        %h_sub_yy(2).TickLength = [0.005,0];
        h_sub_yy(2).Box = 'off';
        
        legend([h_plt_y(2),h_plt_yy(2)],{sub2_y_varname,sub2_yy_varname},...
            'Orientation','horizontal')
        
        linkaxes(h_sub,'x')
        h_sub(2).XLim(2) = max(t);
        
        disp_t = datestr(injection_feat.timestamp(i),'HH:mm:ss');
        vol = injection_feat.thrombusVolume(i);
        suptitle(sprintf('%s %d/%d (starting %s) - %s ml',...
            event_type,i,n_inject,disp_t,vol))
        xlabel(h_sub(2),'Time (sec)')
        
        
        
        %             % Plot lines where the abrupt changes are found
        %             for k=1:numel(pivot_ind)
        %                 pivot_time = plot_time(pivot_ind(k));
        %                 drawline('Position',[pivot_time,0;pivot_time,2],...
        %                     'Color',[0.6350, 0.0780, 0.1840],...
        %                     'Label','Abrupt change',...
        %                     'LineWidth',1.5...
        %                     );
        %             end
        
        %end
        
        
        
        
        
        %         subplot(2,1,1)
        %
        %
        %         [ampl, phase] = make_fft_plots(iv_signal, qc_varname);
        
        % TODO: add text info for volume and rpm
        % TODO: make window/plots before abrupt change
        % TODO: Find harmonic max values (also before and after abrupt change)
        
        
        %break
        pause
        
    end
    
end

function pivot_ind = search_for_abruptchange(var, recur_no)
    
    if nargin<2, recur_no = 0; end
    recur_no
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
        disp('trying_again - first half')
        pivot_ind = search_for_abruptchange(var(1:mid_ind,:), recur_no+1);
    end
    if isempty(pivot_ind)
        disp('trying_again - second half')
        pivot_ind = search_for_abruptchange(var(mid_ind:end,:), recur_no+1);
    end
    
end
