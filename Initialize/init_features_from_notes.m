function feats = init_features_from_notes(notes)
    % EXTRACT_FEATURES_FROM_NOTES
    %   Extract selected event features from notes.
    %   Features in all table cells should be populated with values.
        
    % Ignore columns not in use
    notes(:,all(ismissing(notes))) = [];
    
    % Take out meassured (event) values from notes for each event
    feature_cols = ...
        notes.Properties.CustomProperties.Controlled | ...
        (notes.Properties.CustomProperties.Measured & ...
        contains(string(notes.Properties.VariableContinuity),{'step','event'}));

     ss_rows = find(get_steady_state_rows(notes));
     feats = timetable2table(notes(ss_rows,feature_cols));
     
     % Rename meassured (point-wise manual reading) as steady-state values
     ss_vars = feats.Properties.CustomProperties.Measured;
     ss_varnames = feats.Properties.VariableNames(ss_vars);
     feats.Properties.VariableNames(ss_vars) = string(ss_varnames)+"_steady";
         
     % Store additional ID and reference columns
     % (These columns are not feature-columns.) 
     % Precursor: The last preceeding event that can be tied to the feature.
     feats.precursor = notes.event(ss_rows-1);     
     feats.precursor_noteRow = notes.noteRow(ss_rows-1);
     feats.precursor_startTime = notes.time(ss_rows-1);
     feats.precursor_endTime = notes.event_endTime(ss_rows-1);
     feats.precursor_timerange = notes.event_timerange(ss_rows-1);    
     feats.Properties.VariableDescriptions{'precursor'} = ...
         'The (latest) preceeding event tied to the feature';
     feats.Properties.VariableDescriptions{'precursor_noteRow'} = ...
         'The precursor row-id in the notes file';
     
     % Check and add info of potential additional paralell precursors
     feats = add_parallel_precursor_info(feats,notes);    
    
end

function feats = add_parallel_precursor_info(feats,notes)
    % Look for though all preceeding events and look for additional parallel
    % events still running, by comparing the event end times with the last 
    % preceeding event end time.  
     
    parPrecurNoteRows = cell(height(feats),1);
    parPrecurEvent = cell(height(feats),1);
    
    % For the last preceeding event in each feature...
    for pivot_feat_ind=1:height(feats)
        
        % Check if other preceeding events may be considered as precursors
        % to the current feature, in addition to the last preceeding event
        parPrecur_Noterows = [];
        parPrecur = {};
        pivot_note_ind = feats.precursor_noteRow(pivot_feat_ind)-3;
        for par_ind=1:pivot_note_ind-1
                
          if notes.event_endTime(par_ind)>feats.precursor_startTime(pivot_feat_ind)
              parPrecur_Noterows(end+1) = notes.noteRow(par_ind);
              parPrecur{end+1} = strrep(string(notes.event(par_ind)),' start','');
          end
          
        end
        
        parPrecurNoteRows{pivot_feat_ind} = parPrecur_Noterows;
        parPrecurEvent{pivot_feat_ind} = string(parPrecur);
        
    end
    
    feats.paralellPrecursor_noteRows = parPrecurNoteRows;
    feats.paralellPrecursor = parPrecurEvent;
    
end


