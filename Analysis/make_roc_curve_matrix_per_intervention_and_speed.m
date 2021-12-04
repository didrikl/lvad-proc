function [R,AUC] = make_roc_curve_matrix_per_intervention_and_speed(...
		F,classifiers,stateVar,predStates,pooled)
	% Make ROC matrix per speed and balloon states, with following info:
	% - x and y curve points
	% - AUC
	% - Optimal curve point
	% The info is stored in the common output struct R
	
	AUC = table;
	R = struct;

	speeds = [2200,2500,2800,3100];
	
	% No of bootstrap iterations to calculate AUC confidence intervals
	nBootItr = 1000;
	
	R.pooled = pooled;
	R.classifiers = classifiers;
	R.stateVar = stateVar;
	R.predStates = predStates;

	nPredStateRows = size(predStates,1);
	nSpeedCols = numel(speeds);
	
	for i=1:nPredStateRows
		
		if pooled
			state_inds = F.(stateVar)>=predStates{i,1};
		else
			state_inds = F.(stateVar)==predStates{i,1};
		end
				
		for j=1:nSpeedCols
			
			inds = (state_inds | F.interventionType=='Control' )...
				& F.pumpSpeed==speeds(j);
			
			for k=1:numel(classifiers)
			
				[R.X{i,j,k},R.Y{i,j,k},~,R.AUC{i,j,k},R.opt_roc_pt{i,j,k}] = ...
					perfcurve(F.(stateVar)(inds),F.(classifiers{k})(inds),...
					predStates{i,1},"NBoot",nBootItr);

				% Compile a output text table sorted by speed and predState
				ind = i+(j-1)*nPredStateRows;
				AUC.PumpSpeed(ind) = speeds(j);
				AUC.predState{ind} = predStates{i,1};
				AUC.(classifiers{k}){ind} = sprintf("%1.2f [%1.2f - %1.2f]",...
					R.AUC{i,j,k}(1),R.AUC{i,j,k}(2),R.AUC{i,j,k}(3));
			end
		
		end
		
	end
	
	
	
