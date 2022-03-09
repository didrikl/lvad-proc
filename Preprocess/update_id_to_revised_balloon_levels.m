function Notes = update_id_to_revised_balloon_levels(Notes)

	% Note: Level 0 is unaltered always.
	inds = find(Notes.balLev_xRay>0);
	
	for i=1:numel(inds)
		
		lev = Notes.balLev_xRay(inds(i));
		speed = Notes.pumpSpeed(inds(i));
		
		echo = contains(string(Notes.analysis_id(inds(i))),' E');

		if lev==1 && speed==2200, Notes.analysis_id(inds(i)) = '4.1'; end
		if lev==2 && speed==2200, Notes.analysis_id(inds(i)) = '4.2'; end
		if lev==3 && speed==2200, Notes.analysis_id(inds(i)) = '4.3'; end
		if lev==4 && speed==2200, Notes.analysis_id(inds(i)) = '4.4'; end
		if lev==5 && speed==2200, Notes.analysis_id(inds(i)) = '4.5'; end
		
		if lev==1 && speed==2400, Notes.analysis_id(inds(i)) = '3.1'; end
		if lev==2 && speed==2400, Notes.analysis_id(inds(i)) = '3.2'; end
		if lev==3 && speed==2400, Notes.analysis_id(inds(i)) = '3.3'; end
		if lev==4 && speed==2400, Notes.analysis_id(inds(i)) = '3.4'; end
		if lev==5 && speed==2400, Notes.analysis_id(inds(i)) = '3.5'; end

		if lev==1 && speed==2600, Notes.analysis_id(inds(i)) = '5.1'; end
		if lev==2 && speed==2600, Notes.analysis_id(inds(i)) = '5.2'; end
		if lev==3 && speed==2600, Notes.analysis_id(inds(i)) = '5.3'; end
		if lev==4 && speed==2600, Notes.analysis_id(inds(i)) = '5.4'; end
		if lev==5 && speed==2600, Notes.analysis_id(inds(i)) = '5.5'; end

		if echo
			Notes.analysis_id(inds(i)) = string(Notes.analysis_id(inds(i)))+" E";
		end

	end