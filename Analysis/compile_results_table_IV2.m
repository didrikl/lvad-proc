function [B, C] = compile_results_table_IV2(R, R_rel)
	% One sorted and combined results table with absolute and relative results

	balLevs = {
		'Nominal'
		'Inflated, 4.31 mm'
		'Inflated, 4.73 mm'
		'Inflated, 6.00 mm'
		'Inflated, 6.60 mm'
		'Inflated, 7.30 mm'
		'Inflated, 8.52 mm'
		'Inflated, 9 mm'
		'Inflated, 10 mm'
		'Inflated, 11 mm'
		'Inflated, 12 mm'
		};
	claLevs = {
		'Afterload, Nominal'
		'Afterload Q red., 20%'
		'Afterload Q red., 40%'
		'Afterload Q red., 60%'
		'Afterload Q red., 80%'
		'Preload, Nominal'
		'Preload Q red., 10%'
		'Preload Q red., 20%'
		'Preload Q red., 40%'
		'Preload Q red., 60%'
		'Preload Q red., 80%'
		};
	sortLevs = [balLevs;claLevs];
	relVars = {
		'P_LVAD_mean'
		'Q_mean'
		};
	columOrder = {
		'pumpSpeed'
		'levelLabel'
		'P_LVAD_mean'
		'P_LVAD_mean_p'
		'Q_mean'
		'Q_mean_p'
		'Q_mean_rel'
		'Q_mean_rel_p'
		'accA_x_NF_b1_pow'
		'accA_x_NF_b1_pow_p'
		'accA_y_NF_b1_pow'
		'accA_y_NF_b1_pow_p'
		'accA_z_NF_b1_pow'
		'accA_z_NF_b1_pow_p'
		};

 	R.levelLabel = categorical(R.levelLabel, sortLevs, 'Ordinal',true);
 	R_rel.levelLabel = categorical(R_rel.levelLabel, sortLevs, 'Ordinal',true);

	% Sort according to ordinal order
	R = sortrows(R, {'pumpSpeed','levelLabel'});
	R_rel = sortrows(R_rel, {'pumpSpeed','levelLabel'});
	
	R_rel = convert_to_percent(R_rel, relVars);
	%R = join(R,R_rel, 'Keys',{'levelLabel'}, 'RightVariables',relVars);
	R = [R,R_rel];
	
	R = split_cells(R);
	
	B = R(ismember(R.levelLabel, balLevs),columOrder);
	C = R(ismember(R.levelLabel, claLevs),columOrder);

function R2 = split_cells(R)
	R2 = split(R{:,3:end});
	R21 = R2(:,:,1);
	R22 = R2(:,:,2);
	P = R2(:,:,3);
	P = erase(P,("("|")"));
	R2 = R21+" "+R22;
	R2 = table(R2);
	R2 = splitvars(R2,'R2','NewVariableNames',R.Properties.VariableNames(3:end));
	P = table(P);
	P = splitvars(P,'P','NewVariableNames',R.Properties.VariableNames(3:end)+"_p");
	
	R2 = [R(:,1:2),R2, P];

	
function T = convert_to_percent(R_rel, relVars)
	T = split(R_rel{:,relVars});
	P1 = string(100*double(T(:,:,1)));
	P2 = "["+100*double(erase(T(:,:,2),{'[',']'}))+"]";
	T = P1+" "+P2+" "+T(:,:,3);
	T = table(T);
	T = splitvars(T,'T','NewVariableNames',relVars+"_rel");
	