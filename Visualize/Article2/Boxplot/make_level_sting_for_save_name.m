function levStr = make_level_sting_for_save_name(levs)
	if numel(levs)==1
		levStr = ['Level ',levs{1}];
	else
		levStr = ['Levels ',levs{1},'-',levs{end},' pooled'];
	end