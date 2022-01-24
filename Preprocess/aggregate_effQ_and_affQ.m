function US = aggregate_effQ_and_affQ(US)
    
	welcome('Aggregate afferent and efferent ultrasonic data','function')
    
    US.Q = mean([US.effQ,US.affQ],2,'omitnan');
    if all(isnan(US.effQ))
        warning(sprintf([...
            '\n\tNo recording into effQ channel.',...
            '\n\tAggregate Q will not include effQ.'])); 
    end
    if all(isnan(US.affQ))
        warning(sprintf([...
            '\n\tNo recording into affQ channel.',...
            '\n\tAggregate Q will not include affQ.'])); 
    end
    US.Properties.VariableContinuity(:) = {'continuous'};
    US.Properties.VariableDescriptions{'Q'} = ...
        ['Mean of ',US.Properties.VariableDescriptions{'effQ'}, ' and ',...
        US.Properties.VariableDescriptions{'affQ'}];
    US(:,{'effQ','affQ'}) = [];
    