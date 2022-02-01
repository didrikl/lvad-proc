function isUndefCat = check_missing_essential_info(T, mustHaveCats)
	% Get and display rows with missing essential categoric info
	
	isUndefCat = any(ismissing(T(:,mustHaveCats)),2);
	if any(isUndefCat)
		fprintf('\n\nEssential categoric info missing:\n\n')
		missing_categories = T(isUndefCat,:);
		disp(missing_categories)
	end