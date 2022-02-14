function T = add_revised_balloon_levels(T, levLims)
	
	balLev_xRay = nan(height(T),1);
	lev0_inds = T.balDiam_xRay_mean<levLims(1);
	lev1_inds = T.balDiam_xRay_mean>=levLims(1) & T.balDiam_xRay_mean<levLims(2);
	lev2_inds = T.balDiam_xRay_mean>=levLims(2) & T.balDiam_xRay_mean<levLims(3);
	lev3_inds = T.balDiam_xRay_mean>=levLims(3) & T.balDiam_xRay_mean<levLims(4);
	lev4_inds = T.balDiam_xRay_mean>=levLims(4) & T.balDiam_xRay_mean<levLims(5);
	lev5_inds = T.balDiam_xRay_mean>=levLims(5);
	balLev_xRay(lev0_inds) = 0;
	balLev_xRay(lev1_inds) = 1;
	balLev_xRay(lev2_inds) = 2;
	balLev_xRay(lev3_inds) = 3;
	balLev_xRay(lev4_inds) = 4;
	balLev_xRay(lev5_inds) = 5;

	T.balLev_xRay = balLev_xRay;