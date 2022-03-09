function [ROC,AUC] = make_roc_curve_matrix_per_intervention_and_speed(...
		F, classifiers, stateVar, predStates, pooled, bestAxVar)
	% Make ROC matrix per speed and balloon states, with following info:
	% - x and y curve points
	% - AUC
	% - Optimal curve point
	% The info is stored in the common output struct R
	
	welcome('Make ROC matrix','function')
	
	AUC = table;
	ROC = struct;
	speeds = unique(F.pumpSpeed);
	
	% No of bootstrap iterations to calculate AUC confidence intervals
	nBootItr = 1000;
	
	ROC.pooled = pooled;
	ROC.classifiers = classifiers;
	ROC.stateVar = stateVar;
	ROC.predStates = predStates;
	ROC.speeds = speeds;

	nPredStateRows = size(predStates,1);
	nSpeedCols = numel(speeds);
	nClassifiers = numel(classifiers);
	waitIncr = 1/(nPredStateRows*nSpeedCols*nClassifiers);
	multiWaitbar('Making ROC matrix',0);
	for i=1:nPredStateRows
		
		if pooled,      state_inds = F.(stateVar)>=predStates{i,1}; end
		if not(pooled), state_inds = F.(stateVar)==predStates{i,1}; end
				
		for j=1:nSpeedCols
			
			ctrl_inds = F.interventionType=='Control';
			inds = (state_inds | ctrl_inds ) & F.pumpSpeed==speeds(j);
			
			for k=1:nClassifiers
				multiWaitbar('Making ROC matrix','Increment',waitIncr);
	
				% Lookup control data for corresponding best axis 
				if contains(classifiers{k},bestAxVar) && not(pooled)
					best_ctrl_inds = find(ctrl_inds & F.pumpSpeed==speeds(j));
					for l=1:numel(best_ctrl_inds)
						ctrl_ax = F.([classifiers{k},'_var']){best_ctrl_inds(l)};
						F.(classifiers{k})(best_ctrl_inds(l)) = ...
							F.(ctrl_ax)(best_ctrl_inds(l));
					end
				end

				% Can use best axis var to lookup up the control intervention.
				[ROC.X{i,j,k},ROC.Y{i,j,k},~,ROC.AUC{i,j,k},ROC.opt_roc_pt{i,j,k}] = ...
					perfcurve(F.(stateVar)(inds), F.(classifiers{k})(inds),...
					predStates{i,1}, "NBoot",nBootItr);

				% Compile a output text table sorted by speed and predState
				ind = i+(j-1)*nPredStateRows;
				AUC.PumpSpeed(ind) = speeds(j);
				AUC.predState{ind} = predStates{i,1};
				AUC.(classifiers{k}){ind} = sprintf("%1.2f [%1.2f - %1.2f]",...
					ROC.AUC{i,j,k}(1),ROC.AUC{i,j,k}(2),ROC.AUC{i,j,k}(3));
			end
		
		end
		
	end
	
	
	
