function check_lvad_pressure_gradient_channels(PL,affVar,effVar)
	
	noiseThreshold = 0.01;
	lowEffThreshold = 30;
	
	welcome('Check LVAD pressure gradient channels','function')
	
	for i=1:numel(PL)
		
		isEmpty = display_block_info(PL{i},i,numel(PL));
        if isEmpty, continue; end
		
		isAllNanAff = all(isnan(PL{i}.(affVar)));
		isAllNanEff = all(isnan(PL{i}.(affVar)));
		negAff_inds = find(PL{i}.(affVar)<0);
		negEff_inds = find(PL{i}.(effVar)<0);
		negGrad_inds = find(PL{i}.(affVar)>PL{i}.(effVar));
		isNegMeanGrad = mean(PL{i}.(affVar))>mean(PL{i}.(effVar));
		isOnlyAffNoise = mean(PL{i}.(affVar))<noiseThreshold;
		isOnlyEffNoise = mean(PL{i}.(effVar))<noiseThreshold;
		isLowEff = mean(PL{i}.(effVar))<lowEffThreshold;
		
		% Check for missing recording
		if isAllNanAff
			warning('Afferent pressures is missing');
		elseif isOnlyAffNoise
			warning('Afferent pressures is may be only noise');
		end
		if isAllNanEff
			warning('Efferent pressures in PowerLab block %d is missing');
		elseif isOnlyEffNoise
			warning('Efferent pressures in PowerLab block %d is may be only noise');
		end
		
		% Warn for possibly swapped channel inputs
		warnDlgMsg = '';
		if isNegMeanGrad && not(isOnlyEffNoise) && not(isAllNanAff && isAllNanEff)
			warnDlgMsg = sprintf('%d pst afferent pressures > efferent pressures',...
				100*nnz(negGrad_inds)/numel(negGrad_inds));
			warning(warnDlgMsg);
		elseif isLowEff && not(isOnlyEffNoise)
			warnDlgMsg = 'Low mean efferent pressure';
			warning(warnDlgMsg)
		end
	
		% Check for negative pressures
		if any(negEff_inds) && not(isOnlyEffNoise)
			warning(sprintf('%g pst negative efferent pressures',...
				100*nnz(negEff_inds)/numel(negEff_inds)));
		end
		if any(negAff_inds) && not(isOnlyAffNoise)
			fprintf('%g pst negative afferent pressures',...
				100*nnz(negAff_inds)/numel(negAff_inds));
		end
		
	end
	
	if not(isempty(warnDlgMsg))
		opts = struct('WindowStyle','non-modal','Interpreter','none');
		warndlg(warnDlgMsg,'Warning, Pressure channels',opts)
	end