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
     
    last_note_ind = find(notes.intervType~='Experiment end',1,'last');
    range = timerange(notes.time(1),notes.time(last_note_ind));
    signal = signal(range,:);
    