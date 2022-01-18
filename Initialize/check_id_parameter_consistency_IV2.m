function isOK = check_id_parameter_consistency_IV2(S,idSpecs)
    % TODO: List as input which categories to check and/or different variant for
	% experiment type, object oriented

    isOK = true;
    idSpecs = standardizeMissing(idSpecs,{'-9999'});
	S = standardizeMissing(S,{'-9999'});
	
	speedInData = unique(S.pumpSpeed);
	speedInData = cast(speedInData,class(idSpecs.pumpSpeed));
    notListedSpeed = not(ismember(speedInData,idSpecs.pumpSpeed));
    if any(notListedSpeed)
        speedInData = unique(S.pumpSpeed);
        if ismissing(speedInData), speedInData = '<Missing>'; end
		msg = sprintf(['Unlisted pump speeds found.',...
            '\n\tID: %s',...
            '\n\tID pump speed spec.: %s',...
            '\n\tPump speeds in data: %s'],...
            char(idSpecs.analysis_id),char(idSpecs.pumpSpeed),...
            strjoin(string(speedInData),', '));
        warning(msg);
        isOK = false;
    end
    
%     if ismember('balLev',S.Properties.VariableNames)
% 		idSpecs.balDiam = categorical(idSpecs.balDiam);
% 		idSpecs.balDiam(idSpecs.balDiam=='0') = '-';
%         idSpecs.balDiam(isundefined(idSpecs.balDiam)) = '-';
% 		
%         balDiamInData = unique(S.balDiam);		
%         notListedBalloon = not(ismember(balDiamInData,idSpecs.balDiam));
%         if ismissing(balDiamInData), balDiamInData = '<Missing>'; end
% 		if any(notListedBalloon)
%             msg = sprintf(['Unlisted balloon diameters found.',...
%                 '\n\tID: %s',...
%                 '\n\tID balloon diameter spec.: ',...
%                 '%s\n\tBalloon level in data: %s'],...
%                 char(idSpecs.analysis_id),string(char(idSpecs.balDiam)),...
%                 strjoin(string(balDiamInData)),', ');
%             warning(msg);
%             isOK = false;
%         end
%     end
    
    if ismember('catheter',S.Properties.VariableNames)
        catheterInData = unique(S.catheter);
        notListedCatheter = not(ismember(catheterInData,idSpecs.catheter));
		if ismissing(catheterInData), catheterInData = '<Missing>'; end
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
        idSpecs.QRedTarget_pst(isundefined(idSpecs.QRedTarget_pst)) = '-';
		QRedInData = unique(S.QRedTarget_pst);
		QRedInData(QRedInData=='0') = '-';
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
