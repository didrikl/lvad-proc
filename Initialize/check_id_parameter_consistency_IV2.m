function isOK = check_id_parameter_consistency_IV2(S,idSpecs)
    
    isOK = true;
    %idSpecs = standardizeMissing(idSpecs,'-');
	%S = standardizeMissing(S,'-');
	speedInData = unique(S.pumpSpeed);
	speedInData = cast(speedInData,class(idSpecs.pumpSpeed));
    notListedSpeed = not(ismember(speedInData,idSpecs.pumpSpeed));
    if any(notListedSpeed)
        speedInData = unique(S.pumpSpeed);
        msg = sprintf(['Unlisted pump speeds found.',...
            '\n\tID: %s',...
            '\n\tID pump speed spec.: %s',...
            '\n\tPump speeds in data: %s'],...
            char(idSpecs.analysis_id),char(idSpecs.pumpSpeed),...
            strjoin(string(speedInData),', '));
        warning(msg);
        isOK = false;
    end
    
    if ismember('balloonLev',S.Properties.VariableNames)
		idSpecs.balloonDiam = categorical(idSpecs.balloonDiam);
		idSpecs.balloonDiam(idSpecs.balloonDiam=='0') = '-';
        idSpecs.balloonDiam(isundefined(idSpecs.balloonDiam)) = '-';
		
        balDiamInData = unique(S.balloonDiam);
		
        notListedBalloon = not(ismember(balDiamInData,idSpecs.balloonDiam));
        if any(notListedBalloon)
            msg = sprintf(['Unlisted balloon diameters found.',...
                '\n\tID: %s',...
                '\n\tID balloon diameter spec.: ',...
                '%s\n\tBalloon level in data: %s'],...
                char(idSpecs.analysis_id),char(idSpecs.balloonDiam),...
                strjoin(string(balDiamInData),', '));
            warning(msg);
            isOK = false;
        end
    end
    
    if ismember('catheter',S.Properties.VariableNames)
        catheterInData = unique(S.catheter);
        notListedCatheter = not(ismember(catheterInData,idSpecs.catheter));
        if any(notListedCatheter)
             msg = sprintf(['Unlisted catheter found.',...
                '\n\tID: %s',...
                '\n\tID catheter spec.: %s',...
                '\n\tCatheter in data: %s'],...
                char(idSpecs.analysis_id),char(idSpecs.catheter),...
                strjoin(string(catheterInData),', '));
            warning(msg);
            isOK = false;
        end
    end
    
    if ismember('QRedTarget_pst',S.Properties.VariableNames)
        idSpecs.QRedTarget_pst = categorical(idSpecs.QRedTarget_pst);
        idSpecs.QRedTarget_pst(idSpecs.QRedTarget_pst=='0') = '-';
        
		QRedInData = unique(S.QRedTarget_pst);
        notListedInd = not(ismember(QRedInData,idSpecs.QRedTarget_pst));
        if any(notListedInd)
            warning(sprintf(['Unlisted flow reduction target found.',...
                '\n\tID: %s',...
                '\n\tID flow reduction target spec.: %s',...
                '\n\tFlow reduction target in data: %s'],...
                char(idSpecs.analysis_id),char(idSpecs.QRedTarget_pst),...
                strjoin(string(QRedInData),', ')));
            isOK = false;
        end
    end
