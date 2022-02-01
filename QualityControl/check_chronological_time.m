function isNotChrono = check_chronological_time(T,var)
	% Get and display note (set of) rows for which the time is not increasing
	
	if nargin<2, var='time'; end

	isNotChrono = [diff(T.(var))<0;0];
	if any(isNotChrono)
		notChrono_rows = find(isNotChrono);
		fprintf('\nNon-chronological timestamps found:\n\n')
		for i=1:numel(notChrono_rows)
			non_chronological_timestamps = ...
				T(notChrono_rows(i):notChrono_rows(i)+1,:);
			disp(non_chronological_timestamps);
		end
	else
		fprintf('\nAll time stamps are chronological')
	end
