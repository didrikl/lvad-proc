function US = aggregate_effQ_and_affQ(US)
    
    welcome('Aggregating afferent and efferent ultrasonic Q measurements','function')
    
    US.Q = mean([US.effQ,US.affQ],2);
    US.Properties.VariableContinuity(:) = {'continuous'};
    US(:,{'effQ','affQ'}) = [];
    