function T_parts = add_harmonics_filtered_variables(T_parts, varNames, harmonics, hWidth)
    % Add harmonics filtered varibles
    %
    
    if nargin<2
        varNames = {
            'accA_norm'
            'accA_norm_movRMS'
            %'accA_xz_norm_movRMS'
            'accA_norm_movStd'
            %'accA_xz_norm_movStd'
            'accB_norm'
            'accB_norm_movRMS'
            %'accB_xz_norm_movRMS'
            'accB_norm_movStd'
            %'accB_xz_norm_movStd'
            }; 
    end
    if nargin<3, harmonics = [1]; end
    if nargin<4, hWidth = 0.5; end
    
    if isempty(harmonics), return; end
    
    welcome('Adding filtered variables')
 
    
    varNames = varNames(ismember(varNames,T_parts{1}.Properties.VariableNames));
    newVarNames = varNames+"_["+mat2str(harmonics)+"]hFilt";
    fprintf('Input\n\t%s\n',strjoin(varNames,', '))
    fprintf('Output\n\t%s\n',strjoin(newVarNames,', '))
 
    for i=1:numel(T_parts)
        
        T = T_parts{i};
        T{:,newVarNames} = nan(height(T),numel(newVarNames));
        if isempty(T), continue; end
        
        [fs,T] = get_sampling_rate(T);
        [start_inds, end_inds, rpm_vals] = find_rpm_blocks(T);
        
        for j=1:numel(rpm_vals)
            
            hFreq = harmonics*(double(rpm_vals(j))/60);
            hFilt = make_multiple_notch_filter(hFreq,fs,hWidth);
            block_inds = start_inds(j):end_inds(j);
            
            for k=1:numel(varNames)
                var = varNames{k};
                newVar = newVarNames{k};
                T.(newVar) = nan(height(T),1);             
                
                % Remove first rows with nan in some variables
                nan_inds = isnan(T.(var)(block_inds));
                inds = block_inds(not(nan_inds));
                T(inds,:) = filter_notches(T(inds,:),hFilt,var,newVar);
                
            end
            
        end
        T_parts{i} = T;
        
    end

    T_parts = convert_to_single(T_parts, newVarNames);

    
