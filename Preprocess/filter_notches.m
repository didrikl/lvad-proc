function T = filter_notches(T,filt,varName,new_varName,ignoreNaN)
    % Filter a variable with a designed filter
    
    % TODO: Make part of table tool or table preprocess package
    
    if nargin<4, new_varName = ''; end
    if nargin<5, ignoreNaN = false; end    
    
    % To look at the filter response
    %hfvt= fvtool(hd,'Color','white');
 
    % NaN entries are set to zero so that the filter method does not result 
    % in only NaN values
    nan_inds = isnan(T.(varName));
    if ignoreNaN
        T.(varName)(nan_inds) = 0;
    elseif any(nan_inds)
        warning(['There are %d NaN entries in the input data. Use IgnoreNaN',...
            'input as true'],nnz(nan_inds));
    end
    
    if not(new_varName), new_varName = varName; end
    T.(new_varName) = filter(filt,T.(varName));

    % Restore NaN
    if ignoreNaN
        T.(varName)(nan_inds) = nan;
    end
    
     T.Properties.VariableContinuity(varName) = 'continuous';
%     T.Properties.VariableDescriptions(varName) = 'filtered'; %{sprintf(...
%         'Moving %s\n\t%s\n\tSample rate: %d\n\tFrequencies (samples)',...
%         descr,fs,nSamples)};