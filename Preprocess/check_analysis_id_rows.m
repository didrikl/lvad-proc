function S = check_analysis_id_rows(S)
    % Verify event and intervType are always respectively '-' and 'Steady-state'
    unique(S.event)
    unique(S.intervType)

    % TODO:
    % Verify protocol parameter consistency for each analysis_id in every sequence.
