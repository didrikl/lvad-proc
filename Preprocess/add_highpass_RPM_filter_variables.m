function T = add_highpass_RPM_filter_variables(T, vars, newVars, cut, ...
		cutType, cutFreqShift)
    
    if nargin<6, cutFreqShift = 0; end
    
    [returnAsCell,T] = get_cell(T);
    if isempty(T)
        warning('Input data %s is empty',inputname(1))
        return
    end
    
    welcome('Derive harmonic cut highpass filter','function',not(returnAsCell))
    
    fprintf('Input: %s\nOutput: %s\n',...
       strjoin(string(vars)),strjoin(string(newVars)));
    
	switch lower(cutType)
		case 'harm'
			fnc = @harmonic_cut_filter_data;
			T = add_in_parts(fnc, T, vars, newVars, cut, cutFreqShift);
		case 'freq'
			fnc = @frequency_cut_filter_data;
			T = add_in_parts(fnc, T, vars, newVars, cut);
	end

	T = convert_to_single(T, newVars);
	if not(returnAsCell), T = T{1}; end

function T = frequency_cut_filter_data(T, vars, newVars, Fpass)
   [fs,T] = get_sampling_rate(T);
   vars = cellstr(vars);
   newVars = cellstr(newVars);
  
    preAllocCol = NaN(height(T),1);
        
	for j=1:numel(vars)
		% Use a copy before preallocating, in case of overwriting
		var = T.(vars{j});
		T.(newVars{j}) = preAllocCol;
		inds = not(isnan(var));
		T.(newVars{j})(inds) = highpass(var(inds), Fpass, fs);
	end

	T.Properties.VariableContinuity(newVars) = 'continuous';

function T = harmonic_cut_filter_data(T, vars, newVars, harmCut, cutFreqShift)
   [fs,T] = get_sampling_rate(T);
   vars = cellstr(vars);
   newVars = cellstr(newVars);
   
    % Filling dummy RPM, so that a RPM-based filter can be constructed.
    T.pumpSpeed = single(T.pumpSpeed);
    T.pumpSpeed = standardizeMissing(T.pumpSpeed,0);
    T.pumpSpeed = fillmissing(T.pumpSpeed,'previous');
    T.pumpSpeed = standardizeMissing(T.pumpSpeed,0);
    T.pumpSpeed = fillmissing(T.pumpSpeed,'next');
  
    % NOTE: Use subs_dummy_rpm function, when it is ready
    
    pumpSpeeds = unique(T.pumpSpeed);
    preAllocCol = NaN(height(T),1);
        
	for j=1:numel(vars)
		% Use a copy before preallocating, in case of overwriting
		var = T.(vars{j});
		T.(newVars{j}) = preAllocCol;
		% NOTE: Perhaps better/more accurate to blocks of RPM values
		for i=1:numel(pumpSpeeds)
			inds = T.pumpSpeed==pumpSpeeds(i) & not(isnan(var));
			Fpass = (double(pumpSpeeds(i))/60)*harmCut-cutFreqShift;
			if not(isfinite(Fpass))
				warning('Cut frequency is %s',Fpass)
			end
			T.(newVars{j})(inds) = highpass(var(inds),Fpass,fs);
		end
	end

	T.Properties.VariableContinuity(newVars) = 'continuous';

