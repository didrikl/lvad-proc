function [F, F_rel, F_del, G, G_rel, G_del] = sort_by_level_order(F, levSortOrder, F_rel, F_del, G, G_rel, G_del)
	F.levelLabel = categorical(F.levelLabel, levSortOrder, 'Ordinal',true);
	F_rel.levelLabel = categorical(F_rel.levelLabel, levSortOrder, 'Ordinal',true);
	F_del.levelLabel = categorical(F_del.levelLabel, levSortOrder, 'Ordinal',true);

	G_fields = fieldnames(G);
	for i=1:numel(G_fields)
		G.(G_fields{i}).levelLabel = categorical(...
			G.(G_fields{i}).levelLabel, levSortOrder, 'Ordinal',true);
		G_rel.(G_fields{i}).levelLabel = categorical(...
			G_rel.(G_fields{i}).levelLabel, levSortOrder, 'Ordinal',true);
		G_del.(G_fields{i}).levelLabel = categorical(...
			G_del.(G_fields{i}).levelLabel, levSortOrder, 'Ordinal',true);
	end