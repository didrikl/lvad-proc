function T_parts = add_moving_statistics(T_parts, varNames, statistics)
    % Function for array of data timetables to add moving statistics.
    %
    % First values in each part will be NaN. A good practice could e.g. 
    % therefore be to do some extra recording at start of the part before 
    % doing interventions, which would avoid such gaps.
    
    % TODO: Make this an model object method
    
    statSpecs = {
        % supported win suffix
        'rms',      1,  '_movRMS'
        'var',      15, '_movVar'
        'std',      15, '_movStd'
        'min',      5,  '_movMin'
        'max',      5,  '_movMax'
        'avg',      10, '_movAvg'
        };
    
    % Just for compatibility
    if nargin<2, varNames = 'accA_norm'; end
    if nargin<3, statistics = {'std'}; end
    
    welcome('Calculating moving statistics')
    
    [returnAsCell,T_parts] = get_cell(T_parts);
    if isempty(T_parts)
        warning('Input data %s is empty',inputname(1))
        return
    end
    
    unsupported = not(ismember(statistics,statSpecs(:,1)));
    if any(unsupported)
        warning(sprintf('Unsupported stastitics types given:\n\t%s',...
            strjoin(statistics(unsupported),', ')))
        statSpecs(unsupported,:) = [];
    end
    
    nTypes = numel(statSpecs(:,1));
    newVarNames = {};
    for j=1:numel(varNames)  
        fprintf('Variable %s:\n',varNames{j})
        for i=1:nTypes
            newVarNames{end+1} = [varNames{j},statSpecs{i,3}];
            fprintf('\t%s, %3.3g sec window: %s\n',statSpecs{i,1},...
                statSpecs{i,2},newVarNames{end});
        end
    end  

    T_parts = add_in_parts(@calc_moving,T_parts,varNames,newVarNames,...
            statSpecs(:,1),cell2mat(statSpecs(:,2)));
    
    T_parts = convert_to_single(T_parts, newVarNames);

    if not(returnAsCell), T_parts = T_parts{1}; end
    fprintf('\nDone.\n')
   