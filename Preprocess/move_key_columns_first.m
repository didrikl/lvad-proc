function S = move_key_columns_first(S)
	%S.noteRow = categorical(S.noteRow)
	S = movevars(S, 'noteRow', 'Before', 1);
	S = movevars(S, 'bl_id', 'Before', 1);
	S = movevars(S, 'analysis_id', 'Before', 1);
end