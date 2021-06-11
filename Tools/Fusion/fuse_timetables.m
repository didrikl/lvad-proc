function T = fuse_timetables(T1,T2,syncOpts,contDropSpec)
    % FUSE_TIMETABLES   Fuse two timetables that are syncronized and left joined
    %    FUSE_TIMETABLES(T1,T2) fuse data from T2 into T1. Data in T2 is 
    %    syncronized, so that non-matching timestamps will match.
    %
    % See also timetables, syncronize
    
    if nargin<3, syncOpts = {}; end
    if nargin<4, contDropSpec = {'unset','event'}; end
    
    T2_dropCols = determineColsToDrop(T2,contDropSpec);
    T2_dropVarNames = T2.Properties.VariableNames(T2_dropCols);
    T2_fuseVarNames = T2.Properties.VariableNames(not(T2_dropCols));
    T2 = T2(:,T2_fuseVarNames);
    
    T1_overwriteCols = determine_cols_to_overwrite(T1,T2_fuseVarNames);
    T1_overwriteVarNames = T1.Properties.VariableNames(T1_overwriteCols);
    T1(:,T1_overwriteCols) = [];
    
    display_info(T2_fuseVarNames,T2_dropVarNames,T1_overwriteVarNames)
    
    if not(issorted(T1))
        fprintf('\n')
        T_name = inputname(1);
        if isempty(T_name), T_name = 'First (left) table'; end
        warning([class(T1),' ',T_name,' is not sorted in time.'])
    end
    if not(issorted(T2))
        fprintf('\n')
        T_name = inputname(2);
        if isempty(T_name), T_name = 'Second (right) table'; end
        warning([class(T2),' ',T_name,' is not sorted in time.'])
    end

    try
        T = synchronize(T1,T2,syncOpts{:});
    catch ME
        if strcmp(ME.identifier,'MATLAB:timetable:synchronize:NotMissingAware')
            warning(ME.message)
            
            % First remove all unsupported columns
            T1_notSupported = T1.Properties.VariableNames(...
                varfun(@islogical,T1,'output','uniform'));
            T2_notSupported = T2.Properties.VariableNames(...
                varfun(@islogical,T2,'output','uniform'));
            if not(isempty(T1_notSupported)) || not(isempty(T2_notSupported))
                warning(sprintf('Variable are removed for data fusion:\n\t%s',...
                    strjoin([T1_notSupported,T2_notSupported],', ')));
                T2 = T2(:,not(ismember(T2.Properties.VariableNames,T2_notSupported)));
                T1 = T1(:,not(ismember(T1.Properties.VariableNames,T1_notSupported)));
            end
            
            % Temporarily handle integer columns as single
            T2_intVarNames = T2.Properties.VariableNames(...
                varfun(@isinteger,T2,'output','uniform'));
            %T3 = T2(:,T2_intVarNames);
            T2 = convert_to_single(T2,T2_intVarNames);
            %T2 = T2(:,not(ismember(T2.Properties.VariableNames,T2_intVarNames)));
            
            T1_intVarNames = T1.Properties.VariableNames(...
                varfun(@isinteger,T1,'output','uniform'));
            %T4 = T1(:,T1_intVarNames);
            T1 = convert_to_single(T1,T1_intVarNames);
            %T1 = T1(:,not(ismember(T1.Properties.VariableNames,T1_intVarNames)));
            
            T = synchronize(T1,T2,syncOpts{:});
            %T = synchronize(T1,T3);
            %T = synchronize(T1,T4);
            
            % Convert back to integer
            T = convert_to_int(T,[T1_intVarNames,T2_intVarNames]);
            
        else
            error(ME.message)            
        end
        
    end
    
end

function display_info(merge_varNames,drop_varNames,overwrite_varNames)
    fprintf('\n\tMerging: %s',strjoin(merge_varNames,', '))
    if not(isempty(drop_varNames))
        fprintf('\n\tDropping: %s',strjoin(drop_varNames,', '))
    end
    if not(isempty(overwrite_varNames))
        fprintf('\n\tOverwriting: %s\n',strjoin(overwrite_varNames,', '))
    end
    fprintf(newline)
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
            return;
        end
    
        varName = T1.Properties.VariableNames{alreadyExist(i)};
        msg = sprintf('\nColumn %s exist already in left table (signal)',varName);
        opts = {
            'Overwrite'
            'Overwrite, always'
            'Keep both'           
            'Abort execution'
            };
        response = ask_list_ui(opts,msg,1);
       
        if response==1, colsToRemove(alreadyExist(i)) = true; end
        if response==2
            overways_overwrite_existing_variables = true; 
            fprintf('\n\t(Type "clear fuse_timetables" to reset this choice.)\n')
        end
        if response==4, abort(true); end
        
        % If user cancelled
        if not(response), return; end
        
    end
    
end

function [colsToDrop] = determineColsToDrop(T2,varContDropType)
    % Return logical array of new columns to drop before data fusion
    
    % Merge only data with specified variable continuity (which is used for
    % filling empty entries in non-matching rows when syncing).
    colsToDrop = ismember(T2.Properties.VariableContinuity,varContDropType);
    
%     intVars = varfun(@isinteger,T2,'output','uniform');
%     if any(intVars)
%         fprintf('\t')
%         warning('Integer variables is not supported for syncronize using ''fillwithmissing''')
%         notSupported = [notSupported,intVars];
%     %    ask_to_handle_int_vars()
%     end
%     
%     logicalVars = varfun(@islogical,T2,'output','uniform');
%     if any(logicalVars)
%         warning('Logical variables is not supported for syncronize using ''fillwithmissing''')
%         notSupported = [notSupported,intVars];
%     end    
%     
    %colsToDrop = ask_user_for_handling_empty_cols(T2, colsToDrop);
    
end
    
function colsToDrop = ask_user_for_handling_empty_cols(T2, colsToDrop)
    persistent overwaysIncludeEmptyVariables
    persistent overwaysExcludeEmptyVariables
    if isempty(overwaysIncludeEmptyVariables)
        overwaysIncludeEmptyVariables = false;
    end
    if isempty(overwaysExcludeEmptyVariables)
        overwaysExcludeEmptyVariables = false;
    end
    % Let user choose what to do with columns that only contains missing values
    emptyCols = find(all(ismissing(T2)));
    for i=1:numel(emptyCols)
        
        if overwaysIncludeEmptyVariables==true          
            return;
        end
        if overwaysExcludeEmptyVariables==true
            fprintf('\n\t(Type "clear fuse_timetables" to reset this choice.)\n')
            colsToDrop(emptyCols) = true;
            return;
        end
        
        varName = T2.Properties.VariableNames{emptyCols(i)};
        warning(sprintf('Column %s contain only missing data',varName));
        opts = {
            'Include'
            'Include, always'
            'Exclude'
            'Exclude, always'
            'Abort execution'
            };
        response = ask_list_ui(opts,msg,1);
        if response==2, overwaysIncludeEmptyVariables = true; 
            fprintf('\n\t(Type "clear fuse_timetables" to reset this choice.)\n')
        elseif response==3 
            colsToDrop(emptyCols(i)) = true; 
        elseif response==4 
            overwaysExcludeEmptyVariables = true; 
            fprintf('\n\t(Type "clear fuse_timetables" to reset this choice.)\n')
        elseif response==5 
            abort(true); 
        end
        
        % if cancelled in GUI
        if not(response), return; end
           
    end
end