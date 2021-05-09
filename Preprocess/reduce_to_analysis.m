function S = reduce_to_analysis(S)

    welcome('Reduce to analysis','function')
    
    % Keep only intervals that will go into quatitative analysis, as def. in Notes
    S.analysis_id = standardizeMissing(S.analysis_id,'-');
    S = S(not(ismissing(S.analysis_id)),:);
    
    S = check_analysis_id_rows(S);
    
    % Remove irrelevant columns
    S(:,{'event','intervType','part'}) = [];
    
    % Remove infomation found in Notes by noteRow ID, after have passed the QC
    % S_analysis(:,{pumpSpeed','balloonLevel','Q_LVAD','P_LVAD'}) = [];