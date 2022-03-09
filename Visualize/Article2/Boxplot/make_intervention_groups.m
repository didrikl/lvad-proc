function group = make_intervention_groups(F, levs)
	grpLab = {
		'BL'
		'Lev 1-4 (35%-84%)'
		'Graft clamp'
		'Unclamp/deflation'
		'Lev 5 (>85%)'
		};
	grpOrder = grpLab([3,1,2,5,4]);
	group = categorical(repmat(missing,height(F),1),grpOrder,'Ordinal',true);
	
	% Assign rows into groups
	group(ismember(F.levelLabel,{'Balloon, Nominal','Clamp, Nominal','RPM, Nominal'})) = grpLab{1};
	group(ismember(F.balLev,levs)) = grpLab{2};
	group(ismember(F.levelLabel,{'Clamp,  25%','Clamp,  50%','Clamp,  75%'})) = grpLab{3};
	group(ismember(F.interventionType,'Reversal')) = grpLab{4};
	group(ismember(F.balLev,{'5'})) = grpLab{5};
end