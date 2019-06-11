function feats = extract_features_from_notes(notes)
    % EXTRACT_FEATURES_FROM_NOTES
    %   Extract selected event features from notes.
    %   Features in all table cells should be populated with values.
        
    % Ignore columns not in use
    notes(:,all(ismissing(notes))) = [];
    
    % Take out meassured (event) values from notes for each event
    feature_cols = ...
        notes.Properties.CustomProperties.ControlledParam | ...
        (notes.Properties.CustomProperties.MeassuredParam & ...
        contains(string(notes.Properties.VariableContinuity),{'step','event'}));

     ss_rows = find(contains(lower(string(notes.experimentSubpart)),'steady'));
     
     feats = timetable2table(notes(ss_rows,feature_cols));
     
     % Rename meassured (point-wise manual reading) as steady-state values
     ss_vars = feats.Properties.CustomProperties.MeassuredParam;
     ss_varnames = feats.Properties.VariableNames(ss_vars);
     feats.Properties.VariableNames(ss_vars) = string(ss_varnames)+"_steadyState";
     
     
     %% Store additional ID and reference columns
     % (These columns are not feature-columns.)
     
     %feats.event_noteRow = notes.noteRow(ss_rows);
     
     % Precursor: The lest preceeding event that can be tied to the feature.
     feats.precursor = notes.event(ss_rows-1);     
     feats.precursor_noteRow = notes.noteRow(ss_rows-1);
     feats.precursor_startTime = notes.timestamp(ss_rows-1);
     feats.precursor_endTime = notes.event_endTime(ss_rows-1);
     feats.precursor_timerange = notes.event_timerange(ss_rows-1);
     
     % Check and add info of potential additional paralell precursors
     feats.parPrecursor_noteRows = find_parallel_precursors(feats);
     
    
end

%%

function noteRows = find_parallel_precursors(feats)
    % Look for though all preceeding events and look for additional parallel
    % events still running, by comparing the event end times with the last 
    % preceeding event end time.  
     
    noteRows = cell(height(feats),1);
    
    % For the last preceeding event in each feature...
    for pivot_ind=1:height(feats)
        
        % Check if other preceeding events may be considered as precursors
        % to the current feature, in addition to the last preceeding event
        par_Noterows = [];
        for par_ind=1:pivot_ind-1
                
          if feats.precursor_endTime(par_ind)>feats.precursor_startTime(pivot_ind)
              par_Noterows(end+1) = feats.precursor_noteRow(par_ind);
          end
          
        end
        noteRows{pivot_ind} = par_Noterows;
    end
end


