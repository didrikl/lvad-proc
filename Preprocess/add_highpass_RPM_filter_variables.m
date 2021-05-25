function T = add_highpass_RPM_filter_variables(T,varNames,newVarNames,...
        harmCut,cutFreqShift)
    
    if nargin<5, cutFreqShift = 1; end
    if nargin<4, harmCut = 1; end
     
    [returnAsCell,T] = get_cell(T);
    if isempty(T)
        warning('Input data %s is empty',inputname(1))
        return
    end
    
    welcome('Calculating harmonic cut highpass filter','function',not(returnAsCell))
    
    fprintf('Input: %s\nOutput: %s\n',...
       strjoin(string(varNames)),strjoin(string(newVarNames)));
    
    fnc = @filter_data;   
    T = add_in_parts(fnc,T,varNames,newVarNames,harmCut,cutFreqShift);
    T = convert_to_single(T,newVarNames);
    T.Properties.VariableContinuity(newVarNames) = 'continuous';
         
    if not(returnAsCell), T = T{1}; end
    
function T = filter_data(T,varNames,newVarNames,hamonic_cut,cut_freq_shift)
    [fs,T] = get_sampling_rate(T);
   varNames = cellstr(varNames);
   newVarNames = cellstr(newVarNames);
   
    % Filling dummy RPM, so that a RPM-based filter can be constructed.
    T.pumpSpeed = single(T.pumpSpeed);
    T.pumpSpeed = standardizeMissing(T.pumpSpeed,0);
    T.pumpSpeed = fillmissing(T.pumpSpeed,'previous');
    T.pumpSpeed = standardizeMissing(T.pumpSpeed,0);
    T.pumpSpeed = fillmissing(T.pumpSpeed,'next');
  
    % NOTE: Use subs_dummy_rpm function, when it is ready
    
    pumpSpeeds = unique(T.pumpSpeed);
    preAllocCol = NaN(height(T),1);
        
    for j=1:numel(varNames)
        % Use a copy before preallocating, in case of overwriting
        var = T.(varNames{j});
        T.(newVarNames{j}) = preAllocCol;
        % NOTE: Perhaps better/more accurate to blocks of RPM values
        for i=1:numel(pumpSpeeds)
            inds = T.pumpSpeed==pumpSpeeds(i) & not(isnan(var));
            Fpass = (double(pumpSpeeds(i))/60)*hamonic_cut-cut_freq_shift;
            if not(isfinite(Fpass))
                warning('Cut frequency is %s',Fpass)
            end
            T.(newVarNames{j})(inds) = highpass(var(inds),Fpass,fs);
        end
    end
    