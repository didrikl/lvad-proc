function data = clip_signal_with_notes(signal)

    % Find rows that do not belong to any experiment part and remove these rows
    experiment_inds = not(isundefined(signal.experimentPartNo));
    data = signal(experiment_inds,:);

    % Log info about the clipping
    % ...