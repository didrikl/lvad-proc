function T = fuse_timetables(T1,T2,varargin)
    % FUSE_TIMETABLES   Fuse two timetables that are syncronized and left joined
    %    FUSE_TIMETABLES(T1,T2) fuse data from T2 into T1. Data in T2 is 
    %    syncronized, so that non-matching timestamps will match.
    %
    % See also timetables, syncronize
    
    T=T1;
    
    colsToDrop = determineColsToDrop(T2);
    drop_varNames = T2.Properties.VariableNames(colsToDrop);
    
    colsToMerge = not(colsToDrop);
    merge_varNames = T2.Properties.VariableNames(colsToMerge);
    
    colsToOverwrite = determine_cols_to_overwrite(T1,merge_varNames);
    overwrite_varNames = T1.Properties.VariableNames(colsToOverwrite);
    
    fprintf('\n\tNew variables to merge: %s',strjoin(merge_varNames,', '))
    fprintf('\n\tNew variables to drop: %s',strjoin(drop_varNames,', '))
    fprintf('\n\tExisting variables to overwrite: %s\n',strjoin(overwrite_varNames,', '))
    
    T1(:,colsToOverwrite) = [];
    T2 = T2(:,merge_varNames);
    
    T = synchronize(T1,T2,varargin{:});
    
end

function colsToRemove = determine_cols_to_overwrite(T1,merge_varnames)
    % Return logical array of existing columns to drop before data fusion
    
    persistent overways_overwrite_existing_variables
    if isempty(overways_overwrite_existing_variables)
        overways_overwrite_existing_variables = false;
    end
    
    colsToRemove = false(1,width(T1));
    
    alreadyExist = find(ismember(T1.Properties.VariableNames,merge_varnames));
    n_alreadyExist = numel(alreadyExist);
    for i=1:n_alreadyExist
        
        if overways_overwrite_existing_variables==true
            colsToRemove(i:n_alreadyExist)= alreadyExist(i:n_alreadyExist);
            fprintf(['\nExisting variables will always be overwritten',...
                '\n(type "clear fuse_timetables" to reset)\n'])
            return;
        end
    
        varName = T1.Properties.VariableNames{alreadyExist(i)};
        msg = sprintf('\nColumn %s exist already in left table (signal)',varName);
        opts = {
            'Overwrite'
            'Overwrite, always'
            'Keep both'
            'Cancel merging'
            'Abort execution'
            };
        response = ask_list_ui(opts,msg,1);
        if response==1, colsToRemove(alreadyExist(i)) = true; end
        if response==2, overways_overwrite_existing_variables = true; end
        if response==4 || not(response), return; end
        if response==5, abort(true); end
    end
    
end

function colsToDrop = determineColsToDrop(T2)
    % Return logical array of new columns to drop before data fusion
    
    persistent overwaysIncludeEmptyVariables
      if isempty(overwaysIncludeEmptyVariables)
        overwaysIncludeEmptyVariables = false;
    end
    
    % Merge only data with specified variable continuity (which is used for
    % filling empty entries in non-matching rows when syncing).
    colsToDrop = ismember(T2.Properties.VariableContinuity,{'unset','event'});
    
    % Let user choose what to do with columns that only contains missing values
    emptyCols = find(all(ismissing(T2)));
    for i=1:numel(emptyCols)
        
        if overwaysIncludeEmptyVariables==true
            fprintf(['\nEmpty variables will always be included',...
                '\n(type "clear fuse_timetables" to reset)\n'])
            return;
        end
    
        
        varName = T2.Properties.VariableNames{emptyCols(i)};
        msg = sprintf('\nColumn %s contain only missing data',varName);
        opts = {
            'Include'
            'Include, always'
            'Exclude'
            'Cancel merging'
            'Abort execution'
            };
        response = ask_list_ui(opts,msg,1);
        if response==2, overwaysIncludeEmptyVariables = true; end
        if response==3, colsToDrop(emptyCols(i)) = true; end %#ok<AGROW>
        if response==4 || not(response), return; end
        if response==5, abort(true); end
    end
end
    