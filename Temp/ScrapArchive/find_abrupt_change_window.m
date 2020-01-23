function find_abruptchange_window(signal,notes)
    
    event_type = 'Thrombus injection';
    
    % Detect when the thrombus enters the system from the data, after start of
    % noted intervention window, no classification, just a guestimate
    injection_notes = notes(notes.event==event_type,:);
    n_injection = height(injection_notes);
    
    %close all
    for i=1:n_injection
        iv_row = injection_notes.note_row;
        plot_data = signal(injection_notes.event_range{i},:);
        plot_time = seconds(plot_data.time-plot_data.time(1));
        
        % Find where the mean of x changes most significantly.
        pivot_ind = findchangepts(rmmissing(plot_data.movRMS),...
            'MaxNumChanges',1 ...
            ...'MinThreshold',1 ...
            );
        %TODO: Linear fit after pivot_ind
        
        plot(plot_time,plot_data.movRMS,'DisplayName','Acc')
        for j=1:numel(pivot_ind)
            pivot_time = plot_time(pivot_ind(j));
            drawline('Position',[pivot_time,0;pivot_time,2],...
                'Color',[0.6350, 0.0780, 0.1840],...
                'Label','Abrupt change',...
                'LineWidth',1.5...
                );
        end
        fileName = sprintf('Moving RMS of x,y,z length - Thrombus injection %d of %d - Volume %s',...
            i,n_injection,char(injection_notes.thrombusVol(i)));
        title(strrep(fileName,'_','\_'));
        
        % TODO: Fixed axis for all plots
        % TODO: Use time for set pivot ind, to define and sync intervals
        
        %set(gcf, 'Position', get(0,'Screensize'));
        %Save_Figure(save_path, title_str, 300)
        pause
        
    end
    hold off
    h_leg = legend(string(notes.thrombusVol(notes.event=='Thrombus injection')));
    get(h_leg)
