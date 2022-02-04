function notes = add_event_note_ranges(notes, intervTypesToIncludeinEventRange)
    % Add info about how long the events are running. Two new columns are made,
    % one column for event end time and one column with subscripts for timerange 
    % extractions in timetables.
    %
    % The rule of thumb is that is run until next noted event in the notes.
    % Exceptions are made for events with the key word 'start', which is
    % presumed to be running in parallell until end of experiement or until a
    % similar pairing counterpart event having the key word 'end' instead of
    % 'start'.
    
    n_notes = height(notes);
    
    % Subscripts to extract ranges in timetables, just for convenience. It can
    % be also used to quickly view the timerange, but has no other usage. 
    notes.event_timerange = cell(n_notes,1);
    
    event_inds = find(...
        (notes.event~='-' & not(ismissing(notes.event))) ...
        | notes.intervType=='Continue from pause');
    for i=1:numel(event_inds)
        
        % Applying the rule of thomb
        ii = event_inds(i);
        event_stop_ind = ii+1;%find(notes.event(ii:end)~='-',1,'first');
        
        % Include steady-states and baselines as part of the precursor event when
        % deriving timeranges for the event
        while contains(lower(string(notes.intervType(event_stop_ind))),...
            intervTypesToIncludeinEventRange) && event_stop_ind<n_notes
            event_stop_ind = event_stop_ind+1;
        end
                
        % Handle events that will run i parallell
        event = string(notes.event(ii));
        if contains(event,'start','IgnoreCase',true)
            
            % Search for pairing end of event note
            remaining_events = string(notes.event(ii+1:end));
            event_stop_name = strrep(event,'start','end');
            event_stop_ind = find(remaining_events==event_stop_name,1,'first')+ii;
            
            % No pairing event implies running until the end
            if isempty(event_stop_ind)
                event_stop_ind = find(notes.time>notes.time(ii),1,'last');
                warning('\n\tThe parallell running event %s was not ended.',event)
            end
            
        end
        
        % Make the timerange
        if ii<n_notes
            end_time = notes.time(event_stop_ind);
        else
            end_time = datetime(inf,'ConvertFrom','datenum','TimeZone','Etc/UTC');
        end
        notes.event_timerange{ii} = timerange(notes.time(ii),end_time,'open');
        notes.event_endTime(ii) = end_time;
        
        
    end