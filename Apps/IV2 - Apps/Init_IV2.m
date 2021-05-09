sequences = {
    'IV2_Seq6','D:\Data\IVS\Didrik\IV2 - Data\Seq6 - LVAD8\Processed\IV2_Seq6_S.mat'
    'IV2_Seq7','D:\Data\IVS\Didrik\IV2 - Data\Seq7 - LVAD1\Processed\IV2_Seq7_S.mat'
    'IV2_Seq9','D:\Data\IVS\Didrik\IV2 - Data\Seq9 - LVAD6\Processed\IV2_Seq9_S.mat'
    'IV2_Seq10','D:\Data\IVS\Didrik\IV2 - Data\Seq10 - LVAD9\Processed\IV2_Seq10_S.mat'
    'IV2_Seq11','D:\Data\IVS\Didrik\IV2 - Data\Seq11 - LVAD10\Processed\IV2_Seq11_S.mat'
    'IV2_Seq12','D:\Data\IVS\Didrik\IV2 - Data\Seq12 - LVAD11\Processed\IV2_Seq12_S.mat'
    'IV2_Seq13','D:\Data\IVS\Didrik\IV2 - Data\Seq13 - LVAD12\Processed\IV2_Seq13_S.mat'
    'IV2_Seq14','D:\Data\IVS\Didrik\IV2 - Data\Seq14 - LVAD7\Processed\IV2_Seq14_S.mat'
    'IV2_Seq18','D:\Data\IVS\Didrik\IV2 - Data\Seq18 - LVAD14\Processed\IV2_Seq18_S.mat'
    'IV2_Seq19','D:\Data\IVS\Didrik\IV2 - Data\Seq19 - LVAD13\Processed\IV2_Seq19_S.mat'
    };

for i=1:numel(sequences(:,1))
    
    load(sequences{i,2})
    %eval(['Init_',sequences{i,1}]);
    
    S_analysis.(sequences{i,1}) = S;

end
