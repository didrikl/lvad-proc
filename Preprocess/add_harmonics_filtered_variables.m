function T_parts = add_harmonics_filtered_variables(T_parts, varNames, harmonics, hWidth, constFreq, cfWidth)
    % Add harmonics filtered varibles
    %
    
    
    if nargin<3, harmonics = [1]; end
    if nargin<4, hWidth = 0.5; end
    if nargin<5, constFreq = []; end
    if nargin<6, cfWidth = 0.5; end
    if isempty(harmonics), return; end
    
    welcome('Adding hamonic notch filter variables')
     
    [returnAsCell,T_parts] = get_cell(T_parts);
    if isempty(T_parts)
        warning('Input data %s is empty',inputname(1))
        return
    end
    
    newVarNames = varNames+"_nf";
    fprintf('Input\n\t%s\n',strjoin(varNames,', '))
    fprintf('Output\n\t%s\n',strjoin(newVarNames,', '))
 
    if not(isempty(gcp('nocreate')))
        ...Parallell toolbox is started
        ...run in parallell by parfor implementation
    end

    for i=1:numel(T_parts)
        
        T = T_parts{i};
        if isempty(T), continue; end
        
        varsNotInPart = not(ismember(varNames,T.Properties.VariableNames));
        if any(varsNotInPart)
            error('\n\tPart %d does not contain input variables:\n\t\t%s',...
                i,strjoin(varNames(varsNotInPart),', '));
        end
        
        T{:,newVarNames} = nan(height(T),numel(newVarNames));
        
        [fs,T] = get_sampling_rate(T);
        [start_inds, end_inds, rpm_vals] = find_rpm_blocks(T);
        
        for j=1:numel(rpm_vals)
            
            hFreq = harmonics*(double(rpm_vals(j))/60);
            allFreq = [hFreq,constFreq];
            BW = [repmat(hWidth,1,numel(harmonics)),...
                repmat(cfWidth,1,numel(constFreq))];
            hFilt = make_multiple_notch_filter(allFreq,fs,BW);
            block_inds = start_inds(j):end_inds(j);
            
            for k=1:numel(varNames)
                var = varNames{k};
                newVar = newVarNames{k};
                if j==1, T.(newVar) = nan(height(T),1); end         
                
                % Remove first rows with nan in some variables
                nan_inds = isnan(T.(var)(block_inds));
                inds = block_inds(not(nan_inds));
                %ignoreNaN = true;
                T(inds,:) = filter_notches(T(inds,:),hFilt,var,newVar);
                
            end
            
        end
        T_parts{i} = T;
        
    end

    T_parts = convert_to_single(T_parts, newVarNames);

    if not(returnAsCell), T_parts = T_parts{1}; end