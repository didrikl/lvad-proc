function T = add_norms_and_filtered_variables(accVars, T, Config)
	
	% Derive Eucledian norm of acc signal components
	T = add_norms(accVars, T, 'A');
	T = add_norms(accVars, T, 'B');
	
	% Add notch and highpass filtered acc component signals, as needed
	T = add_filtered_acc_components(T, accVars, 'A', 'x', Config);
	T = add_filtered_acc_components(T, accVars, 'A', 'y', Config);
	T = add_filtered_acc_components(T, accVars, 'A', 'z', Config);
	T = add_filtered_acc_components(T, accVars, 'A', 'norm', Config);
	T = add_filtered_acc_components(T, accVars, 'B', 'x', Config);
	T = add_filtered_acc_components(T, accVars, 'B', 'y', Config);
	T = add_filtered_acc_components(T, accVars, 'B', 'z', Config);
	T = add_filtered_acc_components(T, accVars, 'B', 'norm', Config);

function T = add_norms(accVars, T, accID)
	
	normVar = ['acc',accID,'_norm'];
	xVar = ['acc',accID,'_x'];
	yVar = ['acc',accID,'_y'];
	zVar = ['acc',accID,'_z'];
	
	if not(any(contains(accVars, normVar))), return; end

	% unfiltered norm
	T = add_spatial_norms(T, 2, {xVar,yVar,zVar}, normVar);

function T = add_filtered_acc_components(T, accVars, accID, compID, Config)

	NW = Config.harmonicNotchFreqWidth;
	cut = Config.harmCut;
	cutShift = Config.harmCutFreqShift;
	fs = Config.fs;

	var = ['acc',accID,'_',compID];
    remVars = {var};

	if not(any(contains(accVars, var))), return; end

	% 	% notch filter for component
	if any(contains(accVars, [var,'_NF']))
        remVars = {var,[var,'_NF']};
		T = add_harmonics_filtered_variables(T, {var}, {[var,'_NF']}, NW, fs);
	end

	% highpass filter for notch-filtered component
	if any(contains(accVars, [var,'_HP']))
		T = add_highpass_RPM_filter_variables(T, {var}, {[var,'_HP']},...
			cut, 'harm', cutShift, fs);
	end

 	% highpass filter component
	if any(contains(accVars, [var,'_NF_HP']))
		T = add_highpass_RPM_filter_variables(T, {[var,'_NF']}, {[var,'_NF_HP']},...
			cut, 'harm', cutShift, fs);
	end

	% remove any temporary component 
	remVars = remVars(not(ismember(remVars, accVars)));
	T = cellfun(@(c) removevars(c, remVars), T, 'UniformOutput',false);