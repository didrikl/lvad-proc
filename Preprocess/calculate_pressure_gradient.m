function T = calculate_pressure_gradient(T, pGradVars)

	welcome('Calculate pressure gradient','function')
	
	if isempty(pGradVars)
		T = add_empty_grad(T);
		return
	end

	affVar = pGradVars{1};
	effVar = pGradVars{2};

	noiseThreshold = 0.01;
	
	[returnAsCell,T] = get_cell(T);
	
	for i=1:numel(T)
		
		isEmpty = display_block_info(T{i},i,numel(T),not(returnAsCell));
        if isEmpty, continue; end
		
		pAvg_aff = mean(T{i}.(affVar));
		pAvg_eff = mean(T{i}.(effVar));
		
		isOnlyAffNoise = pAvg_aff<noiseThreshold;
		isOnlyEffNoise = pAvg_eff<noiseThreshold;
		
		% Check for missing recording
		if isOnlyAffNoise || isOnlyEffNoise
			T{i}.pGrad = nan(height(T{i}),1);
		else
			if pAvg_eff<pAvg_aff
				warning('Negative mean pressure gradient')
			end
			T{i}.pGrad = T{i}.(effVar) - T{i}.(affVar);
		end
		
		nan_inds = isnan(T{i}.pGrad);
		if any(nan_inds)
			warning(sprintf(...
				['There is %g pst NaNs in pressure gradient in ',...
				'block %d'],100*nnz(nan_inds)/height(T{i}.pGrad),i));
		end
		
		T{i} = add_prop(T{i},T{i}.Properties.VariableUnits(affVar));
		T{i} = movevars(T{i},'pGrad','After',effVar);
	end
	
	if not(returnAsCell), T = T{1}; end

function PL= add_empty_grad(PL)
	for i=1:numel(PL)
		PL{i}.pGrad = nan(height(PL{i}),1);
		PL{i} = add_prop(PL{i},{''});
	end
	warning('Pressure gradient is created as NaNs')

function PL = add_prop(PL,unit)
	PL.Properties.VariableUnits('pGrad') = unit;
	PL.Properties.VariableContinuity('pGrad') = {'continuous'};
	PL.Properties.VariableDescriptions{'pGrad'} = ...
		'Pressure gradient over LVAD: Efferent minus afferent pressure';
	