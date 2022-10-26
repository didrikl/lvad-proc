function plot_h3(Pxx)
	varsA = {'accA_x_b2_pow','accA_y_b2_pow','accA_z_b2_pow'};
	varsB = {'accB_x_b2_pow','accB_y_b2_pow','accB_z_b2_pow','accB_norm_b2_pow'};

	BM = Pxx.bandMetrics(:,[{'analysis_id'},varsA,varsB]);

	BM.maxB = max(BM{:,varsB},[],2);
	BM.maxA = max(BM{:,varsA},[],2);

	BM = sortrows(BM,'analysis_id','descend');
	blRows = contains(string(BM.analysis_id),'7.0');
	BL = BM(blRows,:);
	BM(blRows,:) = [];

	BM = sortrows(BM,'maxA','ascend');
	woRows = contains(string(BM.analysis_id),'7.3');
	WO = BM(woRows,:);
	BM(woRows) = [];

	ALL = [BL;BM;WO];

	stackedplot(ALL(:,{'maxA','maxB'}),"XLabel",'analysis_id');
