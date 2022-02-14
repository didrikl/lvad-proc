function rpm = parse_rpm_input(rpm, nParts)
	if numel(rpm)==1, rpm = repmat(rpm,nParts,1); end
	if numel(rpm)==0, rpm = cell(nParts,1); end
end