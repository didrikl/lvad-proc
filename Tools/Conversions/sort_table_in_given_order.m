function T = sort_table_in_given_order(sort_order, T, key)
	inds = cell(numel(sort_order),1);
	for i=1:numel(sort_order)
		inds{i} = find(ismember(T.(key),sort_order{i}))';
	end
	T = T([inds{:}]',:);
end