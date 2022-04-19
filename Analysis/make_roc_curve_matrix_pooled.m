function [ROC,AUC] = make_roc_curve_matrix_pooled(...
		F, classifiers, stateVar, predStates)
	% Make ROC matrix per different pooled balloon states, with following info:
	% - x and y curve points
	% - AUC
	% - Optimal curve point
	% The info is stored in the common output struct R
	
	welcome('Make ROC matrix','function')
	
	AUC = table;
	ROC = struct;
	
	% No of bootstrap iterations to calculate AUC confidence intervals
	nBootItr = 1000;
	
	ROC.pooled = true;
	ROC.classifiers = classifiers;
	ROC.stateVar = stateVar;
	ROC.predStates = predStates;
	ROC.speeds = unique(F.pumpSpeed);

	nPredStateRows = size(predStates,1);
	waitIncr = 1/(nPredStateRows*numel(classifiers));
	multiWaitbar('Making ROC matrix',0);
	for i=1:nPredStateRows
		
% 		if isnumeric(predStates{i,1})
			state_inds = double(string(F.(stateVar)))>=predStates{i,1};
% 		end
		ctrl_inds = F.interventionType=='Control';
		inds = (state_inds | ctrl_inds );

		for k=1:numel(classifiers)
			multiWaitbar('Making ROC matrix', 'Increment',waitIncr);

			% Can use best axis var to lookup up the control intervention.
			[ROC.X{i,1,k},ROC.Y{i,1,k},~,ROC.AUC{i,1,k},ROC.opt_roc_pt{i,1,k}] = ...
				perfcurve(F.(stateVar)(inds), F.(classifiers{k})(inds),...
				predStates{i,1}, "NBoot",nBootItr);

			% Compile a output text table sorted by speed and predState
			AUC.predState{i} = predStates{i,1};
			AUC.(classifiers{k}){i} = sprintf("%1.2f [%1.2f - %1.2f]",...
				ROC.AUC{i,1,k}(1),ROC.AUC{i,1,k}(2),ROC.AUC{i,1,k}(3));

		end

	end
