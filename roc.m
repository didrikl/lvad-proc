F2 = F(not(ismember(F.seq,'Seq7')),:);

nBootItr = 1000;

F.effA = F.h3A > 4.75;
ROC.T1 = make_roc_struct(F, 'effA', nBootItr);
multiWaitbar('Making ROC', 0.33);

F.effA = F.h3A > 4.75;
ROC.T1 = make_roc_struct(F, 'effA', nBootItr);
multiWaitbar('Making ROC', 0.33);

F.effA2 = F.h3A > 20;
ROC.T2 = make_roc_struct(F, 'effA', nBootItr);
multiWaitbar('Making ROC', 0.99);

ROC.PLVAD = make_roc_struct(F, 'P_LVAD_change', nBootItr);
multiWaitbar('Making ROC', 0.1);

multiWaitbar('Making ROC', 'close')

function ROC_T1 = make_roc_struct(F, stateVar, nBootItr)
	stateVal = 1;
	[x, y, t, auc, optPt] = perfcurve(F.(stateVar), F.h3B, stateVal, nBootItr);
	ROC_T1.X = x; % 1-specificities (FPR) and corresponding CI
	ROC_T1.Y = y; % sensitivities (TPR) and corresponding CI
	ROC_T1.T = t; % threshold (cut-off) values
	ROC_T1.AUC = auc; % AUC and upper and lower bounds of CI
	ROC_T1.Optimal_Point = optPt; % optimal ROC point
end