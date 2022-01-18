function T = make_tables_for_ROC_analysis_in_SPSS(F)

	% Tables for concrete/specific diameter state levels for SPSS
	T.PCI1 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 4.73 mm' ),:);
	T.PCI2 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 6.60 mm' ),:);
	T.PCI3 = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 8.52 mm' ),:);
	T.RHC  = F(( F.interventionType=='Control' | F.levelLabel=='Inflated, 11 mm' ),:);

	% Tables for pooled diameter state levels for SPSS
	T.D_4_73_or_more = F(( F.interventionType=='Control' | F.balDiam>=4.30 ),:);
	T.D_6_60_or_more = F(( F.interventionType=='Control' | F.balDiam>=6.59 ),:);
	T.D_8_52_or_more = F(( F.interventionType=='Control' | F.balDiam>=8.51 ),:);
	T.D_9_or_more    = F(( F.interventionType=='Control' | F.balDiam>=8.99 ),:);
	T.D_10_or_more   = F(( F.interventionType=='Control' | F.balDiam>=9.99 ),:);
	T.D_11           = F(( F.interventionType=='Control' | F.balDiam>=10.99 ),:);
