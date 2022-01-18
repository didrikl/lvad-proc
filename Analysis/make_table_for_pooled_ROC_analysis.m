function F_ROC = make_table_for_pooled_ROC_analysis(F,F_del)
	F_ROC = join(F,F_del(:,{'id'}),'keys','id');
	
	% Make boolean state variables for SPSS
	F_ROC.('diam_4.31mm_or_more') = F_ROC.balDiam>=4.30;
	F_ROC.('diam_4.73mm_or_more') = F_ROC.balDiam>=4.72;
	F_ROC.('diam_6.00mm_or_more') = F_ROC.balDiam>=5.99;
	F_ROC.('diam_6.60mm_or_more') = F_ROC.balDiam>=6.59;
	F_ROC.('diam_7.30mm_or_more') = F_ROC.balDiam>=7.29;
	F_ROC.('diam_8.52mm_or_more') = F_ROC.balDiam>=8.51;
	F_ROC.('diam_9mm_or_more')    = F_ROC.balDiam>=8.99;
	F_ROC.('diam_10mm_or_more')   = F_ROC.balDiam>=9.99;
	F_ROC.('diam_11mm_or_more')   = F_ROC.balDiam>=10.99;
	F_ROC.('diam_12mm_or_more')   = F_ROC.balDiam>=11.99;
	
	% Make pooled diameter state digit codes
	% NOTE: Alternative code could make use of ordinal rating instead
	F_ROC.pooledDiam = zeros(height(F_ROC),1);
	F_ROC.pooledDiam(F_ROC.('diam_4.31mm_or_more')) = 1;
	F_ROC.pooledDiam(F_ROC.('diam_4.73mm_or_more')) = 2;
	F_ROC.pooledDiam(F_ROC.('diam_6.00mm_or_more')) = 3;
	F_ROC.pooledDiam(F_ROC.('diam_6.60mm_or_more')) = 4;
	F_ROC.pooledDiam(F_ROC.('diam_7.30mm_or_more')) = 5;
	F_ROC.pooledDiam(F_ROC.('diam_8.52mm_or_more')) = 6;
	F_ROC.pooledDiam(F_ROC.('diam_9mm_or_more'))    = 7;
	F_ROC.pooledDiam(F_ROC.('diam_10mm_or_more'))   = 8;
	F_ROC.pooledDiam(F_ROC.('diam_11mm_or_more'))   = 9;
	F_ROC.pooledDiam(F_ROC.('diam_12mm_or_more'))   = 10;
