function T = add_order_track(map, order, rpm, mapTime, T, newVar)
	map = db2pow(map);
 	[mag,~,orderTime] = ordertrack(map,order,rpm,mapTime,3);
 	orderTime = seconds(orderTime);
 	Mag = timetable(orderTime',mag','VariableNames',{'harmonic3'});
 	Mag = retime(Mag,seconds(T.dur),"linear");
 	T.(newVar) = Mag.harmonic3;
