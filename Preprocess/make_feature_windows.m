function features = make_feature_windows(signal, features)
    
    pivot_y_varname = 'movrms';
    y_varnames =  { 'acc_length','movrms' };
    yy_varnames = {
        '',          'movstd' };
    ylims = {[0.75,1.5],[0.56, 0.7]};
    yylims = {[],[0.01,0.02]};
    
    
    event_type = 'Thrombus injection';
    
    iv_wins = features.window(features.precedingEvent==event_type);
    
    n_iv = numel(iv_wins);
    n_subplots = numel(y_varnames);
    
    h_fig = gobjects(n_iv,1);
    close all
    for i=1:n_iv
        iv_signal = signal(iv_wins{i},:);
        
        t_dur = iv_signal.timestamp-iv_signal.timestamp(1);
        t_dur.Format = 'mm:ss';
        %t = t_dur;
        t = seconds(t_dur);
        
        clf
        %h_fig(n_iv) = figure;
        h_subax = gobjects(n_subplots);
        for j=1:n_subplots
            
            h_subax(j) = subplot(n_subplots,1,j);
            
            
            plot(t,iv_signal.(y_varnames{j}),'Clipping','off')
            h_subax(j).YLim = ylims{j};
                    
            if j==1
                h_subax(j).XAxisLocation = 'top';
                %h_subax(j).YAxis.TickLabels{1} = '';
                
            elseif j<n_subplots
                h_subax(j).XAxis.Visible = 'off';
                
            else
                h_subax(j).Position(4) = h_subax(j).Position(4)*1.25;
                h_zoomscr = scrollplot;
                h_zoomscr.Position(2) = h_zoomscr.Position(2)-0.005;
                
            end
            
            
            h_subax(j).XGrid = 'on';
            h_subax(j).XAxis.TickDirection = 'both';
            %h_subax(j).YAxis.TickDirection = 'both';
            h_subax(j).YAxis.TickLength = [0.01,0];
            h_subax(j).XAxis.TickLength = [0.005,0];
            
            if not(isempty(yy_varnames{j}))
                yyaxis right
                yy = iv_signal.(yy_varnames{j});
                plot(t,yy)
                h_subax(j).YLim = yylims{j};
            end
            
            legend(y_varnames{j},yy_varnames{j},'Orientation','horizontal')
            
            
            
            %             % Find where the mean of x changes most significantly.
            %             pivot_ind = findchangepts(rmmissing(y),...
            %                 'MaxNumChanges',1 ...
            %                 ...'MinThreshold',1 ...
            %                 );
            
            
            %             % Plot lines where the abrupt changes are found
            %             for k=1:numel(pivot_ind)
            %                 pivot_time = plot_time(pivot_ind(k));
            %                 drawline('Position',[pivot_time,0;pivot_time,2],...
            %                     'Color',[0.6350, 0.0780, 0.1840],...
            %                     'Label','Abrupt change',...
            %                     'LineWidth',1.5...
            %                     );
            %             end
            
        end
        
        linkaxes(h_subax,'x')
        suptitle(sprintf('%s - %d/%d',event_type,i,n_iv))
        xlabel(h_subax(end,1),'Time (sec)')
        
        
        
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
    
    
function find_abruptchange_window(signal,notes)
    
    % Find where the mean of x changes most significantly.
    pivot_ind = findchangepts(rmmissing(plot_data.movrms),...
        'MaxNumChanges',1 ...
        ...'MinThreshold',1 ...
        );
    %TODO: Linear fit after pivot_ind
    
    plot(plot_time,plot_data.movrms,'DisplayName','Acc')
    for j=1:numel(pivot_ind)
        pivot_time = plot_time(pivot_ind(j));
        drawline('Position',[pivot_time,0;pivot_time,2],...
            'Color',[0.6350, 0.0780, 0.1840],...
            'Label','Abrupt change',...
            'LineWidth',1.5...
            );
    end
    filename = sprintf('Moving RMS of x,y,z length - Thrombus injection %d of %d - Volume %s',...
        i,n_injection,char(injection_notes.thrombusVolume(i)));
    title(strrep(filename,'_','\_'));
    
    % TODO: Fixed axis for all plots
    % TODO: Use time for set pivot ind, to define and sync intervals
    
    %set(gcf, 'Position', get(0,'Screensize'));
    %Save_Figure(save_path, title_str, 300)
    pause
    
    hold off
    h_leg = legend(string(notes.thrombusVolume(notes.event=='Thrombus injection')));
    get(h_leg)
    
    
