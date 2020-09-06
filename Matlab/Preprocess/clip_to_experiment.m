function signal = clip_to_experiment(signal, notes)
    % CLIP_TO_EXPERIMENT
    %   Clip to timerange of notes (experiment start to end). The end is defined
    %   as the time for the last note row that is not denotet as 'Experiment end',
    %   or if such as a row is not present it will be at the very last note row.
    %   The start will always correspond to the first note row.
    %
    % Usage:
    %   data = clip_to_experiment(data, notes)
    %
     
    seq_end_event = 'Sequence end';
    seq_start_event = 'Sequence start';
    
    % Find time s
    end_note_ind = find(notes.intervType~=seq_end_event,1,'first');
    start_note_ind = find(notes.intervType~=seq_start_event,1,'first');
    if isempty(start_note_ind), start_note_ind=1; end
    if isempty(end_note_ind), end_note_ind=height(notes); end
    
    range = timerange(notes.time(start_note_ind),notes.time(end_note_ind));
    signal = signal(range,:);
    