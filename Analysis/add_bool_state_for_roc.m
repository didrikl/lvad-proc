function [state_inds, F] = add_bool_state_for_roc(pooled, F, stateVar, predStates)
		
	% TODO: Implement generic and flexible predStats of upper and lower bounds

		if pooled
			
			if numel(predStates)==1 && isnumeric(predStates)
				state_inds = F.(stateVar)>=predStates;
			elseif numel(predStates)>1
				state_inds = ismember(F.(stateVar),predStates);
			end

		elseif not(pooled)

			state_inds = F.(stateVar)==predStates;
		
		end
		
		% Make and use a logical state column in F, to support pooled states
		F.state = zeros(height(F),1);
		F.state(state_inds) = 1;
end