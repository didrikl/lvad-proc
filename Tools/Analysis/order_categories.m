function T = order_categories(T, catVar, orders)
	T.(catVar) = ordinal(T.(catVar)); 
	T.(catVar) = reorderlevels(T.(catVar), string(unique(orders,'stable')));
