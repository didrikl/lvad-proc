function T = extract_from_data(Data, partSpec, eventsToClip)
	
	% Note: Only needed to do diff from baseline calculations
	%       Joining notes can also be done when plotting
	noteVars = {
		'intervType'         
		'event'              
		'Q_LVAD'
		'QRedTarget_pst'
		'P_LVAD'             
		'pumpSpeed'
		'balLev'
		'embVol'
		'embType'
		};
	Notes = Data.Notes;
	partNo = partSpec{2};
	T = cell(numel(partNo),1);
	for i=1:numel(partNo)
		if partNo>numel(Data.S_parts)
			error('Given part (%s) exceeds number of parts in data (%d)',...
				num2str(partNo), numel(S_parts));
		end
		T{i} = Data.S_parts{partNo(i)};
		if height(T{i})==0
			error('Part no %d is empty', partNo(i));
		end
	end
	if numel(partNo)>1
		T = merge_table_blocks(T);
	else
		T = T{1};
	end
	T = join_notes(T, Notes, noteVars);
	
	% In case baseline is to be taken from a separate part
	T = add_specified_baseline_first(partSpec, Data, Notes, noteVars, partNo, T);

	if not(isempty(eventsToClip))
		T(ismember(T.event, eventsToClip),:)=[];
	end

end

function T = add_specified_baseline_first(partSpec, Data, Notes, noteVars, partNo, T)
	if not(isempty(partSpec{1}))
		blPartNo = partSpec{1}(1);
		blRow = partSpec{1}(2);
		
		% Extract BL part 
		if blPartNo>numel(Data.S_parts)
			error('Given BL part (%d) exceeds number of parts in data (%d)',...
				blPartNo, numel(S_parts));
		end
		BL = Data.S_parts{blPartNo};
		BL = join_notes(BL, Notes, noteVars);		
		if height(BL)==0
			error('BL part (%d) is empty',partNo);
		end

		% Check if specificed BL row actually exist in data 
		bl_inds = BL.noteRow==blRow;
		if nnz(bl_inds)==0
			error(['Given BL row (%d) in not in BL part (%d)'...
				'\nCheck the Notes for correct BL line specfication'],...
			blRow, blPartNo)
		end

		% Ensure that specificed BL row is denoted Baseline in intervType
		if not(contains(lower(string(Notes.event(blRow))),'baseline'))
			warning(['Given baseline note row %d is not stored as ',...
				'Baseline in Notes file.'],blRow)
			Notes(blRow,:)
			BL.intervType(bl_inds) = {'Baseline'};
		end

		BL = BL(bl_inds,:);
		T = merge_table_blocks(BL,T);
	end
end