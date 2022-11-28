function F = calc_pow_norm(F, newVar, vars)

	F.(newVar) = sqrt( sum( F{:,vars}.^2,2,"omitnan"));