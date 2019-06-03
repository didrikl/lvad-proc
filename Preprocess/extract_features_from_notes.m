function feats = extract_features_from_notes(notes)
    % Extract selected event features from notes.
    % Features in all table cells should be populated with values.
        
    % Ignore columns not in use
    notes(:,all(ismissing(notes))) = [];
    
    % Take out meassured (event) values from notes for each event
    feature_cols = ...
        notes.Properties.CustomProperties.ControlledParam | ...
        (notes.Properties.CustomProperties.MeassuredParam & ...
        contains(string(notes.Properties.VariableContinuity),{'step','event'}));

     ss_rows = find(contains(lower(string(notes.experimentSubpart)),'steady'));
     
     feats = timetable2table(notes(ss_rows,feature_cols));
     
     % Store ID/reference (non-feature) columns
     feats.precedingEvent = notes.event(ss_rows-1);
     feats.note_row = notes.note_row(ss_rows);
     feats.window = notes.event_range(ss_rows-1);
     
     % Rename meassured (point-wise manual reading) as steady-state values
     ss_vars = feats.Properties.CustomProperties.MeassuredParam;
     ss_varnames = feats.Properties.VariableNames(ss_vars);
     feats.Properties.VariableNames(ss_vars) = string(ss_varnames)+"_steadyState";
    