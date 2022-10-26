%function h = plot_h3(Pxx)
	h3bA = {'accA_x_b2_pow','accA_y_b2_pow','accA_z_b2_pow'};
	h3bB = {'accB_x_b2_pow','accB_y_b2_pow','accB_z_b2_pow','accB_norm_b2_pow'};
	r1bA = {'accA_x_b3_pow','accA_y_b3_pow','accA_z_b3_pow'};
	r1bB = {'accB_x_b3_pow','accB_y_b3_pow','accB_z_b3_pow','accB_norm_b3_pow'};
	r2bA = {'accA_x_b4_pow','accA_y_b4_pow','accA_z_b4_pow'};
	r2bB = {'accB_x_b4_pow','accB_y_b4_pow','accB_z_b4_pow','accB_norm_b4_pow'};
	vars = [h3bA,h3bB,r1bA,r1bB,r2bA,r2bB];
	
	%BM = Pxx.bandMetrics(:,[{'analysis_id','id'},vars]);
	BM = F_del(:,[{'analysis_id','id'},vars]);
	BM = BM(contains(string(BM.analysis_id),'7.'),:);
	
   	BM{:,h3bA} = BM{:,h3bA}-BM{:,r2bA};
   	BM{:,h3bB} = BM{:,h3bB}-BM{:,r2bB};
	BM{:,[h3bA,h3bB]} = max(BM{:,[h3bA,h3bB]},0.00001);
	BM{:,[h3bA,h3bB]} = pow2db(BM{:,[h3bA,h3bB]});
	
	BM.maxB = max(BM{:,h3bB},[],2);
	BM.maxA = max(BM{:,h3bA},[],2);
	
	BM = sortrows(BM,'analysis_id','descend');
	blRows = contains(string(BM.analysis_id),'7.0');
	woRows = contains(string(BM.analysis_id),'7.3');
	ptRows = contains(string(BM.analysis_id),'7.2');
	
	BL = BM(blRows,:);
	PT = BM(ptRows,:);
	PT = sortrows(PT,'maxA','ascend');
	WO = BM(woRows,:);
	WO = sortrows(WO,'maxA','ascend');
	
	ALL = [BL;sortrows([PT;WO],'maxB','ascend')];	
	figure('Position',[20,20,500,750])
	h = stackedplot(ALL(:,{'maxA','maxB'}));
    h.Marker = '.';
	h.MarkerSize = 15;

close all
nBins = 3;
figure
[counts,edges] = histcounts(ALL.maxB, nBins);
[counts1,edges1] = histcounts(PT.maxB, edges);
[counts2,edges2] = histcounts(WO.maxB, edges);
[counts3,edges3] = histcounts(BL.maxB, edges);
bar(edges(1:end-1)+diff(edges),[counts1;counts2;counts3],'stacked')

figure
[counts,edges] = histcounts(ALL.maxA, nBins);
[counts1,edges1] = histcounts(PT.maxA, edges);
[counts2,edges2] = histcounts(WO.maxA, edges);
[counts3,edges3] = histcounts(BL.maxA, edges);
bar(edges(1:end-1)+diff(edges),[counts1;counts2;counts3],'stacked')

figure('Position',[20,20,500,500])
hold on
scatter(BL.maxA,BL.maxB,'filled')
scatter(PT.maxA,PT.maxB)
scatter(WO.maxA,WO.maxB)

% 	boxplot()
% 	
%ALL.type() = 1