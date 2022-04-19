function [ROC,AUC] = make_roc_curve_matrix_per_intervention_and_speed(...
		F, classifiers, stateVar, predStates, pooledLevs, bestAxVar, pooledSpeed)
	% Make ROC matrix per speed and balloon states, with following info:
	% - x and y curve points
	% - AUC
	% - Optimal curve point
	% The info is stored in the common output struct R
	
	welcome('Make ROC matrix','function')
	
	if nargin<7, pooledSpeed = false; end
	lookupBL = nargin>5 && not(pooledLevs) && not(pooledSpeed);

	AUC = table;
	ROC = struct;
	speeds = unique(F.pumpSpeed);
	
	% No of bootstrap iterations to calculate AUC confidence intervals
	nBootItr = 1;
	
	ROC.pooledSpeed = pooledSpeed;
	ROC.pooledLevs = pooledLevs;
	ROC.classifiers = classifiers;
	ROC.stateVar = stateVar;
	ROC.predStates = predStates;
	ROC.speeds = speeds;

	nPredStateRows = size(predStates,1);
	nCols = numel(speeds);
	if pooledSpeed, nCols = 1; end
	waitIncr = 1/(nPredStateRows*nCols*numel(classifiers));
	multiWaitbar('Making ROC matrix',0);
	
	for i=1:nPredStateRows
		
		[state_inds, F] = add_bool_state_for_roc(pooledLevs, F, stateVar, predStates{i,1});

		for j=1:nCols
			
			ctrl_inds = F.interventionType=='Control';
			inds = (state_inds | ctrl_inds );
			if not(pooledSpeed)
				speed_inds = F.pumpSpeed==speeds(j);
				inds = inds & speed_inds;
			end

			for k=1:numel(classifiers)
				multiWaitbar('Making ROC matrix', 'Increment',waitIncr);
	
				% Lookup control data for corresponding best axis 
				if lookupBL && contains(classifiers{k},bestAxVar)
					F = get_best_axis_bl(F, ctrl_inds, speed_inds, classifiers{k});
				end

				% Can use best axis var to lookup up the control intervention.
				[ROC.X{i,j,k},ROC.Y{i,j,k},~,ROC.AUC{i,j,k},ROC.opt_roc_pt{i,j,k}] = ...
					perfcurve(F.state(inds), F.(classifiers{k})(inds),...
					1, "NBoot",nBootItr);

				% Compile a output text table sorted by speed and predState
				ind = i+(j-1)*nPredStateRows;
				AUC.PumpSpeed(ind) = speeds(j);
				AUC.predState{ind} = predStates{i,1};
				AUC.(classifiers{k}){ind} = sprintf("%1.2f [%1.2f - %1.2f]",...
					ROC.AUC{i,j,k}(1),ROC.AUC{i,j,k}(2),ROC.AUC{i,j,k}(3));
			end
		
		end
		
	end
	

	
