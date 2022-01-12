function segIDs = make_segment_id_for_given_rpm(rpm, segIDs)
	rpm_id = num2str(find(ismember([2200,2500,2800,3100],rpm)));
	segIDs = replaceBetween(segIDs,2,2,rpm_id);
end
