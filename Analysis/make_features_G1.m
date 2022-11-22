function F = make_features_G1(sequences, Data, partSpecNo, idSpecs, accVars, noteVars)
	
	noteVarsNeeded = {
		'part'               
		'intervType'         
		'event' 
		'CO'
		'Q_LVAD'             
		'P_LVAD'      
		'balDiam'
		'balLev'         
		'pumpSpeed'          
		'QRedTarget_pst'
		'embVol'
		'embType'
		};

	nSeqs = numel(sequences);
	F = cell(nSeqs,1);
	
	for i=1:nSeqs

		Notes = Data.G1B.(sequences{i}).Notes;
		T = Data.G1B.(sequences{i}).Plot_Data.T{partSpecNo};
		t = Data.G1B.(sequences{i}).Plot_Data.RPM_Order_Map{partSpecNo}.time;
		
		T = join_notes(T, Notes, noteVarsNeeded);
		T = T(ismember(T.analysis_id, idSpecs.analysis_id),:);
		T.dur = linspace(0,1/750*height(T),height(T))';

		% TODO: Replace with the use of analysis_id and noteRow, so that
		% multiple P_LVAD notes are avergaged for each analysis segment
		segs = get_segment_info(T, 'dur');
		F{i} = segs.main;
		
		for j=1:numel(accVars)
			var = accVars{j};
			mags = Data.G1B.(sequences{i}).Plot_Data.RPM_Order_Map{partSpecNo}.([var,'_mags']);
			[~, ~, segs] = calc_harmonic_salience_per_seg(mags, t, segs);
			F{i}.([var,'_h1Avg']) = segs.main.h1Avg;
			F{i}.([var,'_h2Avg']) = segs.main.h2Avg;
			F{i}.([var,'_h3Avg']) = segs.main.h3Avg;
			F{i}.([var,'_h4Avg']) = segs.main.h4Avg;
		end
	
		% in case multiple registrations of noted vars, use the mean
		for j=1:numel(noteVars)
			var = noteVars{j};
			segs = calc_noted_avg(T, segs, var);
			F{i}.(var) = segs.main.(var);
		end

		F{i} = join(F{i}, idSpecs, "Keys","analysis_id");
		F{i}.id = sequences{i} + "_" + string(F{i}.idLabel);
		F{i}.seq = repmat(string(sequences{i}),height(F{i}),1);

	end
	
	F = merge_table_blocks(F);

	F = remove_variables(F, {'analysisDuration','pumpSpeed_left','balLev_xRay','QRedTarget_pst_left','isClamp','isBalloon','isInjection','isIntraSeg','categoryLabel','contingency','QRedTarget_pst_right','pumpSpeed_right','balLev','balDiam','balHeight','arealObstr_pst','catheter'});
	F = remove_variables(F, {'isBaseline','isEcho','isSteadyState','isWashout','isTransitional','isNominal','extra'});
	F = remove_variables(F, {'endInd','startInd','midInd','EndInd','StartInd','MidInd','StartDur','EndDur','MidDur'});

	F = movevars(F, 'embVol', 'Before', 1);
	F = movevars(F, 'embType', 'Before', 1);
	F = movevars(F, 'intervType', 'Before', 1);
	F = movevars(F, 'event', 'Before', 1);
	F = movevars(F, 'seq', 'Before', 1);
	F = movevars(F, 'bl_id', 'Before', 1);
	F = movevars(F, 'analysis_id', 'Before', 1);
	F = movevars(F, 'levelLabel', 'Before', 1);
	F = movevars(F, 'idLabel', 'Before', 1);
	F = movevars(F, 'id', 'Before', 1);
	
end

function segs = calc_noted_avg(T, segs, var)
	segs.main.(var) = nan(height(segs.main),1);
	for i=1:height(segs.main)
		inds = T.dur>=segs.main.StartDur(i) & T.dur<segs.main.EndDur(i);
		segs.main.(var)(i) = mean(T.(var)(inds),'omitnan');
	end
end