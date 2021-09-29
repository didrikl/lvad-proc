function PL = calculate_pressure_gradient(PL,affVar,effVar)
	
	noiseThreshold = 0.01;
	
	welcome('Calculate pressure gradient','function')
	[returnAsCell,PL] = get_cell(PL);
	
	for i=1:numel(PL)
		
		isEmpty = display_block_info(PL{i},i,numel(PL),not(returnAsCell));
        if isEmpty, continue; end
		
		pAvg_aff = mean(PL{i}.(affVar));
		pAvg_eff = mean(PL{i}.(effVar));
		
		isOnlyAffNoise = pAvg_aff<noiseThreshold;
		isOnlyEffNoise = pAvg_eff<noiseThreshold;
		
		% Check for missing recording
		if isOnlyAffNoise || isOnlyEffNoise
			PL{i}.pGrad = nan(height(PL{i}),1);
		else
			if pAvg_eff<pAvg_aff
				warning('Negative mean pressure gradient')
			end
			PL{i}.pGrad = PL{i}.p_eff - PL{i}.p_aff;
		end
		
		nan_inds = isnan(PL{i}.pGrad);
		if any(nan_inds)
			warning(sprintf(...
				['There is %g pst NaNs in pressure gradient in ',...
				'block %d'],100*nnz(nan_inds)/height(PL{i}.pGrad),i));
		end
		
		PL{i}.Properties.VariableUnits('pGrad') = ...
			PL{i}.Properties.VariableUnits(affVar);
		PL{i}.Properties.VariableContinuity('pGrad') = {'continuous'};
		PL{i}.Properties.VariableDescriptions{'pGrad'} = ...
			'Pressure gradient over LVAD: Efferent minus afferent pressure';
		PL{i} = movevars(PL{i},'pGrad','After',effVar);
	end
	
	if not(returnAsCell), T = T{1}; end