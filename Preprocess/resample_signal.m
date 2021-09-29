function T = resample_signal(T,sampleRate,method)
    %RESAMPLE_SIGNAL resamples timetable 
    %  Resampling or retiming timetable T.
    %
    %  Ensures non-regular timetables as reguluar by Matlab's retime function, 
    %  and resampled whenever required. 
    %
    %  Columns that have true assigned to T.Properties.CustomProperties.Measured 
    %  or any (derived) continious variable are re-sampled. Remaining variables 
    %  are set aside and fused into the resampled table by the fuse_timetables 
    %  function, according to T.Properties.VariableContinuity.
    %  
    % Input:
    %  T: Timetable
    %  sampleRate: New or current sample rate.
    %  method (optional): Method, as supported by Matlab's retime function
    %
    % Examples:
    %  T = resample_signal(T,fs)
    %  T = resample_signal(T,fs,method)
    %
    % See also timetable, retime, fuse_timetables
    %
    
    % Method default settings
    if nargin<3, method = 'linear'; end
    
    welcome('Resample/retime signal')
    
    [returnAsCell,T] = get_cell(T);

    fprintf('Method: %s\n',method)
    fprintf('New sample rate: %d\n',sampleRate)
    
    nBlocks = numel(T);
    for i=1:nBlocks
        
        multiWaitbar('Resample/retime signal',(i-1)/nBlocks);
		isEmpty = display_block_info(T{i},i,nBlocks,not(returnAsCell));
        if isEmpty, continue; end
		
        % Store variable name order
        varNames = T{i}.Properties.VariableNames;
        
        % Resample to even sampling, before adding categorical data and more from notes
        measured_cols = T{i}.Properties.CustomProperties.Measured;
        derived_cols = T{i}.Properties.VariableContinuity=='continuous' & not(measured_cols);
        isFloatCol = varfun(@isfloat,T{i},'output','uniform');
        
        resamp_cols = (measured_cols | derived_cols) & isFloatCol;
        merge_cols = not(resamp_cols);
        merge_varNames = T{i}.Properties.VariableNames(merge_cols);
        resamp_varNames = T{i}.Properties.VariableNames(resamp_cols);
        
        fprintf('\nRe-sampling: %s\n',strjoin(resamp_varNames,', '))
        
        % In case there are notes columns merged with signal, then these columns
        % must be kept separately and then merged with signal after resampling
        if any(merge_cols)
            fprintf('Re-merging: %s\n',strjoin(merge_varNames,', '))
            merge_varsTable = T{i}(:,merge_varNames);
        end
        
        % Resampling
        T{i} = retime(T{i}(:,resamp_varNames),...
            'regular',method,...
            'SampleRate',sampleRate);
        
        % Re-include notes info (using syncronize)
        if any(merge_cols)
            T{i} = fuse_timetables(T{i},merge_varsTable,...
                {'regular','SampleRate',sampleRate},{});
        end
        
        % Reorder columns to original order (excl. unsopprted)
        T{i} = T{i}(:,varNames(...
            ismember(varNames,T{i}.Properties.VariableNames)));
    end

    multiWaitbar('Resample/retime signal',1);
    if not(returnAsCell), T = T{1}; end