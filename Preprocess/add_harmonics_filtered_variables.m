function T_parts = add_harmonics_filtered_variables(...
		T_parts, varNames, newVarNames, harmNotchWidth)
    % Add harmonics filtered varibles by a combined notch filter
    % 
	% Inputs
	% - T_parts: Cell array of timetables or timetable with signal data 
	% - varNames: Cell array of varibles to filter
	
	% Array of harmonic numbers to filter, with respect to pump speed and
	% corresponding notch widths
	harmonics = 1:10;
	
	% Hardcoded array of fixed frequencies and widths to be filtered,
	% irrespective of pump speed.
	% Note: Could be implemented as an peak-adaption part by part
	fixFreq = [];
	fixFreqWidth = 1;
	
    welcome('Derive hamonic notch filtered variables')
     
    [returnAsCell,T_parts] = get_cell(T_parts);
    if isempty(T_parts)
        warning('Input data %s is empty',inputname(1))
        return
    end
    
    fprintf('\nInput\n\t%s\n',strjoin(varNames,', '))
    fprintf('Output\n\t%s\n\n',strjoin(newVarNames,', '))
 
	% if parallell toolbox is started
    %{
	if not(isempty(gcp('nocreate')))
        ...run in parallell by parfor implementation
    end
    %}
	
	% TODO: Implement with add_in_parts, c.f. add_highpass_RPM_filter_variables

    for i=1:numel(T_parts)
        
		isEmpty = display_block_info(T_parts{i},i,numel(T_parts));
		if isEmpty, continue; end
        T = T_parts{i};
		
        varsNotInPart = not(ismember(varNames,T.Properties.VariableNames));
        if any(varsNotInPart)
            error('\n\tPart %d does not contain input variables:\n\t\t%s',...
                i,strjoin(varNames(varsNotInPart),', '));
        end
        
        T{:,newVarNames} = nan(height(T),numel(newVarNames));
        
        [fs,T] = get_sampling_rate(T);
        [start_inds, end_inds, rpms] = find_rpm_blocks(T);
        
        for j=1:numel(rpms)
            
            hFreq = harmonics*(double(rpms(j))/60);
			
			% Design the filter based on all frequencies specified, and 
			% corresponding notch widths,within the effective bandwidt
		    allFreq = [hFreq(hFreq<fs/2),fixFreq(fixFreq<fs/2)];
            BW = [harmNotchWidth(hFreq<fs/2),fixFreqWidth(fixFreq<fs/2)];   
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
        T.Properties.VariableContinuity(newVarNames) = 'continuous';
        T_parts{i} = T;
        
    end

    T_parts = convert_to_single(T_parts, newVarNames);

    if not(returnAsCell), T_parts = T_parts{1}; end