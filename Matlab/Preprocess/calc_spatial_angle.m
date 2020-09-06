function T = calc_spatial_angle(T,varNames,angleVarName)
    % Add spatial norms for recorded data in a timetable
    
    u = T.(varNames{1});
    xz_norm = T.('accA_xz_norm');

    % Calculating the cosince of angle
    cosTheta = u./xz_norm;
    
    % Calculating the angle and taking the real part in case round off error
    % causes an imaginary part for which abs(CosTheta)>1.
    T.(angleVarName) = real(acosd(cosTheta));
    
    T.Properties.VariableContinuity(angleVarName) = 'continuous';
    T.Properties.VariableDescriptions{angleVarName} = ...
            ['Angle between ',strjoin(varNames,' and ')];
    
    